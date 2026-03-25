import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AutoImageCarousel extends StatefulWidget {
  final List<dynamic> media;
  final double height;
  final BorderRadius? borderRadius;

  const AutoImageCarousel({
    super.key,
    required this.media,
    required this.height,
    this.borderRadius,
  });

  @override
  State<AutoImageCarousel> createState() => _AutoImageCarouselState();
}

class _AutoImageCarouselState extends State<AutoImageCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.media.length > 1) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= widget.media.length) {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.media.isEmpty) {
      return Container(
        width: double.infinity,
        height: widget.height,
        color: Colors.grey[200],
        child: Image.asset("assets/logo.jpeg", fit: BoxFit.fill),
      );
    }

    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: widget.media.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            child: CachedNetworkImage(
              imageUrl: widget.media[index],
              height: widget.height,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: double.infinity,
                height: widget.height,
                color: Colors.grey[200],
                child: Image.asset("assets/logo.jpeg"),
              ),
            ),
          );
        },
      ),
    );
  }
}
