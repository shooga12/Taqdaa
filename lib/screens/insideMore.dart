import 'package:flutter/material.dart';
import '../views/aboutUs_view.dart';
import '../views/ViewReturnRequests.dart';
import '../views/profile_view.dart';
import 'getHelp.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF3F4F8),
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildCards("حـسابي", context),
                buildCards("طلبات الاسترجاع", context),
                buildCards("احصل على مساعدة", context),
                buildCards("عن تقضّى", context),
              ],
            )),
      ),
    );
  }

  buildCards(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Container(
        child: new InkWell(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (title == "حـسابي")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person,
                      size: 40,
                      color:  //Color.fromARGB(255, 21, 42, 86),
                      Color.fromARGB(181, 128, 149, 186),
                    ),
                  ),
                if (title == "طلبات الاسترجاع")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.receipt_long,
                      size: 40,
                      color:  //Color.fromARGB(255, 21, 42, 86),
                      Color.fromARGB(181, 128, 149, 186),
                    ),
                  ),
                if (title == "احصل على مساعدة")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.contact_support,
                      size: 40,
                      color:  //Color.fromARGB(255, 21, 42, 86),
                      //Color.fromARGB(255, 254, 177, 57),
                      Color.fromARGB(181, 128, 149, 186)
                    ),
                  ),
                if (title == "عن تقضّى")
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.info,
                      size: 40,
                      color:  //Color.fromARGB(255, 21, 42, 86),
                      Color.fromARGB(181, 128, 149, 186),
                    ),
                  ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  title,
                  style: new TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 21, 42, 86),
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.w500
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_back_ios_rounded,
                  textDirection: TextDirection.ltr,
                  color:  Color.fromARGB(215, 92, 92, 92),//Color.fromARGB(255, 254, 177, 57),
                ),
              ],
            ),
          ),
          onTap: () async {
            if (title == "حـسابي") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homepprofile()),
              );
            } else if (title == "طلبات الاسترجاع") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ViewReturnReq()),
              );
            } else if (title == "أحصل على مساعدة") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => helpPage()),
              );
            } else if (title == "عن تقضّى") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            }
          },
          highlightColor: Color.fromARGB(255, 255, 255, 255),
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 241, 241, 241),
              offset: Offset.zero,
              blurRadius: 20.0,
              blurStyle: BlurStyle.normal,
            ),
          ],
        ),
      ),
    );
  }
}
