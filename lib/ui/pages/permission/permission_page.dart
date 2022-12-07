import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:f_gps_tracker/ui/pages/content/content_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _LocationState();
}

class _LocationState extends State<PermissionPage> {
  late GpsController controller;
  late Future<LocationPermission> _permissionStatus;

  @override
  void initState() {
    super.initState();
    controller = Get.find();
    // TODo: cambios arturo Asigna a _permissionStatus el futuro que obtiene el estado de los permisos.;
    _permissionStatus = controller.permissionStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: Colors.brown[700],
        title: const Text("GPS grupo-14 NRC2287 ", style: TextStyle(fontSize: 40 ), ),
      ),
      body: FutureBuilder<LocationPermission>(
        
        future: _permissionStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final status = snapshot.data!;
            if (status == LocationPermission.always ||
                status == LocationPermission.whileInUse) {
              Get.find<LocationController>().initialize().then(
                    (value) => WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Get.offAll(() => ContentPage()),
                    ),
                  );
              return const Center(
                child: CircularProgressIndicator(),
              );
              /* TODo: cambios arturo Busca el controlador de ubicacion [LocationController] con [Get.find],
               inicializalo [initialize] y cuando el futuro se complete [then] usando [WidgetsBinding.instance.addPostFrameCallback]
               navega usando [Get.offAll] a [ContentPage] */

              // TODo: cambios arturo Mientras el futuro se completa muestra un CircularProgressIndicator

            } else if (status == LocationPermission.unableToDetermine ||
                status == LocationPermission.denied) {
              return Center(
                
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown[700],
                      minimumSize: const Size(400,70)
                      
                    ),
                    icon: const Icon(Icons.gps_fixed_rounded),
                    onPressed: () {
                      setState(() {
                        // TODo: cambios arturo Actualiza el futuro _permissionStatus con requestPermission
                        // TODo: cambios arturo y setState para que el FutureBuilder vuelva a renderizarse.
                        _permissionStatus = controller.requestPermission();
                        setState(() {});
                      });
                    }, label: const Text('  Solicitar permisos GPS', style: TextStyle(fontSize: 30),),
                    // child: const Text("Solicitar Permisos")
                    ),
                    
              );
            } else {
              // TODo: cambios arturo Muestra un texto cuando el usuario a denegado el permiso permanentemente
              return const Center(
                child: Text('Permisos denegados'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasError) {
            // TODo: cambios arturo Muestra un texto con el error si ocurre.
            return Center(
              child: Text(snapshot.hasError.toString()),
            );
          } else {
            // TODo: cambios arturo Mientras el futuro se completa muestra un CircularProgressIndicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
