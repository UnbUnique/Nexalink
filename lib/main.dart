import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'state/app_state.dart';
import 'state/mesh_network_state.dart';
import 'state/message_state.dart';
import 'state/broadcast_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => MeshNetworkState()),
        ChangeNotifierProvider(create: (_) => MessageState()),
        ChangeNotifierProvider(create: (_) => BroadcastState()),
      ],
      child: const CampusMeshApp(),
    ),
  );
}
