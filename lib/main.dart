import 'package:flutter/material.dart';

void main() {
  runApp(const KlikLaundryApp());
}

class KlikLaundryApp extends StatelessWidget {
  const KlikLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klik Laundry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A90D9)),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaCtrl = TextEditingController();
  final _noHpCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  String _jenisKelamin = 'Laki-laki';
  final Map<String, bool> _layanan = {
    'Cuci Kering': false,
    'Cuci Setrika': false,
    'Setrika Saja': false,
    'Ekspres': false,
  };
  String _paket = 'Reguler (3 Hari)';
  bool _setuju = false;
  bool _obscurePass = true;

  final List<String> _paketList = [
    'Reguler (3 Hari)',
    'Express (1 Hari)',
    'Super Express (6 Jam)',
    'Bulanan',
  ];

  @override
  void dispose() {
    _namaCtrl.dispose();
    _noHpCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final layananDipilih = _layanan.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    if (layananDipilih.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu jenis layanan!')),
      );
      return;
    }

    if (!_setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda harus menyetujui syarat dan ketentuan!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(
          nama: _namaCtrl.text,
          noHp: _noHpCtrl.text,
          email: _emailCtrl.text,
          jenisKelamin: _jenisKelamin,
          layanan: layananDipilih,
          paket: _paket,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90D9),
        title: const Text('Klik Laundry',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF4A90D9), Color(0xFF7B5EA7)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_laundry_service, color: Colors.white, size: 40),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Form Pemesanan Laundry',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text('Isi data dengan lengkap dan benar',
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _card([
                _sectionTitle('Data Pelanggan'),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _namaCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person)),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _noHpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'No. HP (min. 8 digit)', prefixIcon: Icon(Icons.phone)),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'No. HP tidak boleh kosong';
                    if (!RegExp(r'^\d+$').hasMatch(v)) return 'No. HP hanya boleh angka';
                    if (v.length < 8) return 'No. HP minimal 8 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', prefixIcon: Icon(Icons.email)),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(v)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePass,
                  decoration: InputDecoration(
                    labelText: 'Password (min. 8 karakter)',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePass ? Icons.visibility : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                    if (v.length < 8) return 'Password minimal 8 karakter';
                    return null;
                  },
                ),
              ]),
              const SizedBox(height: 12),
              _card([
                _sectionTitle('Jenis Kelamin'),
                const SizedBox(height: 4),
                Row(
                  children: ['Laki-laki', 'Perempuan'].map((g) {
                    return Expanded(
                      child: RadioListTile<String>(
                        title: Text(g, style: const TextStyle(fontSize: 13)),
                        value: g,
                        // ignore: deprecated_member_use
                        groupValue: _jenisKelamin,
                        // ignore: deprecated_member_use
                        onChanged: (v) => setState(() => _jenisKelamin = v!),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    );
                  }).toList(),
                ),
              ]),
              const SizedBox(height: 12),
              _card([
                _sectionTitle('Jenis Layanan (boleh lebih dari satu)'),
                const SizedBox(height: 4),
                Wrap(
                  children: _layanan.keys.map((key) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 30,
                      child: CheckboxListTile(
                        title: Text(key, style: const TextStyle(fontSize: 13)),
                        value: _layanan[key],
                        onChanged: (v) => setState(() => _layanan[key] = v!),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    );
                  }).toList(),
                ),
              ]),
              const SizedBox(height: 12),
              _card([
                _sectionTitle('Paket Laundry'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: _paket,
                  decoration:
                      const InputDecoration(prefixIcon: Icon(Icons.inventory_2)),
                  items: _paketList
                      .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p, style: const TextStyle(fontSize: 13))))
                      .toList(),
                  onChanged: (v) => setState(() => _paket = v!),
                ),
              ]),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: CheckboxListTile(
                  title: const Text(
                      'Saya menyetujui syarat dan ketentuan Klik Laundry',
                      style: TextStyle(fontSize: 13)),
                  value: _setuju,
                  onChanged: (v) => setState(() => _setuju = v!),
                  controlAffinity: ListTileControlAffinity.leading,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Simpan Pesanan',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF4A90D9)));
  }
}

class ResultPage extends StatelessWidget {
  final String nama, noHp, email, jenisKelamin, paket;
  final List<String> layanan;

  const ResultPage({
    super.key,
    required this.nama,
    required this.noHp,
    required this.email,
    required this.jenisKelamin,
    required this.layanan,
    required this.paket,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90D9),
        title: const Text('Ringkasan Pesanan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF4A90D9), Color(0xFF7B5EA7)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 60),
                  SizedBox(height: 8),
                  Text('Pesanan Berhasil Disimpan!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text('Terima kasih telah menggunakan Klik Laundry',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  _infoRow(Icons.person, 'Nama Lengkap', nama),
                  const Divider(),
                  _infoRow(Icons.phone, 'No. HP', noHp),
                  const Divider(),
                  _infoRow(Icons.email, 'Email', email),
                  const Divider(),
                  _infoRow(
                    jenisKelamin == 'Laki-laki' ? Icons.male : Icons.female,
                    'Jenis Kelamin',
                    jenisKelamin,
                  ),
                  const Divider(),
                  _infoRow(Icons.local_laundry_service, 'Layanan', layanan.join(', ')),
                  const Divider(),
                  _infoRow(Icons.inventory_2, 'Paket', paket),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text('Kembali ke Form',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4A90D9), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
