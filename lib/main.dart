import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart'; // Import the color picker package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'Advanced Counter App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CounterApp(), // Set CounterApp as the home widget
    );
  }
}

class CounterApp extends StatefulWidget {
  @override
  _CounterAppState createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  List<Counter> counters = [
    Counter(value: 0, color: const Color.fromARGB(255, 255, 0, 0), label: "Counter 1"),
    Counter(value: 0, color: const Color.fromARGB(255, 255, 0, 162), label: "Counter 2"),
  ];

  void _incrementCounter(int index) {
    setState(() {
      counters[index].value++;
    });
  }

  void _decrementCounter(int index) {
    if (counters[index].value > 0) {
      setState(() {
        counters[index].value--;
      });
    }
  }

  void _changeColor(int index, Color color) {
    setState(() {
      counters[index].color = color;
    });
  }

  void _changeLabel(int index, String label) {
    setState(() {
      counters[index].label = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advanced Counter App")),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = counters.removeAt(oldIndex);
            counters.insert(newIndex, item);
          });
        },
        children: [
          for (int i = 0; i < counters.length; i++)
            Card(
              key: ValueKey(counters[i]),
              color: counters[i].color.withOpacity(0.3),
              child: ListTile(
                title: Text(counters[i].label),
                subtitle: Text("Value: ${counters[i].value}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrementCounter(i),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _incrementCounter(i),
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        if (value == "color") {
                          _showColorPicker(context, i);
                        } else if (value == "label") {
                          _showLabelDialog(context, i);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "color",
                          child: Text("Change Color"),
                        ),
                        const PopupMenuItem(
                          value: "label",
                          child: Text("Change Label"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  void _showColorPicker(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a Color"),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: counters[index].color,
            onColorChanged: (color) {
              _changeColor(index, color);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  void _showLabelDialog(BuildContext context, int index) {
    final controller = TextEditingController(text: counters[index].label);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Label"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new label"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _changeLabel(index, controller.text);
              Navigator.of(context).pop();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

class Counter {
  int value;
  Color color;
  String label;

  Counter({required this.value, required this.color, required this.label});
}
