import 'package:flutter/material.dart';


class DrawerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width*.75,
      child: Column(
        children: [
          Stack(
            children: [
              // Image
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                  image: DecorationImage(
                    image: AssetImage('assets/images/drawer.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // Green Shadow
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
                  color: Colors.grey.withOpacity(0.8),
                ),
                child: Center(child: Text('Version: 1.0.0', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)),// Semi-transparent green color
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => NewOrderScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('More Apps'),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => TotalDeliveryScreen()));
            },
            child: ListTile(
              leading: Icon(Icons.share),
              title: Text('Share App'),
            ),
          ),
          //
        ],
      ),
    );
  }
}