import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({Key? key}) : super(key: key);

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final supabase = Supabase.instance.client;
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _teleponController = TextEditingController();
  final _searchController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _searchController.addListener(_filterCustomers);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _teleponController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCustomers() async {
    setState(() => _isLoading = true);
    try {
      final response = await supabase.from('pelanggan').select();
      setState(() {
        _customers = List<Map<String, dynamic>>.from(response);
        _filteredCustomers = _customers;
      });
    }
     catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    }
     finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterCustomers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _customers
          .where((customer) => customer['nama_pelanggan'].toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _addCustomer() async {
    if (_namaController.text.isEmpty || _alamatController.text.isEmpty || _teleponController.text.isEmpty) {
      _showSnackBar('Semua field harus diisi.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await supabase.from('pelanggan').insert({
        'nama_pelanggan': _namaController.text,
        'alamat': _alamatController.text,
        'telepon': _teleponController.text,
      });
      _showSnackBar('Pelanggan berhasil ditambahkan.');
      Navigator.of(context).pop();
      _fetchCustomers();
    }
     catch (e) {
      _showSnackBar('Gagal menambah pelanggan: $e');
    }
     finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateCustomer(int id) async {
    if (_namaController.text.isEmpty || _alamatController.text.isEmpty || _teleponController.text.isEmpty) {
      _showSnackBar('Semua field harus diisi.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await supabase.from('pelanggan').update({
        'nama_pelanggan': _namaController.text,
        'alamat': _alamatController.text,
        'telepon': _teleponController.text,
      }).eq('pelanggan_id', id);
      _showSnackBar('Pelanggan berhasil diperbarui.');
      Navigator.of(context).pop();
      _fetchCustomers();
    }
     catch (e) {
      _showSnackBar('Gagal memperbarui pelanggan: $e');
    }
     finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteCustomer(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin menghapus pelanggan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Hapus')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await supabase.from('pelanggan').delete().eq('pelanggan_id', id);
      _showSnackBar('Pelanggan berhasil dihapus.');
      _fetchCustomers();
    }
     catch (e) {
      _showSnackBar('Gagal menghapus pelanggan: $e');
    }
     finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _showCustomerForm({
    int? id,
    String namaPelanggan = '',
    String alamat = '',
    String telepon = '',
  })
   async {
    _namaController.text = namaPelanggan;
    _alamatController.text = alamat;
    _teleponController.text = telepon;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? 'Tambah Pelanggan' : 'Edit Pelanggan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextField(
                  controller: _alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                ),
                TextField(
                  controller: _teleponController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Telepon'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (id == null) {
                  _addCustomer();
                }
                 else {
                  _updateCustomer(id);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pelanggan'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama pelanggan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredCustomers.isEmpty
              ? const Center(child: Text('Tidak ada pelanggan yang ditemukan.'))
              : ListView.builder(
                  itemCount: _filteredCustomers.length,
                  itemBuilder: (context, index) {
                    final customer = _filteredCustomers[index];
                    return ListTile(
                      title: Text(customer['nama_pelanggan']),
                      subtitle: Text('Alamat: ${customer['alamat']} | Telepon: ${customer['telepon']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showCustomerForm(
                              id: customer['pelanggan_id'],
                              namaPelanggan: customer['nama_pelanggan'],
                              alamat: customer['alamat'],
                              telepon: customer['telepon'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCustomer(customer['pelanggan_id']),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCustomerForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
