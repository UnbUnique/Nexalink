import 'dart:async';
import 'package:flutter/services.dart';
import '../models/nearby_models.dart';

/// NearbyService (Flutter)
///
/// Senior-engineered Flutter service bridging to native Android Google Nearby Connections.
/// Provides reactive Dart [Stream]s for discovered peers, active connections, and messages,
/// ideal for consumption by StreamBuilder, Riverpod, Bloc, or Provider in a Flutter UI.
class NearbyService {
  static final NearbyService _instance = NearbyService._internal();
  factory NearbyService() => _instance;
  NearbyService._internal();

  static const MethodChannel _methods =
      MethodChannel('com.nexalink/nearby_methods');

  static const EventChannel _discoveredChannel =
      EventChannel('com.nexalink/nearby_discovered');

  static const EventChannel _peersChannel =
      EventChannel('com.nexalink/nearby_peers');

  static const EventChannel _messagesChannel =
      EventChannel('com.nexalink/nearby_messages');

  static const EventChannel _eventsChannel =
      EventChannel('com.nexalink/nearby_events');

  // Broadcast streams for UI widgets to listen to
  Stream<List<DiscoveredDevice>>? _discoveredStream;
  Stream<List<PeerDevice>>? _peersStream;
  Stream<List<ChatMessage>>? _messagesStream;
  Stream<Map<dynamic, dynamic>>? _eventsStream;

  /// Stream of nearby devices currently advertising and discovered by this phone.
  Stream<List<DiscoveredDevice>> get discoveredDevices {
    _discoveredStream ??= _discoveredChannel.receiveBroadcastStream().map((raw) {
      final list = raw as List<dynamic>? ?? [];
      return list
          .map((item) => DiscoveredDevice.fromMap(item as Map<dynamic, dynamic>))
          .toList();
    });
    return _discoveredStream!;
  }

  /// Stream of currently connected peers and their connection states.
  Stream<List<PeerDevice>> get connectedPeers {
    _peersStream ??= _peersChannel.receiveBroadcastStream().map((raw) {
      final list = raw as List<dynamic>? ?? [];
      return list
          .map((item) => PeerDevice.fromMap(item as Map<dynamic, dynamic>))
          .toList();
    });
    return _peersStream!;
  }

  /// Stream of full chat history (both incoming from peers and outgoing from this device).
  Stream<List<ChatMessage>> get messages {
    _messagesStream ??= _messagesChannel.receiveBroadcastStream().map((raw) {
      final list = raw as List<dynamic>? ?? [];
      return list
          .map((item) => ChatMessage.fromMap(item as Map<dynamic, dynamic>))
          .toList();
    });
    return _messagesStream!;
  }

  /// One-time system events (toasts, connection alerts, errors).
  Stream<Map<dynamic, dynamic>> get events {
    _eventsStream ??= _eventsChannel.receiveBroadcastStream().map((raw) {
      return raw as Map<dynamic, dynamic>? ?? {};
    });
    return _eventsStream!;
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Starts advertising our presence to nearby devices.
  Future<bool> startAdvertising(String displayName) async {
    try {
      final res = await _methods.invokeMethod<bool>(
        'startAdvertising',
        {'name': displayName},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: startAdvertising error: ${e.message}');
      return false;
    }
  }

  /// Stops advertising.
  Future<bool> stopAdvertising() async {
    try {
      final res = await _methods.invokeMethod<bool>('stopAdvertising');
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: stopAdvertising error: ${e.message}');
      return false;
    }
  }

  /// Starts scanning for nearby devices.
  Future<bool> startDiscovery() async {
    try {
      final res = await _methods.invokeMethod<bool>('startDiscovery');
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: startDiscovery error: ${e.message}');
      return false;
    }
  }

  /// Stops scanning for devices.
  Future<bool> stopDiscovery() async {
    try {
      final res = await _methods.invokeMethod<bool>('stopDiscovery');
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: stopDiscovery error: ${e.message}');
      return false;
    }
  }

  /// Initiates a connection request to a discovered peer.
  Future<bool> requestConnection(String endpointId) async {
    try {
      final res = await _methods.invokeMethod<bool>(
        'requestConnection',
        {'endpointId': endpointId},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: requestConnection error: ${e.message}');
      return false;
    }
  }

  /// Accepts an incoming connection request.
  Future<bool> acceptConnection(String endpointId) async {
    try {
      final res = await _methods.invokeMethod<bool>(
        'acceptConnection',
        {'endpointId': endpointId},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: acceptConnection error: ${e.message}');
      return false;
    }
  }

  /// Rejects an incoming connection request.
  Future<bool> rejectConnection(String endpointId) async {
    try {
      final res = await _methods.invokeMethod<bool>(
        'rejectConnection',
        {'endpointId': endpointId},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: rejectConnection error: ${e.message}');
      return false;
    }
  }

  /// Sends a text message (e.g. "Hello") to a specific connected peer.
  Future<bool> sendMessage(String endpointId, String text) async {
    if (text.trim().isEmpty) return false;
    try {
      final res = await _methods.invokeMethod<bool>(
        'sendMessage',
        {'endpointId': endpointId, 'text': text},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: sendMessage error: ${e.message}');
      return false;
    }
  }

  /// Sends a text message to ALL connected peers simultaneously (offline broadcast).
  Future<bool> broadcastMessage(String text) async {
    if (text.trim().isEmpty) return false;
    try {
      final res = await _methods.invokeMethod<bool>(
        'broadcastMessage',
        {'text': text},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: broadcastMessage error: ${e.message}');
      return false;
    }
  }

  /// Disconnects from a specific peer.
  Future<bool> disconnect(String endpointId) async {
    try {
      final res = await _methods.invokeMethod<bool>(
        'disconnectFromDevice',
        {'endpointId': endpointId},
      );
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: disconnect error: ${e.message}');
      return false;
    }
  }

  /// Shuts down all advertising, discovery, and connections.
  Future<bool> stopAll() async {
    try {
      final res = await _methods.invokeMethod<bool>('stopAll');
      return res ?? false;
    } on PlatformException catch (e) {
      print('NearbyService: stopAll error: ${e.message}');
      return false;
    }
  }
}
