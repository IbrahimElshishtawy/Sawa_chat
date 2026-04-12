# Production-Ready Chat & Community Platform Blueprint

## 1) Final Recommended System Architecture

### 1.1 High-Level Architecture (Startup-to-Scale)

**Client tier**
- Flutter mobile app (iOS/Android), built with GetX + Clean Architecture.
- REST for CRUD/data sync; Socket.IO for realtime events.
- WebRTC media plane for calls.

**Edge/API tier**
- API Gateway / Ingress (Nginx, Cloud Load Balancer, API gateway rules).
- NestJS backend (modular monolith initially, extractable into services later).
- Socket.IO Gateway(s) with Redis adapter for horizontal scaling.

**Data tier**
- PostgreSQL (primary relational source of truth).
- Redis (cache, pub/sub, rate-limit buckets, session nonce, presence state).
- Object storage (S3/GCS/MinIO) for chat media/files/voice notes.

**Messaging/async tier**
- Queue/Broker (BullMQ on Redis initially; Kafka/NATS later if needed).
- Async workers for push notifications, moderation scans, thumbnail generation.

**Observability tier**
- OpenTelemetry traces.
- Prometheus + Grafana metrics dashboards.
- Centralized logs (Loki/ELK).
- Error tracking (Sentry).

### 1.2 Why NestJS over Express.js

**Decision: NestJS**

**Why**
- Opinionated module system enforces scalable boundaries (controllers/services/providers).
- Built-in DI, guards, interceptors, pipes, and validation integration reduce ad-hoc patterns.
- First-class WebSocket gateway support and testing utilities.
- Easier onboarding for larger teams vs unconstrained Express style.

**Tradeoffs**
- Slightly steeper learning curve than bare Express.
- More framework conventions; less freedom.

**Production note**
- For this scope (chat + communities + calls + moderation), strong conventions reduce architecture drift and improve long-term maintainability.

### 1.3 Architecture Style

- **Hexagonal/Clean modular backend** inside NestJS modules.
- **Feature-first + clean architecture** in Flutter.
- **Modular monolith first** with bounded contexts:
  - Identity & Access
  - Social Graph / Profiles
  - Messaging & Communities
  - Calls & Realtime
  - Moderation & Trust
  - Discovery/Search
- Later extraction into microservices (if needed) with minimal refactor because boundaries already exist.

---

## 2) Backend Architecture Design

### 2.1 Backend Layers

```text
src/
  modules/
    <feature>/
      controllers/
      services/
      repositories/
      entities/
      dto/
      mappers/
      policies/
      sockets/ (if realtime in feature)
  common/
    guards/
    interceptors/
    filters/
    decorators/
    pipes/
    middleware/
    constants/
    exceptions/
    utils/
  infra/
    database/
    redis/
    storage/
    queue/
    telemetry/
    logger/
  config/
  main.ts
```

### 2.2 Core Modules and Responsibilities

1. **auth**
   - login/register, OTP verify, token issuing/rotation/revocation.
2. **users**
   - user account lifecycle, block/unblock, device binding.
3. **profiles**
   - bio, avatar, notes/status, privacy settings.
4. **chats**
   - 1:1 and group chat containers + membership.
5. **messages**
   - send/edit/delete/reply/forward, receipts.
6. **groups**
   - group chat rules, admin/mod controls.
7. **communities**
   - community creation, membership, role assignment.
8. **rooms**
   - channels/rooms in communities.
9. **topics**
   - thread/topic hierarchy in rooms.
10. **calls**
    - call sessions, call links, participant states.
11. **notifications**
    - in-app + push queueing and preference checks.
12. **media**
    - upload signatures, metadata persistence, scan status.
13. **search**
    - users, communities, rooms, topics, message indexing endpoints.
14. **moderation**
    - actions: warn, mute, ban, remove content.
15. **reports**
    - abuse reports, triage workflow.
16. **admin**
    - dashboard stats, abuse heatmaps, role grants.
17. **settings**
    - account/app notification/privacy settings.

### 2.3 Example Module Skeleton (NestJS)

```ts
// src/modules/messages/messages.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([MessageEntity, AttachmentEntity])],
  controllers: [MessagesController],
  providers: [MessagesService, MessagesRepository, MessagePolicy],
  exports: [MessagesService],
})
export class MessagesModule {}
```

```ts
// src/modules/messages/controllers/messages.controller.ts
@Controller('v1/chats/:chatId/messages')
@UseGuards(JwtAuthGuard)
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  async send(
    @Param('chatId', ParseUUIDPipe) chatId: string,
    @Body() dto: SendMessageDto,
    @CurrentUser() user: AuthUser,
  ) {
    return this.messagesService.sendMessage(chatId, user.userId, dto);
  }
}
```

---

## 3) Backend Folder Structure (Professional)

```text
backend/
  src/
    main.ts
    app.module.ts
    config/
      app.config.ts
      auth.config.ts
      db.config.ts
      redis.config.ts
      storage.config.ts
      validation.schema.ts
    common/
      constants/
      decorators/
      dto/
      exceptions/
      filters/
        global-exception.filter.ts
      guards/
        jwt-auth.guard.ts
        roles.guard.ts
      interceptors/
        logging.interceptor.ts
        response.interceptor.ts
      middleware/
        request-id.middleware.ts
      pipes/
        zod-validation.pipe.ts
      utils/
    infra/
      database/
        migrations/
        seeds/
        typeorm.config.ts
      redis/
        redis.module.ts
      logger/
        pino.logger.ts
      queue/
        queue.module.ts
      storage/
        s3-storage.service.ts
      telemetry/
        otel.ts
    modules/
      auth/
      users/
      profiles/
      chats/
      messages/
      groups/
      communities/
      rooms/
      topics/
      calls/
      notifications/
      media/
      search/
      moderation/
      reports/
      admin/
      settings/
    sockets/
      gateway.module.ts
      events.constants.ts
  test/
    unit/
    integration/
    e2e/
  docs/
    openapi.yaml
  Dockerfile
  docker-compose.yml
  .env.example
  package.json
```

**Best practices**
- Keep DTOs separate from entities.
- No controller business logic.
- Repository returns domain-ready data, service applies policies.
- Enforce transaction boundaries in service layer.

---

## 4) Database Schema (PostgreSQL)

> Use UUID primary keys, `created_at`, `updated_at`, soft-delete where needed.

### 4.1 users
- `id UUID PK`
- `email CITEXT UNIQUE NULL`
- `phone VARCHAR(20) UNIQUE NULL`
- `password_hash TEXT NULL`
- `is_email_verified BOOLEAN DEFAULT false`
- `is_phone_verified BOOLEAN DEFAULT false`
- `status VARCHAR(20) CHECK (status IN ('active','suspended','deleted'))`
- `last_seen_at TIMESTAMPTZ`
- `created_at TIMESTAMPTZ`
- `updated_at TIMESTAMPTZ`

Indexes:
- unique(email), unique(phone), index(status), index(last_seen_at)

### 4.2 profiles
- `user_id UUID PK FK -> users(id)`
- `username VARCHAR(32) UNIQUE`
- `display_name VARCHAR(100)`
- `bio TEXT`
- `avatar_url TEXT`
- `note_status VARCHAR(140)`
- `is_private BOOLEAN DEFAULT false`
- `country_code CHAR(2)`

Indexes:
- unique(username), gin trigram(display_name)

### 4.3 chats
- `id UUID PK`
- `type VARCHAR(20) CHECK ('direct','group','community_room')`
- `title VARCHAR(140) NULL`
- `created_by UUID FK users(id)`
- `community_id UUID NULL FK communities(id)`
- `room_id UUID NULL FK rooms(id)`
- `last_message_id UUID NULL FK messages(id)`
- `last_message_at TIMESTAMPTZ`

Indexes: `(type, last_message_at DESC)`, `(community_id)`, `(room_id)`

### 4.4 chat_members
- `chat_id UUID FK chats(id)`
- `user_id UUID FK users(id)`
- `role VARCHAR(20) CHECK ('member','admin','owner','moderator')`
- `joined_at TIMESTAMPTZ`
- `left_at TIMESTAMPTZ NULL`
- `mute_until TIMESTAMPTZ NULL`
- `last_read_message_id UUID NULL`

PK: `(chat_id, user_id)`
Index: `(user_id, joined_at DESC)`

### 4.5 messages
- `id UUID PK`
- `chat_id UUID FK chats(id)`
- `sender_id UUID FK users(id)`
- `content TEXT`
- `message_type VARCHAR(20) CHECK ('text','image','video','file','voice','system','call_event')`
- `reply_to_message_id UUID NULL FK messages(id)`
- `is_edited BOOLEAN DEFAULT false`
- `edited_at TIMESTAMPTZ NULL`
- `deleted_at TIMESTAMPTZ NULL`
- `client_message_id VARCHAR(64)` (idempotency)
- `created_at TIMESTAMPTZ`

Indexes:
- `(chat_id, created_at DESC)`
- unique `(chat_id, sender_id, client_message_id)`

### 4.6 attachments
- `id UUID PK`
- `message_id UUID FK messages(id)`
- `storage_key TEXT`
- `url TEXT`
- `mime_type VARCHAR(80)`
- `size_bytes BIGINT`
- `duration_ms INT NULL`
- `width INT NULL`
- `height INT NULL`
- `checksum_sha256 VARCHAR(64)`
- `scan_status VARCHAR(20) CHECK ('pending','safe','blocked')`

Indexes: `(message_id)`, `(scan_status)`

### 4.7 communities
- `id UUID PK`
- `slug VARCHAR(60) UNIQUE`
- `name VARCHAR(120)`
- `description TEXT`
- `avatar_url TEXT`
- `banner_url TEXT`
- `visibility VARCHAR(20) CHECK ('public','private')`
- `join_policy VARCHAR(20) CHECK ('open','request','invite_only')`
- `created_by UUID FK users(id)`

Indexes: unique(slug), gin trigram(name)

### 4.8 community_members
- `community_id UUID FK communities(id)`
- `user_id UUID FK users(id)`
- `role VARCHAR(20) CHECK ('member','moderator','admin','owner')`
- `status VARCHAR(20) CHECK ('active','pending','banned')`
- `joined_at TIMESTAMPTZ`

PK: `(community_id, user_id)`
Index: `(user_id, status)`

### 4.9 rooms
- `id UUID PK`
- `community_id UUID FK communities(id)`
- `name VARCHAR(100)`
- `description TEXT`
- `type VARCHAR(20) CHECK ('chat','announcement','voice')`
- `created_by UUID FK users(id)`
- `is_archived BOOLEAN DEFAULT false`

Indexes: `(community_id, is_archived)`

### 4.10 topics
- `id UUID PK`
- `room_id UUID FK rooms(id)`
- `title VARCHAR(160)`
- `created_by UUID FK users(id)`
- `is_locked BOOLEAN DEFAULT false`
- `is_pinned BOOLEAN DEFAULT false`
- `last_activity_at TIMESTAMPTZ`

Indexes: `(room_id, last_activity_at DESC)`, `(room_id, is_pinned DESC)`

### 4.11 calls
- `id UUID PK`
- `chat_id UUID NULL FK chats(id)`
- `community_id UUID NULL FK communities(id)`
- `room_id UUID NULL FK rooms(id)`
- `initiator_id UUID FK users(id)`
- `call_type VARCHAR(20) CHECK ('voice','video')`
- `mode VARCHAR(20) CHECK ('p2p','group')`
- `status VARCHAR(20) CHECK ('scheduled','ringing','active','ended','missed')`
- `started_at TIMESTAMPTZ NULL`
- `ended_at TIMESTAMPTZ NULL`
- `call_link_token VARCHAR(80) UNIQUE`

Indexes: `(status)`, `(chat_id, started_at DESC)`, unique(call_link_token)

### 4.12 call_participants
- `call_id UUID FK calls(id)`
- `user_id UUID FK users(id)`
- `join_time TIMESTAMPTZ`
- `leave_time TIMESTAMPTZ NULL`
- `state VARCHAR(20) CHECK ('invited','joined','left','rejected','failed')`

PK: `(call_id, user_id)`
Index: `(user_id, join_time DESC)`

### 4.13 notifications
- `id UUID PK`
- `user_id UUID FK users(id)`
- `type VARCHAR(40)`
- `title VARCHAR(140)`
- `body TEXT`
- `payload JSONB`
- `is_read BOOLEAN DEFAULT false`
- `sent_push BOOLEAN DEFAULT false`
- `created_at TIMESTAMPTZ`

Indexes: `(user_id, is_read, created_at DESC)`

### 4.14 reports
- `id UUID PK`
- `reporter_id UUID FK users(id)`
- `target_type VARCHAR(20) CHECK ('message','user','room','community')`
- `target_id UUID`
- `reason VARCHAR(40)`
- `details TEXT`
- `status VARCHAR(20) CHECK ('open','triaged','resolved','rejected')`
- `created_at TIMESTAMPTZ`

Indexes: `(status, created_at DESC)`, `(target_type, target_id)`

### 4.15 moderation_actions
- `id UUID PK`
- `report_id UUID NULL FK reports(id)`
- `moderator_id UUID FK users(id)`
- `action_type VARCHAR(30) CHECK ('warn','mute','ban','delete_message','remove_user')`
- `target_type VARCHAR(20)`
- `target_id UUID`
- `duration_minutes INT NULL`
- `note TEXT`
- `created_at TIMESTAMPTZ`

Indexes: `(moderator_id, created_at DESC)`, `(target_type, target_id)`

### 4.16 roles_permissions
- `id UUID PK`
- `scope_type VARCHAR(20) CHECK ('global','community','room')`
- `scope_id UUID NULL`
- `role VARCHAR(20)`
- `permission VARCHAR(80)`

Unique: `(scope_type, scope_id, role, permission)`

### 4.17 devices
- `id UUID PK`
- `user_id UUID FK users(id)`
- `platform VARCHAR(20) CHECK ('ios','android','web')`
- `push_token TEXT`
- `device_name VARCHAR(120)`
- `last_active_at TIMESTAMPTZ`

Indexes: `(user_id)`, unique(push_token)

### 4.18 sessions
- `id UUID PK`
- `user_id UUID FK users(id)`
- `ip_address INET`
- `user_agent TEXT`
- `created_at TIMESTAMPTZ`
- `expires_at TIMESTAMPTZ`
- `revoked_at TIMESTAMPTZ NULL`

Indexes: `(user_id, expires_at DESC)`

### 4.19 refresh_tokens
- `id UUID PK`
- `session_id UUID FK sessions(id)`
- `token_hash VARCHAR(128)`
- `issued_at TIMESTAMPTZ`
- `expires_at TIMESTAMPTZ`
- `revoked_at TIMESTAMPTZ NULL`
- `replaced_by_token_id UUID NULL FK refresh_tokens(id)`

Indexes: unique(token_hash), `(session_id, expires_at DESC)`

---

## 5) Authentication & Security Architecture

### 5.1 Auth Flow
- Email/password OR phone/OTP login.
- On successful auth:
  - issue short-lived access token (15 min).
  - issue rotating refresh token (7–30 days) tied to session + device.
- Refresh endpoint rotates token and invalidates previous hash.
- Logout revokes current refresh token; global logout revokes all user sessions.

### 5.2 Security Controls
- Argon2id password hashing.
- OTP rate limits by IP + phone/email + device fingerprint.
- JWT signed with asymmetric keys (RS256).
- Redis-backed token denylist for immediate revocation on sensitive events.
- Helmet, CORS strict origin allowlist, HPP protection.
- DTO validation (class-validator / Zod), transform + whitelist.
- RBAC + context-based ABAC checks (community scope permission).
- Audit logs for auth, moderation, role changes, data export.
- Abuse prevention: spam throttling, repeated message similarity checks, upload scanning.

### 5.3 Sample Guard + Role Decorator

```ts
export const Roles = (...roles: string[]) => SetMetadata('roles', roles);

@Injectable()
export class RolesGuard implements CanActivate {
  canActivate(ctx: ExecutionContext): boolean {
    const required = this.reflector.get<string[]>('roles', ctx.getHandler()) || [];
    const user = ctx.switchToHttp().getRequest().user;
    return required.length === 0 || required.some(r => user.roles?.includes(r));
  }
}
```

---

## 6) Realtime Design (Socket.IO)

### 6.1 Namespaces/Rooms
- `/chat`: chat messaging events.
- `/presence`: online/offline, typing.
- `/call`: signaling + call control.
- `/notify`: realtime in-app notification stream.

### 6.2 Socket Event Design

**Client -> Server**
- `chat:join {chatId}`
- `chat:leave {chatId}`
- `message:send {chatId, clientMessageId, content, attachments}`
- `message:typing {chatId, isTyping}`
- `message:read {chatId, messageId}`
- `presence:update {status}`
- `call:initiate {scope, callType, targetIds}`
- `call:signal {callId, sdp/candidate}`
- `call:join-link {token}`

**Server -> Client**
- `message:new`
- `message:delivered`
- `message:seen`
- `typing:update`
- `presence:changed`
- `notification:new`
- `call:incoming`
- `call:participant-joined`
- `call:participant-left`
- `call:ended`

### 6.3 Realtime Reliability
- Use ack + retry for critical events (send/read).
- De-dup with `clientMessageId`.
- Redis adapter for multi-instance broadcast.
- Fallback sync API to recover missed socket events.

---

## 7) REST API Design (Representative Production Set)

> Prefix: `/api/v1`

### 7.1 Auth
- `POST /auth/register`
- `POST /auth/login`
- `POST /auth/otp/request`
- `POST /auth/otp/verify`
- `POST /auth/refresh`
- `POST /auth/logout`
- `POST /auth/logout-all`

### 7.2 Users & Profiles
- `GET /users/me`
- `PATCH /users/me`
- `GET /profiles/:username`
- `PATCH /profiles/me`
- `POST /users/:id/block`
- `DELETE /users/:id/block`

### 7.3 Chats & Messages
- `POST /chats/direct`
- `POST /chats/group`
- `GET /chats`
- `GET /chats/:chatId`
- `POST /chats/:chatId/members`
- `DELETE /chats/:chatId/members/:userId`
- `GET /chats/:chatId/messages`
- `POST /chats/:chatId/messages`
- `PATCH /messages/:messageId`
- `DELETE /messages/:messageId`
- `POST /messages/:messageId/reactions`

### 7.4 Communities, Rooms, Topics
- `POST /communities`
- `GET /communities/:slug`
- `POST /communities/:id/join`
- `POST /communities/:id/invite`
- `PATCH /communities/:id/members/:userId/role`
- `POST /communities/:id/rooms`
- `PATCH /rooms/:roomId`
- `POST /rooms/:roomId/topics`
- `PATCH /topics/:topicId`
- `POST /topics/:topicId/lock`

### 7.5 Calls
- `POST /calls`
- `POST /calls/:id/join`
- `POST /calls/:id/end`
- `POST /calls/:id/invite`
- `POST /calls/link`
- `GET /calls/link/:token`

### 7.6 Notifications
- `GET /notifications`
- `POST /notifications/read-all`
- `PATCH /notifications/:id/read`
- `GET /notifications/unread-count`
- `PATCH /settings/notifications`

### 7.7 Moderation & Reports
- `POST /reports`
- `GET /moderation/reports`
- `POST /moderation/actions`
- `POST /moderation/mute`
- `POST /moderation/ban`

### 7.8 Search & Discover
- `GET /search?q=`
- `GET /discover/communities`
- `GET /discover/topics/trending`
- `GET /discover/people/suggested`

### 7.9 Endpoint Contract Template (Example)

**POST `/api/v1/chats/:chatId/messages`**
- Auth: required
- Body:
```json
{
  "clientMessageId": "uuid-or-ulid",
  "content": "Hello",
  "type": "text",
  "replyToMessageId": null,
  "attachments": []
}
```
- Success 201:
```json
{
  "id": "uuid",
  "chatId": "uuid",
  "senderId": "uuid",
  "content": "Hello",
  "createdAt": "2026-04-12T00:00:00Z"
}
```
- Errors: 400 validation, 403 no permission, 404 chat not found, 409 duplicate `clientMessageId`.

---

## 8) File Uploads & Media Strategy

### 8.1 Storage
- Direct-to-object-storage with presigned URLs for large files.
- Metadata stored in `attachments` table.
- Private bucket + short-lived signed download URLs.

### 8.2 Security
- MIME whitelist + magic-number validation.
- Virus scan pipeline (e.g., ClamAV worker).
- EXIF stripping for privacy.
- Size limits:
  - image <= 15 MB
  - video <= 150 MB
  - file <= 100 MB
  - voice <= 25 MB

### 8.3 Naming
- `tenant/userId/yyyy/mm/dd/<ulid>_<sanitized-filename>`
- Never trust original path; sanitize names.

---

## 9) Notifications

### 9.1 Types
- message received
- mention/reply
- community invite
- moderation action
- call incoming/missed

### 9.2 Delivery Rules
- In-app realtime always when connected.
- Push when:
  - app backgrounded and preference enabled.
  - not muted conversation.

### 9.3 Unread Counts
- conversation unread counter cache in Redis + durable per-user reads in PostgreSQL.
- periodic reconciliation job.

---

## 10) Logging, Monitoring, Health

### 10.1 Logging
- Pino JSON logs with correlation/request ID.
- Structured fields: `userId`, `module`, `latencyMs`, `errorCode`.

### 10.2 Tracing & Metrics
- OpenTelemetry traces across API, DB, Redis, queue.
- Prometheus metrics:
  - request latency p50/p95/p99
  - websocket active connections
  - message throughput
  - failed push count

### 10.3 Health
- `/health/live`, `/health/ready`
- readiness checks DB/Redis/Queue/Storage.

---

## 11) Testing Strategy

### 11.1 Backend
- Unit tests: services, policy guards, utility mappers.
- Integration tests: repository + DB (test containers).
- E2E tests: auth, messaging, community moderation critical flows.

### 11.2 Flutter
- Unit: controllers/use-cases.
- Widget tests: core reusable widgets + screen states.
- Integration tests: login -> chat send -> receive flow.

---

## 12) Deployment & DevOps

### 12.1 Docker
- Multi-stage builds.
- Separate images: `api`, `worker`, `scheduler`.

### 12.2 Environments
- `.env.example` + secret manager (AWS Secrets Manager/GCP Secret Manager).
- Envs: `dev`, `staging`, `prod` with isolated DB/Redis/buckets.

### 12.3 CI/CD
- PR pipeline: lint + tests + security scan + build.
- Main branch: deploy to staging automatically.
- Manual approval gate to prod.
- Zero-downtime migrations (expand-and-contract strategy).

---

## 13) Flutter + GetX Architecture

### 13.1 Layered Feature-First Structure

```text
flutter_app/
  lib/
    core/
      config/
      constants/
      errors/
      network/
      realtime/
      storage/
      theme/
      widgets/
    routes/
      app_pages.dart
      app_routes.dart
      route_middleware.dart
    features/
      auth/
        data/
        domain/
        presentation/
      chats/
      communities/
      calls/
      discover/
      profile/
      settings/
      notifications/
      moderation/
    app_binding.dart
    main.dart
```

### 13.2 GetX Usage Rules
- `GetxController`: feature state + lifecycle.
- `Obx`: reactive UI for `Rx` variables and stream-like updates.
- `GetBuilder`: coarse updates for performance-critical static-ish sections.
- `Bindings`: dependency graph per route/feature.
- Use `fenix` selectively for heavy controllers.
- Dispose socket/listeners in `onClose` to prevent leaks.

### 13.3 Feature Template (Example: Chats)

```text
features/chats/
  data/
    datasources/chats_remote_data_source.dart
    models/chat_model.dart
    repositories/chats_repository_impl.dart
  domain/
    entities/chat.dart
    repositories/chats_repository.dart
    usecases/get_chats_usecase.dart
  presentation/
    bindings/chats_binding.dart
    controllers/chats_controller.dart
    pages/chats_page.dart
    widgets/chat_tile.dart
```

```dart
class ChatsController extends GetxController {
  final GetChatsUseCase _getChats;
  ChatsController(this._getChats);

  final chats = <Chat>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  Future<void> fetchChats() async {
    isLoading.value = true;
    final result = await _getChats();
    result.fold(
      (l) => error.value = l.message,
      (r) => chats.assignAll(r),
    );
    isLoading.value = false;
  }
}
```

### 13.4 Routing
- Centralized route names in `app_routes.dart`.
- `GetPage` with `binding` + optional middleware.
- Protected routes middleware checks auth + profile completion.

### 13.5 Networking
- Dio client with interceptors:
  - auth header injector
  - refresh token interceptor with request replay queue
  - standardized error mapper

### 13.6 Local Storage
- `flutter_secure_storage` for tokens.
- `Hive/Isar` for cached chats and settings.
- Versioned cache schema migrations.

### 13.7 Realtime in Flutter
- Socket service singleton in `core/realtime/socket_service.dart`.
- Auto reconnect with exponential backoff + jitter.
- Queue outbound events while offline.
- Ack-based message UI states: sending/sent/delivered/seen.

---

## 14) UI/UX Structure (Mobile)

### 14.1 Navigation
- Bottom tabs: Home, Chats, Communities, Discover, Profile.
- Global FAB context-sensitive (new chat/new topic).

### 14.2 Key Screens
- Chat list, chat detail (message composer with attachments/voice note).
- Community feed + rooms + topic list.
- Discover with trending topics + suggested communities.
- Calls tab with recent + join by link.
- Notification center with filters.

### 14.3 Reusable Widgets
- `MessageBubble`
- `ChatTile`
- `ProfileAvatar`
- `RoomCard`
- `TopicChip`
- `NotificationTile`
- `PrimaryButton`
- `EmptyStateView`
- `LoadingShimmer`
- `ErrorStateCard`
- `AttachmentPreview`

---

## 15) Business Rules (Authoritative)

### 15.1 Group/Community Creation
- Any verified user can create **group chat**.
- Community creation requires account age >= configurable threshold and no trust violations.

### 15.2 Roles
- Community roles: owner > admin > moderator > member.
- Owner transfer allowed; community must always have one owner.

### 15.3 Room/Topic Permissions
- Admin/mod can create rooms.
- Members can create topics if `community_setting.allow_member_topics = true`.
- Locked topics allow only mod/admin posts.

### 15.4 Message Edit/Delete
- Sender can edit within 15 minutes (configurable).
- Sender can delete own messages anytime (soft delete).
- Mods/admins can hard-remove violating messages with audit trail.

### 15.5 Moderation
- Report creates case in `reports`.
- Repeated violations escalate automatically: warn -> mute -> temp ban -> permanent ban.

### 15.6 Join/Leave/Invite
- Public + open: instant join.
- Public + request: request queue approval.
- Private/invite-only: valid invite token required.

### 15.7 Call Permissions
- Direct chat calls: both members.
- Group/community calls: room permissions and mute/ban restrictions apply.
- Call link can be scoped and expirable.

### 15.8 Discover/Trending
- Trending score = weighted function of recent activity, unique participants, retention, report penalty.
- Private communities never appear in discover.

---

## 16) Major User Flows (Step-by-Step)

### 16.1 Register/Login
1. User chooses email/password or phone OTP.
2. Backend validates input, anti-abuse checks.
3. Account created/verified.
4. Session + tokens issued.
5. Device registered for push.

### 16.2 Create Profile
1. Prompt username/display name/avatar.
2. Validate uniqueness for username.
3. Persist profile and privacy defaults.

### 16.3 Create Chat & Send Message
1. User opens new chat, selects target(s).
2. Backend resolves/creates direct or group chat.
3. Composer sends message with `clientMessageId`.
4. Server persists + broadcasts realtime + push fallback.
5. Receipts update delivered/seen.

### 16.4 Create Community + Room + Topic
1. Creator submits community metadata.
2. Default roles and base room generated.
3. Admin creates additional rooms.
4. User creates topic within allowed rooms.

### 16.5 Start Call / Join via Link
1. Caller starts voice/video call.
2. Call session created; invite events broadcast.
3. Participants exchange WebRTC signaling via socket.
4. Link-based join validates token and scope.
5. Call end event persists summary and notifications.

### 16.6 Report Abuse
1. User reports message/user/community.
2. Report enters triage queue.
3. Moderator reviews evidence and acts.
4. Action audit log + user notification generated.

---

## 17) Non-Functional Requirements

### 17.1 Performance
- Cursor pagination for chats/messages.
- Redis cache for hot reads (profiles, community metadata).
- DB query optimization + connection pooling.

### 17.2 Scalability
- Stateless API instances.
- Socket scale with Redis adapter.
- Async workers for heavy tasks.

### 17.3 Security
- Defense in depth: authn, authz, validation, scanning, auditing.

### 17.4 Reliability
- Idempotency keys for message send.
- Retries + dead-letter queue for async jobs.
- Backup + PITR for PostgreSQL.

### 17.5 Maintainability
- Strict linting + architecture tests.
- Domain-driven module boundaries.
- API versioning strategy.

### 17.6 Observability
- End-to-end tracing and SLO dashboards.

### 17.7 Extensibility
- Plugin-friendly moderation policies.
- Feature flags for staged rollouts.

---

## 18) Recommended Packages / Libraries

### Backend (NestJS)
- `@nestjs/*`, `class-validator`, `class-transformer`
- `typeorm` or `prisma` (choose one team-wide)
- `ioredis`, `bullmq`
- `socket.io`, `@nestjs/websockets`
- `argon2`, `jsonwebtoken`
- `helmet`, `cors`, `rate-limiter-flexible`
- `pino`, `nestjs-pino`
- `@opentelemetry/api`
- `swagger` via `@nestjs/swagger`

### Flutter
- `get`, `dio`, `freezed`, `json_serializable`
- `flutter_secure_storage`
- `hive` or `isar`
- `socket_io_client`
- `flutter_webrtc`
- `firebase_messaging` (or OneSignal)
- `cached_network_image`
- `intl`

---

## 19) Coding Conventions

- Naming: `snake_case` files, `PascalCase` classes, `camelCase` fields/methods.
- No business logic in controller/widget.
- Explicit DTOs and mappers.
- Each PR must include tests for changed logic.
- Use feature flags for risky releases.
- Enforce commit hooks (lint + format + unit tests).

---

## 20) Phased Implementation Roadmap

### Phase 1: Foundation (3–5 weeks)
- Auth, users/profiles, direct chats, basic messaging, media upload, basic notifications.

### Phase 2: Community Core (4–6 weeks)
- Communities, rooms, topics, group moderation, discover basics.

### Phase 3: Realtime Maturity (3–4 weeks)
- Advanced socket reliability, typing/presence, read receipts, push preferences.

### Phase 4: Calls (4–6 weeks)
- Voice/video/group calls, call links, QoS telemetry.

### Phase 5: Trust & Growth (4–6 weeks)
- Reports, moderation dashboard, trending algorithm, admin analytics.

### Phase 6: Hardening (ongoing)
- Performance tuning, chaos testing, security pentest, cost optimization.

---

## 21) Production Notes Checklist

- [ ] Threat model completed.
- [ ] Data retention and privacy compliance policy defined.
- [ ] Incident response runbooks documented.
- [ ] Backup restore drills tested.
- [ ] SLO/SLI and alert thresholds configured.
- [ ] Blue/green or canary deployment enabled.
- [ ] Load test baseline recorded.

