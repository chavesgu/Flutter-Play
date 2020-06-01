import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:flutter_play/components/GlobalComponents.dart';
import 'package:flutter_play/variable.dart';

class Banner extends StatelessWidget {
  Banner(this.bannerList);

  final List bannerList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: vw,
      height: (vw-width(60))/899*349+width(60),
      padding: EdgeInsets.only(
        top: width(30),
        bottom: width(30),
      ),
      child: CancelBubble(
        child: bannerList.length>0?Swiper(
          autoplay: true,
          autoplayDelay: 5000,
          duration: 600,
          itemBuilder: (BuildContext context,int index){
            return Container(
              margin: EdgeInsets.only(
                left: width(30),
                right: width(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(width(16))),
                child: MyImage(
                  bannerList[index]["pic"],
                  loadingSize: 20,
                ),
              ),
            );
          },
          itemCount: bannerList.length,
          pagination: SwiperPagination(
            margin: EdgeInsets.only(bottom: 5),
            builder: DotSwiperPaginationBuilder(
              size: 8,
              activeSize: 8,
            )
          ),
        ):Container(),
      ),
    );
  }
}