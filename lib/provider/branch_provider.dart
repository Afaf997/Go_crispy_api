import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/repository/splash_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BranchProvider extends ChangeNotifier {
  final SplashRepo? splashRepo;
  BranchProvider({required this.splashRepo});

  int? _selectedBranchId;
  int? get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;
  int get branchTabIndex => _branchTabIndex;

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    print(_selectedBranchId.toString() + "selected id");
    print("updating branch id");
    if (isUpdate) {
      notifyListeners();
    }
  }

  int getBranchId() => splashRepo!.getBranchId();

  Future<void> setBranch(int id) async {
    await splashRepo!.setBranchId(id);
    await HomeScreen.loadData(true);
    notifyListeners();
  }

  Future<void> setBranchOnly(int id) async {
    await splashRepo!.setBranchId(id);

    notifyListeners();
  }

  Branches? getBranch({int? id}) {
    int branchId = id ?? getBranchId();
    Branches? branch;
    ConfigModel config =
        Provider.of<SplashProvider>(Get.context!, listen: false).configModel!;
    if (config.branches != null && config.branches!.isNotEmpty) {
      branch = config.branches!
          .firstWhere((branch) => branch!.id == branchId, orElse: () => null);
      if (branch == null) {
        splashRepo!.setBranchId(-1);

      }
    }
    return branch;
  }

  List<Branches?> get branches {
    return Provider.of<SplashProvider>(Get.context!, listen: false)
        .configModel!
        .branches!;
  }

  List<BranchValue> branchSort(LatLng? currentLatLng) {
    _isLoading = true;
    List<BranchValue> branchValueList = [];

    for (var branch in Provider.of<SplashProvider>(Get.context!, listen: false)
        .configModel!
        .branches!) {
      double distance = -1;
      if (currentLatLng != null) {
        distance = Geolocator.distanceBetween(
              double.parse(branch!.latitude!),
              double.parse(branch.longitude!),
              currentLatLng.latitude,
              currentLatLng.longitude,
            ) /
            1000;
      }

      branchValueList.add(BranchValue(branch, distance));
    }
    branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    _isLoading = false;
    notifyListeners();

    return branchValueList;
  }
}