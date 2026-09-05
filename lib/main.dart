import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(HappyVoiceApp());

class HappyVoiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen(), debugShowCheckedModeBanner: false);
  }
}

class HomeScreen extends StatelessWidget {
  final roomController = TextEditingController(text: "dosti-room");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFEA00),
      appBar: AppBar(title: Text('Happy Voice'), backgroundColor: Color(0xFF0052CC)),
      body: Padding(padding: EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.mic, size: 100, color: Color(0xFF0052CC)),
        TextField(controller: roomController, decoration: InputDecoration(labelText: 'Room Name', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
        SizedBox(height: 20),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0052CC), minimumSize: Size(double.infinity, 55)), onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => VoiceRoom(roomName: roomController.text))); }, child: Text('JOIN ROOM', style: TextStyle(color: Colors.white, fontSize: 18)))
      ])),
    );
  }
}

class VoiceRoom extends StatefulWidget {
  final String roomName; VoiceRoom({required this.roomName});
  @override _VoiceRoomState createState() => _VoiceRoomState();
}
class _VoiceRoomState extends State<VoiceRoom> {
  static const String appId = "1fa15f7f453047ffbe45bf97db63254e";
  bool isMuted = false; late RtcEngine engine;
  @override void initState() { super.initState(); initAgora(); }
  Future<void> initAgora() async {
    await [Permission.microphone].request();
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));
    await engine.joinChannel(token: "", channelId: widget.roomName, uid: 0, options: ChannelMediaOptions());
    await engine.enableAudio();
  }
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.roomName)), body: Center(child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      FloatingActionButton(onPressed: () { setState(() => isMuted = !isMuted); engine.muteLocalAudioStream(isMuted); }, child: Icon(isMuted ? Icons.mic_off : Icons.mic)),
      FloatingActionButton(backgroundColor: Colors.red, onPressed: () => Navigator.pop(context), child: Icon(Icons.call_end))
    ])));
  }
}
