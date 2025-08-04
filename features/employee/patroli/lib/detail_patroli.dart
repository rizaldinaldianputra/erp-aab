import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// Tambahkan status enum atau variabel

// Di bagian widget:
Widget? buildButton(String status) {
  switch (status) {
    case 'Selesai':
      return Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            // Handle selesai
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('#0071CE'),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("Selesai",
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      );
    case 'Tugas':
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle tolak
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(
                      color: Color(0xFF0071CE)), // outline biru
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Tolak",
                  style: TextStyle(fontSize: 16, color: Color(0xFF0071CE)),
                ),
              ),
            ),
            const SizedBox(width: 16), // Jarak antar tombol
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Handle kerjakan
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0071CE),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Kerjakan",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );

    case 'review':
      return const SizedBox.shrink(); // Tidak tampilkan apapun
  }
}

class DetailPatroli extends StatelessWidget {
  final String status;
  const DetailPatroli({Key? key, required this.status}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('#0071CE'),
        foregroundColor: Colors.white,
        leadingWidth: 200,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 10),
            Text(
              'Detail Tugas',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pembersihan Ruangan Dokter",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/4.jpg"),
                ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    text: 'Diminta oleh ',
                    style: const TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Jacob',
                        style: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _infoCard(Icons.priority_high, "Prioritas", "High",
                    valueColor: Colors.red),
                _infoCard(
                    Icons.calendar_today, "Batas Pengerjaan", "15 April 2025"),
                _infoCard(Icons.location_on, "Penempatan", "Semarang"),
                _infoCard(Icons.my_location, "Area", "Area Patrol 1"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Deskripsi",
                style: TextStyle(fontWeight: FontWeight.w300)),
            const SizedBox(height: 8),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text("Detail Lokasi",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey)),
            const SizedBox(height: 4),
            const Text(
              "4517 Washington Ave. Manchester, Kentucky 39495",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text("Patroli",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: const [
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/women/1.jpg")),
                SizedBox(width: 4),
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/men/2.jpg")),
                SizedBox(width: 4),
                CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        "https://randomuser.me/api/portraits/women/3.jpg")),
                SizedBox(width: 8),
                Text("Annette, Cameron, Cody"),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Lampiran",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.grey)),
            const SizedBox(height: 12),
            _buildLampiranRow(),
            const Divider(height: 40),
            Visibility(
              visible: status != 'Tugas',
              child: Column(
                children: [
                  const Text("Logs",
                      style: TextStyle(
                          fontWeight: FontWeight.w300, color: Colors.grey)),
                  const SizedBox(height: 16),
                  _buildLogTimeline(),
                  const Divider(height: 40),
                  const Text("Review",
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(5,
                        (index) => const Icon(Icons.star, color: Colors.amber)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      _tag("Sopan"),
                      _tag("Pengerjaan Rapi"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: buildButton(status),
    );
  }

  Widget _infoCard(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 16, color: valueColor ?? Colors.grey),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: valueColor ?? Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLampiranRow() {
    return Row(
      children: List.generate(
          3,
          (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://fastly.picsum.photos/id/689/200/300.jpg?hmac=vg64_CHvD_VwWyxzKJAAAZswOJG8_8xEdMcP9BHgLJM',
                    width: 80,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              )),
    );
  }

  Widget _buildLogTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _logItem(
          title: "Selesai Dikerjakan",
          date: "13 April 2025, 12:00 WIB",
          color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Waktu Pengerjaan: 2 Jam 32 Menit"),
              const SizedBox(height: 6),
              const Text("Bukti Pengerjaan:"),
              const SizedBox(height: 8),
              _buildLampiranRow(),
            ],
          ),
        ),
        _logItem(title: "Sedang Dikerjakan", date: "13 April 2025, 12:00 WIB"),
        _logItem(title: "Tugas Dibuat", date: "12 April 2025, 14:00 WIB"),
      ],
    );
  }

  Widget _logItem(
      {required String title,
      required String date,
      Widget? child,
      Color color = Colors.grey}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(Icons.radio_button_checked, size: 20, color: color),
              Container(width: 2, height: 40, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w300)),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                if (child != null) child,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.blue)),
    );
  }
}
