import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/models/webrtc/peer_connnection.dart';
import 'package:web_socket_channel/io.dart';

import '../../../api/api_wrapper.dart';
import '../../../api/ride.dart';

class WebRtcHelper {
  static WebRtcHelper instance = WebRtcHelper();

  late Function() callback;
  Ride? currentRide;

  var room_id = "";
  StreamController<LiveLocationModel> liveLocationStream =
      StreamController<LiveLocationModel>();
  StreamController<List<dynamic>> userInRoom =
      StreamController<List<dynamic>>();

  static WebRtcHelper getInstance() {
    return instance;
  }

  var users = [];
  SplayTreeMap<String, PeerConnection> peerConnections =
      SplayTreeMap<String, PeerConnection>();
  String userId = "";
  MediaStream? _localStream;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  late IOWebSocketChannel _signalingChannel;
  IOWebSocketChannel getSignalingChannel() {
    return _signalingChannel;
  }

  PeerConnection connectWithIndex(int index) {
    return peerConnections[peerConnections.keys.elementAt(index)]!;
  }

  void init(Ride ride, Function() callback) async {
    currentRide = ride;
    this.callback = callback;
    for (var item in ride.selectedUsers!) {
      users.add(item.userId!);
    }
    userId = Authentication.loggedInUser!.userId!;
    room_id = ride.getId();
    print("creating socket with roomId: ${room_id}");
    _signalingChannel = IOWebSocketChannel.connect(BASE_URL_SOCKET);
    createRoom();
    _localStream = await navigator.mediaDevices
        .getUserMedia({'audio': true, 'video': false});
    await localRenderer.initialize();
    localRenderer.srcObject = _localStream;

    for (var item in users) {
      var peerConnection = PeerConnection();
      peerConnection.onIceCandidate = (candidate) {
        _sendIceCandidate(candidate, peerConnection.userId);
      };
      peerConnection.onTrack = (event) async {
        if (event.track.kind == 'audio') {
          print(
              'Received audio track: ${event.track.id} event stream size ${event.streams.length}');
          RTCVideoRenderer renderer = RTCVideoRenderer();
          await renderer.initialize();
          renderer.srcObject = event.streams[0];
          peerConnection.remoteRenderer.add(renderer);
          event.track.onEnded = () {
            print("Track ended $item");
          };
          event.track.onMute = () {
            print("Track onMute $item");
          };
          event.track.onUnMute = () {
            print("Track onUnMute $item");
          };
          print(
              "Received audio track renderer size: ${peerConnection.remoteRenderer.length}");
          callback();
        } else if (event.track.kind == 'video') {
          print('Received video track: ${event.track.id}');
        }
      };

      await peerConnection.init(_localStream!, item);
      peerConnections.putIfAbsent(item, () => peerConnection);
    }
    _signalingChannel.stream.listen((message) {
      final data = jsonDecode(message);
      final fromUser = data['user_id'];
      final type = data['type'];
      print("message received: $type");
      switch (type) {
        case 'invite':
          List<String> toUserIds =
              List<String>.from(data['data']['to_user_ids']);
          print("send invite from current $userId toUserIds: $toUserIds");
          for (var item in toUserIds) {
            startMeeting(peerConnections[item]!);
          }
          break;
        case 'end':
          List<String> toUserIds =
              List<String>.from(data['data']['to_user_ids']);
          print("send end from current $userId toUserIds: $toUserIds");
          for (var item in toUserIds) {
            endMeeting(peerConnections[item]!);
          }
          break;
        case 'offer':
          final toUserId = data['to_user_id'];
          print(
              "event $type userId:$userId fromUser: $fromUser toUserId: $toUserId");
          if (toUserId != userId) {
            return;
          }
          // Handle offer from remote peer
          _handleOffer(data['offer'], fromUser);
          break;
        case 'answer':
          final toUserId = data['to_user_id'];
          print(
              "event $type userId:$userId fromUser: $fromUser toUserId: $toUserId");
          if (toUserId != userId) {
            return;
          }
          // Handle answer from remote peer
          _handleAnswer(data['answer'], fromUser);
          break;
        case 'ice-candidate':
          final toUserId = data['to_user_id'];
          print(
              "event $type userId:$userId fromUser: $fromUser toUserId: $toUserId");
          if (toUserId != userId) {
            return;
          }
          _handleIceCandidate(data['candidate'], fromUser);
          break;
        case 'close':
          final toUserId = data['to_user_id'];
          print(
              "event $type userId:$userId fromUser: $fromUser toUserId: $toUserId");
          if (toUserId != userId) {
            return;
          }
          _handleClose(peerConnections[fromUser]!);
          break;
        case 'location-update':
          print("location-update");
          print(data['user_id']);
          var location = LiveLocationModel.fromJson(data['data']);
          liveLocationStream.add(location);
          break;
        case 'room-created':
          print("room created");
          break;
        case 'user-joined':
          print("user joined $data");
          userInRoom.add(data['user_id']);
          break;
        default:
          print('Unknown message type: $type');
      }
    });
    callback();
  }

  void _sendOffer(RTCSessionDescription offer, String toUserId) {
    final message = jsonEncode({
      'type': 'offer',
      'offer': offer.toMap(),
      'room_id': room_id,
      'user_id': userId,
      'to_user_id': toUserId,
    });
    _signalingChannel.sink.add(message);
  }

  void _sendIceCandidate(RTCIceCandidate candidate, String toUserId) {
    final message = jsonEncode({
      'type': 'ice-candidate',
      'candidate': candidate.toMap(),
      'room_id': room_id,
      'user_id': userId,
      'to_user_id': toUserId,
    });
    _signalingChannel.sink.add(message);
  }

  void _handleAnswer(Map<String, dynamic> answerMap, String fromUser) async {
    try {
      final answer = RTCSessionDescription(answerMap['sdp'], answerMap['type']);
      await peerConnections[fromUser]!.setRemoteDescription(answer);
      callback();
    } catch (error) {
      print('Error handling answer: $error');
    }
  }

  void _handleIceCandidate(Map<String, dynamic> candidateMap, String fromUser) {
    try {
      final candidate = RTCIceCandidate(candidateMap['candidate'],
          candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
      peerConnections[fromUser]!.addCandidate(candidate);
      callback();
    } catch (error) {
      print('Error handling ICE candidate: $error');
    }
  }

  void _sendAnswer(RTCSessionDescription answer, String toUserId) {
    final message = jsonEncode({
      'type': 'answer',
      'answer': answer.toMap(),
      'room_id': room_id,
      'user_id': userId,
      'to_user_id': toUserId,
    });
    _signalingChannel.sink.add(message);
  }

  void _handleOffer(Map<String, dynamic> offerMap, String fromUser) async {
    try {
      final offer = RTCSessionDescription(offerMap['sdp'], offerMap['type']);
      await peerConnections[fromUser]!.setRemoteDescription(offer);

      // Create an answer
      final answer = await peerConnections[fromUser]!.createAnswer({});
      await peerConnections[fromUser]!.setLocalDescription(answer);

      // Send the answer to the remote peer
      _sendAnswer(answer, fromUser);
      callback();
    } catch (error) {
      print('Error handling offer: $error');
    }
  }

  void dispose() {
    peerConnections.forEach((key, value) {
      peerConnections[key]!.close();
    });
    _signalingChannel.sink.close();
    peerConnections.clear();
  }

  void createRoom() async {
    final message = jsonEncode({
      'type': 'create-room',
      'room_id': room_id,
      'user_id': userId,
    });
    print("create room room_id $room_id");
    _signalingChannel.sink.add(message);
    print("create room sent data $room_id");
  }

  void joinRoom() {
    print("join room");
    final message = jsonEncode({
      'type': 'join-room',
      'room_id': room_id,
      'user_id': userId,
    });
    _signalingChannel.sink.add(message);
  }

  void startMeeting(PeerConnection connection) async {
    print("start meeting");
    final offer = await connection.createOffer({});
    await connection.setLocalDescription(offer);
    _sendOffer(offer, connection.userId);
  }

  void endMeeting(PeerConnection connection) async {
    print("end meeting");
    closeCall(connection.userId);
    _handleClose(connection);
  }

  void closeCall(String toUserId) {
    final message = jsonEncode({
      'type': 'close',
      'room_id': room_id,
      'user_id': userId,
      'to_user_id': toUserId,
    });
    _signalingChannel.sink.add(message);
  }

  void _handleClose(PeerConnection connection) {
    print("close_call");
    connection.close();
    // Stop local media stream
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    connection.remoteRenderer.forEach((element) {
      element.dispose();
    });
    connection.remoteRenderer.clear();
    callback();
  }

  void startMeetingForAll() {
    final message = jsonEncode({
      'type': 'start-meeting',
      'user_id': userId,
      'room_id': room_id,
    });
    _signalingChannel.sink.add(message);
  }

  void endMeetingForAll() {
    final message = jsonEncode({
      'type': 'end-meeting',
      'user_id': userId,
      'room_id': room_id,
    });
    _signalingChannel.sink.add(message);
  }

  void sendLocationDetails(LiveLocationModel data) {
    final message = jsonEncode({
      'type': 'location-update',
      'room_id': room_id,
      'user_id': userId,
      'data': data
    });
    print("send location $room_id $userId");
    _signalingChannel.sink.add(message);
  }

  StreamController<LiveLocationModel> getLiveLocationStream() {
    if (liveLocationStream.isClosed) {
      liveLocationStream = StreamController<LiveLocationModel>();
    }
    return liveLocationStream;
  }

  StreamController<List<dynamic>> getUsersInRoom() {
    if (userInRoom.isClosed) {
      userInRoom = StreamController<List<dynamic>>();
    }
    return userInRoom;
  }
}
