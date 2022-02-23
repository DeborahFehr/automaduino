class ImageSource {
  String imagePath;
  String title;
  String url;

  ImageSource(this.imagePath, this.title, this.url);
}

List<ImageSource> images = [
  ImageSource("graphics/state_icons/demo.png", "defaultBlockIcon",
      "https://www.flaticon.com/free-icon/question-mark-draw_16686"),
  ImageSource("graphics/state_icons/motion-sensor.png", "motionSensor",
      "https://www.flaticon.com/free-icon/motion-sensor_1539088"),
  ImageSource(
      "graphics/state_icons/temperature-sensor.png",
      "temperatureSensor",
      "https://www.flaticon.com/premium-icon/temperature-control_3710965"),
  ImageSource("graphics/state_icons/humidity-sensor.png", "humiditySensor",
      "https://www.flaticon.com/premium-icon/water_4359534"),
  ImageSource("graphics/state_icons/vibration-sensor.png", "vibrationSensor",
      "https://www.flaticon.com/free-icon/vibration_3336931"),
  ImageSource("graphics/state_icons/loudness-sensor.png", "loudnessSensor",
      "https://www.flaticon.com/premium-icon/ear_2964025"),
  ImageSource("graphics/state_icons/ultrasonic-ranger.png", "ultrasonicRanger",
      "https://www.flaticon.com/premium-icon/heights_3789467"),
  ImageSource("graphics/state_icons/button.png", "button",
      "https://www.flaticon.com/premium-icon/tap_655469"),
  ImageSource("graphics/state_icons/switch.png", "switch",
      "https://www.flaticon.com/premium-icon/turn-on_3256132"),
  ImageSource("graphics/state_icons/keypad.png", "keypad",
      "https://www.flaticon.com/free-icon/password_1672575"),
  ImageSource("graphics/state_icons/potentiometer.png", "potentiometer",
      "https://www.flaticon.com/premium-icon/dial_4115969"),
  ImageSource("graphics/state_icons/tilt.png", "tilt",
      "https://www.flaticon.com/free-icon/button_5169082"),
  ImageSource("graphics/state_icons/led_on.png", "led",
      "https://www.flaticon.com/free-icon/led_2088743"),
  ImageSource("graphics/state_icons/buzzer_on.png", "buzzer",
      "https://www.flaticon.com/premium-icon/sound_3091231"),
  ImageSource("graphics/state_icons/vibration_on.png", "vibrationMotor",
      "https://www.flaticon.com/premium-icon/vibration_513171"),
  ImageSource("graphics/state_icons/relay_off.png", "relay",
      "https://www.flaticon.com/premium-icon/switch_6039126"),
  ImageSource("graphics/state_icons/relay_on.png", "flashInRelayOn",
      "https://www.flaticon.com/free-icon/flash_248053"),
  ImageSource("graphics/servo.png", "servo",
      "https://www.flaticon.com/free-icon/servo_6275656"),
  ImageSource("graphics/german.png", "languageIconGerman",
      "https://www.flaticon.com/premium-icon/germany_4628643"),
  ImageSource("graphics/english.png", "languageIconEnglish",
      "https://www.flaticon.com/premium-icon/uk_4628638"),
];
