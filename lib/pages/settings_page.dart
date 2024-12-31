import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:minimal_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //dark mode
              Text("Dark Mode"),
              //switch toggle
              CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme())
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(25),
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //dark mode
              Text("Change theme color"),
              //switch toggle
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(themeNotifier.themeColor)),
                onPressed: () async {
                  Color? newColor = await showDialog(
                    context: context,
                    builder: (_) => ColorPickerDialog(themeNotifier.themeColor),
                  );
                  if (newColor != null) {
                    themeNotifier.setThemeColor(newColor);
                  }
                },
                child: Text(""),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  ColorPickerDialog(this.initialColor);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color selectedColor;

  _ColorPickerDialogState() : selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a Color'),
      content: SingleChildScrollView(
        child: BlockPicker(
          pickerColor: widget.initialColor,
          onColorChanged: (color) => setState(() => selectedColor = color),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: Text('Select'),
        ),
      ],
    );
  }
}
