class SocketEvents {
  // 💬 Chat
  static const sendMessage = "send_message";
  static const receiveMessage = "receive_message";

  // ❤️ Conversation / Match
  static const sendConversationRequest = "send_conversation_request"; // emit + response
  static const newConversationRequest = "new_conversation_request"; // receiver listens

  // Wave List
  static const getConversationRequests = "get_conversation_requests"; // receiver listens
  static const conversationRequests = "conversation_requests"; // receiver listens
  static const acceptConversationRequest = "accept_conversation_request"; // receiver listens
  static const conversationAccepted = "conversation_accepted"; // receiver listens

  // 🔔 Notifications
  static const newNotification = "new_notification"; // receiver listens

  // 📍 Location
  static const updateLocation = "update_location";
}
