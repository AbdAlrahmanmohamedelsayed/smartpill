import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var media = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 5),
              width: media.size.width,
              height: media.size.height * .24,
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    width: 40,
                  ),
                  Text(
                    'Doctor',
                    style: theme.textTheme.titleLarge,
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                height: 120,
                width: 5,
                color: Colors.green,
              ),
              subtitle: Text(
                'User state available ',
                style: theme.textTheme.bodySmall,
              ),
              title: Container(
                margin: const EdgeInsets.only(right: 10, bottom: 10),
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    prefixIcon: Icon(
                      Icons.person,
                      color: theme.primaryColor,
                    ),
                    hintText: 'Enter User ID',
                    hintStyle: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black38,
                    ),
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: theme.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: theme.primaryColor),
                    ),
                  ),
                ),
              ),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.green),
                  onPressed: () {},
                  child: Image.asset(
                    width: 35,
                    'assets/images/icons/Icon awesome-check.png',
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
