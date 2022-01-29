import 'package:flutter/material.dart';
import 'package:flutter_workhour/models/workhour.dart';
import 'package:flutter_workhour/provider/workhour_provider.dart';
import 'package:flutter_workhour/utils/db_helper.dart';
import 'package:flutter_workhour/widgets/time_selector.dart';
import 'package:provider/provider.dart';
import 'package:time/time.dart';

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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => WorkhourProvider()),
        ],
        child: const Home(),
      )));
}

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbHelper = DBHelper();
    return Scaffold(
        appBar: AppBar(
          title: const Text('When do you commute?',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: _MyStatefulWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Respond to button press
            Workhour workhour =
                Provider.of<WorkhourProvider>(context, listen: false).workhour;
            bool isExists = await dbHelper.isExists(workhour.dayOfWeek);
            if (isExists) {
              await dbHelper.update(workhour);
            } else {
              await dbHelper.insert(workhour);
            }
          },
          child: const Icon(Icons.save),
        ));
  }
}

class _MyStatefulWidget extends StatefulWidget {
  @override
  State createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<_MyStatefulWidget> {
  int currentPageOfGetToWork = 0;
  int currentPageOfLeaveWork = 0;

  Duration getToWorkTime = 0.seconds;
  Duration leaveWorkTime = 0.seconds;
  String? currentDayOfWeek = dayOfWeek[DateTime.now().weekday];
  final dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    print('initState');
    dbHelper.getByDayOfWeek(DateTime.now().weekday).then((value) {
      setState(() {
        getToWorkTime = value.startedAt;
        leaveWorkTime = value.endedAt;
        currentDayOfWeek = dayOfWeek[value.dayOfWeek];
      });
      var workhour = Provider.of<WorkhourProvider>(context, listen: false);
      workhour.id = value.dayOfWeek;
      workhour.startedAt = value.startedAt;
      workhour.endedAt = value.endedAt;
      workhour.dayOfWeek = value.dayOfWeek;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  Widget build(BuildContext context) {
    var workHour = leaveWorkTime - getToWorkTime;
    return Column(children: <Widget>[
      Text(
          '$currentDayOfWeek, 시작시간: $getToWorkTime 종료시간: $leaveWorkTime 근무시간: $workHour'),
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
                      // print(e);
                      int weekday = dayOfWeek.values
                          .toList()
                          .indexWhere((element) => element == e);

                      Provider.of<WorkhourProvider>(context, listen: false)
                          .dayOfWeek = weekday;

                      dbHelper.getByDayOfWeek(weekday).then((value) {
                        setState(() {
                          getToWorkTime = value.startedAt;
                          leaveWorkTime = value.endedAt;
                          currentDayOfWeek = e;
                        });
                        var workhour = Provider.of<WorkhourProvider>(context,
                            listen: false);
                        workhour.id = value.dayOfWeek;
                        workhour.startedAt = value.startedAt;
                        workhour.endedAt = value.endedAt;
                        workhour.dayOfWeek = value.dayOfWeek;
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
        onChange: (time) {
          Duration hour = int.parse(time.split(':')[0]).hours;
          Duration minutes = int.parse(time.split(':')[1]).minutes;
          Provider.of<WorkhourProvider>(context, listen: false).startedAt =
              hour + minutes;
          setState(() {
            getToWorkTime = hour + minutes;
          });
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
      TimeSelector(onChange: (time) {
        Duration hour = int.parse(time.split(':')[0]).hours;
        Duration minutes = int.parse(time.split(':')[1]).minutes;
        Provider.of<WorkhourProvider>(context, listen: false).endedAt =
            hour + minutes;
        setState(() {
          leaveWorkTime = hour + minutes;
        });
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
