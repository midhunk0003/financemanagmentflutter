import 'package:flutter/material.dart';

class DashboardItemWidget extends StatelessWidget {
  const DashboardItemWidget(
      {super.key,
      required this.onTap1,
      required this.onTap2,
      required this.titleOne,
      required this.titleTwo});
  final VoidCallback onTap1;
  final VoidCallback onTap2;

  final String titleOne;
  final String titleTwo;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            // Color.fromARGB(255, 192, 223, 16),
            // Color.fromARGB(255, 11, 121, 224)
            Color.fromARGB(255, 73, 75, 64),
            Color.fromARGB(255, 149, 207, 14),
            Color.fromARGB(255, 11, 121, 224),
            Color.fromARGB(255, 60, 67, 73)
          ]),
          borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 0,
            bottom: 30,
            child: Container(
                height: 20, width: 5, color: Color.fromARGB(255, 7, 211, 18)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkResponse(
                  onTap: onTap1,
                  child: Center(
                      child: Text(titleOne,
                          style: TextStyle(color: Colors.white))),
                ),
              ),
              Container(height: 80, width: 2, color: Colors.orange),
              Expanded(
                child: InkResponse(
                  onTap: onTap2,
                  child: Center(
                      child: Text(
                    titleTwo,
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
