import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taqdaa_application/model/invoice.dart';
import 'package:taqdaa_application/model/item.dart';

import '../confige/EcommerceApp.dart';
import '../controller/BNBCustomePainter.dart';
import '../main.dart';
import '../profile/homep_profile.dart';
import 'NoItmesCart.dart';
import 'ShoppingCart.dart';
import 'home_page.dart';
import 'insideMore.dart';
import 'ReturnRequest.dart';
import 'list_of_stores.dart';
import '../model/item.dart';
class invoice_details extends StatefulWidget {
  final invoice;
  const invoice_details(this.invoice,{super.key});
  @override
  State<invoice_details> createState() => _invoicesDetailsState(invoice);
}

class _invoicesDetailsState extends State<invoice_details> {

  Invoice? invoice;
  dynamic itemsList;
  _invoicesDetailsState(invoice){
    this.invoice = invoice;
    //this.itemsList = invoice?.items;
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
          style: TextStyle(fontSize: 24),
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
      body:
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom:15.0, left:20, right:20),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(height: 5,),
            Expanded(
              child:
                ListView.builder(
                          itemCount: invoice?.items.length,
                          itemBuilder: (context, index) {
                            return buildItemCard(invoice?.items[index], context);
                          }

                      ),

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
                          Text(
                              "SR "
                          ),
                          Text(
                              "${invoice!.sub_total}"
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
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                              "SR "
                          ),
                          Text(
                              "${invoice!.vat_total}"
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "إجمالي الفاتورة",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "SR ",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            "${invoice!.total}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40.0,),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => returnRequest()),
                          );
                        },
                        child: Text(
                          'طلب استرجاع',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.grey;
                              }
                              return Colors.orange;
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30)))),
                      ),
                    ),
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
  buildItemCard(dynamic item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                '${item.img}',
                height: 60,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.name}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text(
                          " الكمية: ${item.quantity}",

                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "SR",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "${item.price}",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
