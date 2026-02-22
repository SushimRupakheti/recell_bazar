import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recell_bazar/sensors/fingerprint_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:recell_bazar/features/auth/presentation/pages/login_screen.dart';
import 'package:recell_bazar/features/auth/presentation/state/auth_state.dart';
import 'package:recell_bazar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:recell_bazar/features/auth/presentation/widgets/profile_header.dart';
import 'package:recell_bazar/features/auth/presentation/widgets/stats_card.dart';

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
    final savedEmail = await _secureStorage.read(key: 'saved_email');
    setState(() => _fingerprintEnabled = savedEmail != null);
  }

  Future<void> _toggleFingerprint(bool value) async {
    if (!value) {
      // turning off: remove stored credentials
      await _secureStorage.delete(key: 'saved_email');
      await _secureStorage.delete(key: 'saved_password');
      setState(() => _fingerprintEnabled = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fingerprint login disabled')));
      return;
    }

    // enabling requires saved credentials (user must opt-in from login screen)
    final savedEmail = await _secureStorage.read(key: 'saved_email');
    final savedPassword = await _secureStorage.read(key: 'saved_password');
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
        title: const Text("Profile"),
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

            // Account
            const Text(
              "Account",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.security, color: Color(0xFF0B7C7C)),
                    title: Text("Security"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  const ListTile(
                    leading: Icon(Icons.notifications, color: Color(0xFF0B7C7C)),
                    title: Text("Notifications"),
                    trailing: Icon(Icons.chevron_right),
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

                          await _secureStorage.write(key: 'saved_email', value: email);
                          await _secureStorage.write(key: 'saved_password', value: pw);
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
                      subtitle: const Text('You can login using fingerprint on this device'),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          await _secureStorage.delete(key: 'saved_email');
                          await _secureStorage.delete(key: 'saved_password');
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
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
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
                      : "Log out",
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
