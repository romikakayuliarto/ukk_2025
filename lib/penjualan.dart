import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final supabase = Supabase.instance.client;
  final _searchController = TextEditingController();

  bool _isLoading = false;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _pelanggan = [];
  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(_filterTransactions);
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final transaksiResponse = await supabase
          .from('transaksi')
          .select('id_transaksi, pelanggan_id, tanggal_transaksi, total_harga');
      
      final pelangganResponse = await supabase
          .from('pelanggan')
          .select('id_pelanggan, nama_pelanggan');

      setState(() {
        _transactions = List<Map<String, dynamic>>.from(transaksiResponse);
        _pelanggan = List<Map<String, dynamic>>.from(pelangganResponse);

        // Gabungkan data transaksi dan pelanggan
        _transactions = _transactions.map((transaction) {
          final pelanggan = _pelanggan.firstWhere(
              (p) => p['id_pelanggan'] == transaction['pelanggan_id'],
              orElse: () => {'nama_pelanggan': 'Tidak Diketahui'});
          transaction['nama_pelanggan'] = pelanggan['nama_pelanggan'];
          return transaction;
        }).toList();

        _filteredTransactions = _transactions;
      });
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterTransactions() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        final pelanggan = transaction['nama_pelanggan'].toString().toLowerCase();
        return pelanggan.contains(keyword);
      }).toList();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Transaksi'),
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
          : _filteredTransactions.isEmpty
              ? const Center(child: Text('Tidak ada transaksi yang ditemukan.'))
              : ListView.builder(
                  itemCount: _filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = _filteredTransactions[index];
                    return ListTile(
                      title: Text('Transaksi ID: ${transaction['id_transaksi']}'),
                      subtitle: Text(
                        'Pelanggan: ${transaction['nama_pelanggan']}\n'
                        'Tanggal: ${transaction['tanggal_transaksi']} | Total: Rp ${transaction['total_harga']}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
