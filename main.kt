package com.yourpackage.campusmesh.models

import org.json.JSONObject
import java.util.UUID

/**
 * Represents a single message floating through the mesh network.
 */
data class MessagePacket(
    val messageId: String,
    val senderId: String,
    val targetClass: String,
    val messageText: String,
    val timestamp: Long,
    val ttl: Int
) {
    fun toJson(): String {
        val json = JSONObject()
        json.put("messageId", messageId)
        json.put("senderId", senderId)
        json.put("targetClass", targetClass)
        json.put("messageText", messageText)
        json.put("timestamp", timestamp)
        json.put("ttl", ttl)
        return json.toString()
    }

    companion object {
        fun fromJson(jsonString: String): MessagePacket? {
            return try {
                val json = JSONObject(jsonString)
                MessagePacket(
                    messageId = json.getString("messageId"),
                    senderId = json.getString("senderId"),
                    targetClass = json.getString("targetClass"),
                    messageText = json.getString("messageText"),
                    timestamp = json.getLong("timestamp"),
                    ttl = json.getInt("ttl")
                )
            } catch (e: Exception) {
                null
            }
        }
    }
}

/**
 * Callback interface to communicate with the UI and Networking layers without depending on them.
 */
interface MeshNetworkCallback {
    fun onMessageToDisplay(message: MessagePacket)
    fun onForwardMessageToNetwork(messageJson: String)
}

/**
 * Core logic for processing, filtering, and relaying messages.
 */
class MeshRelayManager(
    private val myDeviceId: String,
    private val myClassId: String,
    private val callback: MeshNetworkCallback
) {
    private val seenMessageIds = mutableSetOf<String>()

    fun createAndSendNewMessage(targetClass: String, messageText: String, initialTtl: Int = 5) {
        val packet = MessagePacket(
            messageId = UUID.randomUUID().toString(),
            senderId = myDeviceId,
            targetClass = targetClass,
            messageText = messageText,
            timestamp = System.currentTimeMillis(),
            ttl = initialTtl
        )
        seenMessageIds.add(packet.messageId)
        callback.onForwardMessageToNetwork(packet.toJson())
    }

    fun onPayloadReceivedFromNetwork(jsonString: String) {
        val packet = MessagePacket.fromJson(jsonString) ?: return

        if (seenMessageIds.contains(packet.messageId)) {
            return
        }
        
        seenMessageIds.add(packet.messageId)

        if (packet.targetClass == myClassId || packet.targetClass == "ALL") {
            callback.onMessageToDisplay(packet)
        }

        if (packet.ttl > 0) {
            val forwardedPacket = packet.copy(ttl = packet.ttl - 1)
            callback.onForwardMessageToNetwork(forwardedPacket.toJson())
        }
    }
}
