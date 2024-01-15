import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key, required this.slideImages});

  final List<String> slideImages;

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider(
          items: widget.slideImages
              .map(
                (image) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(16)),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 5),
              height: 200,
              autoPlay: true,
              autoPlayCurve: Curves.easeInCubic,
              viewportFraction: 1,
              animateToClosest: true,
              initialPage: 0),
        ),
        const SizedBox(
          height: 5,
        ),
        AnimatedSmoothIndicator(
            onDotClicked: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            effect: ExpandingDotsEffect(
              activeDotColor: Theme.of(context).colorScheme.primary,
              paintStyle: PaintingStyle.fill,
              dotHeight: 10,
            ),
            curve: Easing.legacy,
            activeIndex: currentIndex,
            count: widget.slideImages.length),
      ],
    );
  }
}
