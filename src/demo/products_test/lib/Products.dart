import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:products_test/ProductsModel.dart';
import 'package:provider/provider.dart';

class Products extends StatelessWidget {
  @override
  Widget build (BuildContext context) {

    var list = Provider.of<ProductsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
             child: ListView.builder(
               itemBuilder: (context, index) => ListTile(
                title: Text("Product"),
              )
            )
          ),
          Expanded(
            flex: 1, 
            child: Row(
              children: [
                Expanded(
                  child: TextField(),
                  flex: 5,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){},
                    child: Text("Add"),
                  ))
              ],
            ),),
        ],
      ),
    );
  }
}