import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class HiveService {
  static const String _userBox = 'user_box';

  /// Initialize Hive and open required boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters 
    if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
      Hive.registerAdapter(UserModelAdapter());
    }

    // Open boxe
    await Hive.openBox<UserModel>(_userBox);
  }

  /// Retrieve tboxes
  static Box<UserModel> get userBox => Hive.box<UserModel>(_userBox);
}
