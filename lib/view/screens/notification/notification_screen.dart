import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/notification_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    Provider.of<NotificationProvider>(context, listen: false)
        .initNotificationList(context);

    return Scaffold(
      backgroundColor: ColorResources.kWhite,
      appBar: (ResponsiveHelper.isDesktop(context)
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(100), child: WebAppBar())
              : CustomAppBar(
                  context: context,
                  title: getTranslated('notification', context)))
          as PreferredSizeWidget?,
      body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
        List<DateTime> dateTimeList = [];
        return notificationProvider.notificationList != null
            ? notificationProvider.notificationList!.isNotEmpty
                ? RefreshIndicator(
                    onRefresh: () async {
                      await Provider.of<NotificationProvider>(context,
                              listen: false)
                          .initNotificationList(context);
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ResponsiveHelper.isDesktop(context)
                                      ? Dimensions.paddingSizeLarge
                                      : 0.0),
                              child: Center(
                                child: Container(
                                  constraints: BoxConstraints(
                                      minHeight: !ResponsiveHelper.isDesktop(
                                                  context) &&
                                              height < 600
                                          ? height
                                          : height - 400),
                                  width: width > Dimensions.webScreenWidth
                                      ? Dimensions.webScreenWidth
                                      : width,
                                  padding: width > 700
                                      ? const EdgeInsets.all(
                                          Dimensions.paddingSizeDefault)
                                      : null,
                                  child: ListView.builder(
                                      itemCount: notificationProvider
                                          .notificationList!.length,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        DateTime originalDateTime =
                                            DateConverter.isoStringToLocalDate(
                                                notificationProvider
                                                    .notificationList![index]
                                                    .createdAt!);
                                        DateTime convertedDate = DateTime(
                                            originalDateTime.year,
                                            originalDateTime.month,
                                            originalDateTime.day);
                                        bool addTitle = false;
                                        if (!dateTimeList
                                            .contains(convertedDate)) {
                                          addTitle = true;
                                          dateTimeList.add(convertedDate);
                                        }
                                        return InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return NotificationDialog(
                                                      notificationModel:
                                                          notificationProvider
                                                                  .notificationList![
                                                              index]);
                                                });
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              addTitle
                                                  ? Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          10, 10, 10, 10),
                                                      child: Text(DateConverter
                                                          .isoStringToLocalDateOnly(
                                                              notificationProvider
                                                                  .notificationList![
                                                                      index]
                                                                  .createdAt!)),
                                                    )
                                                  : const SizedBox(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:35),
                                                decoration: BoxDecoration(
                                              
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeDefault),
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: SizedBox(
                                                            height: 56,
                                                            width: 56,
                                                            child: FadeInImage
                                                                .assetNetwork(
                                                              placeholder: Images
                                                                  .placeholderImage,
                                                              image:
                                                                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notificationProvider.notificationList![index].image}',
                                                              height: 56,
                                                              width: 56,
                                                              fit: BoxFit.cover,
                                                              imageErrorBuilder: (c,
                                                                      b, v) =>
                                                                  Image.asset(
                                                                      Images
                                                                          .placeholderImage,
                                                                      height:
                                                                          60,
                                                                      width: 60,
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 17.0),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                notificationProvider
                                                                    .notificationList![
                                                                        index]
                                                                    .title!,
                                                                style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                  height: 4.0),
                                                              Text(
                                                                notificationProvider
                                                                    .notificationList![
                                                                        index]
                                                                    .description!,
                                                                     style:const TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: ColorResources.ktextgrey),
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          DateConverter.isoStringToLocalTimeOnly(
                                                              notificationProvider
                                                                  .notificationList![
                                                                      index]
                                                                  .createdAt!),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      Dimensions
                                                                          .fontSizeExtraSmall),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                            if (ResponsiveHelper.isDesktop(context))
                              const FooterView(),
                          ],
                        ),
                      ),
                    ),
                  )
                : const NoDataScreen()
            : Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)));
      }),
    );
  }
}
