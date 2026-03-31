import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ubuzima_connect/core/theme.dart';
import 'package:ubuzima_connect/core/language_service.dart';

class AskDoctorPage extends StatefulWidget {
  const AskDoctorPage({super.key});

  @override
  State<AskDoctorPage> createState() => _AskDoctorPageState();
}

class _AskDoctorPageState extends State<AskDoctorPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _customEmailController = TextEditingController();
  bool _isSending = false;
  String? _selectedEmail;
  bool _useCustomEmail = false;

  final List<Map<String, String>> _availableDoctors = [
    {'name': 'Dr. Kayumba', 'email': 'd.kayumba1@alustudent.com'},
    {'name': 'Dr. David', 'email': 'pontientdavid2005@gmail.com'},
    {'name': 'Dr. Weekend', 'email': 'weekendstarboy7@gmail.com'},
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _customEmailController.dispose();
    super.dispose();
  }

  String? get _activeEmail {
    if (_useCustomEmail) {
      return _customEmailController.text.trim().isEmpty
          ? null
          : _customEmailController.text.trim();
    }
    return _selectedEmail;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _sendMessage() async {
    final email = _activeEmail;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a doctor\'s email'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in subject and message'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(_subjectController.text.trim())}'
          '&body=${Uri.encodeComponent(_messageController.text.trim())}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No email app found on this device'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.currentLanguage,
      builder: (context, language, _) => Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            language == AppLanguage.kinyarwanda
                ? 'Kubuza Muganga'
                : 'Ask Doctor',
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.medical_services_outlined,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        language == AppLanguage.kinyarwanda
                            ? 'Hitamo Muganga cyangwa Andika Imeyili'
                            : 'Select a doctor or enter any email',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Doctor selection
              Text(
                language == AppLanguage.kinyarwanda
                    ? 'Hitamo Muganga'
                    : 'Available Doctors',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ..._availableDoctors.map((doctor) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmail = doctor['email'];
                        _useCustomEmail = false;
                        _customEmailController.clear();
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: _selectedEmail == doctor['email'] &&
                                !_useCustomEmail
                            ? AppTheme.lightBlue
                            : AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedEmail == doctor['email'] &&
                                  !_useCustomEmail
                              ? AppTheme.primaryBlue
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                _selectedEmail == doctor['email'] &&
                                        !_useCustomEmail
                                    ? AppTheme.primaryBlue
                                    : AppTheme.lightBlue,
                            child: Icon(
                              Icons.person_outline,
                              size: 20,
                              color: _selectedEmail == doctor['email'] &&
                                      !_useCustomEmail
                                  ? Colors.white
                                  : AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['name']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedEmail == doctor['email'] &&
                                            !_useCustomEmail
                                        ? AppTheme.primaryBlue
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                Text(
                                  doctor['email']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedEmail == doctor['email'] &&
                              !_useCustomEmail)
                            const Icon(Icons.check_circle,
                                color: AppTheme.primaryBlue, size: 20),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 16),

              // Custom email option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _useCustomEmail = true;
                    _selectedEmail = null;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _useCustomEmail
                        ? AppTheme.lightBlue
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _useCustomEmail
                          ? AppTheme.primaryBlue
                          : Colors.transparent,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _useCustomEmail
                            ? AppTheme.primaryBlue
                            : AppTheme.lightBlue,
                        child: Icon(Icons.edit_outlined,
                            size: 20,
                            color: _useCustomEmail
                                ? Colors.white
                                : AppTheme.primaryBlue),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        language == AppLanguage.kinyarwanda
                            ? 'Andika Imeyili Ubwawe'
                            : 'Enter custom email',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _useCustomEmail
                              ? AppTheme.primaryBlue
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (_useCustomEmail) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _customEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'doctor@example.com',
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppTheme.primaryBlue),
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Subject
              Text(
                language == AppLanguage.kinyarwanda
                    ? 'Insanganyamatsiko'
                    : 'Subject',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: language == AppLanguage.kinyarwanda
                      ? 'Andika insanganyamatsiko...'
                      : 'e.g. Question about my medication',
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Message
              Text(
                language == AppLanguage.kinyarwanda ? 'Ubutumwa' : 'Message',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _messageController,
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: language == AppLanguage.kinyarwanda
                      ? 'Andika ikibazo cyawe hano...'
                      : 'Describe your question or concern...',
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Send button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_outlined),
                  label: Text(
                    language == AppLanguage.kinyarwanda
                        ? 'Ohereza Ubutumwa'
                        : 'Send Message',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
