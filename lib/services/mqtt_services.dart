import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final _controller = StreamController<String>.broadcast();

  Stream<String> get messageStream => _controller.stream;

  final client = MqttServerClient('broker.hivemq.com', 'smart_lights_flutter');

  Future<void> connect() async {
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onConnected = () => print('Connected to MQTT broker');
    client.onDisconnected = () => print('Disconnected from MQTT broker');

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('smart_lights_flutter')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('MQTT connection failed: \$e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected to broker!');
      client.subscribe('light/status', MqttQos.atMostOnce);
      client.subscribe('light/color', MqttQos.atMostOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        _controller.add(payload);
      });
    }
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void disconnect() {
    client.disconnect();
    _controller.close();
  }
}
