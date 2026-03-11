import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';

class AccessRevokedScreen extends StatelessWidget {
  final String reason; // 'revoked' or 'quota'

  const AccessRevokedScreen({super.key, this.reason = 'revoked'});

  @override
  Widget build(BuildContext context) {
    final isRevoked = reason == 'revoked';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isRevoked
                      ? AppColors.error.withAlpha(20)
                      : const Color(0xFFFF8F00).withAlpha(20),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isRevoked ? AppColors.error : const Color(0xFFFF8F00),
                    width: 2,
                  ),
                ),
                child: Icon(
                  isRevoked ? Icons.block : Icons.data_usage,
                  color: isRevoked ? AppColors.error : const Color(0xFFFF8F00),
                  size: 56,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                isRevoked ? 'Access Revoked' : 'Quota Finished',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isRevoked
                    ? 'Your access has been revoked by the host. This could be due to violation of terms or host decision.'
                    : 'Your data quota has been exhausted. Purchase more data to continue browsing.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (!isRevoked)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.data_usage, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '5 GB plan exhausted',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Session ended at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              CustomButton(
                label: 'Find Another Host',
                onPressed: () => context.go('/guest/nearby'),
                icon: Icons.wifi_find_outlined,
              ),
              if (!isRevoked) ...[
                const SizedBox(height: 12),
                CustomButton(
                  label: 'Buy More Data',
                  onPressed: () => context.go('/guest/quota'),
                  outlined: true,
                  icon: Icons.add_circle_outline,
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/role'),
                child: const Text(
                  'Return to Home',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
