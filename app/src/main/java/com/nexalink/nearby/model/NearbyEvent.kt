package com.nexalink.nearby.model

/**
 * Observable one-time events for UI notifications (Snackbars, Toasts, Dialogs).
 */
sealed interface NearbyEvent {
    /** Triggered when a connection request is initiated by or with a peer. */
    data class ConnectionInitiated(
        val endpointId: String,
        val endpointName: String,
        val authenticationDigits: String
    ) : NearbyEvent

    /** Triggered when a connection with a peer has been established and is ready. */
    data class ConnectionEstablished(
        val endpointId: String,
        val endpointName: String
    ) : NearbyEvent

    /** Triggered when a connection request is rejected. */
    data class ConnectionRejected(
        val endpointId: String,
        val endpointName: String
    ) : NearbyEvent

    /** Triggered when a previously connected peer disconnects. */
    data class DeviceDisconnected(
        val endpointId: String,
        val endpointName: String
    ) : NearbyEvent

    /** Triggered when an error occurs during advertising, discovery, or data transfer. */
    data class Error(
        val message: String,
        val throwable: Throwable? = null
    ) : NearbyEvent

    /** Triggered when an outgoing message was successfully queued for delivery. */
    data class MessageSent(
        val endpointId: String,
        val text: String
    ) : NearbyEvent
}
