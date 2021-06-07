
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return MaterialApp(
      title:'HealthCareMania',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pinkAccent
      ),
      home: MenuList(),
    );
  }
}