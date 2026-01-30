import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Full model for holding all phone evaluation + price calculation data
class PhonePriceData {
  // Basic Info
  String category;
  String model;

  // Price
  double basePrice;
  double finalPrice;

  // Text Fields
  int year;
  int batteryHealth;

  // Radio Field
  String deviceCondition;

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

  PhonePriceData({
    this.category = '',
    this.model = '',

    this.basePrice = 0,
    this.finalPrice = 0,

    this.year = 2025,
    this.batteryHealth = 100,

    this.deviceCondition = '',

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
  });

  /// CopyWith for updating fields safely
  PhonePriceData copyWith({
    String? category,
    String? model,

    double? basePrice,
    double? finalPrice,

    int? year,
    int? batteryHealth,

    String? deviceCondition,

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
  }) {
    return PhonePriceData(
      category: category ?? this.category,
      model: model ?? this.model,

      basePrice: basePrice ?? this.basePrice,
      finalPrice: finalPrice ?? this.finalPrice,

      year: year ?? this.year,
      batteryHealth: batteryHealth ?? this.batteryHealth,

      deviceCondition: deviceCondition ?? this.deviceCondition,

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


      case "batteryHealth":
        state = state.copyWith(batteryHealth: value);
        break;

      case "deviceCondition":
        state = state.copyWith(deviceCondition: value);
        break;

      case "chargerAvailable":
        state = state.copyWith(chargerAvailable: value);
        break;

      case "factoryUnlock":
        state = state.copyWith(factoryUnlock: value);
        break;

      case "liquidDamage":
        state = state.copyWith(liquidDamage: value);
        break;

      case "switchOn":
        state = state.copyWith(switchOn: value);
        break;

      case "receiveCall":
        state = state.copyWith(receiveCall: value);
        break;

      case "features1Condition":
        state = state.copyWith(features1Condition: value);
        break;

      case "features2Condition":
        state = state.copyWith(features2Condition: value);
        break;

      case "cameraCondition":
        state = state.copyWith(cameraCondition: value);
        break;

      case "displayCondition":
        state = state.copyWith(displayCondition: value);
        break;

      case "displayCracked":
        state = state.copyWith(displayCracked: value);
        break;

      case "displayOriginal":
        state = state.copyWith(displayOriginal: value);
        break;

      case "repairedBoard":
        state = state.copyWith(repairedBoard: value);
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
}
