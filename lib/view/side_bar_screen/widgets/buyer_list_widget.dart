import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyerListWidget extends StatelessWidget {
  const BuyerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> buyerStream = FirebaseFirestore.instance
        .collection('buyers')
        .snapshots();

    Widget BuyerData(Widget widget, int? flex) {
      return Expanded(
        flex: flex!,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2A3441),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: widget,
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: buyerStream,
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
                    "Loading buyers...",
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
                    Icons.person_off_outlined,
                    size: 48,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No buyers found",
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
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final buyer = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    BuyerData(
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF374151),
                          backgroundImage: NetworkImage(
                            "https://ui-avatars.com/api/?name=${Uri.encodeComponent(buyer['fullName'])}&background=4F46E5&color=fff&size=128"
                          ),
                          onBackgroundImageError: (_, __) {
                            return;
                          },
                          child: Text(
                            buyer['fullName'].toString().isNotEmpty
                                ? buyer['fullName'][0].toUpperCase()
                                : "?",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      1,
                    ),
                    BuyerData(
                      Text(
                        buyer['fullName'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      3,
                    ),
                    BuyerData(
                      Text(
                        buyer['streetAddress'] ?? "No address provided",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      3,
                    ),
                    BuyerData(
                      Text(
                        buyer['email'],
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      3,
                    ),
                    BuyerData(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.visibility_outlined, color: Color(0xFF4F46E5)),
                            tooltip: "View Details",
                            splashRadius: 20,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.block_outlined, color: Color(0xFFEF4444)),
                            tooltip: "Block User",
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      2,
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