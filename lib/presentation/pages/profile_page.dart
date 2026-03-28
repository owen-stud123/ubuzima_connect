import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ubuzima_connect/core/language_service.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_event.dart';
import 'package:ubuzima_connect/presentation/blocs/auth_bloc/auth_state.dart';
import 'package:ubuzima_connect/presentation/pages/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color _mediumGreen = Color(0xFF2FAE66);

  bool notificationsEnabled = true;
  bool isLoggedOut = false;

  String _initialsFromName(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  Future<void> _setLanguage(bool useKinyarwanda) async {
    await LanguageService.setLanguage(
      useKinyarwanda ? AppLanguage.kinyarwanda : AppLanguage.english,
    );
  }

  String _text(AppLanguage language, String english, String kinyarwanda) {
    return language == AppLanguage.kinyarwanda ? kinyarwanda : english;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthAuthenticatedState ? authState.user : null;
    final displayName = (user?.name != null && user!.name!.trim().isNotEmpty)
        ? user.name!.trim()
        : _text(LanguageService.currentLanguage.value, 'User', 'Umukoresha');
    final displayEmail =
        (user?.email ?? '').trim().isNotEmpty
            ? user!.email
            : _text(LanguageService.currentLanguage.value, 'No email', 'Nta imeyili');
    final photoUrl = (user?.photoUrl ?? '').trim();

    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, language, _) => Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticatedState) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _text(language, 'My Profile', 'Umwirondoro'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _mediumGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Profile Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      photoUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(photoUrl),
                              onBackgroundImageError: (_, __) {},
                              child: const SizedBox.shrink(),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xFFDDF4E7),
                              child: Text(
                                _initialsFromName(user?.name),
                                style: const TextStyle(
                                  color: _mediumGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _text(language, 'UbuzimaConnect User', 'Umukoresha wa UbuzimaConnect'),
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            displayEmail,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Divider(color: Colors.grey[400]),

                const SizedBox(height: 10),

                // Language Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _text(language, 'Language', 'Ururimi'),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _setLanguage(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                  color: language == AppLanguage.kinyarwanda
                                  ? _mediumGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'Kinyarwanda',
                                style: TextStyle(
                                  color: language == AppLanguage.kinyarwanda
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _setLanguage(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                  color: language == AppLanguage.english
                                  ? _mediumGreen
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                'English',
                                style: TextStyle(
                                  color: language == AppLanguage.english
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Notifications
                GestureDetector(
                  onTap: () {
                    setState(() => notificationsEnabled = !notificationsEnabled);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _text(language, 'Notifications', 'Imenyesha'),
                          style: const TextStyle(fontSize: 13),
                        ),
                        Row(
                          children: [
                            Text(
                              notificationsEnabled
                                  ? _text(language, 'On', 'Bifunguye')
                                  : _text(language, 'Off', 'Bifunze'),
                              style: const TextStyle(fontSize: 12),
                            ),
                            Switch.adaptive(
                              value: notificationsEnabled,
                              activeThumbColor: _mediumGreen,
                              activeTrackColor: const Color(0xFF9FDCBB),
                              onChanged: (value) {
                                setState(() => notificationsEnabled = value);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Logout Button
                GestureDetector(
                  onTap: () {
                    setState(() => isLoggedOut = true);
                    context.read<AuthBloc>().add(const AuthSignOutEvent());
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _text(language, 'Log Out', 'Sohoka'),
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                if (isLoggedOut)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        _text(language, 'Logged Out', 'Wasohotse'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
