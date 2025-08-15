import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _connection;
  Completer<void>? _screenOperationCompleter;
  Completer<List<dynamic>>? _addressCompleter;
  Completer<void>? _selectAddressCompleter;
  String? _currentWindowReference;
  bool _connected = false;
  Completer<Map<String, dynamic>>? _restaurantDataCompleter;
  Map<String, dynamic>? _lastRestaurantData;

  Future<void> connect() async {
    if (_connected && _connection?.state == HubConnectionState.Connected) return;

    _connection = HubConnectionBuilder()
        .withUrl("http://10.0.2.2:5279/notify-tracker")
        .withAutomaticReconnect()
        .build();

    _connection!.on("NotifyEvent", (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final data = arguments.first;
      if (data is! Map<String, dynamic>) return;

      final message = data["Message"];
      print("[SignalR] NotifyEvent: $message");

      switch (message) {
        case "RestaurantFetchedSuccessfully":
          print("[SignalR] Received restaurant data");

          _currentWindowReference = data["CurrentWindowReference"];

          Future.delayed(Duration(seconds: 5), () {
            if (_restaurantDataCompleter != null && !_restaurantDataCompleter!.isCompleted) {
              _restaurantDataCompleter!.complete(data);
              _restaurantDataCompleter = null;
            }

            if (_screenOperationCompleter != null && !_screenOperationCompleter!.isCompleted) {
              _screenOperationCompleter!.complete();
              _screenOperationCompleter = null;
            }
          });

         
          break;

        case "HomeScreenRendered":
          _currentWindowReference = data["CurrentWindowReference"];
          _screenOperationCompleter?.complete();
          _screenOperationCompleter = null;
          break;

        case "AddressResult":
          final addresses = data["Address"] ?? [];
          _addressCompleter?.complete(List.from(addresses));
          _addressCompleter = null;
          break;

        case "SaveAddressSuccess":
          _selectAddressCompleter?.complete();
          _selectAddressCompleter = null;
          _invokeGetNextDialog();
          break;

        case "ChooseBuildingType":
          _invokeSkipBuildingType();
          break;

        case "SkipBuildingType":
          break;

        case "SaveAddress":
          _invokeSaveAddressClicked();
          break;

        case "AddressSavedSuccessfully":
          print("[SignalR] Address saved successfully.");
          break;

        default:
          print("[SignalR] Unknown message: $message");
      }
    });

    _connection!.onclose(({error}) {
      print("[SignalR] Connection closed: $error");
      _connected = false;
    });

    await _connection!.start();
    _connected = true;
    print("[SignalR] Connected.");
  }

  Future<Map<String, dynamic>> renderHomeScreen(String address) async {
    await connect();

    // Если уже есть данные, возвращаем сразу
    if (_lastRestaurantData != null) {
      print("[SignalR] Cached data exists, skipping render");
      return _lastRestaurantData!;
    }

    if (_screenOperationCompleter == null || _screenOperationCompleter!.isCompleted) {
      _screenOperationCompleter = Completer<void>();
    }

    // Проверка, если уже есть окно
    if (_currentWindowReference != null) {
      print("[SignalR] Window already rendered");
      _screenOperationCompleter!.complete();
      return _lastRestaurantData ?? {};
    }

    try {
      print("[SignalR] Invoking RenderHomeScreen...");
      await _connection!.invoke("RenderHomeScreen", args: [address]);
    } catch (e, st) {
      print("❌ Error during invoke: $e\n$st");
      rethrow;
    }

    await _screenOperationCompleter!.future.timeout(
      Duration(seconds: 10),
      onTimeout: () => throw Exception("Timeout while waiting for RestaurantFetchedSuccessfully"),
    );

    if (_lastRestaurantData == null) {
      throw Exception("Restaurant data was not received after rendering");
    }

    return _lastRestaurantData!;
  }

  Future<List<dynamic>> searchAddress(String address) async {
    await connect();

    _addressCompleter = Completer<List<dynamic>>();

    try {
      await _connection!.invoke("SearchAddress", args: [address]);
    } catch (e, st) {
      print("❌ Error during SearchAddress: $e\n$st");
      rethrow;
    }

    return _addressCompleter!.future.timeout(
      Duration(seconds: 10),
      onTimeout: () => throw Exception("Timeout while waiting for AddressResult"),
    );
  }

  Future<void> selectAddress(int index) async {
    await connect();

    _selectAddressCompleter = Completer<void>();

    try {
      await _connection!.invoke("SelectAddress", args: [index]);
    } catch (e, st) {
      print("❌ Error during SelectAddress: $e\n$st");
      rethrow;
    }

    await _selectAddressCompleter!.future.timeout(
      Duration(seconds: 10),
      onTimeout: () => throw Exception("Timeout while waiting for SaveAddressSuccess"),
    );
  }

  void _invokeGetNextDialog() async {
    try {
      await _connection!.invoke("GetNextDialog");
    } catch (e) {
      print("❌ Error during GetNextDialog: $e");
    }
  }

  void _invokeSkipBuildingType() async {
    try {
      await _connection!.invoke("SkipBuildingType");
    } catch (e) {
      print("❌ Error during SkipBuildingType: $e");
    }
  }

  void _invokeSaveAddressClicked() async {
    try {
      await _connection!.invoke("SaveAddressClicked", args: [""]);
    } catch (e) {
      print("❌ Error during SaveAddressClicked: $e");
    }
  }
}


  // --- Invoke home screen ---
  // Future<void> invokeRenderHomeScreen(String address) async {
  //   if (_isHomeScreenRendered) {
  //     print("[SignalR] HomeScreen already rendered — skipping invoke.");
  //     return;
  //   }
  //   _isHomeScreenRendered = true;
  //   await connect();

  //   _homeScreenRenderedCompleter = Completer<void>();

  //   print("[SignalR] Invoking RenderHomeScreen with address: $address");
  //   await _connection!.invoke("RenderHomeScreen", args: [address]);

  //   await _homeScreenRenderedCompleter!.future.timeout(Duration(seconds: 30));
  //   print("[SignalR] HomeScreenRendered received.");
  // }

  // // --- Invoke search address ---
  // Future<dynamic> invokeSearchAddress(String address) async {
  //   if (_currentWindowReference == null) {
  //     throw Exception("CurrentWindowReference is not set.");
  //   }

  //   _addressResultCompleter = Completer<dynamic>();

  //   print("[SignalR] Invoking SearchAddress: $address");
  //   await _connection!.invoke("SearchAddress", args: [address]);

  //   final result = await _addressResultCompleter!.future.timeout(Duration(seconds: 30));
  //   print("[SignalR] AddressResult: $result");

  //   return result;
  // }

  // // --- Invoke select address ---
  // Future<dynamic> invokeSelectAddress(String address) async {
  //   _selectAddressCompleter = Completer<dynamic>();

  //   print("[SignalR] Invoking SelectAddress: $address");
  //   await _connection!.invoke("SelectAddress", args: [address]);

  //   final result = await _selectAddressCompleter!.future.timeout(Duration(seconds: 30));
  //   print("[SignalR] SelectAddress result: $result");

  //   return result;
  // }

  // // --- Reset state if needed (например, при логауте) ---
  // void reset() {
  //   _isHomeScreenRendered = false;
  //   _currentWindowReference = null;
  // }

  // --- Disconnect ---
//   void dispose() {
//     _connection?.stop();
//   }
// }
