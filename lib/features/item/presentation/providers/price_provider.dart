import 'package:flutter_riverpod/legacy.dart';

/// Full model for holding all phone evaluation + price calculation data
class PhonePriceData {
  // Basic Info
  String category;
  String phoneModel;

  // Price
  double basePrice;
  double finalPrice;

  // Text Fields
  int year;
  int batteryHealth;

  // Radio Field
  // deviceCondition removed

  // Charger
  bool chargerAvailable;

  // Boolean Questions
  bool factoryUnlock;
  bool liquidDamage;
  bool switchOn;
  bool receiveCall;
  bool repairedBoard;


  bool features1Condition;
  bool features2Condition;

  bool cameraCondition;
  bool displayCondition;
  bool displayCracked;
  bool displayOriginal;
  String sellerId;

  PhonePriceData({
    this.category = '',
    this.phoneModel = '',

    this.basePrice = 0.0,
    this.finalPrice = 0.0,

    this.year = 2025,
    this.batteryHealth = 100,

    // deviceCondition removed

    this.chargerAvailable = true,

    this.factoryUnlock = true,
    this.liquidDamage = false,
    this.switchOn = true,
    this.receiveCall = true,
    this.repairedBoard = false,

    this.features1Condition = true,
    this.features2Condition = true,

    this.cameraCondition = true,
    this.displayCondition = true,
    this.displayCracked = false,
    this.displayOriginal = true,
    this.sellerId = '',
  });

  /// CopyWith for updating fields safely
  PhonePriceData copyWith({
    String? category,
    String? phoneModel,

    double? basePrice,
    double? finalPrice,

    int? year,
    int? batteryHealth,

    // deviceCondition removed

    bool? chargerAvailable,

    bool? factoryUnlock,
    bool? liquidDamage,
    bool? switchOn,
    bool? receiveCall,
    bool? repairedBoard,


    bool? features1Condition,
    bool? features2Condition,

    bool? cameraCondition,
    bool? displayCondition,
    bool? displayCracked,
    bool? displayOriginal,
    String? sellerId,
  }) {
    return PhonePriceData(
      category: category ?? this.category,
      phoneModel: phoneModel ?? this.phoneModel,

      basePrice: basePrice ?? this.basePrice,
      finalPrice: finalPrice ?? this.finalPrice,

      year: year ?? this.year,
      batteryHealth: batteryHealth ?? this.batteryHealth,

      // deviceCondition removed

      chargerAvailable: chargerAvailable ?? this.chargerAvailable,

      factoryUnlock: factoryUnlock ?? this.factoryUnlock,
      liquidDamage: liquidDamage ?? this.liquidDamage,
      switchOn: switchOn ?? this.switchOn,
      receiveCall: receiveCall ?? this.receiveCall,
      repairedBoard: repairedBoard ?? this.repairedBoard,

      features1Condition: features1Condition ?? this.features1Condition,
      features2Condition: features2Condition ?? this.features2Condition,

      cameraCondition: cameraCondition ?? this.cameraCondition,
      displayCondition: displayCondition ?? this.displayCondition,
      displayCracked: displayCracked ?? this.displayCracked,
      displayOriginal: displayOriginal ?? this.displayOriginal,
      sellerId: sellerId ?? this.sellerId,
    );
  }
}

/// Provider
final phonePriceProvider =
    StateNotifierProvider<PhonePriceNotifier, PhonePriceData>(
  (ref) => PhonePriceNotifier(),
);

/// Notifier Class
class PhonePriceNotifier extends StateNotifier<PhonePriceData> {
  PhonePriceNotifier() : super(PhonePriceData());

  /// Update any field dynamically
  void updateField(String field, dynamic value) {
  switch (field) {
    case "category":
      state = state.copyWith(category: value as String);
      break;

    case "phoneModel":
      state = state.copyWith(phoneModel: value as String);
      break;

    case "basePrice":
      state = state.copyWith(
        basePrice: (value as num).toDouble(),
      );
      break;

    case "finalPrice":
      state = state.copyWith(
        finalPrice: (value as num).toDouble(),
      );
      break;

    case "year":
      state = state.copyWith(year: value as int);
      break;

    case "batteryHealth":
      state = state.copyWith(batteryHealth: value as int);
      break;

    // deviceCondition removed

    case "chargerAvailable":
      state = state.copyWith(chargerAvailable: value as bool);
      break;

    case "factoryUnlock":
      state = state.copyWith(factoryUnlock: value as bool);
      break;

    case "liquidDamage":
      state = state.copyWith(liquidDamage: value as bool);
      break;

    case "switchOn":
      state = state.copyWith(switchOn: value as bool);
      break;

    case "receiveCall":
      state = state.copyWith(receiveCall: value as bool);
      break;

    case "features1Condition":
      state = state.copyWith(features1Condition: value as bool);
      break;

    case "features2Condition":
      state = state.copyWith(features2Condition: value as bool);
      break;

    case "cameraCondition":
      state = state.copyWith(cameraCondition: value as bool);
      break;

    case "displayCondition":
      state = state.copyWith(displayCondition: value as bool);
      break;

    case "displayCracked":
      state = state.copyWith(displayCracked: value as bool);
      break;

    case "displayOriginal":
      state = state.copyWith(displayOriginal: value as bool);
      break;

    case "repairedBoard":
      state = state.copyWith(repairedBoard: value as bool);
      break;
  }
    _calculateFinalPrice();
  }

  /// Price Calculation Logic
  void _calculateFinalPrice() {
    double price = state.basePrice;



    // Major Issues
    if (state.liquidDamage) price *= 0.5;
    if (!state.switchOn) price *= 0.6;
    if (!state.receiveCall) price *= 0.8;

    // Feature Conditions
    if (!state.features1Condition) price *= 0.9;
    if (!state.features2Condition) price *= 0.9;

    // Camera + Display Conditions
    if (!state.cameraCondition) price *= 0.85;
    if (!state.displayCondition) price *= 0.8;

    // Display Damage
    if (state.displayCracked) price *= 0.7;
    if (!state.displayOriginal) price *= 0.85;

    // Unlock Status
    if (!state.factoryUnlock) price *= 0.6;

    // Charger Deduction
    if (!state.chargerAvailable) price *= 0.95;

    // Battery Effect
    price *= (state.batteryHealth / 100);

    // Age Deduction
    int age = 2025 - state.year;
    if (age > 0) {
      price *= (1 - (0.05 * age));
    }

    // Repaired Board Deduction
    if (state.repairedBoard) price *= 0.8; // Apply a 20% discount if the board is repaired

    // Prevent Negative Price
    if (price < 0) price = 0;

    // Update final price
    state = state.copyWith(finalPrice: price);
  }
    void setSellerId(String id) {
    state = state.copyWith(sellerId: id);
  }
}
