import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/productsModel.dart';
import 'package:provider/provider.dart';




class Products extends StatelessWidget {

  TextEditingController t1 = TextEditingController();

  @override
  Widget build (BuildContext context) {

     //var listModel = Provider.of<ProductsModel>(context);
    var listModel = Provider.of<ProductsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: listModel.isLoading ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          Expanded(
            flex: 4,
             child: ListView.builder(
               itemCount: listModel.productsCount,
               itemBuilder: (context, index) => ListTile(
                title: Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Column(
                    children: [
                      Text(listModel.products[index].name),
                      Text(listModel.products[index].price.toString()),
                      Text(listModel.products[index].assetUrls[0]),
                      Text(listModel.products[index].classification.toString()),
                      Text(listModel.products[index].quantifier.toString())
                  ],),
                )
              )
            )
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: t1,
                  ),
                  flex: 5,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      listModel.addProduct(t1.text);
                      t1.clear();
                    },
                    child: Text("Add"),
                  ))
              ],
            ),),
        ],
      ),
    );
  }
}