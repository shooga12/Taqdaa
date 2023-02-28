import 'package:flutter/material.dart';
import '../confige/EcommerceApp.dart';
import '../models/invoice.dart';

class invoice_afterPayment extends StatefulWidget {
  final invoice;
  const invoice_afterPayment(this.invoice, {super.key});
  @override
  State<invoice_afterPayment> createState() =>
      _invoiceafterPaymentState(invoice);
}

class _invoiceafterPaymentState extends State<invoice_afterPayment> {
  Invoice? invoice;
  dynamic itemsList;

  _invoiceafterPaymentState(invoice) {
    this.invoice = invoice;
    //this.itemsList = invoice?.items;
  }
  int count = -1;

  Widget build(BuildContext context) {
    int earned = (invoice!.total! * 2) ~/ 100;
    int offerDiscpunt = invoice!.total! * 20 ~/ 100;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:Color(0xFF535353), //change your color here
        ),
        automaticallyImplyLeading: true,
        title: Text(
          "تفاصيل الفاتورة",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w100,
              fontFamily: 'Tajawal',
              color: Color(0xFF636363)
          ),
        ),
        shadowColor:Color(0x41C4C4C4) ,
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20, right: 20),
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
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "المتجر: ${invoice!.store}",
                    style: new TextStyle(
                      fontSize: 18,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "${invoice!.date}",
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                        fontFamily: 'Tajawal'
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
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
            SizedBox(
              height: 5,
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
                  SizedBox(height: 5,),
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
                  SizedBox(
                    height: 5.0,
                  ),
                  if (invoice!.store == "Sephora" || invoice!.store == "H&M")
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('عرض الإجازة',
                              style: TextStyle(
                                color: Color.fromARGB(255, 227, 45, 45),
                                fontSize: 15,
                                  fontFamily: 'Tajawal'
                              )),
                        ),
                        Spacer(),
                        Text('- $offerDiscpunt ريال',
                            style: TextStyle(
                              color: Color.fromARGB(255, 227, 45, 45),
                              fontSize: 15,
                                fontFamily: 'Tajawal'
                            )),
                      ],
                    ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (invoice!.rewardsDiscount != 0)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('نـقـاطـي',
                              style: TextStyle(
                                color: Color.fromARGB(255, 227, 45, 45),
                                fontSize: 15,
                                  fontFamily: 'Tajawal'
                              )),
                        ),
                        Spacer(),
                        Text('- ${invoice!.rewardsDiscount} ريال',
                            style: TextStyle(
                              color: Color.fromARGB(255, 227, 45, 45),
                              fontSize: 15,
                                fontFamily: 'Tajawal'
                            )),
                      ],
                    ),
                  SizedBox(
                    height: 15.0,
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
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('تم اكتسـاب',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 15,
                                fontFamily: 'Tajawal'
                            )),
                      ),
                      Spacer(),
                      Text('+ $earned نقطة',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                              fontFamily: 'Tajawal'
                          )),
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
                Padding(
                  padding: const EdgeInsets.only(right: 0, top: 2.5),
                  child: Container(
                    height: 90,
                    margin: EdgeInsets.all(10),
                    child: ClipRRect(
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
                    color: Color.fromARGB(255, 7, 7, 7),
                      fontFamily: 'Tajawal'
                  ),
                ),
                if (item.size != "")
                  Text(
                    "المـقاس : " + item.size,
                    style: new TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 9, 9, 9),
                        fontFamily: 'Tajawal'
                    ),
                  ),
                Text(
                  "  السعر : " + item.price.toString() + ' ريال',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 10, 10, 10),
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
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Text("  "),
          ],
        ),
      ),
      color: Color.fromARGB(255, 255, 255, 255),
    );
  }
}
