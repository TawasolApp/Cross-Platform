# 📌 Feed Module - README

## 1️⃣ Description of Implemented Features

The **Feed module** handles all core social post interactions in the app. It provides functionality for:

- 📝 **Post creation** (with optional media and visibility settings)
- ✏️ **Edit and delete posts**
- 💬 **Commenting on posts**
- ❤️ **React to posts** with reactions (Like, Celebrate, Love, Insightful, Funny, Support)
- 💾 **Save or unsave posts** to a private list
- 👀 **Fetch global posts** and **user-specific posts**
- 📥 **Fetch, edit, and delete comments**

---

## 2️⃣ Folder & File Structure Overview

```
lib/
└── features/
    └── feed/
        ├── data/
        │   ├── models/        → DTOs for Post and Comment
        │   └── data_sources/  → Data source interfaces and implementations
        ├── domain/
        │   ├── entities/      → Business models: PostEntity, CommentEntity
        │   ├── usecases/      → Business logic as individual use case classes
        │   └── repositories/  → FeedRepository interface
        ├── presentation/
        │   ├── provider/      → `FeedProvider` for state management
        │   └── widgets/       → UI components (PostCard, ReactionBar, CommentItem, etc.)
        └── test/
            ├── providers/     → Unit tests for FeedProvider
            └── mocks/         → Mock implementations for all use cases
```

---

## 3️⃣ Description of Key Files & Their Roles

### ✅ `feed_provider.dart`
Handles all state logic related to the feed: fetching posts, creating posts, saving/unsaving, reacting, commenting, and editing/deleting.

### ✅ `post_entity.dart`
Defines the core data structure of a post shown in the feed.

### ✅ `comment_entity.dart`
Defines the structure for a comment.

### ✅ `post_model.dart` / `comment_model.dart`
Data Transfer Objects that convert between app entities and backend responses.

### ✅ `usecases/`
Each file contains one business use case, such as:
- `create_post_usecase.dart`
- `edit_post_usecase.dart`
- `save_post_usecase.dart`
- `comment_post_usecase.dart`
...and more.

### ✅ `feed_create_provider_test.dart`
Contains full unit test coverage for `FeedProvider`.

---

## 4️⃣ Assumptions About User Experience

- ✅ **Email verification is required** before a user can create a post
- ✅ **All feed features require authentication**
- ✅ **Only one reaction per post is allowed per user**
- ✅ **Post visibility options** are enforced via the UI and backend (e.g., Public, Connections)
- ✅ **Saved posts are private** and only visible to the saving user
- ❌ **Reposts and comment replies are not supported yet** — these features are not implemented