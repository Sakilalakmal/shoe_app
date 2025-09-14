import 'package:flutter/material.dart';
import 'package:shoe_app_assigment/utils/constants/text_string.dart';
import 'package:shoe_app_assigment/views/screen/inner_screens/widget/ShoeOrderCardWidget.dart';

class OrderDetailsScreen extends StatefulWidget {
  final dynamic orderData;

  const OrderDetailsScreen({super.key, required this.orderData});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Texts.orderDetails,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          ShoeOrderCard(
            shoeImage: widget.orderData['shoeImage'],
            shoeName: widget.orderData['shoeName'],
            shoeCategory: widget.orderData['shoeCategory'],
            quantity: widget.orderData['quantity'],
            shoeSizes: widget.orderData['shoeSizes'],
            shoePrice: widget.orderData['shoePrice'],
            orderId: widget.orderData['orderId'],
            createdAt: widget.orderData['createdAt'],
            delivered: widget.orderData['delivered'],
            processing:widget.orderData['processing'],
          ),
        ],
      ),
    );
  }
}
