import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: const Icon(Icons.hub, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'STRATA',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Welcome to\nSTRATA',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose how you want to participate\nin the decentralized bandwidth network.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 500) {
                  return Row(
                    children: [
                      Expanded(child: _buildRoleCard(context, 'host')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildRoleCard(context, 'guest')),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildRoleCard(context, 'host'),
                    const SizedBox(height: 16),
                    _buildRoleCard(context, 'guest'),
                  ],
                );
              }),
              const Spacer(),
              Center(
                child: Text(
                  'Powered by STRATA Protocol v1.0',
                  style: TextStyle(
                    color: AppColors.textSecondary.withAlpha(100),
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String role) {
    final isHost = role == 'host';
    return GestureDetector(
      onTap: () => context.go('/login/$role'),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primary.withAlpha(100),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withAlpha(20),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isHost ? Icons.router : Icons.person_pin_circle,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isHost ? 'HOST' : 'GUEST',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isHost ? 'Share your bandwidth,\nearn crypto rewards' : 'Find nearby networks,\nbuy data securely',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isHost
                  ? 'Set up your node, configure pricing and start earning STRATA tokens passively.'
                  : 'Connect to nearby peer-hosted networks with pay-per-use data packages.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Get Started',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
