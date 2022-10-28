import 'package:flutter/material.dart';
import '../model/invoice.dart';
// import '../models/invoice.dart';
import 'ReturnRequest.dart';

class invoice_details extends StatefulWidget {
  final invoice;
  const invoice_details(this.invoice, {super.key});
  @override
  State<invoice_details> createState() => _invoicesDetailsState(invoice);
}

class _invoicesDetailsState extends State<invoice_details> {
  Invoice? invoice;
  dynamic itemsList;

  _invoicesDetailsState(invoice) {
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
          "تفاصيل الفاتورة",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w100),
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
                    ),
                  ),
                  Text(
                    "المتجر: ${invoice!.store}",
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "${invoice!.date}",
                    style: new TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "المنتجات",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 22,
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
                        ),
                      ),
                      Row(
                        children: [
                          Text("${invoice!.sub_total}"),
                          Text(' ريال')
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
                        ),
                      ),
                      Row(
                        children: [
                          Text("${invoice!.vat_total}"),
                          Text(
                            ' ريال',
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
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
                              )),
                        ),
                        Spacer(),
                        Text('- ${invoice!.rewardsDiscount} ريال',
                            style: TextStyle(
                              color: Color.fromARGB(255, 227, 45, 45),
                              fontSize: 15,
                            )),
                      ],
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إجمالي الفاتورة",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Text(
                            "${invoice!.total}",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            ' ريال',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  returnButton(invoice)
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

  returnButton(invoice) {
    canReturn(invoice!.returnDays);
    if (invoice!.HaveReturnReq == false && !invoice.isExpired) {
      return SizedBox(
        width: 200,
        height: 40,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => returnRequest(invoice)),
            );
          },
          child: Text(
            'طلب استرجاع',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.grey;
                }
                return Colors.orange;
              }),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)))),
        ),
      );
    } else if (invoice!.HaveReturnReq == true || invoice.isExpired) {
      return Column(
        children: [
          SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                'طلب استرجاع',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.grey;
                    }
                    return Colors.grey;
                  }),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Card(
              color: Color.fromARGB(243, 243, 239, 231),
              child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  width: 370,
                  child: Row(
                    children: [
                      Text("   "),
                      Icon(Icons.info_outline_rounded),
                      if (invoice.isExpired)
                        Text(
                          " لقد انتهت مهلة الترجيع لطلبك ",
                          style: TextStyle(fontSize: 15.5, letterSpacing: 0.8),
                        ),
                      if (!invoice.isExpired)
                        Text(
                          " لديك طلب ترجيع قيد الانتظار",
                          style: TextStyle(fontSize: 15.5, letterSpacing: 0.8),
                        ),
                    ],
                  )),
            ),
          )
        ],
      );
    }
  }

  Widget buildSecondItems(dynamic item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
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
                    " " + item.name,
                    style: new TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 32, 7, 121),
                    ),
                  ),
                  Text(
                    "  السعر : " + item.price.toString() + ' ريال',
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 77, 76, 76),
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
        color: Color.fromARGB(255, 248, 248, 246),
      ),
    );
  }

  canReturn(int days) {
    var now = new DateTime.now(); //14
    var dateReturn = invoice!.Fulldate!
        .add(Duration(days: days + 1)); //after last date  //9+(5+1)=15

    if (now == dateReturn) {
      invoice!.isExpired = true;
    }
  }
}
