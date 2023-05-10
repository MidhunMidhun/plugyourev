import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:plugyourev/bottom_navbar.dart';
import 'package:plugyourev/maparea.dart';

import 'bookslot.dart';

class stationpage extends StatefulWidget {
  const stationpage({super.key});

  @override
  State<stationpage> createState() => _stationpageState();
}

class _stationpageState extends State<stationpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.28,
                width: MediaQuery.of(context).size.width * 1,
                child: Image(
                  image: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 25, // Adjust the top position as needed
                left: 16, // Adjust the left position as needed
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => MyStatefulWidget()));
                    },
                  ),
                ),
              ),
            ],
          ),

          // Container(
          //     height: MediaQuery.of(context).size.height * 0.28,
          //     width: MediaQuery.of(context).size.width * 1,
          //     child: Image(
          //       image: NetworkImage(
          //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7uynsZtn6oBeQRpyLKY94qwBR-L5BGIAsL1aCR_mL&s",
          //       ),
          //       fit: BoxFit.cover,
          //     )),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EV charging station title here',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'place here',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (builder) => bookslot())),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                    child: Text(
                      'Book Slot',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
