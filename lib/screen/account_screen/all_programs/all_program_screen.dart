import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymeats_mobile/constant/asset_utils.dart';
import 'package:gymeats_mobile/constant/color_utils.dart';

import '../../grocery/modal/grocery_multi_search_modal.dart';

class AllProgramScreen extends StatefulWidget {
  const AllProgramScreen({super.key});

  @override
  State<AllProgramScreen> createState() => _AllProgramScreenState();
}

class _AllProgramScreenState extends State<AllProgramScreen> {
  // List programList = [
  //   {"image": AssetsUtils.appleLogo, "title": ""}
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      /*   body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: AppColors.whiteColor,
            title: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("All Programs"),
                  SizedBox(height: 5.h),
                  Container(
                    height: 35.h,
                    width: 95.h,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssetsUtils.gymEatsSpoon),
                          fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              // collapseMode: CollapseMode.pin,
              centerTitle: true,
              background: Stack(
                // fit: StackFit.expand,
                children: [
                  Image.asset(
                    AssetsUtils.lightBlueBackGroundImage,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Container(
                        height: 100,
                        color: Colors.transparent, // 40
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            */ /*  Image.asset(
                AssetsUtils.lightBlueBackGroundImage,
              ),*/ /*
          )
        ],
        body: Container(
          color: Colors.yellow,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 25,
            itemBuilder: (context, index) => ListTile(
              title: Container(color: Colors.red, child: Text('Item $index')),
            ),
          ),
        ),
      ),*/
    );
  }
}
