import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isMed = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<int> _lastTime;
  late int time;
  late int pastTimeValue;

  Future<void> handlepress() async {
    final prefs = await _prefs;

    setState(() {
      if (isMed == false) {
        _lastTime = prefs.setInt("gaga", time).then((bool succes) => time);
        isMed = !isMed;
      } else {
        isMed = !isMed;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _lastTime = _prefs.then((SharedPreferences pref) {
      return pref.getInt("gaga") ?? 0;
    });

    SharedPreferences.getInstance().then((pref) => pref.getBool("isMed") ?? false);


    pastTimeValue = 0;
  }

  @override
  Widget build(BuildContext context) {
    final minutes = DateTime.now().minute;
    final hours = DateTime.now().hour;
    final seconds = DateTime.now().second;
    time = (hours * 3600) + (minutes * 60) + seconds;

    final outputPastValue = time - pastTimeValue ;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Center(
          child: Text(
            " ~ Medicine Reminder ~ ",
            style: TextStyle(
              color: Colors.amber[200],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Container(
        color: isMed ? Colors.green[200] : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<int>(
                  future: _lastTime,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    final data = snapshot.data ?? 0;
                    pastTimeValue = data;
                    final h = data ~/ 3600;
                    final m = ((data / 60) - (h * 60)).toInt();
                    final s = data % 60;

                    return Text(
                        "Your Last Take = ${h < 10 ? "0$h" : h}:${m < 10 ? "0$m" : m}:${s < 10 ? "0$s" : s}");
                  },
                ),
                Text("You have clicked $outputPastValue seconds ago"),
                Text("Live time (H:M:S) = $hours:$minutes:$seconds"),
                Text("Live data = $time"),
                Text("Live Time : ${DateTime.now()}"),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  child: const Icon(
                    Icons.add_task,
                  ),
                  onPressed: () {
                    if (isMed == true) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Are you sure?"),
                          content: const Text("you might forget soon"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  handlepress();
                                  return Navigator.pop(context, 'OK');
                                },
                                child: const Text("Yes")),
                            TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text("No")),
                          ],
                        ),
                      );
                    }
                    else{
                      handlepress();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(isMed
                    ? "You Have Taken Medicine ! "
                    : "You haven't take your med.")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
