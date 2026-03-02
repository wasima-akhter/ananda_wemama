// class ChatController extends GetxController {
//   late RtmClient rtmClient;
//   late RtmChannel channel;

//   var messages = <String>[].obs;

//   String userId = "user_${DateTime.now().millisecondsSinceEpoch}";

//   Future<void> initRtm(String appId, String token, String channelName) async {
//     rtmClient = await RtmClient.createInstance(appId);

//     await rtmClient.login(token: token, userId: userId);

//     // Join channel
//     channel = await rtmClient.createChannel(channelName);
//     await channel.join();

//     // Listen for messages
//     channel.onMessageReceived = (RtmMessage message, RtmMember? member) {
//       messages.add("${member?.userId ?? "Unknown"}: ${message.text}");
//     };
//   }

//   Future<void> sendMessage(String text) async {
//     final message = RtmMessage.fromText(text);
//     await channel.sendMessage(message);
//     messages.add("Me: $text");
//   }

//   Future<void> leaveChannel() async {
//     await channel.leave();
//     await rtmClient.logout();
//   }
// }
