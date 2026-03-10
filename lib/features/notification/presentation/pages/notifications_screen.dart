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
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
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

  String _formatCreatedAt(BuildContext context, DateTime value) {
    return TimeOfDay.fromDateTime(value.toLocal()).format(context);
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
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), centerTitle: true),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notificationState.errorMessage ??
                            'Your session has expired. Please login again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
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
                      Text(
                        notificationState.errorMessage ??
                            'Failed to load notifications',
                      ),
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
  final String Function(BuildContext context, DateTime value) formatCreatedAt;
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

    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    final surface = colorScheme.surface;

    Color blend(Color foreground, Color background) {
      return Color.alphaBlend(foreground, background);
    }

    final backgroundStart = blend(
      primary.withOpacity(unread ? 0.18 : 0.12),
      surface,
    );
    final backgroundEnd = blend(
      primary.withOpacity(unread ? 0.10 : 0.06),
      surface,
    );

    final borderColor = primary.withOpacity(unread ? 0.45 : 0.18);
    final timeText = formatCreatedAt(context, notification.createdAt);
    final messageText = notification.message.trim();
    final itemText = item?.phoneModel.trim() ?? '';

    final radius = BorderRadius.circular(28);
    final shadowColor = Theme.of(context).shadowColor;

    final baseDescriptionStyle = TextStyle(
      fontSize: 14,
      color: colorScheme.onSurface.withOpacity(0.78),
    );
    final accentDescriptionStyle = baseDescriptionStyle.copyWith(
      color: primary,
      fontWeight: FontWeight.w600,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: unread ? 1.2 : 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [backgroundStart, backgroundEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 52,
                        height: 52,
                        child: photo.isNotEmpty
                            ? Image.network(
                                photo,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _NotificationAvatarFallback(
                                      backgroundColor: blend(
                                        primary.withOpacity(0.10),
                                        surface,
                                      ),
                                      iconColor: primary,
                                    ),
                              )
                            : _NotificationAvatarFallback(
                                backgroundColor: blend(
                                  primary.withOpacity(0.10),
                                  surface,
                                ),
                                iconColor: primary,
                              ),
                      ),
                    ),
                    if (unread)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: surface, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: unread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                fontSize: 16,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              tooltip: 'More',
                              onSelected: (value) {
                                if (value == 'delete') {
                                  onDelete();
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          color: colorScheme.error,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ];
                              },
                              icon: Icon(
                                Icons.more_vert_rounded,
                                size: 20,
                                color: colorScheme.onSurface.withOpacity(0.55),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          text: messageText.isNotEmpty
                              ? messageText
                              : (itemText.isNotEmpty ? itemText : ''),
                          style: baseDescriptionStyle,
                          children: [
                            if (messageText.isNotEmpty && itemText.isNotEmpty)
                              TextSpan(
                                text: ' • ',
                                style: baseDescriptionStyle,
                              ),
                            if (messageText.isNotEmpty && itemText.isNotEmpty)
                              TextSpan(
                                text: itemText,
                                style: accentDescriptionStyle,
                              ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          timeText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface.withOpacity(0.60),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationAvatarFallback extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const _NotificationAvatarFallback({
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.notifications_rounded,
          color: iconColor.withOpacity(0.9),
          size: 26,
        ),
      ),
    );
  }
}
