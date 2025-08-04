import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // <-- IMPORT BARU untuk format tanggal

// --- MODEL DATA UNTUK FILE YANG DI-UPLOAD ---
// Menggunakan class agar lebih mudah mengelola jenis file
class UploadedFile {
  final String name;
  final String type; // 'image' atau 'document'

  UploadedFile({required this.name, required this.type});
}

// --- WIDGET UNTUK UPLOAD FOTO/FILE ---
class AttachmentUploader extends StatefulWidget {
  final int maxFiles;
  // Callback untuk memberitahu parent widget jika ada perubahan
  final Function(List<UploadedFile>) onFilesChanged;

  const AttachmentUploader({
    Key? key,
    this.maxFiles = 3,
    required this.onFilesChanged,
  }) : super(key: key);

  @override
  _AttachmentUploaderState createState() => _AttachmentUploaderState();
}

class _AttachmentUploaderState extends State<AttachmentUploader> {
  // Menggunakan List dari class UploadedFile
  final List<UploadedFile> _uploadedFiles = [];

  void _showAttachmentOptions() {
    if (_uploadedFiles.length >= widget.maxFiles) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Anda sudah mencapai batas maksimal ${widget.maxFiles} file.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () {
                  _addDummyFile('image');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  _addDummyFile('image');
                  Navigator.of(context).pop();
                },
              ),
              // --- OPSI BARU UNTUK DOKUMEN ---
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Pilih Dokumen'),
                onTap: () {
                  _addDummyFile('document');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addDummyFile(String type) {
    setState(() {
      int fileNumber = _uploadedFiles.length + 1;
      String fileName = type == 'image'
          ? 'foto_dummy_$fileNumber.jpg'
          : 'dokumen_$fileNumber.pdf';
      _uploadedFiles.add(UploadedFile(name: fileName, type: type));
      widget.onFilesChanged(_uploadedFiles); // Panggil callback
    });
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
      widget.onFilesChanged(_uploadedFiles); // Panggil callback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._uploadedFiles.asMap().entries.map((entry) {
          int index = entry.key;
          UploadedFile file = entry.value;
          return _buildFileListItem(file, index);
        }).toList(),
        if (_uploadedFiles.length < widget.maxFiles)
          GestureDetector(
            onTap: _showAttachmentOptions,
            child: DottedBorderBox(),
          ),
      ],
    );
  }

  Widget _buildFileListItem(UploadedFile file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // --- IKON DINAMIS BERDASARKAN TIPE FILE ---
          Icon(
            file.type == 'image'
                ? Icons.image_outlined
                : Icons.insert_drive_file_outlined,
            color: const Color(0xFF0071CE),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              file.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            onPressed: () => _removeFile(index),
          ),
        ],
      ),
    );
  }
}

class BuatTugasScreen extends StatefulWidget {
  @override
  State<BuatTugasScreen> createState() => _BuatTugasScreenState();
}

class _BuatTugasScreenState extends State<BuatTugasScreen> {
  // --- STATE MANAGEMENT BARU ---
  final _formKey = GlobalKey<FormState>(); // Untuk validasi
  final _judulController = TextEditingController();
  final _dateController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String? _selectedPenempatan;
  String? _selectedArea;
  String _selectedPriority = 'High'; // Default value
  List<UploadedFile> _lampiran = [];

  // Data dummy untuk dropdown
  final List<String> _penempatanOptions = [
    'Gedung A',
    'Gedung B',
    'Luar Gedung'
  ];
  final List<String> _areaOptions = [
    'Lantai 1',
    'Lantai 2',
    'Lobi',
    'Parkiran'
  ];

  // --- FUNGSI BARU UNTUK DATE PICKER ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
            DateFormat('d MMMM yyyy', 'id_ID').format(picked);
      });
    }
  }

  // --- FUNGSI UNTUK VALIDASI FORM ---
  bool _isFormValid() {
    return _judulController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _selectedPenempatan != null &&
        _selectedArea != null &&
        _lokasiController.text.isNotEmpty &&
        _deskripsiController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Listener untuk memeriksa validasi setiap ada perubahan
    _judulController.addListener(() => setState(() {}));
    _dateController.addListener(() => setState(() {}));
    _lokasiController.addListener(() => setState(() {}));
    _deskripsiController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _judulController.dispose();
    _dateController.dispose();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Tugas',
            style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white)),
        backgroundColor: const Color(0xFF0071CE),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Menggunakan Form untuk validasi di masa depan
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Diminta oleh (Tidak berubah)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Diminta oleh",
                        style: TextStyle(color: Colors.grey)),
                    Row(
                      children: const [
                        Text("Jacob",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/32.jpg'),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              buildTextField(
                label: "Judul Tugas *",
                hintText: "Masukkan Judul Tugas",
                controller: _judulController,
              ),

              // --- TEXTFIELD TANGGAL YANG SUDAH FUNGSIONAL ---
              buildTextField(
                label: "Batas Pengerjaan *",
                hintText: "Pilih Batas Pengerjaan",
                controller: _dateController,
                readOnly: true,
                suffixIcon: Icons.calendar_today,
                onTap: () => _selectDate(context), // Panggil fungsi date picker
              ),

              // --- DROPDOWN UNTUK PENEMPATAN ---
              buildDropdownField(
                label: "Penempatan *",
                hintText: "Pilih Penempatan",
                value: _selectedPenempatan,
                items: _penempatanOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedPenempatan = value;
                  });
                },
              ),

              // --- DROPDOWN UNTUK AREA ---
              buildDropdownField(
                label: "Area *",
                hintText: "Pilih Area",
                value: _selectedArea,
                items: _areaOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value;
                  });
                },
              ),

              buildTextField(
                label: "Detail Lokasi *",
                hintText: "Masukkan Detail Lokasi",
                controller: _lokasiController,
                maxLines: 3,
              ),

              buildTextField(
                label: "Deskripsi *",
                hintText: "Masukkan Deskripsi",
                controller: _deskripsiController,
                maxLines: 3,
              ),

              const Text("Prioritas *"),
              const SizedBox(height: 8),
              // --- CHIP PRIORITAS INTERAKTIF ---
              Row(
                children: ["High", "Medium", "Low"].map((priority) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPriority = priority;
                        });
                      },
                      child: _priorityChip(
                        priority,
                        selected: _selectedPriority == priority,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
              const Text("Patroli *"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0071CE),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),

              const SizedBox(height: 16),
              const Text("Lampiran Tambahan"),
              const SizedBox(height: 8),

              AttachmentUploader(
                onFilesChanged: (files) {
                  setState(() {
                    _lampiran = files;
                  });
                },
              ),

              const SizedBox(height: 8),
              const Text(
                "Unggah maksimal 3 file (media/dokumen), dengan ukuran hingga 50MB",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL BUAT TUGAS DINAMIS ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Tombol aktif jika form valid, jika tidak, null (disabled)
                  onPressed: _isFormValid()
                      ? () {
                          // Logika saat tombol ditekan
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Tugas Dibuat!'),
                                backgroundColor: Colors.green),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    // Warna berubah berdasarkan validitas
                    backgroundColor:
                        _isFormValid() ? const Color(0xFF0071CE) : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Buat Tugas',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET HELPER tidak berubah
  Widget _priorityChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        border:
            Border.all(color: selected ? const Color(0xFF0071CE) : Colors.grey),
        borderRadius: BorderRadius.circular(30),
        color: selected ? const Color(0x1A0071CE) : Colors.transparent,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFF0071CE) : Colors.grey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // WIDGET HELPER tidak berubah
  Widget buildTextField({
    required String label,
    required String hintText,
    TextEditingController? controller,
    bool readOnly = false,
    int maxLines = 1,
    IconData? suffixIcon,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            onTap: onTap,
            style: const TextStyle(color: Colors.black), // Warna teks input
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey), // Warna hint
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Colors.grey),
              ),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER BARU UNTUK DROPDOWN ---
  Widget buildDropdownField({
    required String label,
    required String hintText,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.black)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            hint: Text(hintText),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.grey)),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// Widget DottedBorderBox tidak berubah
class DottedBorderBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
            color: Colors.grey.shade400, style: BorderStyle.solid, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_photo_alternate_outlined, color: Colors.grey),
            SizedBox(height: 4),
            Text("Tambah Foto atau File", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
