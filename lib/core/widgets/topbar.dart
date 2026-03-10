import 'package:flutter/material.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

class Topbar extends StatelessWidget {
  final ValueChanged<String>? onSearch;
  final VoidCallback? onNotificationsTap;
  final bool showUnreadDot;

  const Topbar({
    super.key,
    this.onSearch,
    this.onNotificationsTap,
    this.showUnreadDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searchHintLabel = l10n?.searchHint ?? 'Search';
    final notificationsLabel = l10n?.notifications ?? 'Notifications';
    return  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: TextField(
                      onChanged: onSearch,
                      decoration: InputDecoration(
                        hintText: searchHintLabel,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // SizedBox(width: 8),
                  // Icon(Icons.tune, color: Color(0xFF0B7C7C), size: 30),
                  SizedBox(width: 12),
                  IconButton(
                    onPressed: onNotificationsTap,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Color(0xFF0B7C7C),
                          size: 30,
                        ),
                        if (showUnreadDot)
                          Positioned(
                            right: -1,
                            top: -1,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    tooltip: notificationsLabel,
                  ),
                ],
              ),
            );
  }
}
