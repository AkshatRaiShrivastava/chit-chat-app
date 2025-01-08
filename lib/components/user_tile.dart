import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class UserTile extends StatelessWidget {
  final String email;
  final String name;
  final void Function()? onTap;
  const UserTile({super.key,required this.name, required this.email, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),

        ),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            ProfilePicture(
              name: name, radius: 20, fontsize: 20,
            ),
            SizedBox(width: 15,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 18),),
                Text(email,style: TextStyle(fontSize: 12),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
