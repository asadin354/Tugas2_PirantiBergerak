import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // tambahkan di pubspec.yaml

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(), // pakai font Poppins
      ),
      home: const TodoListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Model tugas
class Task {
  String title;
  String category;
  bool isDone; // tambahan untuk status selesai
  Task(this.title, this.category, {this.isDone = false});
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  final List<String> _categories = ["Penting", "Santai", "Opsional"];
  String _selectedCategory = "Opsional"; // default kategori

  void _addTask() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(_controller.text, _selectedCategory));
        _controller.clear();
        _selectedCategory = "Opsional"; // reset kategori
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }
  Color _getCategoryTextColor(String category) {
    switch (category) {
      case "Penting":
        return Colors.red.shade700;
      case "Santai":
        return Colors.green.shade700;
      default:
        return Colors.blue.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("To Do List - Muhammad Asadin Nur"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Input task + kategori
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Tambahkan tugas...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Kategori",
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Apa yang akan anda lakukan hari ini?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.deepPurple,
              ),
            ),
          ),


          // Daftar Task
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada tugas 🎉",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            activeColor: Colors.deepPurple,
                            value: task.isDone,
                            onChanged: (value) {
                              setState(() {
                                task.isDone = value!;
                              });
                            },
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isDone
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            "Kategori: ${task.category}",
                            style: TextStyle(
                              fontSize: 13,
                              color: _getCategoryTextColor(task.category),
                            ),
                          ),
                          trailing: IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _removeTask(index),
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
