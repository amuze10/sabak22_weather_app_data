import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sabak22_weather_app_data/constants/api_const.dart';
import 'package:sabak22_weather_app_data/constants/app_colors.dart';
import 'package:sabak22_weather_app_data/constants/app_texts.dart';
import 'package:sabak22_weather_app_data/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
const List cities = <String>[
  'Bishkek', 
  'Osh', 
  'Jalal-Abad',
   'Karakol',
   'Naryn',
    'Talas',
    'Batken',
    'Tokmok'];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Weather? weather;
  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission == await Geolocator.requestPermission();
    }if (permission ==LocationPermission.always && permission == LocationPermission.whileInUse){
     Position position = await Geolocator.getCurrentPosition();
     Dio dio = Dio();
    //await kut
    // дионун get degen metod ssylkany alat
    //res bul response | joop aluu
    final response = await dio.get(ApiConst.address(lat: position.latitude, lon: position.longitude),
    );
    if (response.statusCode == 200) {
      weather = Weather(
        id: response.data['current']['weather'][0]['id'],
        main: response.data['current']['weather'][0]['main'],
        description: response.data['current']['weather'][0]['description'],
        icon: response.data['current']['weather'][0]['icon'],
        temp: response.data['current']['temp'],
        name: response.data['timezone'],
      );
    }
    setState(() {
      
    });
    }else{
      Position position = await Geolocator.getCurrentPosition();
     Dio dio = Dio();
    //await kut
    // дионун get degen metod ssylkany alat
    //res bul response | joop aluu
    final response = await dio.get(ApiConst.address(lat: position.latitude, lon: position.longitude));
    if (response.statusCode == 200) {
      weather = Weather(
        id: response.data['current']['weather'][0]['id'],
        main: response.data['current']['weather'][0]['main'],
        description: response.data['current']['weather'][0]['description'],
        icon: response.data['current']['weather'][0]['icon'],
        temp: response.data['current']['temp'],
        name: response.data['timezone'],
      );
    }
    setState(() {
      
    });  

    }
  }

  ///////////////////////////////////
  //fetchData alyp keluu
  Future<void> fetchData([String? url]) async {
    // dio serverden tartyp keluuchu plagin
    Dio dio = Dio();
    //await kut
    //await Future.delayed(const Duration(seconds: 3));
    // дионун get degen metod ssylkany alat
    //res bul response | joop aluu
    final response = await dio.get(ApiConst.weatherData(url ?? 'Bishkek'));
    if (response.statusCode == 200) {
      weather = Weather(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        temp: response.data['main']['temp'],
        name: response.data['name'],
      );
    }

    setState(() {});
  }

  @override
  //initState metodu birinchi ele chakerganda chygat.
  //initState koldonboso pagedata iwtebeyt
  //bul bir variant
  void initState() {
    super.initState();
    fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Weather App')),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: weather == null? const CircularProgressIndicator():
           Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/waterfall.jpg'),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () async {
                            await getLocation();
                            print('>>>>>>>>${getLocation()}');
                          },
                          icon: const Icon(
                            Icons.near_me,
                            color: AppColors.iconColor,
                            size: 40,
                          )),
                      IconButton(
                          onPressed: ()async {
                            showBottom();
                          },
                          icon: const Icon(
                            Icons.location_city,
                            color: AppColors.iconColor,
                            size: 40,
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      '${(weather!.temp - 273.15).toInt()}',
                      style: AppTextStyles.san8,
                    ),
                    Image.network(ApiConst.getIcon(weather!.icon, 4)),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: Text(
                      weather!.description.replaceAll(' ', '\n'),
                      style: const TextStyle(color: Colors.white, fontSize: 70),
                    ),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        weather!.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 80),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
void showBottom()async{
  showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
    return Container(
      height: 300,
      
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey[350],
      ),
      child: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
        return  Card(
          child: ListTile(
            onTap: ()async{
              setState(() {
                weather = null;
              });
              await fetchData(city);
              Navigator.pop(context);
            },
            title: Text("$city", style: TextStyle(fontSize: 25, 
            fontWeight: FontWeight.w700),),
          ),
        );
      },)
    );
  }
  );
}
}

