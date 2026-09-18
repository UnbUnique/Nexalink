package com.campusmesh.nearby.model

/**
 * Represents the current connection state of a nearby peer device.
 */
enum class ConnectionState {
    /** Connection request sent or received, handshake pending. */
    CONNECTING,

    /** Successfully connected and ready to send/receive offline messages. */
    CONNECTED,

    /** Device is disconnected. */
    DISCONNECTED,

    /** Connection was rejected either locally or by the remote peer. */
    REJECTED
}
