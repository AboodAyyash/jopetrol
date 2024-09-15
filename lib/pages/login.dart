import 'package:flutter/material.dart';
import 'package:flutter_jo/controllers/login.dart';
import 'package:flutter_jo/pages/profile.dart';
import 'package:flutter_jo/services/service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  int _counter = 0;

  void _incrementCounter() {
    print(_counter);
    setState(() {
      _counter++;
    });
    print(_counter);
  }

  String title = "Title";

  List numbers = [1, 23, 4, 56, 78, 4, 2, 24, 6, 7];

  TextEditingController nameCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple,
        title: Text(title,
            style: const TextStyle(
              color: Color(0xFFFF0000),
            ) //Colors.white),
            ),
        actions: [
          IconButton(
            onPressed: () {
              print("HEllo");
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          InkWell(
            onTap: () {
              print("onTap");
            },
            onDoubleTap: () {
              print("onDoubleTap");
            },
            onLongPress: () {
              print("onLongPress");
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          //Form()
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: nameCon,
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Your name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(Icons.arrow_forward_ios),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Your Name";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: passwordCon,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Your password",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(Icons.arrow_forward_ios),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Your Password";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      print("onChange $value");
                    },
                    onTap: () {
                      print("onTap");
                    },
                    onEditingComplete: () {
                      print("onEditingComplete ");
                    },
                  ),
                ),
                TextButton( 
                  onPressed: () {
                    nameCon.text = "Ahmad";
                    passwordCon.text = "123456";
                  },
                  child: Text("fill Data"),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      LoginController loginController = LoginController();
                      loginController.loginApi().then((onValue) {
                     
                        if (onValue['data']['EmpName'] == null) {
                          print("Error");
                        } else {
                          saveUser(nameCon.text, passwordCon.text,
                              "Cf6NNPsEWmRd43L8+GnJt3a90OojMj9mBzUqRANTduE=");
                         /*  Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => ProfilePage(),
                            ),
                          ); */
                        }
                        // if(onValue[])
                      });

/*  saveUser(nameCon.text, passwordCon.text,
                          "Cf6NNPsEWmRd43L8+GnJt3a90OojMj9mBzUqRANTduE="); */
                      /*  var url = Uri.https('example.com', 'whatsit/create');
                      var response = await http
                          .post(url, body: {'name': 'doodle', 'color': 'blue'});
                      print('Response status: ${response.statusCode}');
                      print('Response body: ${response.body}');

                      print(await http
                          .read(Uri.https('example.com', 'foobar.txt'))); */
                      /*  final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      print(prefs.getString("userName"));
                      prefs.setString("userName", nameCon.text);
                      print(prefs.getString("userName"));
 */
                      /*  Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ProfilePage(
                            name: nameCon.text,
                            password: passwordCon.text,
                          ),
                        ),
                      ); */
                    }
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          ),
          Text(
            '$_counter',
          ),
          Image.asset(
            "assets/images/logo.png",
            width: 50,
            height: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 120,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                for (int i = 0; i < numbers.length; i++)
                  Text(numbers[i].toString())
              ],
            ),
          ),
          Image.network(
            "https://www.simplilearn.com/ice9/free_resources_article_thumb/what_is_image_Processing.jpg",
            fit: BoxFit.cover,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Text"),
            Text("Text"),
            Text("Text"),
            Text("Text"),
          ],
        ),
      ),
    );
  }
}
