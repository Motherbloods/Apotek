import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<String> imgList;
  final CarouselController carouselController;
  final int current;
  final Function(int, CarouselPageChangedReason) onPageChanged;

  const CarouselWithIndicator({
    Key? key,
    required this.imgList,
    required this.carouselController,
    required this.current,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.imgList
              .map((item) => ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      'assets/images/$item',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ))
              .toList(),
          carouselController: widget.carouselController,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: widget.onPageChanged,
          ),
        ),
      ],
    );
  }
}
