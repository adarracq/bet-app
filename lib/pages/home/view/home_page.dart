import 'package:bet_app/contract_provider/contract_linking.dart';
import 'package:flutter/material.dart';
//import 'package:hello_world/contract_linking.dart';
import 'package:provider/provider.dart';
  
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      
    // Getting the value and object or contract_linking
    final contractLink = Provider.of<ContractLinking>(context);
  
    final yourNameController = TextEditingController();
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello World !'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: contractLink.isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Hello ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 52,),
                      ),
                      Text(
                        contractLink.myBalance,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 52,
                            color: Colors.tealAccent,),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 29),
                    child: TextFormField(
                      controller: yourNameController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Your Name',
                          hintText: 'What is your name ?',
                          icon: Icon(Icons.drive_file_rename_outline),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: () {
                        contractLink.getBalance();
                        contractLink.send(10);
                        yourNameController.clear();
                      },
                      child: const Text(
                        'Set Name',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}