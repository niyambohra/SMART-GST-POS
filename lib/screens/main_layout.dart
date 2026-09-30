import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/isar/user_model.dart';
import '../providers/auth_provider.dart';
import '../providers/business_settings_provider.dart';
import 'dashboard/dashboard_screen.dart';
import 'pos/pos_screen.dart';
import 'inventory/inventory_screen.dart';
import 'categories/category_screen.dart';
import 'sales/sales_screen.dart';
import 'customers/customer_screen.dart';
import 'ledger/ledger_screen.dart';
import 'staff/staff_screen.dart';
import 'audit/audit_log_screen.dart';
import 'settings/settings_screen.dart';
import '../widgets/database_explorer_dialog.dart';
import '../widgets/supabase_todos_dialog.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final settings = context.watch<BusinessSettingsProvider>();
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 850;

    // Define Navigation Items based on Role Access
    final List<NavItem> navItems = [
      NavItem(
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        screen: DashboardScreen(onNavigate: _onDestinationSelected),
      ),
      const NavItem(
        title: 'POS Register',
        icon: Icons.point_of_sale_outlined,
        selectedIcon: Icons.point_of_sale,
        screen: POSScreen(),
      ),
      const NavItem(
        title: 'Inventory',
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        screen: InventoryScreen(),
      ),
      const NavItem(
        title: 'Categories',
        icon: Icons.category_outlined,
        selectedIcon: Icons.category,
        screen: CategoryScreen(),
      ),
      const NavItem(
        title: 'Sales & Invoices',
        icon: Icons.receipt_long_outlined,
        selectedIcon: Icons.receipt_long,
        screen: SalesScreen(),
      ),
      const NavItem(
        title: 'Customers',
        icon: Icons.people_outline,
        selectedIcon: Icons.people,
        screen: CustomerScreen(),
      ),
      const NavItem(
        title: 'Accounts & Ledger',
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet,
        screen: LedgerScreen(),
      ),
      if (auth.isAdmin) ...[
        const NavItem(
          title: 'Staff & Roles',
          icon: Icons.shield_outlined,
          selectedIcon: Icons.shield,
          screen: StaffScreen(),
        ),
        const NavItem(
          title: 'Audit Logs',
          icon: Icons.history_edu_outlined,
          selectedIcon: Icons.history_edu,
          screen: AuditLogScreen(),
        ),
        const NavItem(
          title: 'Admin Settings',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          screen: SettingsScreen(),
        ),
      ],
    ];

    // Ensure selected index is within bounds
    if (_selectedIndex >= navItems.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.calculate, color: Colors.white, size: 20),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    settings.profile.storeName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: -0.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'GSTIN: ${settings.profile.gstin} • State: ${settings.profile.state}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Phase 14: Cloud Status Indicator
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.teal.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  auth.firebaseUid != null ? 'Cloud: Connected' : 'Firebase: Active',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Supabase Todos & Cloud Quick Launcher
          FilledButton.tonalIcon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const SupabaseTodosDialog(),
              );
            },
            icon: const Icon(Icons.cloud_done, size: 16, color: Color(0xFF3ECF8E)),
            label: const Text('Supabase Cloud', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: const Color(0xFF3ECF8E).withValues(alpha: 0.12),
              foregroundColor: Colors.teal[900],
            ),
          ),
          const SizedBox(width: 8),

          // Database Explorer Quick Launcher
          FilledButton.tonalIcon(
            onPressed: () => showDatabaseExplorerDialog(context),
            icon: const Icon(Icons.storage, size: 16),
            label: const Text('Database Explorer & Export', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: Colors.teal.withValues(alpha: 0.12),
              foregroundColor: Colors.teal,
            ),
          ),
          const SizedBox(width: 8),

          // Live Role Switcher Pill for Testing / Persona Simulation
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings_outlined, size: 16, color: Colors.teal),
                const SizedBox(width: 6),
                const Text('Role: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal)),
                DropdownButton<UserRole>(
                  value: auth.currentRole,
                  isDense: true,
                  underline: const SizedBox.shrink(),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.teal, size: 18),
                  items: const [
                    DropdownMenuItem(
                      value: UserRole.owner,
                      child: Text('Owner', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    DropdownMenuItem(
                      value: UserRole.admin,
                      child: Text('Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    DropdownMenuItem(
                      value: UserRole.manager,
                      child: Text('Manager', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    DropdownMenuItem(
                      value: UserRole.cashier,
                      child: Text('Cashier', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                  onChanged: (newRole) {
                    if (newRole != null) {
                      auth.switchRole(newRole);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Switched view to ${newRole.name.toUpperCase()} mode.'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Desktop Navigation Rail
          if (isDesktop)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              backgroundColor: theme.scaffoldBackgroundColor,
              indicatorColor: Colors.teal.withValues(alpha: 0.2),
              destinations: navItems.map((item) {
                return NavigationRailDestination(
                  icon: Icon(item.icon, size: 20),
                  selectedIcon: Icon(item.selectedIcon, color: Colors.teal, size: 20),
                  label: Text(
                    item.title,
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          if (isDesktop) const VerticalDivider(width: 1, thickness: 1),

          // Main View Screen Content
          Expanded(
            child: navItems[_selectedIndex].screen,
          ),
        ],
      ),
      // Mobile / Tablet Drawer
      drawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.teal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.calculate, color: Colors.white, size: 36),
                        const SizedBox(height: 8),
                        Text(
                          settings.profile.storeName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '${auth.userName} • ${auth.currentRole.name.toUpperCase()}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ...navItems.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final isSelected = _selectedIndex == idx;
                    return ListTile(
                      leading: Icon(isSelected ? item.selectedIcon : item.icon,
                          color: isSelected ? Colors.teal : Colors.grey[700]),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.teal : null,
                        ),
                      ),
                      selected: isSelected,
                      onTap: () {
                        Navigator.pop(context);
                        _onDestinationSelected(idx);
                      },
                    );
                  }),
                ],
              ),
            )
          : null,
    );
  }
}

class NavItem {
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Widget screen;

  const NavItem({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.screen,
  });
}
