import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class GuestBookingNotificationScreen extends StatefulWidget {
  const GuestBookingNotificationScreen({super.key});

  @override
  State<GuestBookingNotificationScreen> createState() =>
      _GuestBookingNotificationScreenState();
}

class _GuestBookingNotificationScreenState
    extends State<GuestBookingNotificationScreen> {
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'name': 'Fatima A.',
      'data': '5 GB',
      'price': '2.50 STRATA',
      'time': '2 min ago',
      'status': 'pending',
    },
    {
      'id': '2',
      'name': 'Carlos M.',
      'data': '10 GB',
      'price': '5.00 STRATA',
      'time': '5 min ago',
      'status': 'pending',
    },
    {
      'id': '3',
      'name': 'Li Wei',
      'data': '1 GB',
      'price': '0.50 STRATA',
      'time': '12 min ago',
      'status': 'pending',
    },
  ];

  void _accept(String id) {
    setState(() {
      final item = _requests.firstWhere((r) => r['id'] == id);
      item['status'] = 'accepted';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking accepted! Access key generated.'),
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }

  void _reject(String id) {
    setState(() {
      final item = _requests.firstWhere((r) => r['id'] == id);
      item['status'] = 'rejected';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.go('/host/dashboard'),
        ),
        title: const Text('Guest Booking Requests'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '${_requests.where((r) => r['status'] == 'pending').length} pending',
                style: const TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final req = _requests[index];
          final isPending = req['status'] == 'pending';
          final isAccepted = req['status'] == 'accepted';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isAccepted
                    ? AppColors.primary.withAlpha(120)
                    : req['status'] == 'rejected'
                        ? AppColors.error.withAlpha(80)
                        : AppColors.divider,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withAlpha(25),
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req['name'],
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            req['time'],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isPending)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAccepted
                              ? AppColors.primary.withAlpha(25)
                              : AppColors.error.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAccepted ? 'ACCEPTED' : 'REJECTED',
                          style: TextStyle(
                            color: isAccepted ? AppColors.primary : AppColors.error,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.data_usage, req['data']),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.token, req['price']),
                  ],
                ),
                if (isPending) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _reject(req['id']),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: BorderSide(color: AppColors.error.withAlpha(120)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _accept(req['id']),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
