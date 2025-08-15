import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();

  factory SignalRService() => _instance;

  SignalRService._internal();

  HubConnection? _connection;
  final _responseCompleters = <String, Completer<dynamic>>{};
  bool _isRenderingHomeScreen = false; // Флаг, чтобы отслеживать выполнение RenderHomeScreen

  Future<void> connect() async {
    if (_connection != null && _connection!.state == HubConnectionState.Connected) {
      print("[SignalR] Already connected.");
      return;
    }

    final serverUrl = 'http://57.152.32.239:5279/notify-tracker';

    _connection = HubConnectionBuilder()
        .withUrl(serverUrl)
        .withAutomaticReconnect()
        .build();

    _connection!.onclose(({error}) {
      print("[SignalR] Connection closed: $error");
    });

    _connection!.on("HomeScreenRendered", (arguments) {
      print("[SignalR] Received 'HomeScreenRendered' event: $arguments");
      if (arguments != null && arguments.isNotEmpty) {
        print("[SignalR] Data from 'HomeScreenRendered': ${arguments.first}");
      } else {
        print("[SignalR] No data received from 'HomeScreenRendered'.");
      }
      final completer = _responseCompleters.remove("HomeScreenRendered");
      completer?.complete(arguments?.first);
    });

    _connection!.on("RestaurantFetchedSuccessfully", (arguments) {
      print("[SignalR] Received 'RestaurantFetchedSuccessfully' event: $arguments");
      if (arguments != null && arguments.isNotEmpty) {
        print("[SignalR] Data from 'RestaurantFetchedSuccessfully': ${arguments.first}");
      } else {
        print("[SignalR] No data received from 'RestaurantFetchedSuccessfully'.");
      }
      final completer = _responseCompleters.remove("RestaurantFetchedSuccessfully");
      completer?.complete(arguments?.first);
    });

    _connection!.on("error", (args) {
      print("⚠️ [SignalR] Error received: $args");
    });

    try {
      await _connection!.start();
      print("[SignalR] Connected successfully.");
    } catch (e) {
      print("[SignalR] Error during connection: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> invokeRenderHomeScreen(String address) async {
    if (_isRenderingHomeScreen) {
      print("[SignalR] RenderHomeScreen is already being invoked.");
      return {}; // Возвращаем пустой объект, чтобы избежать повторных вызовов
    }

    _isRenderingHomeScreen = true;

    print("[SignalR] Invoking RenderHomeScreen with address: $address");

    if (_connection == null || _connection!.state != HubConnectionState.Connected) {
      await connect();
    }

    final homeCompleter = Completer<dynamic>();
    final restaurantCompleter = Completer<dynamic>();
    _responseCompleters["HomeScreenRendered"] = homeCompleter;
    _responseCompleters["RestaurantFetchedSuccessfully"] = restaurantCompleter;

    try {
      await _connection!.invoke("RenderHomeScreen", args: ['']);
      print("[SignalR] 'RenderHomeScreen' invoked successfully.");
    } catch (e) {
      print("[SignalR] Error invoking 'RenderHomeScreen': $e");
      _isRenderingHomeScreen = false;
      rethrow;
    }

    try {
      final home = await homeCompleter.future.timeout(const Duration(seconds: 10));
      final restaurants = await restaurantCompleter.future.timeout(const Duration(seconds: 10));

      if (home == null || restaurants == null) {
        throw Exception("Received null data from SignalR.");
      }

      print("[SignalR] Successfully received home and restaurant data.");
      print("[SignalR] Home data: $home");
      print("[SignalR] Restaurants data: $restaurants");

      _isRenderingHomeScreen = false; // Разблокировать вызов
      return {
        'home': home ?? {},
        'restaurants': restaurants ?? {},
      };
    } catch (e) {
      _responseCompleters.remove("HomeScreenRendered");
      _responseCompleters.remove("RestaurantFetchedSuccessfully");
      _isRenderingHomeScreen = false;
      print("[SignalR] Timeout or error while waiting for response: $e");
      throw Exception("SignalR timeout or error: $e");
    }
  }

  void dispose() {
    _connection?.stop();
  }
}