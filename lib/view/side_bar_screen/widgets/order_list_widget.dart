import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderListWidget extends StatelessWidget {
  const OrderListWidget({super.key});

  Widget OrderDisplayData(Widget widget, int? flex) {
    return Expanded(
      flex: flex!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFF2A3441),
          borderRadius: BorderRadius.circular(8),
        ),
        child: widget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('shoeOrders')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: GoogleFonts.poppins(color: Colors.red[300], fontSize: 16),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Color(0xFF4F46E5),
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Loading orders...",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.data!.size == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No orders found",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            final orderData = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    OrderDisplayData(
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            orderData['shoeImage'],
                            width: 58,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 58,
                                height: 50,
                                color: Color(0xFF374151),
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 58,
                                height: 50,
                                color: Color(0xFF374151),
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      1,
                    ),
                    OrderDisplayData(
                      Text(
                        orderData['fullName'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      3,
                    ),
                    OrderDisplayData(
                      Text(
                        "${orderData['locality']}, ${orderData['State']}",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      2,
                    ),
                    OrderDisplayData(
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('shoeOrders')
                              .doc(orderData['orderId'])
                              .update({'delivered': true, 'processing': false});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF059669),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: orderData['delivered'] == true
                            ? Text(
                                "delivered",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              )
                            : Text(
                                textAlign: TextAlign.center,
                                "Mark Delivered",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                      ),
                      1,
                    ),
                    OrderDisplayData(
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('shoeOrders')
                              .doc(orderData['orderId']).update({
                                'processing':false,
                                'delivered':false,
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1F2937),
                          foregroundColor: Color(0xFFEF4444),
                          elevation: 0,
                          side: BorderSide(color: Color(0xFFEF4444), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: orderData['processing'] == false && orderData['delivered'] == false ? Text('Order Cancelled')  : Text(
                          'Cancel Order',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      3,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
