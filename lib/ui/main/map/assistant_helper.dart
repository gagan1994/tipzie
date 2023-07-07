import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AssistantHelper {
  final SpeechToText speech = SpeechToText();
  String lastError = "";
  String lastStatus = "done";
  bool _logEvents = true;
  bool isInit = false;
  Function()? callback;
  String _currentLocaleId = "";

  String lastWords = "";

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error message:${error.errorMsg}, listening: ${speech.isListening}');
    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    lastStatus = status;
    updateUi();
  }

  bool isListening() {
    return lastStatus != "done";
  }

  Future<void> initSpeechState(Function() callback) async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      isInit = hasSpeech;
      this.callback = callback;
      print("updating ui callback helper: $hashCode");
    } catch (e) {
      lastError = 'Speech recognition failed: ${e.toString()}';
    }
    updateUi();
  }

  void startListening(Function(VoiceEvents) callback) {
    _logEvent('start listening');
    lastError = '';
    speech.listen(
      onResult: (result) {
        _logEvent(
            'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
        if (result.finalResult) {
          updateDataFromText(callback, result);
        }
        lastWords = '${result.recognizedWords} - ${result.finalResult}';
      },
      listenFor: Duration(seconds: 5),
      pauseFor: Duration(seconds: 3),
      partialResults: true,
      localeId: _currentLocaleId,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: false,
    );
  }

  void stopListening() {
    _logEvent('stop');
    speech.stop();
  }

  void cancelListening() {
    _logEvent('cancel');
    speech.cancel();
  }

  void _logEvent(String s) {
    print(s);
  }

  void dispose() {
    callback = null;
  }

  void updateUi() {
    print("updating ui callback helper: $hashCode");
    if (callback != null) {
      print("updateUI2");
      callback!();
    }
  }

  void updateDataFromText(
      Function(VoiceEvents) callback, SpeechRecognitionResult result) {
    var receivedWords = result.recognizedWords;
    print("received words: $receivedWords");
    if (receivedWords.toLowerCase().contains("unmute")) {
      print("sending unmute event");
      callback(VoiceEvents.UNMUTE);
    } else {
      if (receivedWords.toLowerCase().contains("mute")) {
        print("sending mute event");
        callback(VoiceEvents.MUTE);
      }
    }
    if (receivedWords.toLowerCase().contains("speaker")) {
      if (receivedWords.toLowerCase().contains("on")) {
        print("sending speakerMode on event");
        callback(VoiceEvents.SPEAKER_MODE_ON);
      }
      if (receivedWords.toLowerCase().contains("off") ||
          receivedWords.toLowerCase().contains("of")) {
        print("sending speakerMode off event");
        callback(VoiceEvents.SPEAKER_MODE_OF);
      }
    }
  }
}

enum VoiceEvents { MUTE, UNMUTE, SPEAKER_MODE_ON, SPEAKER_MODE_OF }
