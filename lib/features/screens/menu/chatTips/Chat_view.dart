import 'package:flutter/material.dart';
import 'package:smartpill/core/theme/color_pallets.dart';

class ChatView extends StatelessWidget {
   ChatView({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var medi = MediaQuery.of(context);
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Tips'),
        leading: const BackButton(),
      ),
      body:  Column(
        children: [
      const Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text("please enter below your symptoms or how you are feeling",
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style:TextStyle(color: AppColor.primaryColor),),
                )
              ],
            ),
      ),
    ),  Padding(
       padding: EdgeInsets.all(8.0),
       child: Row(
         children: [
           Expanded(
             child: TextField(
               style: TextStyle(fontSize: 20),
               controller: _controller,
               maxLines: null,
               decoration: InputDecoration(
                 hintStyle: TextStyle(
                   color: AppColor.textColorHint, // Change this to your desired color
                   fontSize: 18, // Optional: Adjust the font size of the hint text
                 ),
                 hintText: "How Are You Feeling At The Moment",
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(30),
                   borderSide: BorderSide(
                     color: AppColor.primaryColor,
                     width: 2.0,
                     style: BorderStyle.solid
                   )
                 ),
                 focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(30),
                     borderSide: BorderSide(
                         color: AppColor.primaryColor,
                         width: 2.0,
                         style: BorderStyle.solid
                     )
                 ),
                 enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide(
                         color: Colors.black,
                         width: 2.0,
                         style: BorderStyle.solid
                     )
                 ),
               ),
             ),
           ),
           IconButton(
             icon: Icon(Icons.send),
             onPressed: () {},
                    ),
                ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical:15.0),
            child: Text("always check the tips provided in case of critical conditions",
            style: TextStyle(color: Colors.blueGrey,
                fontSize:13 ,
            fontWeight: FontWeight.bold,)
            ),
          ),
        ],
      ),
    );
  }
}
