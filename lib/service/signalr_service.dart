import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:gymeats_mobile/screen/appmanager/app_manager_screen.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _connection;
  Completer<void>? _screenOperationCompleter;
  Completer<void>? _renderHomeCompleter;
  Map<String, dynamic>? _restaurantData;
  String? _currentWindowReference;
  bool _connected = false;
  Completer<void>? _addressCompleter;
  Completer<void>? _selectAddressCompleter;
  List<dynamic>? _lastAddressResults;
  List<Map<String, dynamic>> _restaurantCategories = [];
  Completer<void>? _restaurantCategoriesCompleter;
  Completer<void>? _storeItemsCompleter;
  List<dynamic>? _storeItemsData;
  Completer<void>? _selectRestaurantCompleter;
  List<dynamic>? _selectedRestaurantCategories;
  String? _userId;
  Completer<void>? _customizationCompleter;
  Map<String, dynamic>? _customizationPayload;
  bool _hasShopRestaurant = false;
  Completer<void>? _restaurantSubcategoriesCompleter;
  List<dynamic>? _restaurantSubcategories = [];
  Completer<dynamic>? _addItemsToCartCompleter;
  Completer<dynamic>? _getCartInformationCompleter;
  Completer<dynamic>? _goToCheckoutCompleter;  
  Completer<dynamic>? _getViewCartItemsCompleter;
  Completer<void>? _openRestaurantCartCompleter;
  Completer<void>? _selectQuantityCompleter;
  Completer<void>? _editDeliveryInstructionsCompleter;
  
 Completer<dynamic>? _adjustCartItemCompleter;
  String? test = 'AC00C94BF33B895AFB3A43895897BCAC';
  Future<void> connect() async {
    if (_connected && _connection?.state == HubConnectionState.Connected) return;

    // _connection = HubConnectionBuilder()
    //     .withUrl("http://10.0.2.2:5279/notify-tracker")
    //     .withAutomaticReconnect()
    //     .build();

    _connection = HubConnectionBuilder()
        .withUrl("http://57.152.32.239:5279/notify-tracker")
        .withAutomaticReconnect()
        .build();

  //         if (_connection!.state == HubConnectionState.Connected) {
  //   print('Already connected');
  //   _connected = true;
  //   return;
  // }

  // if (_connection!.state != HubConnectionState.Disconnected) {
  //   print('Cannot connect: current state is ${_connection!.state}');
  //   return;
  // }

  // try {
  //   print('Starting connection...');
  //   await _connection!.start()!.timeout(const Duration(seconds: 5));
  //   print('Connection started successfully');
  //   _connected = true;
  // } on TimeoutException {
  //   print('Timeout while connecting');
  //   _connected = false;
  // } catch (e) {
  //   print('Failed to connect: $e');
  //   _connected = false;
  // }

    _connection!.on("NotifyEvent", (arguments) {
      if (arguments == null || arguments.isEmpty) return;
      final data = arguments.first;
      if (data is! Map<String, dynamic>) return;

      var message = data["Message"];
      print('MESSAGE RECIEVED');
      print(data);

      switch (message) {
        case "RestaurantFetchedSuccessfully":
          print(data);
          _restaurantData = data;
          _currentWindowReference = data["CurrentWindowReference"];
          if (_screenOperationCompleter != null && !_screenOperationCompleter!.isCompleted) {
            Future.delayed(Duration(seconds: 1), () {
              if (_screenOperationCompleter != null && !_screenOperationCompleter!.isCompleted) {
                _screenOperationCompleter!.complete();
                _screenOperationCompleter = null;
              }
            });
          }
          break;

        case "HomeScreenRendered":
          print("HomeScreenRendered33");
          print(data);

          try {
            print('123 inside Home Screen');
            _currentWindowReference = data["CurrentWindowReference"];
            print("_currentWindowReference: $_currentWindowReference");

            if (_renderHomeCompleter != null) {
              if (!_renderHomeCompleter!.isCompleted) {
                print("_renderHomeCompleter");
                _renderHomeCompleter!.complete();
              } else {
                print("WARN: _renderHomeCompleter completed");
              }
            } else {
              print("WARN: _renderHomeCompleter == null");
            }

            _renderHomeCompleter = null;
          } catch (e, stack) {
            print('444 inside Home Screen');
            print("ERROR внутри case HomeScreenRendered: $e\n$stack");
          }

          break;

        case "AddItemToCartResponse":
          print(' AddItemsToCart result');

          if (_addItemsToCartCompleter != null && !_addItemsToCartCompleter!.isCompleted) {
            _addItemsToCartCompleter!.complete();
          }
          break;

        case "GetCartInformationResponse":
          print(' [SignalR] GetCartInformationResponse result');
          print(data);

          try {
            final parsedData = Map<String, dynamic>.from(data);
            final cartDetailsRawString = parsedData["CartItems"];

            if (cartDetailsRawString is! String) {
              print(" [SignalR] Expected ViewCartItemsDetails to be a String, got: ${cartDetailsRawString.runtimeType}");
              return;
            }

            List<dynamic> decodedList;
            try {
              decodedList = jsonDecode(cartDetailsRawString);
              print(" [SignalR] Decoded ViewCartItemsDetails: $decodedList");
            } catch (e) {
              print(" [SignalR] Failed to decode ViewCartItemsDetails string: $e");
              return;
            }

            final cartInformationResult = List<Map<String, dynamic>>.from(decodedList);

            if (_getCartInformationCompleter != null && !_getCartInformationCompleter!.isCompleted) {
              _getCartInformationCompleter!.complete(cartInformationResult);
              _getCartInformationCompleter = null;
            }
          } catch (e, stack) {
            print("🔥 [SignalR] Error parsing GetCartInformationResponse: $e\n$stack");
          }
          break;

        case "GoToCheckoutResponse":
          print(' [SignalR] GoToCheckoutResponse result');
          print(data);

          try {
            final parsedData = Map<String, dynamic>.from(data);
            final deliveryDetailsRawString = parsedData["DeliveryDetails"];

            if (deliveryDetailsRawString is! String) {
              print(" [SignalR] Expected DeliveryDetails to be a String, got: ${deliveryDetailsRawString.runtimeType}");
              return;
            }

            Map<String, dynamic> decodedMap;
            try {
              decodedMap = jsonDecode(deliveryDetailsRawString);
              print(" [SignalR] Decoded DeliveryDetails: $decodedMap");
            } catch (e) {
              print(" [SignalR] Failed to decode DeliveryDetails string: $e");
              return;
            }

            if (_goToCheckoutCompleter != null && !_goToCheckoutCompleter!.isCompleted) {
              _goToCheckoutCompleter!.complete(decodedMap);
              _goToCheckoutCompleter = null;
            }
          } catch (e, stack) {
            print(" [SignalR] Error parsing GoToCheckoutResponse: $e\n$stack");
          }
          break;

        case "GetViewCartItemsResponse":
          print(' [SignalR] GetViewCartItemsResponse result');
          print(data);

          try {
            final parsedData = Map<String, dynamic>.from(data);
            final rawItems = parsedData["ViewCartItemsDetails"];

            late List<dynamic> decodedList;

            if (rawItems is String) {
              try {
                decodedList = jsonDecode(rawItems);
                print(" [SignalR] Decoded ViewCartItemsDetails from string");
              } catch (e) {
                print(" Failed to decode ViewCartItemsDetails string: $e");
                return;
              }
            } else if (rawItems is List) {
              decodedList = rawItems;
            } else {
              print(" Unexpected type for ViewCartItemsDetails: ${rawItems.runtimeType}");
              return;
            }

            final cartItems = List<Map<String, dynamic>>.from(decodedList);

            if (_getViewCartItemsCompleter != null && !_getViewCartItemsCompleter!.isCompleted) {
              _getViewCartItemsCompleter!.complete(cartItems);
              _getViewCartItemsCompleter = null;
            }
          } catch (e, stack) {
            print(" [SignalR] Error parsing GetViewCartItemsResponse: $e\n$stack");
          }
          break;

        case "SaveAddressSuccess":
          _selectAddressCompleter?.complete();
          _selectAddressCompleter = null;
          _invokeGetNextDialog();
          break;

        case "ChooseBuildingType":
          _invokeSkipBuildingType();
          break;

        case "SaveAddress":
          _invokeSaveAddressClicked();
          break;

        case "EditDeliveryInstructionsResponse":
          print(' [SignalR] EditDeliveryInstructionsResponse');
          print(data);
          if (_editDeliveryInstructionsCompleter != null && !_editDeliveryInstructionsCompleter!.isCompleted) {
            _editDeliveryInstructionsCompleter!.complete();
            _editDeliveryInstructionsCompleter = null;
          }
          break;

        case "AddressSavedSuccessfully":
          print("[SignalR] Address saved successfully.");
          break;

        case "RestaurantCategoriesFetchedSuccessfully":


          try {
            final Map<String, dynamic> parsedData = Map<String, dynamic>.from(data);

            final rawCategories = parsedData["RestaurantCategories"];

            late final List<dynamic> categories;

            if (rawCategories is String) {
              try {
                categories = jsonDecode(rawCategories);
                print('categories after jsonDecode: $categories');
              } catch (e) {
                print(" [SignalR] Failed to decode JSON string in RestaurantCategories: $e");
                return;
              }
            } else if (rawCategories is List) {
              categories = rawCategories;
            } else {
              print(" [SignalR] Unexpected type for RestaurantCategories: ${rawCategories.runtimeType}");
              return;
            }

            if (categories.isNotEmpty && categories.first is Map<String, dynamic>) {
              _restaurantCategories = List<Map<String, dynamic>>.from(categories);
            } else {
              print(" [SignalR] Categories data is invalid!");
              return;
            }

            if (_restaurantCategoriesCompleter == null) {
              print(" [SignalR] _restaurantCategoriesCompleter is NULL when event is received!");
            } else if (_restaurantCategoriesCompleter!.isCompleted) {
              print(" [SignalR] _restaurantCategoriesCompleter already COMPLETED!");
            } else {
              Future.delayed(Duration(milliseconds: 100), () {
                try {
                  if (_restaurantCategoriesCompleter != null && !_restaurantCategoriesCompleter!.isCompleted) {
                    print(" [SignalR] Completing _restaurantCategoriesCompleter...");
                    _restaurantCategoriesCompleter!.complete();
                    _restaurantCategoriesCompleter = null;
                  } else {
                    print(" [SignalR] Skipped completer completion due to late state");
                  }
                } catch (e, stack) {
                  print(" Error inside delayed completion: $e\n$stack");
                }
              });
            }
          } catch (e, stackTrace) {
            print("Error in handler for RestaurantCategoriesFetchedSuccessfully: $e");
            print(stackTrace);
          }
          break;

        case "GetRestaurantSubcategoriesResponse":
          print(" [SignalR] GetRestaurantSubcategoriesResponse received");
          print(data);

          try {
            final parsedData = Map<String, dynamic>.from(data);
            final subcategoriesRawString = parsedData["SubcategoriesResponse"];

            if (subcategoriesRawString is! String) {
              print(" [SignalR] Expected SubcategoriesResponse to be a String, got: ${subcategoriesRawString.runtimeType}");
              return;
            }

            Map<String, dynamic> decodedResponse;
            try {
              decodedResponse = jsonDecode(subcategoriesRawString);
              print(" [SignalR] Decoded SubcategoriesResponse: $decodedResponse");
            } catch (e) {
              print(" [SignalR] Failed to decode SubcategoriesResponse string: $e");
              return;
            }

            // _hasShopRestaurant = decodedResponse["HasShopRestaurant"] == true;

            final subcategoriesList = decodedResponse["Subcategories"];

            if (subcategoriesList is! List) {
              print(" [SignalR] Subcategories field is not a List: ${subcategoriesList.runtimeType}");
              _restaurantSubcategories = [];
            } else {
              _restaurantSubcategories = List<String>.from(subcategoriesList);
            }

            if (_restaurantSubcategoriesCompleter != null && !_restaurantSubcategoriesCompleter!.isCompleted) {
              _restaurantSubcategoriesCompleter!.complete();
              _restaurantSubcategoriesCompleter = null;
            }

          } catch (e, stack) {
            print("[SignalR] Error parsing GetRestaurantSubcategoriesResponse: $e\n$stack");
          }

          break;

        case 'AdjustCartItemQuantityResponse': 
          if (_adjustCartItemCompleter != null && !_adjustCartItemCompleter!.isCompleted) {
            _adjustCartItemCompleter!.complete();
            _adjustCartItemCompleter = null;
          }

        case "GetItemResponse":
          print(" Received GetItemResponse");
          print(data);

          try {
            final rawItems = data["StoreItems"];

            late final List<dynamic> items;

            if (rawItems is String) {
              try {
                final decoded = jsonDecode(rawItems);
                
                if (decoded is Map<String, dynamic> && decoded.containsKey('StoreItems')) {
                  items = decoded['StoreItems'];
                } 
                else if (decoded is List) {
                  items = decoded;
                }
                else {
                  print(" Unexpected StoreItems format: $decoded");
                  return;
                }
                
                print(" Decoded StoreItems from string: $items");
              } catch (e, st) {
                print(" Failed to decode StoreItems JSON string: $e");
                print(st);
                return;
              }
            } else if (rawItems is List) {
              items = rawItems;
            } else {
              print(" Unexpected type for StoreItems: ${rawItems.runtimeType}");
              return;
            }

            _storeItemsData = items;

            if (_storeItemsCompleter != null && !_storeItemsCompleter!.isCompleted) {
              print("Completing _storeItemsCompleter...");
              _storeItemsCompleter!.complete();
              _storeItemsCompleter = null;
            } else {
              print(" No completer to complete or already completed.");
            }
          } catch (e, stack) {
            print(" Error in GetItemResponse handler: $e");
            print(stack);
          }
          break;
        case "GetCustomizationResponse":
          print(" Received GetCustomizationResponse");
          print(data);
          try {
            final storeItems = data["StoreItems"];

            late Map<String, dynamic> decoded;

            if (storeItems is String) {
              try {
                final parsed = jsonDecode(storeItems);
                if (parsed is Map<String, dynamic>) {
                  decoded = parsed;
                } else {
                  print(" StoreItems string is not a valid JSON object");
                  return;
                }
              } catch (e) {
                print(" Failed to decode StoreItems JSON string: $e");
                return;
              }
            } else if (storeItems is Map<String, dynamic>) {
              decoded = storeItems;
            } else {
              print(" Unexpected type for StoreItems: ${storeItems.runtimeType}");
              return;
            }

            final customizations = decoded["Customizations"];
            if (customizations is! List) {
              print(" Customizations key missing or not a list");
              return;
            }

            final isUnavailable = decoded["IsItemsUnavailable"] == true;

            _customizationPayload = {
              "customizations": customizations,
              "isItemsUnavailable": isUnavailable,
            };

            print(" Parsed Customizations: ${_customizationPayload!['customizations']}");
            print(" IsItemsUnavailable: $isUnavailable");

            if (_customizationCompleter != null && !_customizationCompleter!.isCompleted) {
              print(" Completing _customizationCompleter...");
              _customizationCompleter!.complete();
              _customizationCompleter = null;
            } else {
              print(" No customization completer to complete or already completed.");
            }
          } catch (e, stack) {
            print(" Error in GetCustomizationResponse handler: $e");
            print(stack);
          }
          break;

        case "SelectRestaurantResponse":
          print(' Received SelectRestaurantResponse');
          print(data);

          try {
            late final Map<String, dynamic> parsedData;
            try {
              parsedData = Map<String, dynamic>.from(data);
            } catch (e, st) {
              print(st);
              return;
            }

            final rawCategories = parsedData["Categories"];
            late final List<dynamic> categories;

            try {
              if (rawCategories is String) {
                try {
                  final decoded = jsonDecode(rawCategories);
                  
                  if (decoded is Map<String, dynamic> && decoded.containsKey('Categories')) {
                    if (decoded.containsKey("HasShopRestaurant")) {
                      _hasShopRestaurant = decoded["HasShopRestaurant"] == true;
                      print('HasShopRestaurant: $_hasShopRestaurant');
                    }
                    final innerCategories = decoded['Categories'];
                    
                    if (innerCategories is Map<String, dynamic> && innerCategories.containsKey('Categories')) {
                      categories = innerCategories['Categories'];
                    } else {
                      categories = innerCategories;
                    }
                  } 
                  else {
                    categories = decoded;
                  }
                  
                  print(' Categories after jsonDecode: $categories');
                } catch (e, st) {
                  print(" Error during Json Decode Categories: $e");
                  print(st);
                  return;
                }
              } else if (rawCategories is List) {
                categories = rawCategories;
              } else {
                print(" Categories wrong foremat: ${rawCategories.runtimeType}");
                return;
              }
            } catch (e, st) {
              print(" error during fetching categories: $e");
              print(st);
              return;
            }

            try {
              _selectedRestaurantCategories = List<String>.from(categories);
              print(' Parsed categories: $_selectedRestaurantCategories');
            } catch (e, st) {
              print(st);
              return;
            }

            try {
              if (_selectRestaurantCompleter != null && !_selectRestaurantCompleter!.isCompleted) {
                print(' Completing SelectRestaurant completer');
                _selectRestaurantCompleter!.complete();
                _selectRestaurantCompleter = null;
              } else {
                print(' _selectRestaurantCompleter completed');
              }
            } catch (e, st) {
              print("Error during complete: $e");
              print(st);
              return;
            }

          } catch (e, stackTrace) {
            print(" Erorr SelectRestaurantResponse: $e");
            print(stackTrace);
          }
          break;

        case "OpenRestaurantCartResponse":
          print(' [SignalR] OpenRestaurantCartResponse result');
          print(data);
          if (_openRestaurantCartCompleter != null && !_openRestaurantCartCompleter!.isCompleted) {
              _openRestaurantCartCompleter!.complete();
              _openRestaurantCartCompleter = null;
            }
          break;

        case "QuantitySelectedSuccessfully":
          print(' QuantitySelectedSuccessfully received');

          if (_selectQuantityCompleter != null && !_selectQuantityCompleter!.isCompleted) {
            _selectQuantityCompleter!.complete();
            _selectQuantityCompleter = null;
          }
          break;

        case "ErrorResponse":
          print(' Received ErrorResponse');
          print(data);

          if (_addItemsToCartCompleter != null && !_addItemsToCartCompleter!.isCompleted) {
            _addItemsToCartCompleter!.completeError(Exception("AddItemsToCart failed: ${data.toString()}"));
          }
          if (_openRestaurantCartCompleter != null && !_openRestaurantCartCompleter!.isCompleted) {
            _openRestaurantCartCompleter!.complete();
            _openRestaurantCartCompleter = null;
          }

          final isExpired = data['IsUserSessionExpired'];
          if (isExpired == true || isExpired == 'true') {
            _currentWindowReference = null;
            print('Session expired — redirecting to Dashboard');
            Get.offAll(AppManagerScreen(selectIndex: 2));
          }

          break;

        default:
          print("[SignalR] Unknown message: $message");
      }
    });

    _connection!.onclose(({error}) {
      _connected = false;
    });

    await _connection!.start();
    _connected = true;
  }

  Future<void> selectQuantity(int quantity) async {
    await connect();

    if (_selectQuantityCompleter == null || _selectQuantityCompleter!.isCompleted) {
      print(' Creating new _selectQuantityCompleter');
      _selectQuantityCompleter = Completer<void>();
    }

    final localCompleter = _selectQuantityCompleter!;

    print('Invoking SelectQuantity with quantity: $quantity');

    try {
      await _connection!.invoke("SelectQuantity", args: [
        quantity.toString(),
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking SelectQuantity: $e');
      throw Exception("Error invoking SelectQuantity: $e");
    }

    try {
      await localCompleter.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!_selectQuantityCompleter!.isCompleted) {
            _selectQuantityCompleter!.completeError(Exception("Timeout while waiting for QuantitySelectedSuccessfully response"));
          }
          throw Exception("Timeout while waiting for QuantitySelectedSuccessfully response");
        },
      );

      print('SelectQuantity completed');
    } catch (e) {
      print("selectQuantity failed: $e");
      return Future.error(e);
    }
  }

  Future<void> openRestaurantCart() async {
    await connect();

    if (_openRestaurantCartCompleter == null || _openRestaurantCartCompleter!.isCompleted) {
      print(' Creating new _openRestaurantCartCompleter');
      _openRestaurantCartCompleter = Completer<void>();
    }

    final localCompleter = _openRestaurantCartCompleter!;

    print('Sending OpenRestaurantCart command');

    try {
      _connection!.send("OpenRestaurantCart", args: [
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      throw Exception("Error sending OpenRestaurantCart: $e");
    }

    await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for OpenRestaurantCart response"),
    );

    print(' OpenRestaurantCart completed');
  }

  Future<bool> renderHomeScreen(String address, {String? userId}) async {
    if (_currentWindowReference == null) {
      await initializeWindowReference(address: address, userId: userId ?? _userId!);
    }

    _renderHomeCompleter = Completer<void>();
    final localCompleter = _renderHomeCompleter!;

    try {
      print('BEFORE INVOKE, $userId, $_userId, $_currentWindowReference, $address');
      await _connection!.invoke("RenderHomeScreen", args: [_userId!, _currentWindowReference!, address]);
    } catch (e) {
      throw Exception("Error in RenderHomeScreen: $e");
    }
    try {
      await localCompleter.future.timeout(
        Duration(seconds: 20),
        onTimeout: () => throw Exception("HomeScreenRendered TimeOut"),
      );
    } catch (e) {
      throw Exception("RenderHomeScreen erorr: $e");
    }

    return true;
  }

  Future<List<Map<String, dynamic>>> getRestaurantCategories([String? address = '', String? userId]) async {
    if (_currentWindowReference == null) {
      print('Current Windwos Reference is Null InititalizeWindowReference');
      await initializeWindowReference(address: address!, userId: userId!);
    }

    final prefs = await SharedPreferences.getInstance();
    final currentAddress = prefs.getString('currentUserAddress') ?? '';

    if (currentAddress.trim().isEmpty) {
      print('Address is empty');
      return [];
    }

    final cacheKey = 'categoryCache_$currentAddress';
    final cachedCategoriesString = prefs.getString(cacheKey);

    if (cachedCategoriesString != null) {
      final cachedList = jsonDecode(cachedCategoriesString) as List<dynamic>;
      final cachedData = cachedList.cast<Map<String, dynamic>>();
      print(' Categories loaded from cache: $currentAddress');
      return cachedData;
    }

    await connect();
    final addressUpdated = prefs.getBool('AddressUpdated') ?? false;
    print(prefs.getBool('AddressUpdated'));
    if (addressUpdated) {
      print(" AddressUpdated = true");
      await renderHomeScreen(address!);
      await prefs.setBool('AddressUpdated', false);
      print("AddressUpdated false");
    }

    print(" [SignalR] getRestaurantCategories started");

    try {
      print("[SignalR] Sending invoke: GetRestaurantCategories");
      final result = await _connection!.invoke("GetRestaurantCategories", args: [_currentWindowReference!, _userId!]);
      print('RESULT FOR GET CATEGORIES');
      print(result);
      if (result == null) throw Exception("Empry response GetRestaurantCategories");

      List<dynamic> categoriesRaw;

      if (result is String) {
        try {
          categoriesRaw = jsonDecode(result);
          print("[SignalR] Categories decoded from string: $categoriesRaw");
        } catch (e) {
          print(" Erorr during parsing GetRestaurantCategories: $e");
          return [];
        }
      } else if (result is List) {
        categoriesRaw = result;
      } else {
        print("Wrong Format: ${result.runtimeType}");
        return [];
      }

      if (categoriesRaw.isEmpty || categoriesRaw.first is! Map<String, dynamic>) {
        throw Exception("Wrong Format");
      }

      final categories = List<Map<String, dynamic>>.from(categoriesRaw);

      final filteredCategories = categories.where((cat) {
        final title = cat["title"] ?? cat["Title"] ?? "";
        return title != "Grocery";
      }).toList();
      await prefs.setString(cacheKey, jsonEncode(filteredCategories));
      print("Categories saved in cache $cacheKey");

      return filteredCategories;
    } catch (e, stack) {
      print("Error during fetch Categories: $e\n$stack");
      rethrow;
    }
  }

  Future<void> placeOrder() async {
    if (_currentWindowReference == null) {
      print('Current Window Reference is null — initializing...');
      final prefs = await SharedPreferences.getInstance();
      final address = prefs.getString('currentUserAddress') ?? '';
      final userId = _userId;
      if (address.isEmpty || userId == null) {
        print('Address or User ID is missing. Cannot place order.');
        return;
      }

      await initializeWindowReference(address: address, userId: userId);
    }

    await connect();

    print("[SignalR] placeOrder started");

    try {
      print("[SignalR] Sending invoke: PlaceOrder");
      final result = await _connection!.invoke("PlaceOrder", args: [_currentWindowReference!, _userId!]);

      print("[SignalR] RESULT FOR PLACE ORDER:");
      print(result);
    } catch (e, stack) {
      print("Error during PlaceOrder: $e\n$stack");
    }
  }

  Future<List<String>> getRestaurantSubcategories(String categoryName) async {
    await connect();

    print(" [SignalR] Requesting subcategories for: $categoryName");

    if (_restaurantSubcategoriesCompleter == null || _restaurantSubcategoriesCompleter!.isCompleted) {
      print("Creating new _restaurantSubcategoriesCompleter");
      _restaurantSubcategoriesCompleter = Completer<void>();
    }

    final localCompleter = _restaurantSubcategoriesCompleter!;

    try {
      await _connection!.invoke(
        "GetRestaurantSubcategoriesByCategoryName",
        args: [categoryName, _currentWindowReference!, _userId!],
      );
    } catch (e) {
      print("[SignalR] Error invoking GetRestaurantSubcategoriesByCategoryName: $e");
      rethrow;
    }

    try {
      await localCompleter.future.timeout(
        Duration(seconds: 12),
        onTimeout: () => throw Exception("Timeout while waiting for GetRestaurantSubcategoriesResponse"),
      );
    } catch (e) {
      print("[SignalR] Timeout or error: $e");
      rethrow;
    }

    if (_restaurantSubcategories!.isEmpty) {
      throw Exception("No subcategories received for $categoryName");
    }

    return List<String>.from(_restaurantSubcategories!);
  }

  Future<void> initializeWindowReference({
    required String address,
    required String userId,
  }) async {
    print(userId);
    _userId = userId;
    print('TRY to ping');

    try {
      final uri = Uri.https(
        "gymeats.azurewebsites.net",
        "/api/SignalR/GetVirtualMachineDetail",
        {
          if (userId.isNotEmpty) "userId": userId,
          if (address.isNotEmpty) "address": address,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          "Api_Key": "peONDsofens8dfs6sfYi4RvtTwlEXpQBwo==",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Response: ${response.body}");

        if (jsonData["data"] != null &&
            jsonData["data"]["userWindowReferenceId"] != null) {
          _currentWindowReference = jsonData["data"]["userWindowReferenceId"];
          print("_currentWindowReference recieved: $_currentWindowReference");

          try {
            await _connection!.invoke("JoinAuthorizedGroup", args: [userId]);
            print("Joined authorized group");
          } catch (e) {
            print("Error during JoinAuthorizedGroup: $e");
          }
        } else {
          throw Exception("userWindowReferenceId not found");
        }
      } else {
        print(" Response: ${response.body}");
        throw Exception(
          "Erorr in VirtualMachineDetail: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error in CurrentWindowReference: $e");
    }
  }

  Future<void> releaseDriverByUserId() async {
    print('ReleaseDriverByUserId');
    try {
      final uri = Uri.https(
        "gymeats.azurewebsites.net",
        "/api/SignalR/ReleaseDriverByUserId",
      );

      final response = await http.delete(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Api_Key": "peONDsofens8dfs6sfYi4RvtTwlEXpQBwo==",
        },
        body: jsonEncode({
          "userId": _userId,
        }),
      );

      if (response.statusCode == 200) {
        _currentWindowReference = null;
        _userId = null;
        print(": ${response.body}");
      } else {
        print(": ${response.statusCode}");
        print(": ${response.body}");
      }
    } catch (e) {
      print("ReleaseDriverByUserId: $e");
      throw Exception("");
    }
  }

  Future<Map<String, dynamic>> getFilteredRestaurants({
    required String address,
    required String userId,
    required int pageIndex,
    required int pageSize,
    required Map<String, dynamic> filters,
    bool firstCall = false
  }) async {
    _restaurantData = null;
    await connect();
    print('getFilteredRestaurants');
    print(_currentWindowReference);
    if (_currentWindowReference == null) {
      await initializeWindowReference(address: address, userId: userId);
    }

    if (firstCall) {
      return  <String, dynamic>{};
    }
    final prefs = await SharedPreferences.getInstance();
    final addressUpdated = prefs.getBool('AddressUpdated') ?? false;

    if (addressUpdated) {
      print("AddressUpdated = true");

      // await renderHomeScreen(address);

      // await prefs.setBool('AddressUpdated', false);
      print("AddressUpdated false");
    }

    if (_screenOperationCompleter == null || _screenOperationCompleter!.isCompleted) {
      _screenOperationCompleter = Completer<void>();
    }

    
    print(address);
    print(_currentWindowReference);
    print(userId);
    print(pageIndex);
    print(pageSize);
    print(filters);

    Future<bool> tryFetchRestaurants() async {
      print('tryFetchRestaurants!!');
      try {
        print('Before invoke GetFilteredRestaurants');
        await _connection!.invoke("GetFilteredRestaurants", args: [
          address,
          _currentWindowReference!,
          pageIndex,
          pageSize,
          userId,
          filters
        ]);
      } catch (e) {
        throw Exception("Error during GetFilteredRestaurants invoke: $e");
      }

      try {
        await _screenOperationCompleter!.future.timeout(
          Duration(seconds: 20),
          onTimeout: () => null,
        );
      } catch (_) {
      }

      return _restaurantData != null;
    }

    if (!await tryFetchRestaurants()) {
      print("No data after first GetFilteredRestaurants, calling RenderHomeScreen...");

      try {
        await renderHomeScreen('');
      } catch (e) {
        throw Exception("RenderHomeScreen failed: $e");
      }

      if (!await tryFetchRestaurants()) {
        throw Exception("No filtered restaurant data received after RenderHomeScreen");
      }
   }

  return _restaurantData!;
  }

  Future<List<dynamic>> searchAddress(String address) async {
    await connect();

    if (_currentWindowReference == null) {
      await initializeWindowReference(address: address, userId: _userId!);
    }

    if (_addressCompleter == null || _addressCompleter!.isCompleted) {
      _addressCompleter = Completer<void>();
    }

    _lastAddressResults = null;
    print(address);
    print(_currentWindowReference);
    print(_userId);

    Future<bool> trySearchAddress() async {
      print('trySearchAddress');
      try {
        print('before invoke AddressInputCompleted');
        await _connection!.invoke(
          "AddressInputCompleted",
          args: [address, _currentWindowReference!, _userId!],
        );
      } catch (e) {
        throw Exception("Error during AddressInputCompleted invoke: $e");
      }

      try {
        await _addressCompleter!.future.timeout(
          Duration(seconds: 10),
          onTimeout: () => null,
        );
      } catch (_) {
      }

      return _lastAddressResults != null;
    }

    if (!await trySearchAddress()) {
      print("No address data after first try, calling RenderHomeScreen...");

      try {
        await renderHomeScreen('');
      } catch (e) {
        throw Exception("RenderHomeScreen failed: $e");
      }

      if (!await trySearchAddress()) {
        throw Exception("No address data received after RenderHomeScreen");
      }
    }

    print(_lastAddressResults);
    return _lastAddressResults!;
  }

  Future<void> selectAddress(int index) async {
    await connect();

    _selectAddressCompleter = Completer<void>();

    try {
      await _connection!.invoke("SelectAddress", args: [index]);
    } catch (e, st) {
      print("Error during SelectAddress: $e\n$st");
      rethrow;
    }

    await _selectAddressCompleter!.future.timeout(
      Duration(seconds: 10),
      onTimeout: () => throw Exception("Timeout while waiting for SaveAddressSuccess"),
    );
  }

  Future<Map<String, dynamic>> selectRestaurant(String restaurantName, {bool onlyCategories = false}) async {
    print('selectRestaurant');
    await connect();

    if (_selectRestaurantCompleter == null || _selectRestaurantCompleter!.isCompleted) {
      print(' Creating new completer');
      _selectRestaurantCompleter = Completer<void>();
    }

    final localCompleter = _selectRestaurantCompleter!;

    print(' Selecting restaurant: $restaurantName');
    print(_currentWindowReference!);
    print(_userId!);

    try {
      await _connection!.invoke("SelectRestaurant", args: [restaurantName, _currentWindowReference!, _userId!]);
    } catch (e) {
      throw Exception("Error during SelectRestaurant invoke: $e");
    }

    await localCompleter.future.timeout(
      Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for SelectRestaurantResponse"),
    );

    print(' Completer completed!');

    if (_selectedRestaurantCategories == null || _selectedRestaurantCategories!.isEmpty) {
      throw Exception("No restaurant categories received");
    }

    if (onlyCategories) {
      return {
        "categories": _selectedRestaurantCategories!,
        "hasShopRestaurant": _hasShopRestaurant,
        "menu": [],
        "subcategories": [],
      };
    }

    final firstCategory = _selectedRestaurantCategories!.first;
    print('First category: $firstCategory');

    List<dynamic> menuItems;
    List<String> subcategories = [];

    if (_hasShopRestaurant) {
      print('Shop restaurant detected — fetching subcategories');
      subcategories = await getRestaurantSubcategories(firstCategory);

      if (subcategories.isEmpty) {
        menuItems = await getMenuItems(firstCategory);
      } else {
        final firstSubcategory = subcategories.first;
        print('First subcategory: $firstSubcategory');

        menuItems = await getMenuItems(firstCategory, firstSubcategory);
      }
    } else {
      print('No shop restaurant — fetching menu for category');
      menuItems = await getMenuItems(firstCategory);
    }

    print(' Menu items fetched');

    return {
      "categories": _selectedRestaurantCategories!,
      "hasShopRestaurant": _hasShopRestaurant,
      "menu": menuItems,
      "subcategories": subcategories,
    };
  }

  Future<void> goBack() async {
    await connect();

    print(' Invoking GoBack with windowRef=$_currentWindowReference and userId=$_userId');

    try {
      await _connection!.invoke("GoBack", args: [_currentWindowReference!, _userId!]);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isGoingBack", false);
      print(' GoBack invoked successfully');
    } catch (e) {
      throw Exception("Error during GoBack invoke: $e");
    }
  }

  Future<void> redirectToHomePage() async {
    await connect();

    print(' Invoking redirectToHomePage with windowRef=$_currentWindowReference and userId=$_userId');

    try {
      await _connection!.invoke("RedirectToHomePage", args: [_currentWindowReference!, _userId!]);
      print(' redirectToHomePage invoked successfully');
    } catch (e) {
      throw Exception("Error during redirectToHomePage invoke: $e");
    }
  }

  Future<void> SaveNestedSelectionOption() async {
    await connect();

    print(' Invoking SaveNestedSelectionOption with windowRef=$_currentWindowReference and userId=$_userId');

    try {
      await _connection!.invoke("SaveNestedSelectionOption", args: [_currentWindowReference!, _userId!]);
      print('SaveNestedSelectionOption invoked successfully');
    } catch (e) {
      throw Exception("Error during GoBack invoke: $e");
    }
  }

  Future<List<dynamic>> getNestedSelection(String header, String selectedItemName) async {
    await connect();

    final nestedPayload = {
      "Header": header,
      "Items": [selectedItemName]
    };

    print(' Invoking GetNestedSelection with payload: $nestedPayload');
    final jsonPayload = jsonEncode(nestedPayload);

    try {
      final result = await _connection!.invoke("GetNestedSelection", args: [
        jsonPayload,
        _currentWindowReference!,
        _userId!,
      ]);

      print("Raw result from GetNestedSelection:");
      print(result);

      List<dynamic> nestedSelections = [];

      if (result is String) {
        try {
          final decoded = jsonDecode(result);

          if (decoded is List) {
            nestedSelections = decoded;
          } else if (decoded is Map<String, dynamic> && decoded["Customizations"] is List) {
            nestedSelections = decoded["Customizations"];
          } else {
            print(" Unexpected JSON structure from nested selection.");
          }
        } catch (e) {
          print(" Failed to decode result string: $e");
          return [];
        }
      } else if (result is List) {
        nestedSelections = result;
      } else {
        print("Unexpected type from GetNestedSelection: ${result.runtimeType}");
      }

      print(" Parsed nested selections: $nestedSelections");
      return nestedSelections;
    } catch (e) {
      print(" Error during GetNestedSelection invoke: $e");
      return [];
    }
  }

  Future<dynamic> triggerOptionButtonClick(String header, String selectedItemName, String buttonType) async {
    await connect();


    print('Invoking TriggerOptionButtonClick with payload: $header');
    print(header);
    print(selectedItemName);
    print(buttonType);
    
    try {
      final result = await _connection!.invoke("TriggerOptionButtonClick", args: [
        header,
        selectedItemName,
        buttonType,
        _currentWindowReference!,
        _userId!,
      ]);

      print("Raw result from triggerOptionButtonClick:");
      print(result);

      return result;
    } catch (e) {
      print("Error during TriggerOptionButtonClick invoke: $e");
      return [];
    }
  }


  Future<dynamic> CloseViewCart() async {
    await connect();

    print('Invoking CloseViewCart');

    try {
      final result = await _connection!.invoke("CloseViewCart", args: [
        _currentWindowReference!,
        _userId!,
      ]);

      print(' CloseViewCart result:');
      print(result);

      return result;
    } catch (e) {
      print(' Error invoking CloseViewCart: $e');
      rethrow;
    }
  }

  Future<dynamic> clearRestaurantCartItems() async {
    await connect();

    print('Invoking ClearRestaurantCartItems');

    final prefs = await SharedPreferences.getInstance();
    while (prefs.getBool("isGoingBack") == true) {
      print("Waiting for isGoingBack to become false...");
      await Future.delayed(const Duration(milliseconds: 500));
      await prefs.reload();
    }

    try {
      final result = await _connection!.invoke("ClearRestaurantCartItems", args: [
        _currentWindowReference!,
        _userId!,
      ]);

      print('ClearRestaurantCartItems result:');
      print(result);

      return result;
    } catch (e) {
      print('Error invoking ClearRestaurantCartItems: $e');
      rethrow;
    }
  }

  Future<dynamic> addItemsToCart() async {
    await connect();

    if (_addItemsToCartCompleter == null || _addItemsToCartCompleter!.isCompleted) {
      print(' Creating new _addItemsToCartCompleter');
      _addItemsToCartCompleter = Completer<dynamic>();
    }

    final localCompleter = _addItemsToCartCompleter!;

    print('Invoking AddItemsToCart');

    try {
      await _connection!.invoke("AddItemsToCart", args: [
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking AddItemsToCart: $e');
      throw Exception("Error invoking AddItemsToCart: $e");
    }

    try {
      final result = await localCompleter.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (!_addItemsToCartCompleter!.isCompleted) {
            _addItemsToCartCompleter!.completeError(Exception("Timeout while waiting for AddItemsToCart response"));
          }
          throw Exception("Timeout while waiting for AddItemsToCart response");
        },
      );

      return result;
    } catch (e) {
      print("addItemsToCart failed: $e");
      return Future.error(e);
    }
  }

  Future<List<Map<String, dynamic>>> getCartInformation() async {
    await connect();

    if (_getCartInformationCompleter == null || _getCartInformationCompleter!.isCompleted) {
      print('Creating new _getCartInformationCompleter');
      _getCartInformationCompleter = Completer<List<Map<String, dynamic>>>();
    }

    final localCompleter = _getCartInformationCompleter!;

    print('Invoking GetCartInformation');

    try {
      await _connection!.invoke("GetCartInformation", args: [
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking GetCartInformation: $e');
      throw Exception("Error invoking GetCartInformation: $e");
    }

    final result = await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GetCartInformation response"),
    );

    return result;
  }

  Future<Map<String, dynamic>> goToCheckout() async {
    await connect();

    if (_goToCheckoutCompleter == null || _goToCheckoutCompleter!.isCompleted) {
      print('Creating new _goToCheckoutCompleter');
      _goToCheckoutCompleter = Completer<Map<String, dynamic>>();
    }

    final localCompleter = _goToCheckoutCompleter!;

    print('Invoking GoToCheckout');

    try {
      await _connection!.invoke("GoToCheckout", args: [
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking GoToCheckout: $e');
      throw Exception("Error invoking GoToCheckout: $e");
    }

    final result = await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GoToCheckout response"),
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> OpenRestaurantCart() async {
    await connect();

    if (_getCartInformationCompleter == null || _getCartInformationCompleter!.isCompleted) {
      print('Creating new _getCartInformationCompleter');
      _getCartInformationCompleter = Completer<List<Map<String, dynamic>>>();
    }

    final localCompleter = _getCartInformationCompleter!;

    print('Invoking GetCartInformation');

    try {
      await _connection!.invoke("GetCartInformation", args: [
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking GetCartInformation: $e');
      throw Exception("Error invoking GetCartInformation: $e");
    }

    final result = await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GetCartInformation response"),
    );

    return result;
  }

  Future<dynamic> getViewCartItems(String? address) async {
    await connect();

    if (_getViewCartItemsCompleter == null || _getViewCartItemsCompleter!.isCompleted) {
      print('Creating new _addItemsToCartCompleter');
      _getViewCartItemsCompleter = Completer<dynamic>();
    }

    final localCompleter = _getViewCartItemsCompleter!;

    print(' Invoking GetViewCartItems');

    try {
      await _connection!.invoke("GetViewCartItems", args: [
        address!,
        _currentWindowReference!,
        _userId!,
      ]);
    } catch (e) {
      print('Error invoking GetViewCartItems: $e');
      throw Exception("Error invoking GetViewCartItems: $e");
    }

    final result = await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GetViewCartItems response"),
    );


    return result;
  }
  
  Future<dynamic> selectCustomizationItem(String header, String selectedItemName) async {
    await connect();

    final payload = {
      "Header": header,
      "Items": [selectedItemName]
    };

    print('Invoking SelectCustomizationItem with payload: $payload');
    final jsonPayload = jsonEncode(payload);

    try {
      final result = await _connection!.invoke("SelectCustomizationItem", args: [
        jsonPayload,
        _currentWindowReference!,
        _userId!,
      ]);

      print("Result from SelectCustomizationItem:");
      print(result);

      return result;
    } catch (e) {
      print("Error invoking SelectCustomizationItem: $e");
      rethrow;
    }
  }

  void _invokeGetNextDialog() async {
    try {
      await _connection!.invoke("GetNextDialog");
    } catch (e) {
      print("Error during GetNextDialog: $e");
    }
  }

  void _invokeSkipBuildingType() async {
    try {
      await _connection!.invoke("SkipBuildingType");
    } catch (e) {
      print("Error during SkipBuildingType: $e");
    }
  }

  void _invokeSaveAddressClicked() async {
    try {
      await _connection!.invoke("SaveAddressClicked", args: [""]);
    } catch (e) {
      print("Error during SaveAddressClicked: $e");
    }
  }

  Future<Map<String, dynamic>> getCustomization(String menuItem) async {
    await connect();

    if (_customizationCompleter == null || _customizationCompleter!.isCompleted) {
      print('Creating new _customizationCompleter');
      _customizationCompleter = Completer<void>();
    }

    final localCompleter = _customizationCompleter!;

    print('Fetching customization for menu item: $menuItem');

    try {
      print('beforeInvoking GetCustomization');
      await _connection!.invoke(
        "GetCustomization",
        args: [menuItem, _currentWindowReference!, _userId!],
      );
    } catch (e) {
      throw Exception("Error during GetCustomization invoke: $e");
    }

    await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GetCustomizationResponse"),
    );

    if (_customizationPayload == null) {
      throw Exception("No customization payload received");
    }

    print('Customization payload received');
    return _customizationPayload!;
  }

  Future<dynamic> adjustCartItemQuantity(String itemUrl, String buttonType) async {
    await connect();

    if (_adjustCartItemCompleter == null || _adjustCartItemCompleter!.isCompleted) {
      print('Creating new _adjustCartItemCompleter');
      _adjustCartItemCompleter = Completer<void>();
    }

    final localCompleter = _adjustCartItemCompleter!;

    final storeItem = {
      'ItemUrl': itemUrl,
    };

    final strStoreDetail = jsonEncode(storeItem);

    print('Invoking AdjustCartItemQuantity with: $strStoreDetail and $buttonType');

    try {
      await _connection!.invoke(
        "AdjustCartItemQuantity",
        args: [strStoreDetail, buttonType, _currentWindowReference!, _userId!],
      );
    } catch (e) {
      throw Exception("Error during AdjustCartItemQuantity invoke: $e");
    }

    await localCompleter.future.timeout(
      Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for AdjustCartItemQuantity response"),
    );

    print('AdjustCartItemQuantity completed');
    return true; 
  }

  Future<bool> editDeliveryInstructions({
    required String deliveryInstructions,
    required String userFullName,
    required String phoneNumber,
  }) async {
    await connect();

    if (_editDeliveryInstructionsCompleter == null || _editDeliveryInstructionsCompleter!.isCompleted) {
      print('Creating new _editDeliveryInstructionsCompleter');
      _editDeliveryInstructionsCompleter = Completer<void>();
    }

    final localCompleter = _editDeliveryInstructionsCompleter!;

    print('[SignalR] Invoking EditDeliveryInstructions with args: '
          'deliveryInstructions="$deliveryInstructions", userFullName="$userFullName", phoneNumber="$phoneNumber"');

    try {
      await _connection!.invoke(
        "EditDeliveryInstructions",
        args: [deliveryInstructions, userFullName, phoneNumber, _currentWindowReference!, _userId!],
      );
    } catch (e) {
      throw Exception("Error during EditDeliveryInstructions invoke: $e");
    }

    await localCompleter.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for EditDeliveryInstructionsResponse"),
    );

    print('[SignalR] EditDeliveryInstructions completed');
    return true;
  }

  Future<List<dynamic>> getMenuItems(String categoryName, [String? subCategory, int pageIndex = 0, bool? isInitLoad = true]) async {
    await connect();

    if (_storeItemsCompleter == null || _storeItemsCompleter!.isCompleted) {
      print('Creating new _storeItemsCompleter');
      _storeItemsCompleter = Completer<void>();
    }

    final localCompleter = _storeItemsCompleter!;
    print('Fetching menu items for category: $categoryName  for subcategory $subCategory for index $pageIndex');

    try {
      await _connection!.invoke("GetFilteredMenuItems", args: [categoryName, _currentWindowReference!, _userId!, _hasShopRestaurant, pageIndex, isInitLoad!, subCategory ?? '']);
    } catch (e) {
      throw Exception("Error during GetFilteredMenuItems invoke: $e");
    }

    await localCompleter.future.timeout(
      Duration(seconds: 15),
      onTimeout: () => throw Exception("Timeout while waiting for GetItemResponse"),
    );

    if (_storeItemsData == null) {
      throw Exception("No store items data received");
    }

    print('Menu items received');

    return _storeItemsData!;
  }
}
