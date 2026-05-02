import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Placeholder (Only visible on wide screens, but here we just show an icon bar)
          NavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.security_outlined),
                selectedIcon: Icon(Icons.security),
                label: Text('Roles'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.report_outlined),
                selectedIcon: Icon(Icons.report),
                label: Text('Reports'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Overview Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildStatCard(context, 'Total Users', '124,592', Icons.people, Colors.blue),
                    _buildStatCard(context, 'Active Posts', '8,932', Icons.post_add, Colors.orange),
                    _buildStatCard(context, 'Reports Pending', '34', Icons.warning, Colors.red),
                    _buildStatCard(context, 'Avg Engagement', '4.2%', Icons.trending_up, Colors.green),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'Recent Reports',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.report_gmailerrorred, color: Colors.red),
                        title: Text('Inappropriate content reported by User $index'),
                        subtitle: const Text('Post ID: #009384 - 2 hours ago'),
                        trailing: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Review'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
