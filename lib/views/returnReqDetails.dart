import 'package:flutter/material.dart';
import '../models/returnModel.dart';

class returnReq_details extends StatefulWidget {
  final invoice;
  const returnReq_details(this.invoice, {super.key});
  @override
  State<returnReq_details> createState() => _returnReqDetailsState(invoice);
}

class _returnReqDetailsState extends State<returnReq_details> {
  returnInvoice? invoice;
  dynamic itemsList;

  _returnReqDetailsState(invoice) {
    this.invoice = invoice;
  }

  bool isInsideHome = false;
  bool isInsideReceipt = true;
  bool isInsideMore = false;
  bool isInsideCart = false;
  int count = -1;

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "طلب الاسترجاع",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal'
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Vector.png"), fit: BoxFit.fill)),
        ),
        centerTitle: true,
        toolbarHeight: 170,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "رقم الفاتورة: ${invoice!.id}",
                    style: new TextStyle(
                      fontSize: 18,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                  Text(
                    "المتجر: ${invoice!.store}",
                    style: new TextStyle(
                      fontSize: 18,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                  Text(
                    "تاريخ تقديم الطلب: ${invoice!.date}",
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "المنتجات",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 22,
                  fontFamily: 'Tajawal'
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: invoice?.items.length,
                  itemBuilder: (context, index) {
                    return buildSecondItems(invoice?.items[index], context);
                  }),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المجموع",
                        style: TextStyle(
                          fontSize: 18,
                            fontFamily: 'Tajawal'
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                              "SR ",
                            style: TextStyle(
                                fontFamily: 'Tajawal'
                            ),
                          ),
                          Text(
                              "${invoice!.sub_total}",
                            style: TextStyle(
                                fontFamily: 'Tajawal'
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الضريبة المضافة 15% ",
                        style: TextStyle(
                          fontSize: 18,
                            fontFamily: 'Tajawal'
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                              "SR ",
                            style: TextStyle(
                                fontFamily: 'Tajawal'
                            ),
                          ),
                          Text(
                              "${invoice!.vat_total}",
                            style: TextStyle(
                                fontFamily: 'Tajawal'
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إجمالي الفاتورة",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Tajawal'
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "SR ",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Tajawal'
                            ),
                          ),
                          Text(
                            "${invoice!.total}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Tajawal'
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  nothing() {
    return Container();
  }

  Widget buildSecondItems(dynamic item, BuildContext context) {
    return Container(
      child: new InkWell(
        child: Row(
          children: <Widget>[
            new Container(
              child: Stack(children: <Widget>[
                Container(
                  child: new Image.asset(
                    'assets/Rectangle.png',
                    height: 82.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25, top: 2.5),
                  child: Container(
                    width: 55,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: NetworkImage(
                          item.img,
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
            Column(
              children: <Widget>[
                Text(
                  item.name,
                  style: new TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 32, 7, 121),
                      fontFamily: 'Tajawal'
                  ),
                ),
                if (item.size != null)
                  Text(
                    "المـقاس : " + item.size,
                    style: new TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 32, 7, 121),
                        fontFamily: 'Tajawal'
                    ),
                  ),
                Text(
                  "  السعر : " + item.price.toString() + ' ريال',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 77, 76, 76),
                      fontFamily: 'Tajawal'
                  ),
                ),
              ],
            ),
            Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: new BoxDecoration(
                    color: Color.fromARGB(255, 245, 161, 14),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  item.quantity.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Tajawal'
                  ),
                )
              ],
            ),
            Text("  "),
          ],
        ),
      ),
      color: Color.fromARGB(255, 248, 248, 246),
    );
  }
}
