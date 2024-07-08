import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:provider/provider.dart';

class BranchButton extends StatelessWidget {
  final Color? color;
  final bool isRow;
  const BranchButton({
    Key? key, this.isRow = true, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        return splashProvider.isBranchSelectDisable()
            ? Consumer<BranchProvider>(
                builder: (context, branchProvider, _) {
                  if (branchProvider.getBranchId() == -1) return const SizedBox();

                  List<Branches?> sortedBranches = List.from(branchProvider.branches);
                  sortedBranches.sort((a, b) {
                    if (a!.id == branchProvider.getBranchId()) return -1;
                    if (b!.id == branchProvider.getBranchId()) return 1;
                    return 0;
                  });

                  return InkWell(
                    onTap: () => RouterHelper.getBranchListScreen(),
                    child: isRow
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: sortedBranches
                                  .map((branch) => buildCategoryItems(
                                        branch!.name ?? 'Unknown Branch',
                                        color ?? ColorResources.kOrangeColor,
                                        branchProvider.getBranchId() == branch.id,
                                      ))
                                  .toList(),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: sortedBranches
                                .map((branch) => buildCategoryItems(
                                      branch!.name ?? 'Unknown Branch',
                                      Theme.of(context).primaryColor,
                                      branchProvider.getBranchId() == branch.id,
                                    ))
                                .toList(),
                          ),
                  );
                },
              )
            : const SizedBox();
      },
    );
  }

  Widget buildCategoryItems(String categoryName, Color color, bool isSelected) {
    return IntrinsicWidth(
      child: Container(
        height: 44,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: ColorResources.kColorgrey,
          border: Border.all(color: isSelected ? color : ColorResources.klgreyColor),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Image.asset(
                Images.mapicon, 
                color: isSelected ? color : ColorResources.kblack,
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  categoryName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ColorResources.kblack),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
