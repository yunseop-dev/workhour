import 'package:flutter/material.dart';
import 'package:flutter_workhour/widgets/time_selector.dart';

Map<int, String> dayOfWeek = {
  0: '일',
  1: '월',
  2: '화',
  3: '수',
  4: '목',
  5: '금',
  6: '토',
};

void main() {
  runApp(MaterialApp(
      title: 'When do you commute?',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('When do you commute?',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
          ),
          body: _MyStatefulWidget(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Respond to button press
            },
            child: const Icon(Icons.save),
          ))));
}

class _MyStatefulWidget extends StatefulWidget {
  @override
  State createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<_MyStatefulWidget> {
  int currentPageOfGetToWork = 0;
  int currentPageOfLeaveWork = 0;

  String getToWorkTime = '';
  String leaveWorkTime = '';
  String? currentDayOfWeek = dayOfWeek[DateTime.now().weekday];

  @override
  void initState() {
    super.initState();
    print('initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('$currentDayOfWeek, $getToWorkTime $leaveWorkTime'),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 30),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: dayOfWeek.values
                .map((e) => ElevatedButton(
                    onPressed: () {
                      print(e);
                      setState(() {
                        currentDayOfWeek = e;
                      });
                    },
                    child: Text(e,
                        style: TextStyle(
                            color: currentDayOfWeek == e
                                ? Colors.white
                                : Colors.black)),
                    style: ElevatedButton.styleFrom(
                        primary:
                            currentDayOfWeek == e ? Colors.blue : Colors.white,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20))))
                .toList(),
          ),
        ),
      ),
      Row(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Get to work by",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      TimeSelector(
        onChange: (index) {
          print('one $index');
        },
      ),
      const Divider(
        indent: 16,
        endIndent: 16,
      ),
      Row(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: const Text(
              "Leave work by",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      TimeSelector(onChange: (index) {
        print('two $index');
      })
    ]);
  }

  @override
  void didUpdateWidget(covariant _MyStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    super.deactivate();
    print('dispose');
  }
}
