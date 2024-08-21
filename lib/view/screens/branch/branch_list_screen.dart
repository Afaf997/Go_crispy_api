import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_dialog.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/branch/widget/bracnh_cart_view.dart';
import 'package:flutter_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'widget/branch_close_view.dart';
import 'widget/branch_item_view.dart';

class BranchListScreen extends StatefulWidget {
  final bool useNavigator; // Add this line to accept the parameter
  final bool? isOtp;
  final bool? istakeAway;

  const BranchListScreen(
      {Key? key, required this.useNavigator, this.isOtp, this.istakeAway})
      : super(key: key);

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  List<BranchValue> _branchesValue = [];
  Set<Marker> _markers = HashSet<Marker>();
  late GoogleMapController _mapController;
  LatLng? _currentLocationLatLng;
  AutoScrollController? scrollController;

  @override
  void initState() {
    print("in init");
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    branchProvider.updateTabIndex(0, isUpdate: false);
    // If need to previous selection
    print("first here");
    if (branchProvider.getBranchId() == -1) {
      print("here1");
      branchProvider.updateBranchId(null, isUpdate: false);
    }
    //  else {
    //   print("here2");
    //   branchProvider.updateBranchId(branchProvider.getBranchId(),
    //       isUpdate: false);
    // }
    print("location");

    Provider.of<LocationProvider>(context, listen: false)
        .getCurrentLatLong()
        .then((latLong) {
      if (latLong != null) {
        print("in lat");
        _currentLocationLatLng = latLong;
      }
      _branchesValue = branchProvider.branchSort(_currentLocationLatLng);
      //Auto selecting  branch as the nearest branch.
      print(branchProvider.getBranchId());
      if (widget.isOtp != null && widget.isOtp == true) {
        print("init");
        branchProvider.updateBranchId(_branchesValue.first.branches?.id ?? 1);
        //auto confirming nearest branch
        _setBranch(widget.useNavigator);
        //new code
        if (branchProvider.branchTabIndex != 0) {
          branchProvider.updateTabIndex(0, isUpdate: false);
        }
        // _setBranch(widget.useNavigator);
      } else {
        if (branchProvider.getBranchId() != -1) {
          branchProvider.updateBranchId(branchProvider.getBranchId());
        }
      }
    });

    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      return WillPopScope(
        onWillPop: () async {
          if (branchProvider.branchTabIndex != 0) {
            branchProvider.updateTabIndex(0);
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: ColorResources.kWhite,
          appBar: widget.isOtp != null && widget.isOtp == true
              ? null
              : AppBar(
                  title: Text(
                    getTranslated('select_branch', context),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: ColorResources.kWhite,
                  centerTitle: true,
                ),

          // appBar: (ResponsiveHelper.isDesktop(context)
          //     ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBar())
          //     : CustomAppBar(context: context, title: getTranslated('select_branch', context))) as PreferredSizeWidget?,

          body: widget.isOtp != null && widget.isOtp == true
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                      Center(
                          child: Image.asset(
                        Images.gif,
                        height: 150,
                        width: 150,
                      )),
                      const Text("Finding Nearest Branch..")
                    ]))
              : Center(
                  child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: splashProvider.getActiveBranch() == 0
                        ? const BranchCloseView()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Expanded(
                                  child: branchProvider.branchTabIndex == 1
                                      ? Stack(
                                          children: [
                                            GoogleMap(
                                              mapType: MapType.normal,
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                  double.parse(_branchesValue[0]
                                                      .branches!
                                                      .latitude!),
                                                  double.parse(_branchesValue[0]
                                                      .branches!
                                                      .longitude!),
                                                ),
                                                zoom: 5,
                                              ),
                                              minMaxZoomPreference:
                                                  const MinMaxZoomPreference(
                                                      0, 16),
                                              zoomControlsEnabled: true,
                                              markers: _markers,
                                              onMapCreated: (GoogleMapController
                                                  controller) async {
                                                await Geolocator
                                                    .requestPermission();
                                                _mapController = controller;
                                                // _loading = false;
                                                _setMarkers(1);
                                              },
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: SingleChildScrollView(
                                                  controller: scrollController,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: _branchesValue
                                                        .map((branchValue) {
                                                      return AutoScrollTag(
                                                        controller:
                                                            scrollController!,
                                                        key: ValueKey(
                                                            _branchesValue
                                                                .indexOf(
                                                                    branchValue)),
                                                        index: _branchesValue
                                                            .indexOf(
                                                                branchValue),
                                                        child: BranchCartView(
                                                          branchModel:
                                                              branchValue,
                                                          branchModelList:
                                                              _branchesValue,
                                                          onTap: () => _setMarkers(
                                                              _branchesValue
                                                                  .indexOf(
                                                                      branchValue),
                                                              fromBranchSelect:
                                                                  true),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical:
                                                  Dimensions.paddingSizeSmall,
                                              horizontal: Dimensions
                                                  .paddingSizeDefault),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      '${getTranslated('nearest_branch', context)} (${_branchesValue.length})',
                                                      style: rubikBold),
                                                  GestureDetector(
                                                    onTap: () => branchProvider
                                                        .updateTabIndex(1),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        border: Border.all(
                                                            color: ColorResources
                                                                .kOrangeColor),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: ColorResources
                                                                        .kOrangeColor,
                                                                    borderRadius: Provider.of<LocalizationProvider>(context, listen: false)
                                                                            .isLtr
                                                                        ? const BorderRadius
                                                                            .only(
                                                                            bottomLeft:
                                                                                Radius.circular(30),
                                                                            topLeft:
                                                                                Radius.circular(30),
                                                                          )
                                                                        : const BorderRadius
                                                                            .only(
                                                                            bottomRight:
                                                                                Radius.circular(30),
                                                                            topRight:
                                                                                Radius.circular(30),
                                                                          )),
                                                            child: const Icon(
                                                              Icons
                                                                  .my_location_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: Dimensions
                                                                  .paddingSizeDefault,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    Dimensions
                                                                        .paddingSizeExtraSmall),
                                                            child: Text(
                                                              getTranslated(
                                                                  'select_from_map',
                                                                  context)!,
                                                              style: rubikMedium
                                                                  .copyWith(
                                                                      color: ColorResources
                                                                          .kOrangeColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault),
                                              _branchesValue.isNotEmpty
                                                  ? Flexible(
                                                      child: GridView.builder(
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          mainAxisExtent: 230,
                                                          crossAxisSpacing: 5,
                                                          mainAxisSpacing: 5,
                                                          childAspectRatio: 1.8,
                                                          crossAxisCount: ResponsiveHelper
                                                                  .isDesktop(
                                                                      context)
                                                              ? 3
                                                              : MediaQuery.of(context)
                                                                          .size
                                                                          .width >
                                                                      780
                                                                  ? 2
                                                                  : 1,
                                                        ),
                                                        itemCount:
                                                            _branchesValue
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) =>
                                                                BranchItemView(
                                                          branchesValue:
                                                              _branchesValue[
                                                                  index],
                                                        ),
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Image.asset(
                                                      Images.gif,
                                                      height: 150,
                                                      width: 150,
                                                    )),
                                            ],
                                          ),
                                        ),
                                ),
                                Container(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? 400
                                      : Dimensions.webScreenWidth,
                                  padding: const EdgeInsets.all(
                                          Dimensions.fontSizeDefault)
                                      .copyWith(
                                          bottom:
                                              Dimensions.paddingSizeDefault),
                                  child: Consumer<BranchProvider>(
                                      builder: (context, branchProvider, _) {
                                    final cartProvider =
                                        Provider.of<CartProvider>(context,
                                            listen: false);
                                    return _branchesValue.isNotEmpty
                                        ? CustomButton(
                                            btnTxt: getTranslated(
                                                'confirm_branch', context),
                                            borderRadius: 10,
                                            onTap: () {
                                              if (branchProvider
                                                      .selectedBranchId !=
                                                  null) {
                                                if (branchProvider
                                                        .selectedBranchId !=
                                                    branchProvider
                                                        .getBranchId()) {
                                                  print("hereee");
                                                  _setBranch(
                                                      widget.useNavigator,
                                                      istakeAway:
                                                          widget.istakeAway);

                                                  //clearing cart when changing branch if we have food in cart is removed.
                                                  // showAnimatedDialog(
                                                  //   context,
                                                  //   CustomDialog(
                                                  //     buttonTextTrue: getTranslated('yes', context),
                                                  //     buttonTextFalse: getTranslated('no', context),
                                                  //     description: '',
                                                  //     icon: Icons.question_mark,
                                                  //     title: getTranslated('you_have_some_food', context),
                                                  //     onTapTrue: () {
                                                  //     //  cartProvider.clearCartList();
                                                  //       _setBranch(widget.useNavigator); // Use the parameter here
                                                  //     },
                                                  //     onTapFalse: () => context.pop(),
                                                  //   ),
                                                  //   dismissible: false,
                                                  //   isFlip: true,
                                                  // );
                                                } else {
                                                  print("here2");
                                                  if (branchProvider
                                                          .branchTabIndex !=
                                                      0) {
                                                    branchProvider
                                                        .updateTabIndex(0,
                                                            isUpdate: false);
                                                  }

                                                  _setBranch(
                                                      widget.useNavigator,
                                                      istakeAway:
                                                          widget.istakeAway);

                                                  print("this is here");

                                                  // Use the parameter here
                                                }
                                              } else {
                                                showCustomNotification(context,
                                                    'select_branch_first',
                                                    type:
                                                        NotificationType.error);
                                                // showCustomSnackBar(getTranslated('select_branch_first', context));
                                              }
                                            })
                                        : const SizedBox();
                                  }),
                                ),
                              ]),
                  ),
                ),
        ),
      );
    });
  }

  void _setBranch(bool useNavigator, {bool? istakeAway = false}) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    branchProvider.setBranch(branchProvider.selectedBranchId!);
    print("settig branch");

    if (useNavigator && istakeAway == null) {
      //dashboard navigation here.
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => DashboardScreen(pageIndex: 0)));
      print("new here");

      RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
    } else if (useNavigator && istakeAway != null && istakeAway) {
      print("here now");
      Navigator.pop(context);
    } else {
      print("tyhis is here");
      RouterHelper.getMainRoute(action: RouteAction.pushNamedAndRemoveUntil);
    }
    showCustomNotification(context, 'branch_successfully_selected',
        type: NotificationType.success);
    // if (istakeAway!) {
    //   print("trueeeee");
    //   Navigator.pop(context);
    // }
    // showCustomSnackBar(getTranslated('branch_successfully_selected', context), isError: false);
  }

  void _setMarkers(int selectedIndex, {bool fromBranchSelect = false}) async {
    await scrollController!.scrollToIndex(selectedIndex,
        preferPosition: AutoScrollPosition.middle);
    setState(() {
      _markers = HashSet<Marker>();
      for (int index = 0; index < _branchesValue.length; index++) {
        if (selectedIndex == index) {
          _markers.add(
            Marker(
              markerId: MarkerId(index.toString()),
              position: LatLng(
                double.parse(_branchesValue[index].branches!.latitude!),
                double.parse(_branchesValue[index].branches!.longitude!),
              ),
              icon: BitmapDescriptor.defaultMarker,
            ),
          );
          if (fromBranchSelect) {
            _mapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                double.parse(_branchesValue[index].branches!.latitude!),
                double.parse(_branchesValue[index].branches!.longitude!),
              ),
              zoom: 8,
            )));
          }
        } else {
          _markers.add(
            Marker(
              markerId: MarkerId(index.toString()),
              position: LatLng(
                double.parse(_branchesValue[index].branches!.latitude!),
                double.parse(_branchesValue[index].branches!.longitude!),
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
            ),
          );
        }
      }
    });
  }
}
