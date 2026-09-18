package com.nexalink.nearby.model

/**
 * Represents a peer with whom a connection has been initiated or established.
 *
 * @property endpointId Unique identifier for this peer session.
 * @property endpointName Display name of the peer.
 * @property state Current [ConnectionState] of the peer.
 * @property authenticationDigits Optional authentication token (digits) provided by Nearby Connections for manual verification.
 */
data class PeerDevice(
    val endpointId: String,
    val endpointName: String,
    val state: ConnectionState,
    val authenticationDigits: String? = null
)
