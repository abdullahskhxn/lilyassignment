import 'package:flutter/foundation.dart';
import '../models/host_model.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  String _selectedRole = '';
  HostModel? _selectedHost;
  int _selectedQuota = 5;
  bool _isHostActive = false;
  double _remainingData = 5.0;
  String _sessionKey = '';

  UserModel? get currentUser => _currentUser;
  String get selectedRole => _selectedRole;
  HostModel? get selectedHost => _selectedHost;
  int get selectedQuota => _selectedQuota;
  bool get isHostActive => _isHostActive;
  double get remainingData => _remainingData;
  String get sessionKey => _sessionKey;

  final List<HostModel> dummyHosts = const [
    HostModel(
      id: '1',
      name: "Ahmad's Node",
      ssid: 'STRATA-Ahmad-01',
      pricePerGB: 0.50,
      rating: 4.8,
      distance: 150,
      availableGB: 45,
      isActive: true,
    ),
    HostModel(
      id: '2',
      name: "Sara's Hub",
      ssid: 'STRATA-Sara-02',
      pricePerGB: 0.35,
      rating: 4.5,
      distance: 280,
      availableGB: 20,
      isActive: true,
    ),
    HostModel(
      id: '3',
      name: 'Campus Node 3',
      ssid: 'STRATA-Campus-03',
      pricePerGB: 0.25,
      rating: 4.9,
      distance: 95,
      availableGB: 100,
      isActive: true,
    ),
    HostModel(
      id: '4',
      name: "Khan's Relay",
      ssid: 'STRATA-Khan-04',
      pricePerGB: 0.75,
      rating: 4.2,
      distance: 420,
      availableGB: 15,
      isActive: true,
    ),
    HostModel(
      id: '5',
      name: "Ali's Network",
      ssid: 'STRATA-Ali-05',
      pricePerGB: 0.45,
      rating: 4.6,
      distance: 200,
      availableGB: 60,
      isActive: true,
    ),
  ];

  void setRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void selectHost(HostModel host) {
    _selectedHost = host;
    notifyListeners();
  }

  void setQuota(int gb) {
    _selectedQuota = gb;
    _remainingData = gb.toDouble();
    notifyListeners();
  }

  void activateHostSharing() {
    _isHostActive = true;
    notifyListeners();
  }

  void deactivateHostSharing() {
    _isHostActive = false;
    notifyListeners();
  }

  void generateAccessKey() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final part1 = (timestamp % 10000).toString().padLeft(4, '0');
    const part2 = 'A7F3';
    const part3 = 'B2D9';
    _sessionKey = 'STRATA-$part1-$part2-$part3';
    notifyListeners();
  }

  void consumeData(double gb) {
    _remainingData = (_remainingData - gb).clamp(0.0, _selectedQuota.toDouble());
    notifyListeners();
  }

  void resetSession() {
    _selectedHost = null;
    _selectedQuota = 5;
    _remainingData = 5.0;
    _sessionKey = '';
    notifyListeners();
  }
}
