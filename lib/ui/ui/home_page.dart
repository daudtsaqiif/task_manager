part of '../pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userId;
  late Future<Map<String, dynamic>> userData;

  final FirebaseService _auth = FirebaseService();

  @override
  void initState() {
    super.initState();

    User? user = _auth.currentUser;

    userId = user!.uid;
    userData = _auth.getUserData(userId!);
  }

  void _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/sign-in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return ListView(
            children: [
              Column(
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
                              backgroundImage:
                                  const AssetImage("assets/images/mulogo.png"),
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons.flip_camera_android_outlined,
                                        size: 30,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'On going',
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons.access_time,
                                        size: 30,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                        Row(
                          children: [
                            Expanded(
                              child: Container(
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
                                        color: const Color.fromARGB(
                                            73, 192, 190, 190),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons.task_outlined,
                                        size: 30,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                width: 190,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: mainColor,
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
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        size: 30,
                                        color: whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Canceled',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.99,
                          height: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: balckColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
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
                                      "BELAJAR MASAK",
                                      style:
                                          titleTextStyle.copyWith(fontSize: 19),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Text(
                                      'Bersama chef juna di bogor',
                                      style: subTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month_outlined),
                                        Text(
                                          '19-03-25',
                                          style: defaultTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 9.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.flip_camera_android_outlined,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 23),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.99,
                          height: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: balckColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
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
                                      "BELAJAR MASAK",
                                      style:
                                          titleTextStyle.copyWith(fontSize: 19),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Text(
                                      'Bersama chef juna di bogor',
                                      style: subTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month_outlined),
                                        Text(
                                          '19-03-25',
                                          style: defaultTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 9.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: yellowColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.access_time,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 23),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.99,
                          height: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: balckColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
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
                                      "BELAJAR MASAK",
                                      style:
                                          titleTextStyle.copyWith(fontSize: 19),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Text(
                                      'Bersama chef juna di bogor',
                                      style: subTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month_outlined),
                                        Text(
                                          '19-03-25',
                                          style: defaultTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 9.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: greenColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.task_outlined,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 23),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.99,
                          height: 90,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: balckColor,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
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
                                      "BELAJAR MASAK",
                                      style:
                                          titleTextStyle.copyWith(fontSize: 19),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Text(
                                      'Bersama chef juna di bogor',
                                      style: subTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_month_outlined),
                                        Text(
                                          '19-03-25',
                                          style: defaultTextStyle.copyWith(
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 9.0),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size: 30,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 23),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
