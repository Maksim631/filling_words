import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpeechRecording(),
    );
  }
}

class SpeechRecording extends StatefulWidget {
  @override
  State createState() => SpeechRecordingState();
}

class SpeechRecordingState extends State<SpeechRecording> {
  final _speech = SpeechRecognition();
  bool _isListening = false;
  String _currentLocale;
  bool _speechRecognitionAvailable = false;

  void speechRecording() {
    if (_isListening) {
      print("Stop");
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    } else {
      print("Start");
      print(_speechRecognitionAvailable);
      _speech
          .listen(locale: _currentLocale);
    }
  }

  void initState() {
    super.initState();
    requestPermission();

    _speech.setRecognitionStartedHandler(
        () => setState(() => _isListening = true));
    // _speech.setRecognitionCompleteHandler(
    //     () => setState(() => _isListening = false));
    _speech.setCurrentLocaleHandler(
        (String locale) => setState(() => _currentLocale = locale));
    _speech.setAvailabilityHandler(
        (bool result) => setState(() => _speechRecognitionAvailable = result));
    _speech.setRecognitionResultHandler((String text) => print(text));
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        onPressed: () => speechRecording(),
      ),
    );
  }

  requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    print('Permissions $permissions');
  }
}
