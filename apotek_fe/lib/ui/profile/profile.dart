import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apotek_fe/ui/authpage/register/screen/body.dart';
import 'package:apotek_fe/ui/crud/update_user.dart';
import 'package:apotek_fe/ui/home/widgets/home_bottom_bar.dart';
import 'package:apotek_fe/utils/api-service/get_user.dart';

class ProfilePage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const ProfilePage(
      {Key? key, required this.selectedIndex, required this.onItemTapped})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userId = '';
  String userEmail = '';
  String userName = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
    });
    await _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final userData = await getUser(userId);
      setState(() {
        userId = userData['id'];
        userEmail = userData['email'];
        userName = userData['fullname'] ?? '';
        imageUrl = userData['imageUrl'];
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var url = dotenv.env['URL'];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 10.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Profile', style: TextStyle(color: Colors.white)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00BF62), Color(0xFF008040)],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage('$url$imageUrl')
                        : AssetImage('/images/default.jpeg') as ImageProvider,
                    onBackgroundImageError: (_, __) {
                      setState(() {
                        imageUrl = '';
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    userName.isNotEmpty ? userName : 'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 30),
                  _buildInfoCard('User ID', userId),
                  SizedBox(height: 15),
                  _buildInfoCard('Email', userEmail),
                  SizedBox(height: 15),
                  _buildInfoCard('Full Name', userName),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            fullname: userName,
                            email: userEmail,
                            imageUrl: imageUrl,
                          ),
                        ),
                      ).then((_) => _loadUser());
                    },
                  ),
                  SizedBox(height: 20),
                  TextButton.icon(
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text('Logout', style: TextStyle(color: Colors.red)),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Body()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavbarPage(
        selectedIndex: widget.selectedIndex,
        onItemTapped: widget.onItemTapped,
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
