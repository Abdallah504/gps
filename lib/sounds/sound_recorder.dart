

import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
final pathToSaveAudio = 'audio_example.aac';
class SoundRecorder{

  FlutterSoundRecorder? _soundRecorder;
  bool _isRecorderInitialized = false;
  bool get isRecording => _soundRecorder!.isRecording;
  Future init() async{
    _soundRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted){
      throw RecordingPermissionException('Please enable permission of microphone');
    }
    await _soundRecorder!.openAudioSession();
    _isRecorderInitialized = true;
  }
  void dispose(){
    if(!_isRecorderInitialized)return;
    _soundRecorder!.closeAudioSession();
    _soundRecorder = null;
    _isRecorderInitialized = false;
  }
  Future _record() async{
    if(!_isRecorderInitialized)return;
    await _soundRecorder!.startRecorder(toFile: pathToSaveAudio);
  }
  Future _stop()async{
    if(!_isRecorderInitialized)return;
    await _soundRecorder!.stopRecorder();
  }
  Future toggleRecording() async{
    if(_soundRecorder!.isStopped){
      await _record();
    }else{
      await _stop();
    }
  }
}