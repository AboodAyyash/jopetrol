import 'package:flutter/material.dart';

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

  List<Product> products = [
    Product(
        name: "Mocca 1",
        categoryId: '1',
        desc: 'desc 1',
        id: '1',
        image: 'assets/images/logo.png',
        price: '10'),
    Product(
        name: "Mocca 2",
        categoryId: '1',
        desc: 'desc 2',
        id: '2',
        image: 'assets/images/logo.png',
        price: '10'),
    Product(
        name: "Mocca 3",
        categoryId: '2',
        desc: 'desc 3',
        id: '3',
        image: 'assets/images/logo.png',
        price: '10'),
    Product(
        name: "Mocca 4",
        categoryId: '2',
        desc: 'desc 4',
        id: '4',
        image: 'assets/images/logo.png',
        price: '10'),
    Product(
        name: "Mocca 5",
        categoryId: '3',
        desc: 'desc 5',
        id: '5',
        image: 'assets/images/logo.png',
        price: '10'),
  ];

  String selectedCategoryId = '0';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      categories.insert(0, {"name": "All", 'id': '0'});
    });
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
    return Container(
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

  Product(
      {required this.name,
      required this.categoryId,
      required this.desc,
      required this.id,
      required this.image,
      required this.price});
}
