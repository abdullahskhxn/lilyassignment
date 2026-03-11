import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/otp_input.dart';
import '../../widgets/custom_button.dart';

class OtpScreen extends StatefulWidget {
  final String role;
  final String contact;

  const OtpScreen({super.key, required this.role, required this.contact});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _otp = '';
  bool _loading = false;
  bool _resent = false;

  void _verify() {
    if (_otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a 6-digit OTP'),
          backgroundColor: AppColors.primaryDark,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _loading = false);
        if (widget.role == 'host') {
          context.go('/host/onboarding');
        } else {
          context.go('/guest/location');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayContact = widget.contact.isEmpty ? '•••@strata.io' : widget.contact;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/login/${widget.role}'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.lock_open_outlined,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Verify OTP',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'A 6-digit code was sent to\n'),
                    TextSpan(
                      text: displayContact,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              OtpInput(
                onCompleted: (otp) => setState(() => _otp = otp),
              ),
              const SizedBox(height: 36),
              CustomButton(
                label: 'Verify & Continue',
                onPressed: _verify,
                loading: _loading,
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() => _resent = true);
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) setState(() => _resent = false);
                    });
                  },
                  child: Text(
                    _resent ? 'OTP Resent ✓' : 'Resend OTP',
                    style: TextStyle(
                      color: _resent ? AppColors.primary : AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
