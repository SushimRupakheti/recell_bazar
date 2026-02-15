import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:recell_bazar/core/services/connectivity/network_info.dart';


/// ------------------------------
/// Mock Connectivity
/// ------------------------------
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfo networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfo(mockConnectivity);
  });

  test("Should return false when there is no network connection", () async {
    // Arrange: ConnectivityResult.none
    when(() => mockConnectivity.checkConnectivity()).thenAnswer(
      (_) async => [ConnectivityResult.none],
    );

    // Act
    final result = await networkInfo.isConnected;

    // Assert
    expect(result, false);
  });
}
