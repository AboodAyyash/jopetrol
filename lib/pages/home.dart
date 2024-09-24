import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jo/firebase/firebas.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [
    {"name": "Mocca", 'id': '1'},
    {"name": "Coffe", 'id': '2'},
    {"name": "Latte", 'id': '3'},
  ];

  List<Product> products = [];

  String selectedCategoryId = '0';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      categories.insert(0, {"name": "All", 'id': '0'});
    });
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('products').get();

      for (var doc in snapshot.docs) {
        Map data = doc.data() as Map;

        products.add(Product(
          name: data['name'],
          categoryId: data['categoryId'].toString(),
          desc: data['desc'],
          id: data['id'].toString(),
          image: data['image'] ?? "assets/images/logo.png",
          documnetId: doc.id.toString(),
          price: data['price'].toString(),
        ));
      }
      setState(() {});
    } on FirebaseException catch (e) {
      print('Error fetching data: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  void updateProductData(
      {required String documentId,
      required Map<Object, Object> product}) async {
    try {
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('products').doc(documentId);

      await productRef.update(product);

      print('Product name updated successfully');
    } on FirebaseException catch (e) {
      print('Error updating product: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  void addProductDataWithoutID(Map<String, dynamic> productData) async {
    try {
      // Add a new document with a randomly generated ID to the 'products' collection
      DocumentReference newDocRef =
          await FirebaseFirestore.instance.collection('cart').add(productData);

      // Print the newly created document ID
      print('Product added with ID: ${newDocRef.id}');
    } on FirebaseException catch (e) {
      print('Error adding product: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  void searchProductByName(String name) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('name', isEqualTo: name)
          .get();
      print(snapshot.docs);
      for (var doc in snapshot.docs) {
        print(doc.data()); // Prints the product data that matches the search
      }
    } on FirebaseException catch (e) {
      print('Error fetching data: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  void setProductInCartDataWithMerge(
      {required String documentId,
      required Map<String, dynamic> productData}) async {
    try {
      DocumentReference productRef =
          FirebaseFirestore.instance.collection('cart').doc(documentId);

      await productRef.set(productData, SetOptions(merge: true));

      print('Product data merged successfully');
    } on FirebaseException catch (e) {
      print('Error merging product data: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 400,
            child: Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Select Location",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Amman-Jordan",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: TextField(
                                  decoration:
                                      InputDecoration(label: Text("Search")),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.filter_list),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 20,
                  right: 20,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < categories.length; i++)
                  category(categories[i])
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              for (int i = 0; i < products.length; i++)
                if (selectedCategoryId == '0' ||
                    products[i].categoryId == selectedCategoryId)
                  productWidget(products[i]),
            ],
          ),
        ],
      ),
    );
  }

  Widget category(category) {
    return TextButton(
        onPressed: () {
          setState(() {
            selectedCategoryId = category['id'];
          });
        },
        child: Text(
          category['name'],
          style: TextStyle(
            color: selectedCategoryId == category['id']
                ? Colors.blue
                : Colors.black,
          ),
        ));
  }

  Widget productWidget(Product productData) {
    return InkWell(
      onTap: () {
        /*   setProductInCartDataWithMerge(
            documentId: 'qklhro325yo',
            productData: {'name': productData.name, 'id': productData.id}); */

        //  addProductDataWithoutID({'name': productData.name, 'id': productData.id});

        /* updateProductData(documentId: productData.documnetId, product: {
          'newName': "New Name",
          'name': "Updated Name",
        }); */
        searchProductByName("Product 2");
      },
      child: Column(
        children: [
          Image.asset(
            productData.image,
            width: 50,
          ),
          Text(
            productData.name,
          ),
          Text(
            productData.desc,
          ),
          Text(
            productData.price,
          ),
        ],
      ),
    );
  }
}

class Product {
  String name;
  String image;
  String id;
  String categoryId;
  String price;
  String desc;
  String documnetId;

  Product(
      {required this.name,
      required this.categoryId,
      required this.desc,
      required this.id,
      required this.image,
      required this.documnetId,
      required this.price});
}
