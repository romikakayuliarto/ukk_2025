import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart';
import 'stok_produk.dart';
import 'tambah_pelanggan.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProductStockPage()),
      );
    } else if (_selectedIndex == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddCustomerPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('BrantasMart'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stok Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pelanggan',
          ),
        ],
      ),
    );
  }
}
