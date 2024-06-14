import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prectical_exam/file_provider.dart';
import 'package:prectical_exam/pay.dart';
import 'package:prectical_exam/signup.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController uriController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  FocusNode uriNode = FocusNode();
  FocusNode subjectNode = FocusNode();
  FocusNode titleNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .read<ImageProviders>()
              .shareImage(context, context.read<ImageProviders>().image!.path);
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ImageProviders>().onShareXFileFromNetwork(context);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Pay()));
            },
            icon: const Icon(
              Icons.money,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Consumer<ImageProviders>(
        builder: (context, images, child) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.image != null
                    ? SizedBox(
                        height: 400,
                        width: 450,
                        child:
                            Image(image: FileImage(File(images.image!.path))),
                      )
                    : const SizedBox(
                        height: 300,
                        width: 300,
                        child: Center(
                          child: Text(
                            "No image selected",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AuthField(
                    hintText: 'uri',
                    controller: uriController,
                    focusNode: uriNode,
                    prefixIcon: const Icon(
                      Icons.link,
                      color: Colors.black,
                    ),
                    textInputType: TextInputType.url,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AuthField(
                    hintText: 'subject',
                    controller: subjectController,
                    focusNode: subjectNode,
                    prefixIcon: const Icon(
                      Icons.subject,
                      color: Colors.black,
                    ),
                    textInputType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AuthField(
                    hintText: 'Title',
                    controller: titleController,
                    focusNode: titleNode,
                    prefixIcon: const Icon(
                      Icons.title,
                      color: Colors.black,
                    ),
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      images.pickImage();
                    },
                    child: const Text(
                      'Pick Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 2nd
