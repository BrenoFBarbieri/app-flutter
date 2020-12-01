/*
  App para calcular o IMC de uma pessoa.
  Referências:
  - [Programador BR] https://www.youtube.com/watch?v=hOsSDTxzrKQ
*/

import 'package:flutter/material.dart';

class Wall {
  // attributes
  String _name;
  double _height;
  double _width;
  double _squareM = 0;

  // constructor
  Wall(this._height, this._width, [this._name]) {
    this._squareM = calculateSquareMeter();
  }

  // methods
  double calculateSquareMeter() {
    return _height * _width;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Wall> list = [];

  // constructor
  MyApp() {
    Wall wall1 = Wall(2.0, 2.0, "Parede quarto");
    Wall wall2 = Wall(2.5, 4, "Parede Sala");
    list.add(wall1);
    list.add(wall2);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Proof Flutter",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(list),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Wall> list;

  // constructor
  HomePage(this.list);

  @override
  _HomePageState createState() => _HomePageState(list);
}

class _HomePageState extends State<HomePage> {
  final List<Wall> list;

  // constructor
  _HomePageState(this.list);

  // methods
  void _refreshScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      drawer: NavDrawer(list),
      appBar: AppBar(
        title: Text("Walls (${list.length})"),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                "${list[index]._name}",
                style: TextStyle(fontSize: 16.0),
              ),
              onTap: () {},
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshScreen,
        tooltip: 'Update',
        child: Icon(Icons.update),
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  // attributes
  final List list;
  final double _fontSize = 17.0;

  // constructor
  NavDrawer(this.list);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Opcional
          DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(color: Colors.blueGrey),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              "Wall information",
              style: TextStyle(fontSize: _fontSize),
            ),
            onTap: () {
              Navigator.pop(context); // Fecha o Drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WallInformationScreen(list),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1_sharp),
            title: Text(
              "Register a new wall",
              style: TextStyle(fontSize: _fontSize),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenRegisterWall(list),
                ),
              );
            },
          ),
          Container(
            padding: EdgeInsets.all(20.0),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              leading: Icon(Icons.face),
              title: Text(
                "About",
                style: TextStyle(fontSize: _fontSize),
              ),
              onTap: () {
                Navigator.pop(context); // Fecha o Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutScreen(),
                ),
              );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//-----------------------------------------------------------------------------
// Room Information screen
//-----------------------------------------------------------------------------

class WallInformationScreen extends StatefulWidget {
  final List<Wall> list;

  // constructor
  WallInformationScreen(this.list);

  @override
  _WallInformationScreen createState() => _WallInformationScreen(list);
}

class _WallInformationScreen extends State<WallInformationScreen> {
  // Atributos
  final List list;
  Wall wall;
  int index = -1;
  double _fontSize = 18.0;
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final squareMController = TextEditingController();
  bool _edicaoHabilitada = false;

  // constructor
  _WallInformationScreen(this.list) {
    if (list.length > 0) {
      index = 0;
      wall = list[0];
      nameController.text = wall._name;
      heightController.text = wall._height.toString();
      widthController.text = wall._width.toString();
      squareMController.text = wall._squareM.toStringAsFixed(1);
    }
  }

  // methods
  void _exibirRegistro(index) {
    if (index >= 0 && index < list.length) {
      this.index = index;
      wall = list[index];
      nameController.text = wall._name;
      heightController.text = wall._height.toString();
      widthController.text = wall._width.toString();
      squareMController.text = wall._squareM.toStringAsFixed(1);
      setState(() {});
    }
  }

  void _atualizarDados() {
    if (index >= 0 && index < list.length) {
      _edicaoHabilitada = false;
      list[index]._name = nameController.text;
      list[index]._height = heightController.text;
      list[index]._width = widthController.text;
      list[index]._squareM = list[index].calculateSquareMeter();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = "Wall information";
    if (wall == null) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Column(
          children: <Widget>[
            Text("No records found!"),
            Container(
              color: Colors.blueGrey,
              child: BackButton(),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  _edicaoHabilitada = true;
                  setState(() {});
                },
                tooltip: 'Click here to enable editing',
                child: Text("Edit"),
              ),
            ),
            // --- Wall name ---
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                enabled: _edicaoHabilitada,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Wall name",
                  // hintText: "Wall name",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: nameController,
              ),
            ),
            // --- Wall height ---
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                enabled: _edicaoHabilitada,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Height (m)",
                  // hintText: 'Wall height (m)',
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: heightController,
              ),
            ),
            // --- Wall width ---
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                enabled: _edicaoHabilitada,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Width (m)",
                  hintText: "Width (m)",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: widthController,
              ),
            ),
            // --- IMC (desabilitado) ---
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                enabled: false,
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Square meters",
                  hintText: "Square meters",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: squareMController,
              ),
            ),
            RaisedButton(
              child: Text(
                "Update data",
                style: TextStyle(fontSize: _fontSize),
              ),
              onPressed: _atualizarDados,
            ),
            Text(
              "[${index + 1}/${list.length}]",
              style: TextStyle(fontSize: 15.0),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <FloatingActionButton>[
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(0),
                    tooltip: 'First',
                    child: Icon(Icons.first_page),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(index - 1),
                    tooltip: 'Before',
                    child: Icon(Icons.navigate_before),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(index + 1),
                    tooltip: 'Next',
                    child: Icon(Icons.navigate_next),
                  ),
                  FloatingActionButton(
                    heroTag: null,
                    onPressed: () => _exibirRegistro(list.length - 1),
                    tooltip: 'Last',
                    child: Icon(Icons.last_page),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------
// About screen
// ----------------------------------------------------------------------------

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Center(
        child: Container(
          height: 20.0,
          width: 280.0,
          color: Colors.blue[50],
          child: Text(
            'Application developed by Breno Barbieri',
             textAlign: TextAlign.center,
             overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
           ),
          ),
        );
     }
 }

//-----------------------------------------------------------------------------
// Register Wall screen
// ----------------------------------------------------------------------------

class ScreenRegisterWall extends StatefulWidget {
  final List<Wall> list;

  // Construtor
  ScreenRegisterWall(this.list);

  @override
  _ScreenRegisterWallState createState() =>
      _ScreenRegisterWallState(list);
}

class _ScreenRegisterWallState extends State<ScreenRegisterWall> {
  // Atributos
  final List<Wall> list;
  String _name = "";
  double _height = 0.0;
  double _width = 0.0;
  double _fontSize = 20.0;
  final nameController = TextEditingController();
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final squareMController = TextEditingController();

  // Constructor
  _ScreenRegisterWallState(this.list);

  // Métodos
  void _screenRegisterWall() {
    _name = nameController.text;
    _height = double.parse(heightController.text);
    _width = double.parse(widthController.text);
    if (_height > 0 && _width > 0) {
      var wall = Wall(_height, _width, _name);
      // _imc = paciente._imc;
      list.add(wall);
      // _index = lista.length - 1;
      nameController.text = "";
      heightController.text = "";
      widthController.text = "";
      squareMController.text = "${wall._squareM}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register wall (???)"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                "Wall data:",
                style: TextStyle(fontSize: _fontSize),
              ),
            ),
            // --- Wall name ---
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Wall name",
                  // hintText: "Wall name",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: nameController,
              ),
            ),
            // --- Wall height  ---
            Padding(
              padding: EdgeInsets.all(5),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Height (m)",
                  // hintText: 'Height (m)',
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: heightController,
              ),
            ),
            // --- Wall Height ---
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Width (m)",
                  hintText: "Width (m)",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: widthController,
              ),
            ),
            // --- Square meters (desabilitado) ---
            Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 20),
              child: TextField(
                enabled: false,
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Square meters",
                  hintText: "Square meters",
                ),
                style: TextStyle(fontSize: _fontSize),
                controller: squareMController,
              ),
            ),
            // exit
            RaisedButton(
              child: Text(
                "Register wall",
                style: TextStyle(fontSize: _fontSize),
              ),
              onPressed: _screenRegisterWall,
            ),
          ],
        ),
      ),
    );
  }
}