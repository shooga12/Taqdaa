import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StoreDetails extends StatefulWidget {
  String? Name;
  String? url;

  StoreDetails({
    this.Name,
    this.url,
  });

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
