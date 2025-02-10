import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductStockPage extends StatefulWidget {
  const ProductStockPage({Key? key}) : super(key: key);

  @override
  State<ProductStockPage> createState() => _ProductStockPageState();
}

class _ProductStockPageState extends State<ProductStockPage> {
  final supabase = Supabase.instance.client;
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

Future<void> _fetchProducts() async {
  setState(() => _isLoading = true);
  try {
    final response = await supabase.from('produk').select();

    // ignore: unnecessary_null_comparison
    if (response == null) {
      _showSnackBar('Data produk kosong.');
    } else {
      setState(() {
        _products = List<Map<String, dynamic>>.from(response);
      });
    }
  } catch (e) {
    _showSnackBar('Terjadi kesalahan: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}



Future<void> _addProduct() async {
  final name = _namaController.text.trim();
  final price = double.tryParse(_hargaController.text.trim()) ?? 0;
  final stock = int.tryParse(_stokController.text.trim()) ?? 0;

  if (name.isEmpty || price <= 0 || stock < 0) {
    _showSnackBar('Nama, harga, dan stok harus valid.');
    return;
  }

  setState(() => _isLoading = true);
  try {
    await supabase.from('produk').insert({
      'nama_produk': name,
      'harga': price,
      'stok': stock,
    });
    _showSnackBar('Produk berhasil ditambahkan.');
    _fetchProducts();
    Navigator.pop(context);
  } catch (e) {
    _showSnackBar('Gagal menambahkan produk: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

Future<void> _updateProduct(int id) async {
  final name = _namaController.text.trim();
  final price = double.tryParse(_hargaController.text.trim()) ?? 0;
  final stock = int.tryParse(_stokController.text.trim()) ?? 0;

  if (name.isEmpty || price <= 0 || stock < 0) {
    _showSnackBar('Nama, harga, dan stok harus valid.');
    return;
  }

  setState(() => _isLoading = true);
  try {
    final response = await supabase.from('produk').update({
      'nama_produk': name,
      'harga': price,
      'stok': stock,
    }).eq('id', id).select(); // Pastikan kamu menambahkan .select()

    if (response.isEmpty) {
      _showSnackBar('Gagal memperbarui produk. Produk tidak ditemukan.');
    } else {
      _showSnackBar('Produk berhasil diperbarui.');
      _fetchProducts(); // Refresh data
      Navigator.pop(context);
    }
  } catch (e) {
    _showSnackBar('Gagal memperbarui produk: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

Future<void> _deleteProduct(int id) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi'),
      content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Hapus'),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  setState(() => _isLoading = true);
  try {
    final response = await supabase.from('produk').delete().eq('id', id).select();

    if (response.isEmpty) {
      _showSnackBar('Produk tidak ditemukan atau sudah dihapus.');
    } else {
      _showSnackBar('Produk berhasil dihapus.');
      _fetchProducts(); // Refresh data setelah delete
    }
  } catch (e) {
    _showSnackBar('Gagal menghapus produk: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}




  void _showProductForm({int? id, String namaProduk = '', double harga = 0, int stok = 0}) {
    _namaController.text = namaProduk;
    _hargaController.text = harga.toString();
    _stokController.text = stok.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Tambah Produk' : 'Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Harga'),
                ),
                TextField(
                  controller: _stokController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stok'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (id == null) {
                  _addProduct();
                } else {
                  _updateProduct(id);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Produk')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product['nama_produk']),
                  subtitle: Text('Harga: Rp ${product['harga']} | Stok: ${product['stok']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showProductForm(
                          id: product['id'],
                          namaProduk: product['nama_produk'],
                          harga: (product['harga'] as num).toDouble(),
                          stok: product['stok'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(product['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}



