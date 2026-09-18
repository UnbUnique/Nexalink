package com.campusmesh.nearby.model

import java.util.UUID

/**
 * Represents an offline text message exchanged between devices.
 *
 * @property id Unique identifier for this message.
 * @property senderEndpointId Endpoint ID of the sender device.
 * @property senderName Human-readable name of the sender.
 * @property text The actual UTF-8 text message content (e.g., "Hello").
 * @property timestamp Unix epoch timestamp in milliseconds when the message was sent/received.
 * @property isIncoming True if received from a remote peer; false if sent locally by this device.
 */
data class ChatMessage(
    val id: String = UUID.randomUUID().toString(),
    val senderEndpointId: String,
    val senderName: String,
    val text: String,
    val timestamp: Long = System.currentTimeMillis(),
    val isIncoming: Boolean
)
