import 'package:careplus_patient/constant/color_constants.dart';
import 'package:careplus_patient/constant/dimension_constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final double height;
  final bool showIndicator;
  final List<dynamic>? carouselItems;

  const Carousel({
    Key? key,
    required this.height,
    this.showIndicator=true,
    this.carouselItems,
  }) : super(key: key);

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int activePage = 0;

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = widget.carouselItems ?? [1,2,3];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: _carousel(items),
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: widget.showIndicator,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _indicators(
              items.length,
              activePage,
            ),
          ),
        )
      ],
    );
  }

  Widget _carousel(List<dynamic> items) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(RADIUS_EXTRA_SMALL),
      child: CarouselSlider(
        items: _carouselItems(items),
        options: CarouselOptions(
          height: widget.height,
            viewportFraction: 1.0,
            autoPlay: true,
            onPageChanged: (page, reason) {
              setState(() {
                activePage = page;
              });
            }),
      ),
    );
  }

  _carouselItems(List<dynamic> items) {
    return items.map((item) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              gradient: const LinearGradient(
                colors: [
                  PRIMARY_COLOR_1,
                  PRIMARY_COLOR_2,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              image: widget.carouselItems!=null?
              DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    'https://careplusmedia.sgp1.cdn.digitaloceanspaces.com/${item.banner}',
                  )):null,
            ),
          );
        },
      );
    }).toList();
  }

  List<Widget> _indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(
      imagesLength,
      (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
