import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Principal extends StatefulWidget {
  Principal({Key? key}) : super(key : key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  List<dynamic> _data = [];

  @override
  void _carregarDados() async{
    setState(() {
      _buscarDados();
    });
  }

  Future<void> _buscarDados() async {
    try{
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      if(response.statusCode == 200){
        setState(() {
          _data = jsonDecode(response.body);
        });
        print("Get ok CRUD Flutter");
      }else{
        throw Exception('Failed to load');
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> _criarDados() async {
    try{
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': 'Flutter Http CRUD',
          'body': 'Inserido dados com HTTP CRUD no Flutter',
          'UserId': 1,
        }));
      if(response.statusCode == 201){
        _buscarDados();
        print("POST ok HTTP CRUD com Flutter");
      } else{
        throw Exception('Failed to create data');
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> _alterarDados(int id) async{
    try{
      final response = await http.put(
        Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': 'Flutter Http CRUD',
          'body': 'Update dados com HTTP CRUD no Flutter',
        }));
      if(response.statusCode == 200){
        _buscarDados();
        print("Udpdate Ok");
      }else {
        throw Exception('Failed update');
      }
    }catch(error){
      print(error);
    }
  }

  Future<void> _deletarDados(int id) async{
    try{
      final response = await http
          .delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

          if(response.statusCode == 200){
            print("Delete ok");
            _buscarDados();
      }else{
            throw Exception('Failed to delete');
      }
    }catch (error){
     print(error);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("CONSUMIR API COM HTTP"),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index){
          final data = _data[index];
          return ListTile(
            title: Text(data['title'],
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              data['body'],
              style: TextStyle(fontSize: 10),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _alterarDados(data['id']),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                    onPressed: () => _deletarDados(data['id']),
                    icon: Icon(Icons.delete)
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _criarDados,
        tooltip: 'Create',
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        elevation: 5,
      ),
    );
  }
}