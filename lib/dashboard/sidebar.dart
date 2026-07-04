
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/user_models.dart';
import 'menu_items.dart';

class Sidebar extends StatelessWidget {
  final UserModel user;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.user,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffFFE0B2).withValues(alpha: 0.15),
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
            user.imageUrl != null
                ? NetworkImage(user.imageUrl!)
                : null,
            child: user.imageUrl == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),

          SizedBox(height: 10),

          Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          //Text(user.role),

          SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return ListTile(
                  iconColor: Color(0xFFFFA726),
                  selected: selectedIndex == index,
                  leading: Icon(item.$1),
                  title: Text(item.$2.tr),
                  onTap: () => onItemSelected(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}