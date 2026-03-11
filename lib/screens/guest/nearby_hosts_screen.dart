import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/sidebar.dart';
import '../../widgets/host_card.dart';
import '../../widgets/placeholder_map.dart';
import '../../providers/app_provider.dart';
import '../../models/host_model.dart';

class NearbyHostsScreen extends StatefulWidget {
  const NearbyHostsScreen({super.key});

  @override
  State<NearbyHostsScreen> createState() => _NearbyHostsScreenState();
}

class _NearbyHostsScreenState extends State<NearbyHostsScreen> {
  bool _isMapView = false;
  String _activeFilter = 'Distance';
  final _filters = ['Distance', 'Price', 'Rating'];

  List<HostModel> _getSortedHosts(List<HostModel> hosts) {
    final sorted = List<HostModel>.from(hosts);
    switch (_activeFilter) {
      case 'Distance':
        sorted.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'Price':
        sorted.sort((a, b) => a.pricePerGB.compareTo(b.pricePerGB));
        break;
      case 'Rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final hosts = _getSortedHosts(provider.dummyHosts);

    return LayoutBuilder(builder: (context, constraints) {
      final isWide = constraints.maxWidth > 800;

      return Scaffold(
        backgroundColor: AppColors.background,
        drawer: isWide ? null : const Sidebar(role: 'guest', currentRoute: '/guest/nearby'),
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: isWide
              ? null
              : Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
          title: const Text('Nearby Hosts'),
          actions: [
            IconButton(
              icon: Icon(
                _isMapView ? Icons.list : Icons.map_outlined,
                color: AppColors.primary,
              ),
              onPressed: () => setState(() => _isMapView = !_isMapView),
            ),
          ],
        ),
        body: Row(
          children: [
            if (isWide) const Sidebar(role: 'guest', currentRoute: '/guest/nearby'),
            Expanded(
              child: Column(
                children: [
                  // Filter chips
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: AppColors.surface,
                    child: Row(
                      children: [
                        const Text(
                          'Sort by: ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        ..._filters.map((f) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(f),
                                selected: _activeFilter == f,
                                onSelected: (_) =>
                                    setState(() => _activeFilter = f),
                                selectedColor: AppColors.primary.withAlpha(40),
                                checkmarkColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: _activeFilter == f
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _isMapView
                        ? _buildMapView(hosts, provider)
                        : _buildListView(hosts, provider),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMapView(List<HostModel> hosts, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: PlaceholderMap(
              height: double.infinity,
              hostPositions: [
                const Offset(0.25, 0.35),
                const Offset(0.65, 0.2),
                const Offset(0.15, 0.6),
                const Offset(0.78, 0.58),
                const Offset(0.5, 0.72),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hosts.length,
              itemBuilder: (context, index) {
                final host = hosts[index];
                return GestureDetector(
                  onTap: () {
                    provider.selectHost(host);
                    context.go('/guest/select-host');
                  },
                  child: Container(
                    width: 180,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          host.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${host.distance.toInt()}m away',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${host.pricePerGB}/GB',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '⭐ ${host.rating}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<HostModel> hosts, AppProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: hosts.length,
      itemBuilder: (context, index) {
        return HostCard(
          host: hosts[index],
          onConnect: () {
            provider.selectHost(hosts[index]);
            context.go('/guest/select-host');
          },
        );
      },
    );
  }
}
