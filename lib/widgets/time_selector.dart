import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

List<int> hours = [for (var i = 0; i <= 23; i++) i];
List<int> minutes = [for (var i = 0; i < 60; i++) i];

List<String> selectableTimes = hours
    .map((hour) => minutes.map((minute) {
          var h = hour < 10 ? '0$hour' : hour;
          var m = minute < 10 ? '0$minute' : minute;
          return '$h:$m';
        }))
    .fold([], (prev, curr) => [...prev, ...curr]);

class _TimeSelector extends State<TimeSelector> {
  CarouselController carouselController = CarouselController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      options: CarouselOptions(
          height: 72.0,
          enlargeCenterPage: true,
          reverse: true,
          viewportFraction: 0.25,
          onPageChanged: (index, reason) {
            print('$index, $reason');
            String selectedTime = selectableTimes[index];
            setState(() {
              selectedIndex = index;
            });
            widget.onChange(selectedTime);
            // onPress(index);
          }),
      items: selectableTimes.asMap().entries.map((entry) {
        int page = entry.key;
        String text = entry.value;
        return TextButton(
            onPressed: () {
              carouselController.animateToPage(page,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            },
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 24.0,
                  color: selectedIndex == page ? Colors.black : Colors.grey),
            ));
      }).toList(),
    );
  }
}

class TimeSelector extends StatefulWidget {
  final Function(String time) onChange;

  const TimeSelector({Key? key, required this.onChange}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimeSelector();
}
