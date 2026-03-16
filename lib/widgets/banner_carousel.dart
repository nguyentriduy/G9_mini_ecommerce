import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'network_product_image.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key, required this.images});

  final List<String> images;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1C000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkProductImage(
                    imageUrl: widget.images[index],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [Color(0x55000000), Color(0x09000000)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    top: 18,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Text(
                          'SIÊU DEAL',
                          style: TextStyle(
                            color: Color(0xFF9A3412),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    bottom: 36,
                    child: Text(
                      'Mega sale cuối tuần',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    bottom: 16,
                    child: Text(
                      'Freeship 0đ • Hoàn xu mỗi đơn',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 168,
            viewportFraction: 0.92,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            final selected = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: selected ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEA580C)
                    : const Color(0xFFD6C2B5),
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),
      ],
    );
  }
}
