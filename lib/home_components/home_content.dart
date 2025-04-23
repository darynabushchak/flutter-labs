import 'package:app/home_components/home_buttons.dart';
import 'package:app/home_components/light_bulb_widget.dart';
import 'package:app/home_components/mode_selector.dart';
import 'package:app/services/mqtt_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final MqttService mqttService = MqttService();

  bool isLightOn = false;
  Color bulbColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    mqttService.connect();
    mqttService.messageStream.listen((message) {
      if (message == 'on') {
        setState(() => isLightOn = true);
      } else if (message == 'off') {
        setState(() => isLightOn = false);
      } else if (message.startsWith('#') && message.length == 7) {
        try {
          final color =
              Color(int.parse('FF${message.substring(1)}', radix: 16));
          setState(() => bulbColor = color);
        } catch (_) {
          // ignore invalid color
        }
      }
    });
  }

  @override
  void dispose() {
    mqttService.disconnect();
    super.dispose();
  }

  void _toggleLight() {
    setState(() => isLightOn = !isLightOn);
    mqttService.publishMessage('light/status', isLightOn ? 'on' : 'off');
  }

  void _pickColor(BuildContext context) async {
    Color picked = bulbColor;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: picked,
            onColorChanged: (color) => picked = color,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
    setState(() => bulbColor = picked);
    final hex =
        '#${bulbColor.value.toRadixString(16).substring(2).toUpperCase()}';
    mqttService.publishMessage('light/color', hex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        LightBulbWidget(color: isLightOn ? bulbColor : Colors.grey.shade300),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _toggleLight,
          child: Text(isLightOn ? 'Turn Off' : 'Turn On'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _pickColor(context),
          child: const Text('Pick Color'),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ModeSelector(),
        ),
        const Spacer(),
        const HomeButtons(),
      ],
    );
  }
}
