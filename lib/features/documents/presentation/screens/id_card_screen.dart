import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class IDCardScreen extends StatefulWidget {
  const IDCardScreen({super.key});

  @override
  State<IDCardScreen> createState() => _IDCardScreenState();
}

class _IDCardScreenState extends State<IDCardScreen> {
  late Map<String, String> _userData;
  bool _peselVisible = false;

  @override
  void initState() {
    super.initState();
    _userData = _generateRandomData();
  }

  Map<String, String> _generateRandomData() {
    final names = ['Jan', 'Anna', 'Piotr', 'Katarzyna', 'Michał', 'Zofia'];
    final surnames = ['Kowalski', 'Nowak', 'Wiśniewski', 'Wójcik', 'Kamiński', 'Lewandowski'];
    final rand = Random();

    String pesel() => List.generate(11, (_) => rand.nextInt(10)).join();

    String docNumber() => 'AB${List.generate(7, (_) => rand.nextInt(10)).join()}';

    String dateOfBirth() {
      final day = (rand.nextInt(28) + 1).toString().padLeft(2, '0');
      final month = (rand.nextInt(12) + 1).toString().padLeft(2, '0');
      final year = 1970 + rand.nextInt(35);
      return '$day.$month.$year';
    }

    String expiryDate() {
      final day = (rand.nextInt(28) + 1).toString().padLeft(2, '0');
      final month = (rand.nextInt(12) + 1).toString().padLeft(2, '0');
      final year = 2025 + rand.nextInt(10);
      return '$day.$month.$year';
    }

    return {
      'name': names[rand.nextInt(names.length)],
      'surname': surnames[rand.nextInt(surnames.length)],
      'pesel': pesel(),
      'docNumber': docNumber(),
      'dateOfBirth': dateOfBirth(),
      'expiryDate': expiryDate(),
      'nationality': 'Polska',
      'sex': rand.nextBool() ? 'Mężczyzna' : 'Kobieta',
    };
  }

  void _showPinDialog() {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1E1E2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 48, color: Colors.indigo[300]),
              const SizedBox(height: 16),
              const Text(
                'Weryfikacja tożsamości',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Wprowadź PIN aby zobaczyć PESEL',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 8),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '1234',
                  hintStyle: TextStyle(color: Colors.grey[600], letterSpacing: 8),
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFF2A2A3E),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.indigo[400]!, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF2A2A3E),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Anuluj', style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (pinController.text == '1234') {
                          setState(() => _peselVisible = true);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('PESEL odsłonięty'),
                              backgroundColor: Colors.green[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Nieprawidłowy PIN'),
                              backgroundColor: Colors.red[700],
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.indigo[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Potwierdź', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qrData = '${_userData['name']};${_userData['surname']};${_userData['pesel']};${_userData['docNumber']}';

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Dowód osobisty'), backgroundColor: const Color(0xFF1E1E2E), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // GŁÓWNA KARTA
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E2E), const Color(0xFF2A2A3E)],
                ),
                boxShadow: [
                  BoxShadow(color: Colors.indigo.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // HERB I NAGŁÓWEK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield, color: Colors.indigo[300], size: 28),
                      const SizedBox(width: 8),
                      Text(
                        "RZECZPOSPOLITA POLSKA",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo[300],
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text("DOWÓD OSOBISTY", style: TextStyle(fontSize: 12, color: Colors.grey[500], letterSpacing: 2)),
                  const SizedBox(height: 24),

                  // AWATAR
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [Colors.indigo[400]!, Colors.purple[700]!]),
                      boxShadow: [
                        BoxShadow(color: Colors.indigo.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    padding: const EdgeInsets.all(4),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF2A2A3E),
                      child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // NUMER DOKUMENTU
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.indigo[900]!.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo[700]!.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.credit_card, size: 18, color: Colors.indigo[300]),
                        const SizedBox(width: 8),
                        Text(
                          'Nr dokumentu: ${_userData['docNumber']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[200],
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // DANE OSOBOWE
                  _buildDataSection('Dane osobowe', [
                    _buildInfoRow(Icons.person_outline, 'Imię', _userData['name']!),
                    _buildInfoRow(Icons.badge_outlined, 'Nazwisko', _userData['surname']!),
                    _buildInfoRow(Icons.cake_outlined, 'Data urodzenia', _userData['dateOfBirth']!),
                    _buildInfoRow(Icons.wc_outlined, 'Płeć', _userData['sex']!),
                    _buildInfoRow(Icons.flag_outlined, 'Obywatelstwo', _userData['nationality']!),
                  ]),

                  const SizedBox(height: 16),

                  // PESEL Z PRZYCISKIEM
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.indigo[800]!.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.fingerprint, color: Colors.indigo[300], size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'PESEL',
                                  style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Text(
                              _peselVisible ? _userData['pesel']! : '•••••••••••',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _peselVisible ? Colors.white : Colors.grey[600],
                                letterSpacing: _peselVisible ? 2 : 4,
                              ),
                            ),
                          ],
                        ),
                        if (!_peselVisible) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showPinDialog,
                              icon: const Icon(Icons.visibility, size: 18),
                              label: const Text('Pokaż PESEL'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // DATA WAŻNOŚCI
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[900]!.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange[800]!.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event_outlined, color: Colors.orange[300], size: 20),
                            const SizedBox(width: 8),
                            const Text('Ważny do', style: TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                        Text(
                          _userData['expiryDate']!,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[200]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // KOD QR
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        QrImageView(data: qrData, size: 180, backgroundColor: Colors.white),
                        const SizedBox(height: 12),
                        Text(
                          "Zeskanuj aby potwierdzić tożsamość",
                          style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // STOPKA
            Text('Dokument wygenerowany elektronicznie', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text('© 2025 Rzeczpospolita Polska', style: TextStyle(fontSize: 10, color: Colors.grey[700])),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo[800]!.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.indigo[300], letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
