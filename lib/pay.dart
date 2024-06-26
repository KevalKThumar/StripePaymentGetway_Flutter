// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:prectical_exam/constants.dart';
import 'package:prectical_exam/payment.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();
  final formkey7 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'INR',
    'USD',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'INR';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
        amount: (int.parse(amountController.text) * 100).toString(),
        currency: selectedCurrency,
        name: nameController.text,
        address: addressController.text,
        pin: pincodeController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
        description: descriptionController.text,
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Keval Thumar',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pay Now',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              hasDonated
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your ${amountController.text} $selectedCurrency is successfully transferred.",
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                child: const Text(
                                  "Pay again",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  setState(() {
                                    hasDonated = false;
                                    amountController.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pay Your Bill",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ReusableTextField(
                                      formkey: formkey,
                                      controller: amountController,
                                      isNumber: true,
                                      title: "Amount",
                                      hint: " Ex. 100"),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                DropdownMenu<String>(
                                  inputDecorationTheme: InputDecorationTheme(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                  initialSelection: currencyList.first,
                                  onSelected: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      selectedCurrency = value!;
                                    });
                                  },
                                  dropdownMenuEntries: currencyList
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReusableTextField(
                              formkey: formkey1,
                              title: "Name",
                              hint: "Ex. Keval Thumar",
                              controller: nameController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReusableTextField(
                              formkey: formkey7,
                              title: "description",
                              hint: "Ex. To buy clothes",
                              controller: descriptionController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReusableTextField(
                              formkey: formkey2,
                              title: "Address Line",
                              hint: "Ex. 123 Main Street",
                              controller: addressController,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: ReusableTextField(
                                      formkey: formkey3,
                                      title: "City",
                                      hint: "Ex. Ahemadabad",
                                      controller: cityController,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 5,
                                    child: ReusableTextField(
                                      formkey: formkey4,
                                      title: "State (Short code)",
                                      hint: "Ex.GJ for Gujarat",
                                      controller: stateController,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: ReusableTextField(
                                      formkey: formkey5,
                                      title: "Country (Short Code)",
                                      hint: "Ex. IN for India",
                                      controller: countryController,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 5,
                                    child: ReusableTextField(
                                      formkey: formkey6,
                                      title: "Pincode",
                                      hint: "Ex. 123456",
                                      controller: pincodeController,
                                      isNumber: true,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                child: const Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () async {
                                  if (formkey.currentState!.validate() &&
                                      formkey1.currentState!.validate() &&
                                      formkey2.currentState!.validate() &&
                                      formkey3.currentState!.validate() &&
                                      formkey4.currentState!.validate() &&
                                      formkey5.currentState!.validate() &&
                                      formkey6.currentState!.validate() &&
                                      formkey7.currentState!.validate()) {
                                    await initPaymentSheet();

                                    try {
                                      await Stripe.instance
                                          .presentPaymentSheet();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Payment Done",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ));

                                      setState(() {
                                        hasDonated = true;
                                      });
                                      nameController.clear();
                                      addressController.clear();
                                      cityController.clear();
                                      stateController.clear();
                                      countryController.clear();
                                      pincodeController.clear();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                          "Payment Failed",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.redAccent,
                                      ));
                                      setState(() {
                                        hasDonated = false;
                                      });
                                    }
                                  }
                                },
                              ),
                            )
                          ])),
            ],
          ),
        ),
      ),
    );
  }
}
