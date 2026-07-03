enum CallType { voice, video }

enum CallStatus { ringing, accepted, rejected, missed, ended }

class CallModel {
  final String callId;
  final String callerId;
  final String receiverId;
  final String channelName;
  final CallType type;
  final CallStatus status;
  final DateTime createdAt;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.receiverId,
    required this.channelName,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'callId': callId,
    'callerId': callerId,
    'receiverId': receiverId,
    'channelName': channelName,
    'type': type.name,
    'status': status.name,
    'createdAt': createdAt,
  };

  factory CallModel.fromMap(Map<String, dynamic> map) => CallModel(
    callId: map['callId'],
    callerId: map['callerId'],
    receiverId: map['receiverId'],
    channelName: map['channelName'],
    type: CallType.values.byName(map['type']),
    status: CallStatus.values.byName(map['status']),
    createdAt: map['createdAt'].toDate(),
  );
}
