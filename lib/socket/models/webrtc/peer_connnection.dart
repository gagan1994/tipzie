import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerConnection {
  late RTCPeerConnection _peerConnection;
  List<RTCVideoRenderer> remoteRenderer = [];

  Function(RTCIceCandidate candidate)? onIceCandidate;

  Function(RTCTrackEvent event)? onTrack;

  String userId = "";

  Future<void> init(MediaStream localStream, String userId) async {
    this.userId = userId;
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    });
    localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, localStream);
    });
    _peerConnection?.onIceCandidate = onIceCandidate!;
    _peerConnection?.onTrack = onTrack!;
  }

  setRemoteDescription(RTCSessionDescription answer) async {
    await _peerConnection.setRemoteDescription(answer);
  }

  void addCandidate(RTCIceCandidate candidate) {
    _peerConnection.addCandidate(candidate);
  }

  Future<RTCSessionDescription> createAnswer(Map<String, String> map) async {
    return await _peerConnection.createAnswer(map);
  }

  Future<void> setLocalDescription(RTCSessionDescription sdp) async {
    return _peerConnection.setLocalDescription(sdp);
  }

  void close() {
    _peerConnection.close();
  }

  Future<RTCSessionDescription> createOffer(Map<String, String> map) {
    return _peerConnection.createOffer(map);
  }

  RTCPeerConnection getPeerConnection() {
    return _peerConnection;
  }
}
