package com.nexalink.nearby.flutter

import android.content.Context
import com.nexalink.nearby.NearbyManager
import com.nexalink.nearby.model.NearbyEvent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

/**
 * NearbyPlatformChannel
 *
 * Bridges [NearbyManager] to a Flutter front-end using MethodChannel and EventChannel.
 * Allows Flutter developers to call nearby methods from Dart and listen to real-time streams
 * of discovered peers, connected devices, incoming chat messages, and events.
 */
class NearbyPlatformChannel(
    context: Context,
    private val messenger: BinaryMessenger,
    val nearbyManager: NearbyManager = NearbyManager(context)
) : MethodChannel.MethodCallHandler {

    companion object {
        const val METHOD_CHANNEL = "com.nexalink/nearby_methods"
        const val EVENT_DEVICES_CHANNEL = "com.nexalink/nearby_discovered"
        const val EVENT_PEERS_CHANNEL = "com.nexalink/nearby_peers"
        const val EVENT_MESSAGES_CHANNEL = "com.nexalink/nearby_messages"
        const val EVENT_NOTIFICATIONS_CHANNEL = "com.nexalink/nearby_events"
    }

    private val scope = CoroutineScope(Dispatchers.Main + Job())
    private var methodChannel: MethodChannel? = null

    fun register() {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL).apply {
            setMethodCallHandler(this@NearbyPlatformChannel)
        }

        // 1. Discovered devices stream
        EventChannel(messenger, EVENT_DEVICES_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            private var job: Job? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                job = scope.launch {
                    nearbyManager.discoveredDevices.collect { list ->
                        val data = list.map { mapOf("endpointId" to it.endpointId, "endpointName" to it.endpointName) }
                        events?.success(data)
                    }
                }
            }
            override fun onCancel(arguments: Any?) { job?.cancel() }
        })

        // 2. Connected peers stream
        EventChannel(messenger, EVENT_PEERS_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            private var job: Job? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                job = scope.launch {
                    nearbyManager.connectedDevices.collect { list ->
                        val data = list.map {
                            mapOf(
                                "endpointId" to it.endpointId,
                                "endpointName" to it.endpointName,
                                "state" to it.state.name
                            )
                        }
                        events?.success(data)
                    }
                }
            }
            override fun onCancel(arguments: Any?) { job?.cancel() }
        })

        // 3. Incoming & outgoing messages stream
        EventChannel(messenger, EVENT_MESSAGES_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            private var job: Job? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                job = scope.launch {
                    nearbyManager.messages.collect { list ->
                        val data = list.map {
                            mapOf(
                                "id" to it.id,
                                "senderEndpointId" to it.senderEndpointId,
                                "senderName" to it.senderName,
                                "text" to it.text,
                                "timestamp" to it.timestamp,
                                "isIncoming" to it.isIncoming
                            )
                        }
                        events?.success(data)
                    }
                }
            }
            override fun onCancel(arguments: Any?) { job?.cancel() }
        })

        // 4. One-time notification events stream (toasts/errors)
        EventChannel(messenger, EVENT_NOTIFICATIONS_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
            private var job: Job? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                job = scope.launch {
                    nearbyManager.events.collect { event ->
                        when (event) {
                            is NearbyEvent.ConnectionInitiated -> events?.success(mapOf("type" to "CONNECTION_INITIATED", "endpointId" to event.endpointId, "endpointName" to event.endpointName))
                            is NearbyEvent.ConnectionEstablished -> events?.success(mapOf("type" to "CONNECTED", "endpointId" to event.endpointId, "endpointName" to event.endpointName))
                            is NearbyEvent.ConnectionRejected -> events?.success(mapOf("type" to "REJECTED", "endpointId" to event.endpointId, "endpointName" to event.endpointName))
                            is NearbyEvent.DeviceDisconnected -> events?.success(mapOf("type" to "DISCONNECTED", "endpointId" to event.endpointId, "endpointName" to event.endpointName))
                            is NearbyEvent.Error -> events?.success(mapOf("type" to "ERROR", "message" to event.message))
                            is NearbyEvent.MessageSent -> events?.success(mapOf("type" to "MESSAGE_SENT", "endpointId" to event.endpointId, "text" to event.text))
                        }
                    }
                }
            }
            override fun onCancel(arguments: Any?) { job?.cancel() }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startAdvertising" -> {
                val name = call.argument<String>("name") ?: "NexaPeer"
                nearbyManager.startAdvertising(name)
                result.success(true)
            }
            "stopAdvertising" -> {
                nearbyManager.stopAdvertising()
                result.success(true)
            }
            "startDiscovery" -> {
                nearbyManager.startDiscovery()
                result.success(true)
            }
            "stopDiscovery" -> {
                nearbyManager.stopDiscovery()
                result.success(true)
            }
            "requestConnection" -> {
                val endpointId = call.argument<String>("endpointId")
                if (endpointId != null) {
                    nearbyManager.requestConnection(endpointId)
                    result.success(true)
                } else {
                    result.error("INVALID_ARG", "endpointId is required", null)
                }
            }
            "acceptConnection" -> {
                val endpointId = call.argument<String>("endpointId")
                if (endpointId != null) {
                    nearbyManager.acceptConnection(endpointId)
                    result.success(true)
                } else {
                    result.error("INVALID_ARG", "endpointId is required", null)
                }
            }
            "rejectConnection" -> {
                val endpointId = call.argument<String>("endpointId")
                if (endpointId != null) {
                    nearbyManager.rejectConnection(endpointId)
                    result.success(true)
                } else {
                    result.error("INVALID_ARG", "endpointId is required", null)
                }
            }
            "sendMessage" -> {
                val endpointId = call.argument<String>("endpointId")
                val text = call.argument<String>("text")
                if (endpointId != null && text != null) {
                    val sent = nearbyManager.sendMessage(endpointId, text)
                    result.success(sent)
                } else {
                    result.error("INVALID_ARG", "endpointId and text are required", null)
                }
            }
            "broadcastMessage" -> {
                val text = call.argument<String>("text")
                if (text != null) {
                    val sent = nearbyManager.broadcastMessage(text)
                    result.success(sent)
                } else {
                    result.error("INVALID_ARG", "text is required", null)
                }
            }
            "disconnectFromDevice" -> {
                val endpointId = call.argument<String>("endpointId")
                if (endpointId != null) {
                    nearbyManager.disconnectFromDevice(endpointId)
                    result.success(true)
                } else {
                    result.error("INVALID_ARG", "endpointId is required", null)
                }
            }
            "stopAll" -> {
                nearbyManager.stopAll()
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    fun unregister() {
        methodChannel?.setMethodCallHandler(null)
        nearbyManager.destroy()
    }
}
