import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x/constants/appwrite_constants.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;

  const CarouselImage({
    super.key,
    required this.imageLinks,
  });

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          items: widget.imageLinks
              .map((link) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Image.network(
                      kIsWeb ? link : link.replaceAll('http://127.0.0.1', 'http://172.29.112.1'),
                      fit: BoxFit.contain,
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            // viewportFraction: .75,
            aspectRatio: 2,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imageLinks.asMap().entries.map((e) {
              return Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(
                    _current == e.key ? 0.9 : 0.4,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
