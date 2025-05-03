# 📬 Messaging Module - TawasolApp

This module implements real-time messaging and direct communication in the TawasolApp.

---

## 📁 Folder Structure
```
messaging/
│
├── data/
│   ├── data_sources/
│   │   ├── conversation_remote_data_source.dart
│   │   └── mock_conversation_remote_data_source.dart
│   ├── models/
│   │   ├── conversation_model.dart
│   │   ├── message_model.dart
│   │   └── user_preview_model.dart
│   └── repository/
│       └── conversation_repository.dart
│
├── domain/
│   ├── entities/
│   │   ├── conversation_entity.dart
│   │   ├── message_entity.dart
│   │   └── user_preview_entity.dart
│   ├── repository/
│   │   └── repository_impl.dart
│   └── usecases/
│       ├── get_chat_use_case.dart
│       └── get_conversations_usecase.dart
│
├── presentation/
│   ├── pages/
│   │   ├── chat_page.dart
│   │   └── conversation_list_page.dart
│   ├── provider/
│   │   ├── chat_provider.dart
│   │   └── conversation_list_provider.dart
│   └── widgets/
│       ├── chat_input_bar.dart
│       ├── conversation_tile.dart
│       └── message_tile.dart
│
└── .gitkeep
```

---

## 🧠 File Overview

### Data Layer
- `conversation_remote_data_source.dart`: Interface for fetching conversations/messages remotely.
- `mock_conversation_remote_data_source.dart`: Provides mock data for offline development and testing.
- `conversation_model.dart`, `message_model.dart`, `user_preview_model.dart`: DTOs for converting between JSON and domain entities.
- `conversation_repository.dart`: Concrete implementation of the repository using data sources.

### Domain Layer
- `conversation_entity.dart`, `message_entity.dart`, `user_preview_entity.dart`: Pure data classes representing the business logic structure.
- `repository_impl.dart`: Defines abstract methods required for messaging operations.
- `get_conversations_usecase.dart`, `get_chat_use_case.dart`: Use cases implementing business logic.

### Presentation Layer
- `chat_page.dart`, `conversation_list_page.dart`: UI screens for conversations and individual chat.
- `chat_provider.dart`, `conversation_list_provider.dart`: State management using Provider.
- `chat_input_bar.dart`, `conversation_tile.dart`, `message_tile.dart`: UI components for user interaction and display.

---


## ✅ Implemented Features and Code Flow

| Task   | Feature Description | Implementation Details |
|--------|----------------------|--------------------------|
| Task 1 | Messaging Page Layout | `conversation_list_page.dart` shows a list of user conversations using `ConversationTile`. Tapping a tile navigates to `ChatPage`, where messages are displayed using `MessageTile`. Layout uses `ListView`, `AppBar`, and custom UI widgets. |
| Task 2 | Sending and Receiving of Messages | Handled in `chat_input_bar.dart` (UI) and `chat_provider.dart` (logic). Messages are added to the local state and shown in real-time. Receiving is simulated via `mock_conversation_remote_data_source.dart`. |
| Task 3 | Conversation History Retrieval | When entering a chat, `chat_provider.dart` calls `get_chat_use_case.dart` to retrieve full message history via `ConversationRepository`. Mock data is loaded using `mock_conversation_remote_data_source.dart`. |
| Task 4 | Unseen Message Count | Each conversation has an `unseenCount` property in `conversation_model.dart`. This is shown as a badge in `conversation_tile.dart`. When a chat is opened, the count is reset via `chat_provider`. |
| Task 5 | Read Receipts & Typing Indicators | Placeholder support exists for message `isRead` status and simulated `isTyping` flag in the mock source. These are displayed with UI hints in `message_tile.dart` or `chat_input_bar.dart`. |
| Task 6 | Mark Conversation as Read/Unread | Toggling read/unread status is handled in `conversation_list_provider.dart`, modifying the `unseenCount` and updating the tile. In full version, it will call an API to update state on backend. |
| Task 7 | Block Users from Messaging | Simulated logic in `mock_conversation_remote_data_source.dart`. A `blocked` flag can prevent sending messages, and the UI shows a restriction note via `chat_provider.dart`. |


| Task   | Description                                      |
|--------|--------------------------------------------------|
| Task 1 | Messaging page layout                            |
| Task 2 | Sending and receiving of text and media messages |
| Task 3 | Conversation history retrieval                   |
| Task 4 | Unseen message count functionality               |
| Task 5 | Read receipts and typing indicators              |
| Task 6 | Mark conversation as read/unread                 |
| Task 7 | Block users from messaging                       |

---

## 👨‍💻 Assigned Developer

**Module 5: Messaging & Direct Communication**  
Assigned to: Omar Kaddah

---

## 📌 Notes

- Follows **Clean Architecture**: separates business logic, data access, and UI.
- **Mock data** supports full feature testing without backend setup.
- Easily extendable for WebSocket integration, message encryption, or file attachments.
