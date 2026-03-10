import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/sensors/fingerprint_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recell_bazar/app/app.dart';

import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/auth/presentation/widgets/profile_header.dart';
import 'package:recell_bazar/features/auth/presentation/widgets/stats_card.dart';
import 'package:recell_bazar/features/notification/presentation/pages/notifications_screen.dart';
import 'package:recell_bazar/app/theme/theme_mode_controller.dart';
import 'package:recell_bazar/l10n/app_localizations.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  final _secureStorage = const FlutterSecureStorage();
  bool _fingerprintEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadFingerprintState();
  }

  Future<void> _loadFingerprintState() async {
    final auth = ref.read(authViewModelProvider);
    final userId = auth.user?.authId;
    if (userId == null) {
      setState(() => _fingerprintEnabled = false);
      return;
    }
    final savedEmail = await _secureStorage.read(key: 'fingerprint_email_$userId');
    setState(() => _fingerprintEnabled = savedEmail != null);
  }

  Future<void> _toggleFingerprint(bool value) async {
    final auth = ref.read(authViewModelProvider);
    final userId = auth.user?.authId;
    if (userId == null) {
      setState(() => _fingerprintEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No logged in user')));
      return;
    }
    if (!value) {
      // turning off: remove stored credentials
      await _secureStorage.delete(key: 'fingerprint_email_$userId');
      await _secureStorage.delete(key: 'fingerprint_password_$userId');
      setState(() => _fingerprintEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint login disabled')));
      return;
    }

    // enabling requires saved credentials (user must opt-in from login screen)
    final savedEmail = await _secureStorage.read(key: 'fingerprint_email_$userId');
    final savedPassword = await _secureStorage.read(key: 'fingerprint_password_$userId');
    if (savedEmail == null || savedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No saved credentials. Go to Login and enable fingerprint there.')));
      return;
    }

    // Optionally verify biometrics now
    final ok = await fingerprintAuth.canAuthenticate();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometrics not available on this device')));
      return;
    }

    final did = await fingerprintAuth.authenticate(reason: 'Enable fingerprint login');
    if (did) {
      setState(() => _fingerprintEnabled = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint login enabled')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final l10n = AppLocalizations.of(context);
    final profileLabel = l10n?.profile ?? 'Profile';
    final languageLabel = l10n?.language ?? 'Language';
    final notificationsLabel = l10n?.notifications ?? 'Notifications';
    final logoutLabel = l10n?.logout ?? 'Logout';
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<AuthState>(authViewModelProvider, (prev, next) {
      if (next.status == AuthStatus.unauthenticated) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(profileLabel),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileHeader(),
            const SizedBox(height: 24),
            const StatsCard(),
            const SizedBox(height: 24),

            // Theme
            const Text(
              'Theme',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isDark
                    ? Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.35),
                      )
                    : null,
              ),
              child: ValueListenableBuilder<AppThemePreference>(
                valueListenable: appThemeController.preference,
                builder: (context, pref, _) {
                  final autoEnabled = pref == AppThemePreference.auto;
                  final effectiveDark = Theme.of(context).brightness == Brightness.dark;
                  final manualDark = pref == AppThemePreference.dark;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SwitchListTile(
                        value: autoEnabled,
                        activeColor: colorScheme.primary,
                        title: const Text('Auto'),
                        subtitle: const Text('Automatically switches theme'),
                        onChanged: (v) {
                          if (v) {
                            appThemeController.setPreference(AppThemePreference.auto);
                            return;
                          }

                          appThemeController.setPreference(
                            effectiveDark
                                ? AppThemePreference.dark
                                : AppThemePreference.light,
                          );
                        },
                      ),
                      Divider(height: 1, color: Theme.of(context).dividerColor),
                      SwitchListTile(
                        value: autoEnabled ? effectiveDark : manualDark,
                        activeColor: colorScheme.primary,
                        title: const Text('Dark mode'),
                        subtitle: autoEnabled
                            ? const Text('Turn off Auto to change')
                            : const Text('Toggle between Dark and Light'),
                        onChanged: autoEnabled
                            ? null
                            : (v) {
                                appThemeController.setPreference(
                                  v
                                      ? AppThemePreference.dark
                                      : AppThemePreference.light,
                                );
                              },
                      ),
                    ],
                  );
                },
              ),
            ),

            // Account
            const Text(
              "Account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isDark
                    ? Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.35),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language, color: Color(0xFF0B7C7C)),
                    title: Text(languageLabel),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("EN", style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: Localizations.localeOf(context).languageCode == 'ne',
                          onChanged: (isNepali) {
                            final newLocale = isNepali ? const Locale('ne') : const Locale('en');
                            App.setLocale(context, newLocale);
                          },
                        ),
                        Text("ने", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications, color: Color(0xFF0B7C7C)),
                    title: Text(notificationsLabel),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  const ListTile(
                    leading: Icon(Icons.lock, color: Color(0xFF0B7C7C)),
                    title: Text("Privacy"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  // Fingerprint registration
                  if (!_fingerprintEnabled)
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: Color(0xFF0B7C7C)),
                      title: const Text('Register fingerprint'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          // ask for password to verify and save
                          final auth = ref.read(authViewModelProvider);
                          final email = auth.user?.email;
                          if (email == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No logged in user')));
                            return;
                          }

                          final pw = await showDialog<String?>(
                            context: context,
                            builder: (ctx) {
                              final pwCtl = TextEditingController();
                              return AlertDialog(
                                title: const Text('Confirm password'),
                                content: TextField(
                                  controller: pwCtl,
                                  obscureText: true,
                                  decoration: const InputDecoration(hintText: 'Enter your password to register'),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text('Cancel')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, pwCtl.text.trim()), child: const Text('OK')),
                                ],
                              );
                            },
                          );

                          if (pw == null || pw.isEmpty) return;

                          // Verify biometrics then save
                          final ok = await fingerprintAuth.canAuthenticate();
                          if (!ok) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Biometrics not available')));
                            return;
                          }

                          final did = await fingerprintAuth.authenticate(reason: 'Authenticate to register fingerprint');
                          if (!did) return;

                          final userId = auth.user?.authId;
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No logged in user')));
                            return;
                          }
                          await _secureStorage.write(key: 'fingerprint_email_$userId', value: email);
                          await _secureStorage.write(key: 'fingerprint_password_$userId', value: pw);
                          setState(() => _fingerprintEnabled = true);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint registered for this account')));
                        },
                        child: const Text('Register'),
                      ),
                    )
                  else
                    ListTile(
                      leading: const Icon(Icons.fingerprint, color: Color(0xFF0B7C7C)),
                      title: const Text('Fingerprint registered'),
                      subtitle: const Text('Login using fingerprint'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          final auth = ref.read(authViewModelProvider);
                          final userId = auth.user?.authId;
                          if (userId == null) {
                            setState(() => _fingerprintEnabled = false);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No logged in user')));
                            return;
                          }
                          await _secureStorage.delete(key: 'fingerprint_email_$userId');
                          await _secureStorage.delete(key: 'fingerprint_password_$userId');
                          setState(() => _fingerprintEnabled = false);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint unregistered')));
                        },
                        child: const Text('Unregister'),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Support
            const Text(
              "Support & About",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surface : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isDark
                    ? Border.all(
                        color: Theme.of(context).dividerColor.withOpacity(0.35),
                      )
                    : null,
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.flag, color: Color(0xFF0B7C7C)),
                    title: Text("Report a problem"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: Color(0xFF0B7C7C)),
                    title: Text("Terms and Policies"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: Text(
                  authState.status == AuthStatus.loading
                      ? "Logging out..."
                      : logoutLabel,
                  style: const TextStyle(color: Colors.red),
                ),
                onPressed: authState.status == AuthStatus.loading
                    ? null
                    : () {
                        ref
                            .read(authViewModelProvider.notifier)
                            .logout();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


