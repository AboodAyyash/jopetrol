import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jo/firebase/firebas.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? image;
  Uint8List? imageData;
  ImagePicker picker = ImagePicker();
  File? selectedFile;
  String fileName = '';
  String fullFileName = '';
  String firestoreLink =
      "https://firebasestorage.googleapis.com/v0/b/jopetrol-f161d.appspot.com/o/";

  String randomId() {
    Random random = Random();
    return random.nextInt(99999999).toString();
  }

  Future uploadImage() async {
    if (imageData != null) {
      fileName = randomId();
      fullFileName = "${firestoreLink}images%2F$fileName?alt=media";
      print(fullFileName);
      try {
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
        );
        await FirebaseStorage.instance
            .ref('images/$fileName')
            .putData(imageData!, metadata);
      } on FirebaseException catch (e) {
        print('error is ${e.message}');
      }

      return true;
    } else {
      return false;
    }
  }

  Future<String?> selectPicture(ImageSource source) async {
    image = await picker.pickImage(
      source: source,
      maxHeight: 1000,
      maxWidth: 1000,
    );
    selectedFile = File(image!.path);

    return image!.path;
  }

  void pickImage() async {
    setState(() {
      selectPicture(ImageSource.gallery).then((value) async {
        imageData = await XFile(value!).readAsBytes();
        setState(() {
          
        });
      });
    
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              pickImage();
            },
            child: imageData != null
                ? Image.memory(
                    imageData!,
                    width: 230,
                    height: 160,
                  )
                : Container(
                    margin: EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 230,
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_search_rounded,
                          color: Colors.grey.shade400,
                          size: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Select Image",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          TextButton(
              onPressed: () {
                uploadImage();
              },
              child: Text("Upload")),
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
