import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recell_bazar/core/constants/hive_table_constant.dart';
import 'package:recell_bazar/features/auth/data/models/auth_hive_model.dart';


final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  /// Initialize Hive
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init('${directory.path}/${HiveTableConstant.dbName}');

    _registerAdapters();
    await _openBoxes();
  }

  /// Register all Hive adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    // if (!Hive.isAdapterRegistered(HiveTableConstant.userTypeId)) {
    //   Hive.registerAdapter(BatchHiveModelAdapter());
    // }

    // if (!Hive.isAdapterRegistered(HiveTableConstant.categoryTypeId)) {
    //   Hive.registerAdapter(CategoryHiveModelAdapter());
    // }
  }

  /// Open all required boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(
      HiveTableConstant.userTable,
    );

    // await Hive.openBox<BatchHiveModel>(
    //   HiveTableConstant.batchTable,
    // );

    // await Hive.openBox<CategoryHiveModel>(
    //   HiveTableConstant.categoryTable,
    // );
  }

  /// Close all Hive boxes
  Future<void> close() async {
    await Hive.close();
  }
}
