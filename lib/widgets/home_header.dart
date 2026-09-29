import 'package:flutter/material.dart';

import '../models/user_model.dart';

class HomeHeader extends StatelessWidget {

  final UserModel user;

  const HomeHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 20,
      ),

      child: Row(
        children: [
        _buildProfileImage(),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  'Namaste,',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),


          _buildNotificationIcon(),


          const SizedBox(width: 20),

          IconButton(
            onPressed: () {
              // Menu action will be handled later.
            },

            icon: const Icon(
              Icons.menu,
              size: 38,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileImage() {


    if (user.profileImageUrl != null &&
        user.profileImageUrl!.isNotEmpty) {

      return CircleAvatar(
        radius: 38,

        backgroundImage: NetworkImage(
          user.profileImageUrl!,
        ),
      );
    }


    return CircleAvatar(
      radius: 38,

      backgroundColor: const Color(0xFF7042A5),

      child: Text(
        user.initials,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {

    return Stack(
      clipBehavior: Clip.none,

      children: [

        const Icon(
          Icons.notifications_none,
          size: 38,
          color: Colors.black87,
        ),

        if (user.unreadNotifications > 0)

          Positioned(
            right: 0,
            top: 0,

            child: Container(
              width: 12,
              height: 12,

              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}