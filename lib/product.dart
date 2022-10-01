import 'dart:convert';
import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetApi extends StatefulWidget {
  const GetApi({Key? key}) : super(key: key);

  @override
  State<GetApi> createState() => _GetApiState();
}

class _GetApiState extends State<GetApi> {
  bool loading = false;
  bool networkError = false;
  List products = [];

  var data = [];
  int i = 0;

  getData() async {
    try {
      networkError = false;
      loading = true;
      log('api calling.....');
      setState(() {});
      var api = "https://fakestoreapi.com/products";

      var response = await http
          .get(
            Uri.parse(api),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        data = jsonDecode(response.body);
        products = data.toList();

        // statement = data['setup'];
        // punchline = data['punchline'];
        if (kDebugMode) {
          print(response.statusCode);
        }
      } else {
        if (kDebugMode) {
          print(response.statusCode);
          print('server error');
        }
      }
      loading = false;
      log('api end.....');
      setState(() {});
    } catch (error) {
      loading = false;
      networkError = true;
      debugPrint('Network Error');
      debugPrint(error.toString());
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: 'Search Here.........',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 63,
                child: Card(
                  color: Colors.deepOrange,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.filter,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.greenAccent,
                      Colors.white,
                      Colors.lightGreenAccent
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.center,
                  // color: Colors.lime,
                  child: networkError
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/lotti_files/network-error-super-hero.json',
                                height: 300),
                            const Text(
                              'Please check Your Internet Connection',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  backgroundColor: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                              onPressed: () {
                                getData();
                              },
                              child: loading
                                  ? Lottie.asset('assets/lotti_files/loading.json',
                                      height: 70)
                                  : const Text(
                                      'Refresh',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 250,
                                          childAspectRatio: 2 / 3,
                                          crossAxisSpacing: 30,
                                          mainAxisSpacing: 30),
                                  itemCount: products.length,
                                  itemBuilder: (BuildContext ctx, i) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                            height: 200,
                                            width: 200,

                                            child: ElevatedButton(
                                              onPressed: () {  },
                                              child: Image.network(
                                                  products[i]['image']),
                                            )),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(products[i]['title']),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
