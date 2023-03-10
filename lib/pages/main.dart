import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_second_flutter_app/pages/home_page_with_fb.dart';
import 'package:my_second_flutter_app/pages/login_page.dart';
import 'package:my_second_flutter_app/widgets/my_drawer.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_second_flutter_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MaterialApp(
    home: Constants.prefs?.getBool("loggedIn") == true
        ? const HomePageFB()
        : const LoginPage(),
    theme: ThemeData(primarySwatch: Colors.amber),
    debugShowCheckedModeBanner: false,
    routes: {
      LoginPage.routeName: (context) => const LoginPage(),
      HomePage.routeName: (context) => const HomePage()
    },
  ));
}

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var myText = "Change My Name";
  // //new keyword not needed here
  // final TextEd
  //itingController _nameController = TextEditingController();

  // var url = "https://jsonplaceholder.typicode.com/photos";
  dynamic data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    // var res = await http.get(Uri.parse(url));
    var res = await rootBundle.loadString("assets/mockdata.json");
    data = jsonDecode(res);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 240, 240),
      appBar: AppBar(
        title: const Text("My Second App"),
        actions: [
          IconButton(
              onPressed: () {
                Constants.prefs?.setBool("loggedIn", false);
                // Navigator.pop(context);
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: data != null
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index]["title"]),
                  subtitle: Text("${data[index]["id"]}"),
                  //theory it works because it is an online image
                  leading: Image.network(data[index]["url"]),
                );
              },
              itemCount: data.length,
            )
          // ListView.builder(
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(data[index]["title"]),
          //         subtitle: Text("${data[index]["id"]}"),
          //         //theory it works because it is an online image
          //         leading: Image.network(data[index]["url"]),
          //       );
          //     },
          //     itemCount: data.length,
          //   )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // myText = _nameController.text;
          // setState(() {});
        },
        child: const Icon(Icons.send),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
