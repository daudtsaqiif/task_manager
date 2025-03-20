part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    priority = ['Low', 'Medium', 'High'];
    listPriority = priority![0];
    super.initState();

    User? user = _auth.currentUser;

    userId = user!.uid;
    userData = _auth.getUserData(userId!);
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  int currentIndex = 0;

  String? userId;
  late Future<Map<String, dynamic>> userData;

  final FirebaseService _auth = FirebaseService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<String>? priority;
  String? listPriority;

//date
  void _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

//make task
  void _makeTask() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, saveDialog) {
            return AlertDialog(
              title: Text(
                'Create New Task',
                style: titleTextStyle,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      hintText: 'Date',
                      prefixIcon: Icon(Icons.date_range_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () {
                      _selectDate();
                    },
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black54,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.priority_high_outlined),
                        Text(
                          "Priority: ",
                          style: subTextStyle.copyWith(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton(
                          value: listPriority,
                          items: priority!
                              .map((e) =>
                                  DropdownMenuItem(child: Text(e), value: e))
                              .toList(),
                          onChanged: (item) {
                            saveDialog(() {
                              setState(() {
                                listPriority = item.toString();
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String title = _titleController.text.trim();
                    String description = _descriptionController.text.trim();
                    if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('cannot be empty.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      await _auth.addTask(
                          _titleController.text,
                          _descriptionController.text,
                          _dateController.text,
                          listPriority!);
                    }
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task has been created'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text('Create'),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _makeTask();
        },
        backgroundColor: mainColor,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.home, color: mainColor), onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.calendar_today, color: mainColor),
                  onPressed: () {}),
              SizedBox(width: 40),
              IconButton(
                  icon: Icon(Icons.task_outlined, color: mainColor),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.person, color: mainColor), onPressed: () {}),
            ],
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User data not found'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        null;
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 33,
                          ),
                          Positioned(
                            child: Icon(
                              Icons.camera_alt,
                            ),
                            bottom: 0,
                            right: 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi ${snapshot.data!['first_name']}👋',
                          style: welcomeTextStyle.copyWith(fontSize: 25),
                        ),
                        Text(
                          'Your daily advanture starts now!',
                          style: subTextStyle.copyWith(fontSize: 14),
                        )
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _signOut,
                      child: Icon(Icons.logout_rounded,
                          color: mainColor, size: 35),
                    ),
                    const Spacer()
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 190,
                              height: 90,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          73, 192, 190, 190),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      Icons.flip_camera_android_outlined,
                                      size: 30,
                                      color: whiteColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Not Yet',
                                        style: titleTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '100 Taks',
                                        style: subTextStyle.copyWith(
                                          color: greeyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              width: 190,
                              height: 90,
                              decoration: BoxDecoration(
                                color: yellowColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          73, 192, 190, 190),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Icon(
                                      Icons.access_time,
                                      size: 30,
                                      color: whiteColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'In Process',
                                        style: titleTextStyle.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '100 Taks',
                                        style: subTextStyle.copyWith(
                                          color: greeyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 190,
                        height: 90,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(73, 192, 190, 190),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.task_outlined,
                                size: 30,
                                color: whiteColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Completed',
                                  style: titleTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  '100 Taks',
                                  style: subTextStyle.copyWith(
                                    color: greeyColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Recent Task',
                    style: titleTextStyle,
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: _auth.getTask(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error fetching data'),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No data found'),
                      );
                    }

                    return Column(
                      children: snapshot.data!.docs.map((e) {
                        String priority = e['priority']; // Priority task
                        String status =
                            e['status']; // Status task (Done / Not Done)
                        String taskId = e.id; // ID task di Firestore

                        Color cardColor;
                        IconData iconData;
                        Color iconColor;
                        String newStatus =
                            status == "Hasen't started" ? "Not Done" : "Done";

                        // Tentukan warna dan ikon berdasarkan priority
                        switch (priority.toLowerCase()) {
                          case 'low':
                            cardColor = greenColor;
                            iconData = Icons.check_circle_outline;
                            break;
                          case 'medium':
                            cardColor = yellowColor;
                            iconData = Icons.access_time;
                            break;
                          case 'high':
                          default:
                            cardColor = mainColor;
                            iconData = Icons.priority_high;
                            break;
                        }

                        // Tentukan warna ikon berdasarkan status
                        iconColor =
                            status == "Done" ? Colors.grey : Colors.white;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.99,
                            height: 90,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: balckColor,
                                width: 2,
                              ),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 9.0),
                                      child: Text(
                                        e['title'],
                                        style: titleTextStyle.copyWith(
                                            fontSize: 19),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 9.0),
                                      child: Text(
                                        'Status: $status', // Menampilkan status
                                        style: subTextStyle.copyWith(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 9.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons.calendar_month_outlined),
                                          Text(
                                            e['date'],
                                            style: defaultTextStyle.copyWith(
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // Update status di Firebase
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .collection('task')
                                        .doc(taskId)
                                        .update({'status': newStatus});

                                    // Beri umpan balik kepada pengguna
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "Status updated to $newStatus"),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 9.0),
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons
                                            .done, // Ikon klik untuk mengubah status
                                        size: 30,
                                        color: iconColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
