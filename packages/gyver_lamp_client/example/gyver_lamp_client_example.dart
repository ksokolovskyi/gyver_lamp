// ignore_for_file: inference_failure_on_instance_creation, avoid_print

import 'package:gyver_lamp_client/gyver_lamp_client.dart';

const address = '192.168.1.5';
const port = 8888;

void main() async {
  final client = GyverLampClient();

  GyverLampResponse response;

  // TURN ON
  response = await client.turnOn(
    address: address,
    port: port,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // MODE 8
  response = await client.setMode(
    address: address,
    port: port,
    mode: 8,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // MODE 7
  response = await client.setMode(
    address: address,
    port: port,
    mode: 7,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // BRIGHTNESS 100
  response = await client.setBrightness(
    address: address,
    port: port,
    brightness: 100,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // BRIGHTNESS 255
  response = await client.setBrightness(
    address: address,
    port: port,
    brightness: 255,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // SPEED 50
  response = await client.setSpeed(
    address: address,
    port: port,
    speed: 50,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // SPEED 30
  response = await client.setSpeed(
    address: address,
    port: port,
    speed: 30,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // SCALE 30
  response = await client.setScale(
    address: address,
    port: port,
    scale: 30,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // SCALE 78
  response = await client.setScale(
    address: address,
    port: port,
    scale: 78,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  // TURN OFF
  response = await client.turnOff(
    address: address,
    port: port,
  );
  print(response);
  await Future.delayed(
    const Duration(seconds: 2),
  );

  await client.close();
}
