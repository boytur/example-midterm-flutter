import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SETravelApp());
}

class SETravelApp extends StatelessWidget {
  const SETravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SE-Travel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProductListPage(),
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<dynamic> hotels = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      // โหลดไฟล์ JSON จาก assets
      final String jsonString =
          await rootBundle.loadString('assets/data/hotel_data.json');
      final jsonData = jsonDecode(jsonString);

      setState(() {
        hotels = jsonData;
      });

      pragma(jsonString);
    } catch (e) {
      // กรณีเกิดข้อผิดพลาด
      print('Error loading products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('SE Travel'),
        ),
      ),
      body: hotels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                return HotelTile(
                    name: hotels[index]['name'],
                    image: hotels[index]['image'],
                    price: hotels[index]['price'],
                    location: hotels[index]['location'],
                    detail: hotels[index]['detail'],
                    amenities: List.from(hotels[index]['amenities']));
              },
            ),
    );
  }
}

class HotelTile extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String location;
  final String detail;
  final List<String> amenities;

  const HotelTile(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.location,
      required this.detail,
      required this.amenities});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HotelDetailPage(
              name: name,
              image: image,
              price: price,
              location: location,
              detail: detail,
              amenities: amenities),
        ),
      )),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/' + image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  "฿" "$price" "/" "คืน",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HotelDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final int price;
  final String location;
  final String detail;
  final List<String> amenities;

  const HotelDetailPage(
      {super.key,
      required this.name,
      required this.image,
      required this.price,
      required this.location,
      required this.detail,
      required this.amenities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            onPressed: () => (),
            icon: const Icon(Icons.favorite_border_outlined),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/' + image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.red),
                        Text(
                          location,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                      ],
                    ),
                    Text(
                      "฿" "$price" "/คืน",
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(detail)
                ),
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: amenities
                          .map<Widget>((e) => Row(
                            children: [
                              Icon(Icons.check),
                              Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                    ),
                              ),
                            ],
                          ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              child: ElevatedButton(
                  child: const Text('จองห้องพัก'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
