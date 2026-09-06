class SocketEvents {
  // 💬 Chat
  static const sendMessage = "send_message";
  static const receiveMessage = "receive_message";

  // ❤️ Conversation / Match
  static const sendConversationRequest =
      "send_conversation_request"; // emit + response
  static const newConversationRequest =
      "new_conversation_request"; // receiver listens

  // Wave List
  static const getConversationRequests =
      "get_conversation_requests"; // receiver emits
  static const conversationRequests =
      "conversation_requests"; // receiver listens
  static const acceptConversationRequest =
      "accept_conversation_request"; // receiver listens
  static const rejectConversationRequest =
      "reject_conversation_request"; // receiver listens
  static const conversationAccepted =
      "conversation_accepted"; // receiver listens
  static const conversationRejected =
      "conversation_rejected"; // receiver listens

  static const chatList = "chat_list"; // receiver listens
  static const getChatList = "get_chat_list"; // receiver emits

  static const getMessages = "get_messages"; // receiver emits
  static const messages = "messages"; // receiver listens
  static const newMessage = "new_message"; // receiver listens

  // 🔔 Notifications
  static const newNotification = "new_notification"; // receiver listens

  static const joinConversation = "join_conversation";
  static const leaveConversation = "leave_conversation";
}
