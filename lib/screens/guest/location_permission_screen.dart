import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.primary.withAlpha(20),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Enable Location\nAccess',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'STRATA needs your location to discover nearby bandwidth hosts in your area.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              _buildFeatureRow(Icons.wifi_find_outlined, 'Find hosts within 500m radius'),
              _buildFeatureRow(Icons.security_outlined, 'Your location stays private'),
              _buildFeatureRow(Icons.speed_outlined, 'Connect to the fastest nearby node'),
              const Spacer(),
              CustomButton(
                label: 'Grant Permission',
                onPressed: () => context.go('/guest/nearby'),
                icon: Icons.my_location,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/guest/nearby'),
                child: const Text(
                  'Not now',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
