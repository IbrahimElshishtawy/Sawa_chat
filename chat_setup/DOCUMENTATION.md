# Sphere: Social Media Platform - Product & Technical Documentation

## 1. Idea Description
**Sphere** is a next-generation social ecosystem that merges the visual expression of Instagram, the real-time discourse of Threads, the community structure of Facebook, and the powerful communication tools of Telegram. It is designed with a **"Private First, Expression Always"** philosophy, using a premium **Soft UI** aesthetic to provide a calm, modern, and highly functional user experience.

## 2. Competitor Analysis & Strategy
| Platform | Key Strength to Adopt | Weakness to Improve | Sphere's Approach |
| :--- | :--- | :--- | :--- |
| **Instagram** | Visual Storytelling & Reels | Algorithm fatigue, cluttered UI | Minimalist feed focused on high-quality interactions. |
| **Threads** | Text-based real-time updates | Lack of deep messaging features | Integrated "Threads-style" updates within the same ecosystem. |
| **Facebook** | Robust Groups & Communities | Dated UI, privacy concerns | Premium community management with transparent privacy controls. |
| **Telegram** | Powerful Channels & Bot API | Complex for average users | Clean, iOS-inspired UI for powerful backend features. |

## 3. Brand Identity
*   **Suggested Name:** **Sphere** (Representing your circle, your world, and a seamless environment).
*   **Alternative Names:** **Aura**, **Nexus**, **Vibe**.
*   **Visual Identity:**
    *   **Primary Color:** Deep Obsidian (#1A1A1A)
    *   **Secondary Color:** iOS Blue (#007AFF)
    *   **Design Language:** Soft UI (Neumorphism-inspired, but cleaner), 24px border radii, SF Pro Typography, transparent blurs.

## 4. User Roles & Permissions
*   **Guest:** Browse public content only.
*   **User:** Create posts, stories, reels, join groups/channels, chat.
*   **Verified User:** Higher visibility, additional professional tools.
*   **Creator:** Access to monetization tools and advanced analytics.
*   **Admin/Moderator:** Content moderation, user management, system settings.

## 5. Technical Architecture (Flutter + GetX)
### Presentation Layer
*   **GetX Controllers:** Manage state per feature (e.g., `ChatController`, `FeedController`).
*   **Modular Views:** Reusable widgets and feature-specific screens.
*   **Bindings:** Dependency injection managed by GetX for clean lifecycle management.

### Business Logic Layer
*   **Services:** Singleton-like classes for Firebase Auth, Firestore, Storage, and AI.
*   **Repositories:** Abstract data source logic from controllers.

### Data Layer
*   **Models:** Strong typing for all entities (User, Message, Post, Reel).
*   **Data Sources:** Direct interactions with Firebase SDK.

## 6. Database Design (Firestore Collections)
*   `users`: `{uid, name, role, plan, privacySettings, blockedUsers...}`
*   `posts`: `{postId, authorId, contentUrl, type: 'image'|'video', likesCount...}`
*   `chats`: `{chatId, members[], lastMessage, settings: {mute: {}, hide: {}}, isSelfChat}`
*   `messages`: `{messageId, senderId, text, mediaUrl, canEditUntil, editCount}`
*   `groups_channels`: `{id, ownerId, members[], admins[], type: 'group'|'channel'}`
*   `stories`: `{id, authorId, mediaUrl, expiresAt}`
*   `notifications`: `{id, targetUserId, type, data, isRead}`

## 7. Specialized Architectures
### AI Chatbot Module
*   **Strategy Pattern:** `AIService` (Interface) -> `OpenAIService`, `GeminiService`, `MockAIService`.
*   **Config:** Managed in `AppConfig` or a dedicated `SettingsService` for API Keys.
*   **Integration:** A dedicated Chatbot view that interacts with the `AIService` via `ChatbotController`.

### Self-Chat (Notes to Self)
*   Implemented as a standard chat where `members = [currentUserId]`.
*   Flagged as `isSelfChat: true` for specific UI treatments (e.g., "Pinned" by default, different icon).

### Real-time Communication
*   **Chat:** Firestore Snapshots for messages + Realtime Database for typing indicators/presence.
*   **Calls:** Agora RTC for low-latency Voice/Video. Signaling via Firestore `calls` collection.

## 8. Roadmap & MVP
### Phase 1: MVP (The Core)
*   Auth (Email/Google).
*   User Profile & Follow system.
*   Private Chat & Self-Chat.
*   Basic Feed (Images/Text).
*   AI Chatbot (Mock Data).

### Phase 2: Engagement
*   Stories & Reels.
*   Groups & Channels.
*   Push Notifications.
*   Search & Discover.

### Phase 3: Professional & Advanced
*   Voice/Video Calls.
*   Admin Dashboard.
*   Monetization & Plans.
*   Advanced AI Integrations.
