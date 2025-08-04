import 'package:flutter/material.dart';
import 'package:profile/src/presentation/pages/index/sections/add_tugas.dart';
import 'package:profile/src/presentation/pages/index/sections/detail_tugas.dart';

class Tugas extends StatefulWidget {
  const Tugas({Key? key}) : super(key: key);

  @override
  State<Tugas> createState() => _TugasState();
}

class _TugasState extends State<Tugas> {
  final tabs = ["Tugas", "Proses", "Tinjau", "Selesai"];
  int selectedTabIndex = 0;

  String selectedPrioritas = "Semua";
  String selectedPeriode = "";

  final allTasks = [
    {"status": "Belum Dikerjakan", "priority": "High", "tab": "Tugas"},
    {"status": "Sedang Diproses", "priority": "Low", "tab": "Proses"},
    {"status": "Menunggu Tinjauan", "priority": "Medium", "tab": "Tinjau"},
    {"status": "Selesai", "priority": "High", "tab": "Selesai"},
  ];

  Color getPriorityColor(String p) {
    switch (p) {
      case 'High':
        return Colors.red.shade100;
      case 'Medium':
        return Colors.yellow.shade100;
      case 'Low':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color getPriorityTextColor(String p) {
    switch (p) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterBottomSheet(
        selectedTahapan: tabs[selectedTabIndex],
        selectedPrioritas: selectedPrioritas,
        selectedPeriode: selectedPeriode,
      ),
    );

    if (result != null) {
      setState(() {
        selectedTabIndex = tabs.indexOf(result['tahapan']!);
        selectedPrioritas = result['prioritas']!;
        selectedPeriode = result['periode']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs[selectedTabIndex];
    final tasks = allTasks.where((t) {
      final matchTab = t['tab'] == selectedTab;
      final matchPriority =
          selectedPrioritas == "Semua" || t['priority'] == selectedPrioritas;
      return matchTab && matchPriority;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tugas',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white, // background TabBar putih
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                dividerColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Tugas'),
                  Tab(text: 'Manage Tugas'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab Tugas
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Cari Tugas',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[600]),
                                      prefixIcon: Icon(Icons.search,
                                          color: Colors.grey[600]),
                                      filled: true,
                                      fillColor: Colors.grey[100],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _openFilterSheet,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.filter_alt_outlined,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                tabs.length,
                                (index) {
                                  final selected = index == selectedTabIndex;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedTabIndex = index;
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: selected
                                              ? Colors.blue.shade100
                                              : Colors.white,
                                          side: BorderSide(
                                            color: selected
                                                ? Colors.blue
                                                : Colors.grey.shade300,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                        ),
                                        child: Text(
                                          tabs[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: selected
                                                ? Colors.blue
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: tasks.isEmpty
                            ? const Center(child: Text("Tidak ada tugas"))
                            : ListView.separated(
                                padding: const EdgeInsets.all(16),
                                itemCount: tasks.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (_, index) {
                                  final task = tasks[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              DetailTugas(status: task['tab']!),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("11 Apr 2025, 9:24 AM",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .grey.shade600)),
                                              Text(" - ${task['status']}",
                                                  style: TextStyle(
                                                      color:
                                                          getPriorityTextColor(
                                                              task[
                                                                  'priority']!),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          const SizedBox(height: 30),
                                          Row(
                                            children: [
                                              const CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    'https://randomuser.me/api/portraits/men/1.jpg'),
                                              ),
                                              const SizedBox(width: 10),
                                              const Text("PM Hidayat",
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              const Spacer(),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: getPriorityColor(
                                                      task['priority']!),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  task['priority']!,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: getPriorityTextColor(
                                                        task['priority']!),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            "Pembersihan Ruangan Dokter",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  ManageTugas()
                  // Ganti sesuai kebutuhanmu
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageTugas extends StatefulWidget {
  const ManageTugas({Key? key}) : super(key: key);

  @override
  State<ManageTugas> createState() => _ManageTugasState();
}

class _ManageTugasState extends State<ManageTugas> {
  final tabs = ["Tugas", "Proses", "Tinjau", "Selesai"];
  int selectedTabIndex = 0;

  String selectedPrioritas = "Semua";
  String selectedPeriode = "";

  final allTasks = [
    {"status": "Belum Dikerjakan", "priority": "High", "tab": "Tugas"},
    {"status": "Sedang Diproses", "priority": "Low", "tab": "Proses"},
    {"status": "Menunggu Tinjauan", "priority": "Medium", "tab": "Tinjau"},
    {"status": "Selesai", "priority": "High", "tab": "Selesai"},
  ];

  Color getPriorityColor(String p) {
    switch (p) {
      case 'High':
        return Colors.red.shade100;
      case 'Medium':
        return Colors.yellow.shade100;
      case 'Low':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  Color getPriorityTextColor(String p) {
    switch (p) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _openFilterSheet() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterBottomSheet(
        selectedTahapan: tabs[selectedTabIndex],
        selectedPrioritas: selectedPrioritas,
        selectedPeriode: selectedPeriode,
      ),
    );

    if (result != null) {
      setState(() {
        selectedTabIndex = tabs.indexOf(result['tahapan']!);
        selectedPrioritas = result['prioritas']!;
        selectedPeriode = result['periode']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs[selectedTabIndex];
    final tasks = allTasks.where((t) {
      final matchTab = t['tab'] == selectedTab;
      final matchPriority =
          selectedPrioritas == "Semua" || t['priority'] == selectedPrioritas;
      return matchTab && matchPriority;
    }).toList();
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BuatTugasScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Buat Tugas Baru',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0071CE),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // tanpa radius
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Tugas',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[600]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _openFilterSheet,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.filter_alt_outlined,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    tabs.length,
                    (index) {
                      final selected = index == selectedTabIndex;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedTabIndex = index;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: selected
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              side: BorderSide(
                                color: selected
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: selected ? Colors.blue : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("Tidak ada tugas"))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final task = tasks[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailTugas(status: task['tab']!),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("11 Apr 2025, 9:24 AM",
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                  Text(" - ${task['status']}",
                                      style: TextStyle(
                                          color: getPriorityTextColor(
                                              task['priority']!),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                        'https://randomuser.me/api/portraits/men/1.jpg'),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("PM Hidayat",
                                      style: TextStyle(color: Colors.black)),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color:
                                          getPriorityColor(task['priority']!),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      task['priority']!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: getPriorityTextColor(
                                            task['priority']!),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Pembersihan Ruangan Dokter",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final String selectedTahapan;
  final String selectedPrioritas;
  final String selectedPeriode;

  const FilterBottomSheet({
    required this.selectedTahapan,
    required this.selectedPrioritas,
    required this.selectedPeriode,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String tahapan;
  late String prioritas;
  late String periode;

  @override
  void initState() {
    super.initState();
    tahapan = widget.selectedTahapan;
    prioritas = widget.selectedPrioritas;
    periode = widget.selectedPeriode;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          child: Wrap(
            children: [
              const Text("Tahapan",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...["Tugas", "Proses", "Tinjau", "Selesai"].map(
                (e) => RadioListTile(
                  title: Text(e),
                  value: e,
                  groupValue: tahapan,
                  onChanged: (value) {
                    setState(() {
                      periode = value as String;
                    });
                  },
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const Text("Prioritas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...["Semua", "High", "Medium", "Low"].map(
                (e) => RadioListTile(
                  title: Text(e),
                  value: e,
                  groupValue: prioritas,
                  onChanged: (value) {
                    setState(() {
                      prioritas = value as String;
                    });
                  },
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const Text("Periode",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...["7 Hari Terakhir", "30 Hari Terakhir", "Pilih Tanggal"].map(
                (e) => RadioListTile(
                  title: Text(e),
                  value: e,
                  groupValue: periode,
                  onChanged: (value) {
                    setState(() {
                      periode = value as String;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      "tahapan": tahapan,
                      "prioritas": prioritas,
                      "periode": periode,
                    });
                  },
                  child: const Text("Terapkan",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
