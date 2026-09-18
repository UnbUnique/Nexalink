package com.nexalink.nearby

import android.content.Context
import android.util.Log
import com.nexalink.nearby.model.ChatMessage
import com.nexalink.nearby.model.ConnectionState
import com.nexalink.nearby.model.DiscoveredDevice
import com.nexalink.nearby.model.NearbyEvent
import com.nexalink.nearby.model.PeerDevice
import com.nexalink.nearby.permission.NearbyPermissions
import com.google.android.gms.nearby.Nearby
import com.google.android.gms.nearby.connection.AdvertisingOptions
import com.google.android.gms.nearby.connection.ConnectionInfo
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback
import com.google.android.gms.nearby.connection.ConnectionResolution
import com.google.android.gms.nearby.connection.ConnectionsClient
import com.google.android.gms.nearby.connection.ConnectionsStatusCodes
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo
import com.google.android.gms.nearby.connection.DiscoveryOptions
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback
import com.google.android.gms.nearby.connection.Payload
import com.google.android.gms.nearby.connection.PayloadCallback
import com.google.android.gms.nearby.connection.PayloadTransferUpdate
import com.google.android.gms.nearby.connection.Strategy
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

/**
 * NearbyManager
 *
 * Core engine for offline, zero-internet, peer-to-peer communication using Google Nearby Connections.
 * Uses Strategy.P2P_CLUSTER (M-to-N mesh topology) to allow multiple devices to discover,
 * connect, and exchange text messages completely offline over Bluetooth and Wi-Fi Direct.
 *
 * All state is exposed via Kotlin Coroutines [StateFlow] and [SharedFlow], making it
 * effortless to observe from a Jetpack Compose ViewModel, Android View, or Flutter MethodChannel.
 *
 * @param context Android Application context.
 * @param serviceId Unique service identifier separating your app's network from others.
 * @param autoAcceptConnections When true, automatically accepts incoming connection handshakes
 *                              (recommended for seamless hackathon demos).
 */
class NearbyManager(
    context: Context,
    private val serviceId: String = DEFAULT_SERVICE_ID,
    var autoAcceptConnections: Boolean = true
) {
    companion object {
        private const val TAG = "NexaLinkNearby"
        const val DEFAULT_SERVICE_ID = "com.nexalink.app"

        /**
         * Strategy.P2P_CLUSTER supports an M-to-N cluster (mesh-like) topology where any device
         * can simultaneously advertise and discover other devices in proximity.
         */
        val STRATEGY: Strategy = Strategy.P2P_CLUSTER
    }

    private val appContext = context.applicationContext
    private val connectionsClient: ConnectionsClient = Nearby.getConnectionsClient(appContext)

    // Coroutine scope for internal state management and event emission
    private val managerScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    // Current local advertised device name (e.g., "Alice's Phone")
    private var localDeviceName: String = "NexaPeer"

    // -------------------------------------------------------------------------
    // Observable UI State (Jetpack Compose / Flutter Platform Channel Ready)
    // -------------------------------------------------------------------------

    private val _isAdvertising = MutableStateFlow(false)
    val isAdvertising: StateFlow<Boolean> = _isAdvertising.asStateFlow()

    private val _isDiscovering = MutableStateFlow(false)
    val isDiscovering: StateFlow<Boolean> = _isDiscovering.asStateFlow()

    private val _discoveredDevices = MutableStateFlow<List<DiscoveredDevice>>(emptyList())
    val discoveredDevices: StateFlow<List<DiscoveredDevice>> = _discoveredDevices.asStateFlow()

    private val _connectedDevices = MutableStateFlow<List<PeerDevice>>(emptyList())
    val connectedDevices: StateFlow<List<PeerDevice>> = _connectedDevices.asStateFlow()

    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages: StateFlow<List<ChatMessage>> = _messages.asStateFlow()

    private val _events = MutableSharedFlow<NearbyEvent>(extraBufferCapacity = 64)
    val events: SharedFlow<NearbyEvent> = _events.asSharedFlow()

    // -------------------------------------------------------------------------
    // 1. Advertising (Making Phone Visible to Nearby Peers)
    // -------------------------------------------------------------------------

    /**
     * Broadcasts our presence so nearby devices running the same app can find us.
     *
     * @param deviceName The display name shown to other devices (e.g. "Alice").
     */
    fun startAdvertising(deviceName: String) {
        if (!NearbyPermissions.hasAllPermissions(appContext)) {
            val errorMsg = "Cannot start advertising: Missing required runtime permissions."
            Log.e(TAG, errorMsg)
            emitEvent(NearbyEvent.Error(errorMsg))
            return
        }

        val hw = NearbyPermissions.checkHardwareStatus(appContext)
        if (!hw.isBluetoothOn) {
            val msg = "Bluetooth is turned off. Please turn on Bluetooth to advertise."
            Log.w(TAG, msg)
            emitEvent(NearbyEvent.Error(msg))
            return
        }

        localDeviceName = deviceName.trim().ifEmpty { "NexaPeer" }

        val advertisingOptions = AdvertisingOptions.Builder()
            .setStrategy(STRATEGY)
            .build()

        connectionsClient.startAdvertising(
            localDeviceName,
            serviceId,
            connectionLifecycleCallback,
            advertisingOptions
        ).addOnSuccessListener {
            Log.d(TAG, "Advertising successfully started as: $localDeviceName")
            _isAdvertising.value = true
        }.addOnFailureListener { exception ->
            Log.e(TAG, "Failed to start advertising", exception)
            _isAdvertising.value = false
            emitEvent(NearbyEvent.Error("Failed to start advertising: ${exception.localizedMessage}", exception))
        }
    }

    /**
     * Stops broadcasting our presence to nearby devices.
     */
    fun stopAdvertising() {
        connectionsClient.stopAdvertising()
        _isAdvertising.value = false
        Log.d(TAG, "Advertising stopped")
    }

    // -------------------------------------------------------------------------
    // 2. Discovery (Searching for Nearby Peers)
    // -------------------------------------------------------------------------

    /**
     * Scans for other devices advertising with our [serviceId].
     */
    fun startDiscovery() {
        if (!NearbyPermissions.hasAllPermissions(appContext)) {
            val errorMsg = "Cannot start discovery: Missing required runtime permissions."
            Log.e(TAG, errorMsg)
            emitEvent(NearbyEvent.Error(errorMsg))
            return
        }

        val hw = NearbyPermissions.checkHardwareStatus(appContext)
        if (!hw.isBluetoothOn) {
            val msg = "Bluetooth is turned off. Please turn on Bluetooth to scan."
            Log.w(TAG, msg)
            emitEvent(NearbyEvent.Error(msg))
            return
        }
        if (!hw.isLocationOn) {
            val msg = "Location Services is turned off. Nearby discovery requires Location to detect beacons."
            Log.w(TAG, msg)
            emitEvent(NearbyEvent.Error(msg))
            return
        }

        val discoveryOptions = DiscoveryOptions.Builder()
            .setStrategy(STRATEGY)
            .build()

        connectionsClient.startDiscovery(
            serviceId,
            endpointDiscoveryCallback,
            discoveryOptions
        ).addOnSuccessListener {
            Log.d(TAG, "Discovery successfully started")
            _isDiscovering.value = true
        }.addOnFailureListener { exception ->
            Log.e(TAG, "Failed to start discovery", exception)
            _isDiscovering.value = false
            emitEvent(NearbyEvent.Error("Failed to start discovery: ${exception.localizedMessage}", exception))
        }
    }

    /**
     * Stops scanning for nearby devices.
     */
    fun stopDiscovery() {
        connectionsClient.stopDiscovery()
        _isDiscovering.value = false
        _discoveredDevices.value = emptyList()
        Log.d(TAG, "Discovery stopped")
    }

    // -------------------------------------------------------------------------
    // 3. Requesting Connection to a Discovered Device
    // -------------------------------------------------------------------------

    /**
     * Sends a connection request to a discovered peer.
     * Prevents duplicate requests if already connecting or connected.
     *
     * @param endpointId The unique endpointId of the discovered device.
     */
    fun requestConnection(endpointId: String) {
        val existingPeer = _connectedDevices.value.find { it.endpointId == endpointId }
        if (existingPeer != null && (existingPeer.state == ConnectionState.CONNECTING || existingPeer.state == ConnectionState.CONNECTED)) {
            Log.d(TAG, "Already connecting or connected to $endpointId. Ignoring duplicate request.")
            return
        }

        val target = _discoveredDevices.value.find { it.endpointId == endpointId }
        val targetName = target?.endpointName ?: "Unknown Device"

        Log.d(TAG, "Requesting connection to $targetName ($endpointId)")

        // Add to connected devices list in CONNECTING state
        _connectedDevices.update { list ->
            list.filterNot { it.endpointId == endpointId } + PeerDevice(
                endpointId = endpointId,
                endpointName = targetName,
                state = ConnectionState.CONNECTING
            )
        }

        connectionsClient.requestConnection(
            localDeviceName,
            endpointId,
            connectionLifecycleCallback
        ).addOnSuccessListener {
            Log.d(TAG, "Connection request successfully queued for $endpointId")
        }.addOnFailureListener { exception ->
            Log.e(TAG, "Failed to request connection to $endpointId", exception)
            _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
            emitEvent(NearbyEvent.Error("Failed to request connection: ${exception.localizedMessage}", exception))
        }
    }

    // -------------------------------------------------------------------------
    // 4. Accepting / Rejecting Connections
    // -------------------------------------------------------------------------

    /**
     * Accepts an incoming connection request from a peer.
     *
     * @param endpointId The unique endpointId of the peer requesting connection.
     */
    fun acceptConnection(endpointId: String) {
        Log.d(TAG, "Accepting connection from $endpointId")
        connectionsClient.acceptConnection(endpointId, payloadCallback)
            .addOnFailureListener { exception ->
                Log.e(TAG, "Failed to accept connection from $endpointId", exception)
                emitEvent(NearbyEvent.Error("Failed to accept connection: ${exception.localizedMessage}", exception))
            }
    }

    /**
     * Rejects an incoming connection request.
     *
     * @param endpointId The unique endpointId of the peer to reject.
     */
    fun rejectConnection(endpointId: String) {
        Log.d(TAG, "Rejecting connection from $endpointId")
        connectionsClient.rejectConnection(endpointId)
            .addOnSuccessListener {
                _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
            }
            .addOnFailureListener { exception ->
                Log.e(TAG, "Failed to reject connection from $endpointId", exception)
            }
    }

    // -------------------------------------------------------------------------
    // 5. Sending Text Messages
    // -------------------------------------------------------------------------

    /**
     * Sends a plain UTF-8 text message to a specific connected peer.
     *
     * @param endpointId The recipient peer's endpoint ID.
     * @param text The string message (e.g. "Hello").
     * @return true if payload was successfully passed to Nearby Connections for transmission.
     */
    fun sendMessage(endpointId: String, text: String): Boolean {
        val trimmed = text.trim()
        if (trimmed.isEmpty()) return false

        val peer = _connectedDevices.value.find { it.endpointId == endpointId && it.state == ConnectionState.CONNECTED }
        if (peer == null) {
            Log.w(TAG, "Cannot send message: Device $endpointId is not connected.")
            emitEvent(NearbyEvent.Error("Device is not connected"))
            return false
        }

        val bytes = trimmed.toByteArray(Charsets.UTF_8)
        val payload = Payload.fromBytes(bytes)

        connectionsClient.sendPayload(endpointId, payload)
            .addOnSuccessListener {
                Log.d(TAG, "Message payload sent to $endpointId: '$trimmed'")
                // Record message once in history as an outgoing message
                val outgoingMessage = ChatMessage(
                    senderEndpointId = "ME",
                    senderName = "Me",
                    text = trimmed,
                    isIncoming = false
                )
                _messages.update { it + outgoingMessage }
                emitEvent(NearbyEvent.MessageSent(endpointId, trimmed))
            }
            .addOnFailureListener { exception ->
                Log.e(TAG, "Failed to send message to $endpointId", exception)
                emitEvent(NearbyEvent.Error("Failed to send message: ${exception.localizedMessage}", exception))
            }

        return true
    }

    /**
     * Sends a plain text message to ALL currently connected peers in a single batch call.
     * Fixes duplicate chat history entries by recording the message once.
     *
     * @param text The string message to broadcast.
     */
    fun broadcastMessage(text: String): Boolean {
        val trimmed = text.trim()
        if (trimmed.isEmpty()) return false

        val connectedPeers = _connectedDevices.value.filter { it.state == ConnectionState.CONNECTED }
        if (connectedPeers.isEmpty()) {
            Log.w(TAG, "No connected peers to broadcast to.")
            return false
        }

        val endpointIds = connectedPeers.map { it.endpointId }
        val bytes = trimmed.toByteArray(Charsets.UTF_8)
        val payload = Payload.fromBytes(bytes)

        connectionsClient.sendPayload(endpointIds, payload)
            .addOnSuccessListener {
                Log.d(TAG, "Broadcast message payload sent to ${endpointIds.size} peers: '$trimmed'")
                // Record message ONCE in history
                val outgoingMessage = ChatMessage(
                    senderEndpointId = "ME",
                    senderName = "Me",
                    text = trimmed,
                    isIncoming = false
                )
                _messages.update { it + outgoingMessage }
                emitEvent(NearbyEvent.MessageSent("BROADCAST", trimmed))
            }
            .addOnFailureListener { exception ->
                Log.e(TAG, "Failed to broadcast message", exception)
                emitEvent(NearbyEvent.Error("Failed to broadcast message: ${exception.localizedMessage}", exception))
            }

        return true
    }

    // -------------------------------------------------------------------------
    // 6. Disconnecting & Teardown
    // -------------------------------------------------------------------------

    /**
     * Disconnects from a specific peer device.
     */
    fun disconnectFromDevice(endpointId: String) {
        Log.d(TAG, "Disconnecting from $endpointId")
        connectionsClient.disconnectFromEndpoint(endpointId)
        _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
    }

    /**
     * Disconnects all peers, stops advertising, and stops discovery.
     * Call this when exiting the chat screen to release radio hardware.
     */
    fun stopAll() {
        Log.d(TAG, "Stopping all Nearby operations and disconnecting all peers")
        connectionsClient.stopAdvertising()
        connectionsClient.stopDiscovery()
        connectionsClient.stopAllEndpoints()

        _isAdvertising.value = false
        _isDiscovering.value = false
        _discoveredDevices.value = emptyList()
        _connectedDevices.value = emptyList()
    }

    /**
     * Completely cleans up all resources and cancels the internal CoroutineScope.
     * Call this from ViewModel.onCleared() or Flutter Activity onDestroy.
     */
    fun destroy() {
        stopAll()
        managerScope.cancel()
    }

    // -------------------------------------------------------------------------
    // Internal Callbacks: Connection Lifecycle
    // -------------------------------------------------------------------------

    private val connectionLifecycleCallback = object : ConnectionLifecycleCallback() {
        override fun onConnectionInitiated(endpointId: String, connectionInfo: ConnectionInfo) {
            val peerName = connectionInfo.endpointName
            val authDigits = connectionInfo.authenticationDigits
            Log.d(TAG, "onConnectionInitiated: $peerName ($endpointId), authDigits: $authDigits")

            // Track peer in CONNECTING state
            val pendingPeer = PeerDevice(
                endpointId = endpointId,
                endpointName = peerName,
                state = ConnectionState.CONNECTING,
                authenticationDigits = authDigits
            )
            _connectedDevices.update { list ->
                list.filterNot { it.endpointId == endpointId } + pendingPeer
            }

            emitEvent(NearbyEvent.ConnectionInitiated(endpointId, peerName, authDigits))

            // In hackathon mode, automatically accept the connection so devices link seamlessly
            if (autoAcceptConnections) {
                acceptConnection(endpointId)
            }
        }

        override fun onConnectionResult(endpointId: String, resolution: ConnectionResolution) {
            when (resolution.status.statusCode) {
                ConnectionsStatusCodes.STATUS_OK,
                ConnectionsStatusCodes.STATUS_ALREADY_CONNECTED_TO_ENDPOINT -> {
                    Log.d(TAG, "onConnectionResult: Connection established with $endpointId (code ${resolution.status.statusCode})")
                    _connectedDevices.update { list ->
                        list.map { peer ->
                            if (peer.endpointId == endpointId) {
                                peer.copy(state = ConnectionState.CONNECTED)
                            } else peer
                        }
                    }
                    // Remove from discovered list now that it is connected
                    _discoveredDevices.update { list -> list.filterNot { it.endpointId == endpointId } }

                    val peerName = _connectedDevices.value.find { it.endpointId == endpointId }?.endpointName ?: endpointId
                    emitEvent(NearbyEvent.ConnectionEstablished(endpointId, peerName))
                }
                ConnectionsStatusCodes.STATUS_CONNECTION_REJECTED -> {
                    Log.w(TAG, "onConnectionResult: Connection rejected by $endpointId")
                    val peerName = _connectedDevices.value.find { it.endpointId == endpointId }?.endpointName ?: endpointId
                    _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
                    emitEvent(NearbyEvent.ConnectionRejected(endpointId, peerName))
                }
                else -> {
                    Log.e(TAG, "onConnectionResult: Error code ${resolution.status.statusCode} for $endpointId")
                    _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
                    emitEvent(NearbyEvent.Error("Connection failed with code: ${resolution.status.statusCode}"))
                }
            }
        }

        override fun onDisconnected(endpointId: String) {
            Log.d(TAG, "onDisconnected: Endpoint $endpointId disconnected")
            val peerName = _connectedDevices.value.find { it.endpointId == endpointId }?.endpointName ?: endpointId
            _connectedDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
            emitEvent(NearbyEvent.DeviceDisconnected(endpointId, peerName))
        }
    }

    // -------------------------------------------------------------------------
    // Internal Callbacks: Endpoint Discovery
    // -------------------------------------------------------------------------

    private val endpointDiscoveryCallback = object : EndpointDiscoveryCallback() {
        override fun onEndpointFound(endpointId: String, info: DiscoveredEndpointInfo) {
            Log.d(TAG, "onEndpointFound: ${info.endpointName} ($endpointId)")
            val device = DiscoveredDevice(endpointId = endpointId, endpointName = info.endpointName)

            _discoveredDevices.update { list ->
                if (list.none { it.endpointId == endpointId }) {
                    list + device
                } else {
                    list.map { if (it.endpointId == endpointId) device else it }
                }
            }
        }

        override fun onEndpointLost(endpointId: String) {
            Log.d(TAG, "onEndpointLost: $endpointId")
            _discoveredDevices.update { list -> list.filterNot { it.endpointId == endpointId } }
        }
    }

    // -------------------------------------------------------------------------
    // Internal Callbacks: Data Payloads (Text Messages)
    // -------------------------------------------------------------------------

    private val payloadCallback = object : PayloadCallback() {
        override fun onPayloadReceived(endpointId: String, payload: Payload) {
            if (payload.type == Payload.Type.BYTES) {
                val bytes = payload.asBytes() ?: return
                val text = String(bytes, Charsets.UTF_8)
                Log.d(TAG, "Received message from $endpointId: '$text'")

                val peerName = _connectedDevices.value.find { it.endpointId == endpointId }?.endpointName ?: "Peer"
                val incomingMessage = ChatMessage(
                    senderEndpointId = endpointId,
                    senderName = peerName,
                    text = text,
                    isIncoming = true
                )

                _messages.update { it + incomingMessage }
            }
        }

        override fun onPayloadTransferUpdate(endpointId: String, update: PayloadTransferUpdate) {
            when (update.status) {
                PayloadTransferUpdate.Status.SUCCESS -> {
                    Log.d(TAG, "Payload transfer successful to/from $endpointId")
                }
                PayloadTransferUpdate.Status.FAILURE -> {
                    Log.e(TAG, "Payload transfer failed to/from $endpointId")
                    emitEvent(NearbyEvent.Error("Payload transfer failed with $endpointId"))
                }
                PayloadTransferUpdate.Status.CANCELED -> {
                    Log.w(TAG, "Payload transfer canceled to/from $endpointId")
                }
                PayloadTransferUpdate.Status.IN_PROGRESS -> {
                    // Small text messages complete almost instantaneously
                }
            }
        }
    }

    private fun emitEvent(event: NearbyEvent) {
        if (!_events.tryEmit(event)) {
            managerScope.launch {
                _events.emit(event)
            }
        }
    }
}
