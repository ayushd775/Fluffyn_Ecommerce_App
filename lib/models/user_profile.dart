import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UserProfile extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _city = '';
  String _state = '';
  String _zipCode = '';
  String _profileImagePath = '';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get address => _address;
  String get city => _city;
  String get state => _state;
  String get zipCode => _zipCode;
  String get profileImagePath => _profileImagePath;

  Future<void> initializeDefaultImage() async {
    if (_profileImagePath.isEmpty) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final defaultImagePath = '${directory.path}/default_profile.jpg';

        // Check if the default image already exists
        if (!await File(defaultImagePath).exists()) {
          // Copy the asset to the app's directory
          final ByteData data =
              await rootBundle.load('assets/images/profile.jpg');
          final bytes = data.buffer.asUint8List();
          await File(defaultImagePath).writeAsBytes(bytes);
        }

        _profileImagePath = defaultImagePath;
        notifyListeners();
      } catch (e) {
        print('Error initializing default profile image: $e');
      }
    }
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? profileImagePath,
  }) {
    _name = name ?? _name;
    _email = email ?? _email;
    _phone = phone ?? _phone;
    _address = address ?? _address;
    _city = city ?? _city;
    _state = state ?? _state;
    _zipCode = zipCode ?? _zipCode;
    _profileImagePath = profileImagePath ?? _profileImagePath;
    notifyListeners();
  }
}
