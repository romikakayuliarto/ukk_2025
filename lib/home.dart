import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'stok_produk.dart';
import 'tambah_pelanggan.dart';
import 'penjualan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('BrantasMart'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPageWidget()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'BrantasMart Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Stok Produk'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductStockPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Tambah Pelanggan'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCustomerPage()),
                );
              },
            ),
              ListTile(
              leading: const Icon(Icons.add_shopping_cart_rounded),
              title: const Text('Penjualan'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TransactionPage()),
                );
              },
            ),

          ],
        ),
      ),
      body: Center(
        child: Text(
          _selectedIndex == 0
              ? 'Ini halaman Home!'
              : _selectedIndex == 1
                  ? 'Stok Produk'
                  : 'Tambah Pelanggan',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
