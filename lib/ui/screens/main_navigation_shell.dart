import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/responsive_wrapper.dart';
import '../../providers/app_state_provider.dart';
import 'home/home_dashboard_screen.dart';
import 'discover/discover_hub_screen.dart';
import 'activities/activities_explorer_screen.dart';
import 'memories/memories_hub_screen.dart';
import 'profile/profile_settings_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboardScreen(),
    DiscoverHubScreen(),
    ActivitiesExplorerScreen(),
    MemoriesHubScreen(),
    ProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<AppStateProvider, bool>((p) => p.isDarkMode);
    final isTr = context.select<AppStateProvider, bool>((p) => p.isTurkish);

    return ResponsiveWrapper(
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.8,
              ),
            ),
          ),
          child: SafeArea(
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor:
                  isDark ? AppColors.blushPinkDeep : AppColors.deepBurgundy,
              unselectedItemColor:
                  isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              selectedFontSize:
                  MediaQuery.sizeOf(context).width <= 360 ? 11 : 12,
              unselectedFontSize:
                  MediaQuery.sizeOf(context).width <= 360 ? 10 : 11,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: (idx) => setState(() => _currentIndex = idx),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_border_rounded),
                  activeIcon: const Icon(Icons.favorite_rounded),
                  label: isTr ? 'Bağlantı' : 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.explore_outlined),
                  activeIcon: const Icon(Icons.explore_rounded),
                  label: isTr ? 'Keşfet' : 'Discover',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.celebration_outlined),
                  activeIcon: const Icon(Icons.celebration_rounded),
                  label: isTr ? 'Randevu' : 'Activities',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.auto_stories_outlined),
                  activeIcon: const Icon(Icons.auto_stories_rounded),
                  label: isTr ? 'Anılar' : 'Memories',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: isTr ? 'Çiftimiz' : 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
