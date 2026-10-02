import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/features/activity/presentation/pages/activity_page.dart';
import 'package:smart_tani_mobile/features/farm/presentation/pages/farm_page.dart';
import 'package:smart_tani_mobile/features/home/presentation/pages/home_page.dart';
import 'package:smart_tani_mobile/features/profile/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static const _pages = [
    HomePage(),
    FarmPage(),
    ActivityPage(),
    ProfilePage(),
  ];

  void _onSelect(int index) {
    if (_selectedIndex == index) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCenterActionPressed() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Fitur aksi akan segera tersedia.'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: _onCenterActionPressed,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Beranda',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onSelect(0),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.agriculture_outlined,
                  activeIcon: Icons.agriculture,
                  label: 'Lahan Saya',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onSelect(1),
                ),
              ),
              const SizedBox(width: 56),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.list_alt_outlined,
                  activeIcon: Icons.list_alt,
                  label: 'Aktivitas',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onSelect(2),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'Profil',
                  isSelected: _selectedIndex == 3,
                  onTap: () => _onSelect(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
