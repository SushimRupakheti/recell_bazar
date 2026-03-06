import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/error/failure.dart';
import 'package:recell_bazar/core/services/connectivity/network_info.dart';
import 'package:recell_bazar/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:recell_bazar/features/cart/domain/entities/cart_models.dart';
import 'package:recell_bazar/features/cart/domain/repositories/cart_repository.dart';

final cartRepositoryProvider = Provider<ICartRepository>((ref) {
  return CartRepository(
    remoteDataSource: ref.read(cartRemoteDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class CartRepository implements ICartRepository {
  final ICartRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  CartRepository({
    required ICartRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  String _extractMessageFromDio(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return fallback;
  }

  @override
  Future<Either<Failure, bool>> addToCart(String productId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.addToCart(productId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to add to cart'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CartResponse>> fetchCart() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      final cart = await _remoteDataSource.fetchCart();
      return Right(cart);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to fetch cart'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> removeCartItem(String cartItemId) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }

    try {
      await _remoteDataSource.removeCartItem(cartItemId);
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: _extractMessageFromDio(e, fallback: 'Failed to remove cart item'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
