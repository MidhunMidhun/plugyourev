import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/bottom_navbar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // //Bottom navbar
  // int _currentIndex = 3;

  // void _onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  void signOutUser() async {
    await AuthMethods().signOut();
  }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Color.fromARGB(255, 146, 128, 128),
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 135),
                child: SizedBox(
                  height: 115,
                  width: 115,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/pro_pic.jpg'),
                      ),
                      Positioned(
                        right: -12,
                        bottom: 0,
                        child: SizedBox(
                            height: 46,
                            width: 46,
                            child: FloatingActionButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.white)),
                              onPressed: () {},
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.camera_alt,
                                  )),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ProfileMenu(
            icon: Icons.person_outline,
            text: 'My Account',
            press: () {},
          ),
          ProfileMenu(
            icon: Icons.notifications_outlined,
            text: 'Notifications',
            press: () {},
          ),
          ProfileMenu(
            icon: Icons.settings_outlined,
            text: 'Settings',
            press: () {},
          ),
          ProfileMenu(
            icon: Icons.question_mark_outlined,
            text: 'Help Center',
            press: () {},
          ),
          ProfileMenu(
            icon: Icons.logout_outlined,
            text: 'Log Out',
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => MyLogin()));
              signOutUser();
            },
          ),
        ],
      ),
      // bottomNavigationBar: MyBottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTabTapped: _onTabTapped,
      // ),
      // //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF5F6F9),
            padding: EdgeInsets.all(10),
          ),
          onPressed: press,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(icon),
                color: Color.fromARGB(255, 117, 116, 116),
                iconSize: 30,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Color.fromARGB(255, 117, 116, 116)),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              )
            ],
          )),
    );
  }
}
