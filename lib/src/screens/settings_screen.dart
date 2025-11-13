import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sound_manager.dart';
import '../services/locale_provider.dart';
import '../services/auth_service.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SoundManager _soundManager = SoundManager();
  
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'en';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A237E),
              const Color(0xFF311B92),
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.settings,
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildSection(
                      title: '🎵 ${l10n.settingsAudio}',
                      children: [
                        _buildSwitchTile(
                          title: l10n.settingsMusic,
                          subtitle: l10n.settingsMusicSubtitle,
                          value: _soundManager.musicEnabled,
                          onChanged: (val) {
                            setState(() {
                              _soundManager.musicEnabled = val;
                            });
                            if (val) {
                              _soundManager.playMusic('musics/menu.mp3', fadeIn: 500);
                            }
                          },
                        ),
                        if (_soundManager.musicEnabled)
                          _buildSliderTile(
                            title: l10n.settingsMusicVolume,
                            value: _soundManager.musicVolume,
                            onChanged: (val) {
                              setState(() {
                                _soundManager.musicVolume = val;
                              });
                            },
                          ),
                        _buildSwitchTile(
                          title: l10n.settingsSfx,
                          subtitle: l10n.settingsSfxSubtitle,
                          value: _soundManager.sfxEnabled,
                          onChanged: (val) {
                            setState(() {
                              _soundManager.sfxEnabled = val;
                            });
                          },
                        ),
                        if (_soundManager.sfxEnabled)
                          _buildSliderTile(
                            title: l10n.settingsSfxVolume,
                            value: _soundManager.sfxVolume,
                            onChanged: (val) {
                              setState(() {
                                _soundManager.sfxVolume = val;
                              });
                            },
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSection(
                      title: '🌍 ${l10n.settingsLanguage}',
                      children: [
                        _buildLanguageTile(l10n),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    _buildSection(
                      title: '👤 ${l10n.settingsAccount}',
                      children: [
                        _buildAccountInfo(),
                        ..._buildAccountLinkOptions(l10n),
                        _buildDeleteAccountTile(l10n),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _showResetDialog(l10n),
                        icon: const Icon(Icons.restore),
                        label: Text(l10n.settingsResetDefaults),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.amber,
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      title: Row(
      children: [
        Expanded(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        ),
        Text(
        '${(value * 100).round()}%',
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
        ),
      ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Slider(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.amber,
            inactiveColor: Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(S l10n) {
    return ListTile(
      title: Text(
        l10n.settingsLanguageTitle,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(
        _getLanguageName(l10n, _language),
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
      onTap: () => _showLanguageDialog(l10n),
    );
  }

  String _getLanguageName(S l10n, String code) {
    switch (code) {
      case 'en': return l10n.languageEnglish;
      case 'fr': return l10n.languageFrench;
      case 'es': return l10n.languageSpanish;
      case 'de': return l10n.languageGerman;
      default: return l10n.languageEnglish;
    }
  }

  void _showLanguageDialog(S l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(
          l10n.settingsSelectLanguage,
          style: const TextStyle(color: Colors.amber),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(l10n, 'en', l10n.languageEnglish, '🇬🇧'),
            _buildLanguageOption(l10n, 'fr', l10n.languageFrench, '🇫🇷'),
            _buildLanguageOption(l10n, 'es', l10n.languageSpanish, '🇪🇸'),
            _buildLanguageOption(l10n, 'de', l10n.languageGerman, '🇩🇪'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(S l10n, String code, String name, String flag) {
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      trailing: _language == code
          ? const Icon(Icons.check, color: Colors.amber)
          : null,
      onTap: () async {
        setState(() => _language = code);
        await _saveSetting('language', code);
        
        LocaleProvider.instance.setLocale(Locale(code));
        
        if (mounted) Navigator.pop(context);
      },
    );
  }

  void _showResetDialog(S l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(
          l10n.settingsResetTitle,
          style: const TextStyle(color: Colors.amber),
        ),
        content: Text(
          l10n.settingsResetMessage,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              await _loadSettings();
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.settingsResetSuccess),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  // ========== ACCOUNT MANAGEMENT ==========

  Widget _buildAccountInfo() {
    final user = AuthService.currentUser;
    String accountType = '';
    String accountDetails = '';

    if (user == null) {
      accountType = 'Not logged in';
      accountDetails = '';
    } else if (user.isAnonymous) {
      accountType = S.of(context)!.settingsAnonymous;
      accountDetails = 'ID: ${user.uid.substring(0, 8)}...';
    } else {
      final providers = user.providerData.map((p) => p.providerId).toList();
      accountType = providers.join(', ').replaceAll('.com', '');
      accountDetails = user.email ?? user.displayName ?? 'ID: ${user.uid.substring(0, 8)}...';
    }

    return ListTile(
      leading: const Icon(Icons.account_circle, color: Colors.amber, size: 32),
      title: Text(
        accountType,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        accountDetails,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
      ),
    );
  }

  List<Widget> _buildAccountLinkOptions(S l10n) {
    final user = AuthService.currentUser;
    if (user == null) return [];

    final providers = user.providerData.map((p) => p.providerId).toList();
    final hasEmail = providers.contains('password');
    final hasGoogle = providers.contains('google.com');

    final options = <Widget>[];

    if (!hasEmail) {
      options.add(ListTile(
        leading: const Icon(Icons.email, color: Colors.blue),
        title: Text(
          l10n.settingsLinkEmail,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          l10n.settingsLinkEmailSubtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
        trailing: const Icon(Icons.add_circle, color: Colors.amber),
        onTap: () => _showLinkEmailDialog(l10n),
      ));
    } else {
      options.add(ListTile(
        leading: const Icon(Icons.email, color: Colors.grey),
        title: Text(
          l10n.settingsLinkEmail,
          style: const TextStyle(color: Colors.grey),
        ),
        subtitle: Text(
          l10n.settingsAlreadyLinked,
          style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 13),
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ));
    }

    if (!hasGoogle) {
      options.add(ListTile(
        leading: const Icon(Icons.g_mobiledata, color: Colors.red, size: 32),
        title: Text(
          l10n.settingsLinkGoogle,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          l10n.settingsLinkGoogleSubtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
        trailing: const Icon(Icons.add_circle, color: Colors.amber),
        onTap: () => _linkWithGoogle(l10n),
      ));
    } else {
      options.add(ListTile(
        leading: const Icon(Icons.g_mobiledata, color: Colors.grey, size: 32),
        title: Text(
          l10n.settingsLinkGoogle,
          style: const TextStyle(color: Colors.grey),
        ),
        subtitle: Text(
          l10n.settingsAlreadyLinked,
          style: TextStyle(color: Colors.grey.withOpacity(0.6), fontSize: 13),
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ));
    }

    return options;
  }

  Widget _buildDeleteAccountTile(S l10n) {
    return ListTile(
      leading: const Icon(Icons.delete_forever, color: Colors.red),
      title: Text(
        l10n.settingsDeleteAccount,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
      onTap: () => _showDeleteAccountDialog(l10n),
    );
  }

  void _showLinkEmailDialog(S l10n) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(
          l10n.settingsLinkEmail,
          style: const TextStyle(color: Colors.amber),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final password = passwordController.text;

              if (email.isEmpty || password.isEmpty) return;

              try {
                Navigator.pop(context);
                
                if (AuthService.isAnonymous) {
                  await AuthService.linkAnonymousWithEmail(
                    email: email,
                    password: password,
                  );
                } else {
                  await AuthService.linkWithEmail(
                    email: email,
                    password: password,
                  );
                }

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsLinkSuccess),
                      backgroundColor: Colors.green,
                    ),
                  );
                  setState(() {});
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  Future<void> _linkWithGoogle(S l10n) async {
    try {
      if (AuthService.isAnonymous) {
        await AuthService.linkAnonymousWithGoogle();
      } else {
        await AuthService.linkWithGoogle();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.settingsLinkSuccess),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteAccountDialog(S l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(
          l10n.settingsDeleteAccountTitle,
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(
          l10n.settingsDeleteAccountMessage,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.deleteAccount();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed('/');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.settingsDeleteAccountSuccess),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
