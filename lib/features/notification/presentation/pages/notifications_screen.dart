import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recell_bazar/core/api/api_endpoints.dart';
import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/features/notification/domain/entities/notification_entity.dart';
import 'package:recell_bazar/features/notification/presentation/state/notification_state.dart';
import 'package:recell_bazar/features/notification/presentation/view_model/notification_viewmodel.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModelProvider.notifier).fetchNotifications();
    });
  }

  String _resolveMediaUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final mediaBase = ApiEndpoints.baseUrl.replaceFirst('/api', '');
    return mediaBase + (path.startsWith('/') ? path : '/$path');
  }

  String _formatCreatedAt(DateTime value) {
    final d = value.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationViewModelProvider);

    ref.listen<NotificationState>(notificationViewModelProvider, (prev, next) {
      final message = next.errorMessage;
      if (message == null || message.trim().isEmpty) return;
      if (prev?.errorMessage == message) return;
      if (next.status == NotificationStatus.unauthorized) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (notificationState.status == NotificationStatus.loading &&
                notificationState.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (notificationState.status == NotificationStatus.unauthorized) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Unauthorized',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notificationState.errorMessage ?? 'Your session has expired. Please login again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        },
                        child: const Text('Go to Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (notificationState.status == NotificationStatus.error) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(notificationState.errorMessage ?? 'Failed to load notifications'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(notificationViewModelProvider.notifier)
                            .fetchNotifications(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final notifications = notificationState.notifications;
            if (notifications.isEmpty) {
              return const Center(child: Text('No notifications'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return _NotificationTile(
                  notification: n,
                  resolveMediaUrl: _resolveMediaUrl,
                  formatCreatedAt: _formatCreatedAt,
                  onTap: () async {
                    if (!n.isRead) {
                      await ref
                          .read(notificationViewModelProvider.notifier)
                          .markAsRead(n.id);
                    }
                  },
                  onDelete: () async {
                    await ref
                        .read(notificationViewModelProvider.notifier)
                        .deleteNotification(n.id);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final String Function(String path) resolveMediaUrl;
  final String Function(DateTime value) formatCreatedAt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.resolveMediaUrl,
    required this.formatCreatedAt,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final item = notification.item;

    final photo = (item != null && item.photos.isNotEmpty)
        ? resolveMediaUrl(item.photos.first)
        : '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: unread ? const Color(0xFF0B7C7C) : Colors.transparent,
              width: unread ? 1 : 0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (photo.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photo,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 56,
                      height: 56,
                      color: Colors.grey.shade300,
                    ),
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: unread ? FontWeight.bold : FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete_outline),
                          color: Colors.red,
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (item != null)
                      Text(
                        item.phoneModel,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF0B7C7C),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (unread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0B7C7C),
                              shape: BoxShape.circle,
                            ),
                          ),
                        if (unread) const SizedBox(width: 6),
                        Text(
                          formatCreatedAt(notification.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
