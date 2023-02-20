import 'package:flutter/material.dart';
import 'package:flutter_application_300/sounds/sound_recorder.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';

class Record extends StatefulWidget {
  Record({Key? key}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  final recorder = SoundRecorder();
  @override
  void initState() { 
    super.initState();
    recorder.init();
  }
  @override
  void dispose() {
   recorder.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Center(
        child: buildStart(),
      ),
    );
  }
  Widget buildStart(){
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'Stop' : 'Record';
    final primary = isRecording ? Colors.redAccent : Colors.black;
    final onPrimary = isRecording ? Colors.black : Colors.redAccent;
    return ElevatedButton.icon(
      onPressed: ()async{
        final isRecording = await recorder.toggleRecording();
        setState(() {
          
        });
      },
       icon: Icon(icon),
        label: Text(text,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(170, 50),
          primary: primary,
          onPrimary: onPrimary
        ),
        );
  }
}