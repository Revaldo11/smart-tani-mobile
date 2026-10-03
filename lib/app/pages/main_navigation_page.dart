import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smart_tani_mobile/core/widget/global_snackbar.dart';
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
    showGlobalSnackbar(
      context,
      title: 'Fitur Belum Tersedia',
      subtitle: 'Fitur ini masih dalam pengembangan.',
      mode: SnackBarMode.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 68,
        padding: EdgeInsets.zero,
        color: Colors.white,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: EvaIcons.homeOutline,
                  activeIcon: EvaIcons.home,
                  label: 'Beranda',
                  isSelected: _selectedIndex == 0,
                  onTap: () => _onSelect(0),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.agriculture_outlined,
                  activeIcon: Icons.agriculture,
                  label: 'Lahan',
                  isSelected: _selectedIndex == 1,
                  onTap: () => _onSelect(1),
                ),
              ),
              Container(
                width: 56,
                height: 56,
                child: Transform.translate(
                  offset: const Offset(0, -10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -8,
                        bottom: -8,
                        left: -8,
                        right: -8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: Color(0xFF3C952C),
                        shape: const CircleBorder(),
                        onPressed: _onCenterActionPressed,
                        elevation: 0,
                        child: const Icon(
                          EvaIcons.plus,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: EvaIcons.listOutline,
                  activeIcon: EvaIcons.list,
                  label: 'Aktivitas',
                  isSelected: _selectedIndex == 2,
                  onTap: () => _onSelect(2),
                ),
              ),
              Expanded(
                child: _BottomNavItem(
                  icon: EvaIcons.personOutline,
                  activeIcon: EvaIcons.person,
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
