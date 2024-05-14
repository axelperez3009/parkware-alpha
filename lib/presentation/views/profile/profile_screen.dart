import 'package:flutter/material.dart';
import 'package:parkware/presentation/views/login/login_screen.dart';
import 'package:parkware/controllers/user_controller.dart';
import 'package:parkware/presentation/views/purchases/purchases_screen.dart';
import 'package:parkware/presentation/views/help/help_screen.dart';
import 'package:parkware/presentation/views/notifications/notifications_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.green, // Color de fondo para la parte superior
            padding: EdgeInsets.all(20),
            child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    CircleAvatar(
      radius: 40,
      foregroundImage: NetworkImage(UserController.user?.photoURL ?? ''),
    ),
    Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          UserController.user?.displayName ?? '',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    ),
    SizedBox(width: 10),
  ],
),

          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Mis Compras'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificaciones'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationListPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('¿Necesitas Ayuda?'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HelpPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () async {
                await UserController.signOut();
                if (mounted) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                }
              },
              child: Text("Cerrar Sesión"),
            ),
          ),
        ],
      ),
    );
  }
}
