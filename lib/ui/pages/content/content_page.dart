import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/ui/controllers/gps.dart';
import 'package:f_gps_tracker/ui/controllers/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContentPage extends GetView<LocationController> {
  late final GpsController gpsController = Get.find();

  ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: Colors.brown[700],
        shadowColor: Colors.black,
        elevation: 10,
        title: const Text("GPS Grupo-14  NRC2287", style : TextStyle(fontSize: 40 ),),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.getAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown[700],
                          minimumSize: const Size(400, 70)),
                      icon: const Icon(Icons.location_on_outlined, size: 50, ),
                      
                      onPressed: () async {

                        
                        // TODo: 1. cambios arturo Obten la ubicacion actual con gpsController.currentLocation
                        // TODo: 2. cambios arturo Obten la precision de la lectura con gpsController.locationAccuracy.
                        // TODo: 3. cambios arturo Crea un objeto [TrackedLocation] con fecha actual [DateTime.now] y la precisio como
                        // texto [accuracy.name]
                        // TODo: 4.  cambios arturo con el [controller] guarda ese objeto [saveLocation]

                        final position = await gpsController.currentLocation;
                        final currency = await gpsController.locationAccuracy;
                        TrackedLocation location = TrackedLocation(
                            latitude: position.latitude,
                            longitude: position.longitude,
                            precision: currency.name,
                            timestamp: DateTime.now());
                        controller
                            .saveLocation(location: location)
                            .then((value) => controller.getAll());
                      },
                      label: const Text("Registrar Ubicacion", style: TextStyle(fontSize: 25), ),
                      
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ListView.separated(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: controller.locations.length,
                        itemBuilder: (context, index) {
                          final location = controller.locations[index];
                          return Card(
                            child: ListTile(
                              isThreeLine: true,
                              leading: Icon(
                                Icons.gps_fixed_rounded,
                                color: Colors.brown[700],
                                size: 60,
                              ),
                              title: Text(
                                  '${location.latitude}, ${location.longitude}', style: TextStyle(color: Colors.brown[700], fontSize: 23), ),
                              subtitle: Text(
                                  'Fecha: ${location.timestamp.toIso8601String()}\n${location.precision.toUpperCase()}',
                                  style: TextStyle(
                                      color: Colors.brown[300], fontSize: 20) ),
                              trailing: IconButton(
                                onPressed: () {
                                  // TODo: cambios arturo elimina la ubicacion [location] usando el controlador [deleteLocation]
                                  controller.deleteLocation(location: location);
                                },
                                icon: const Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red,
                                  size: 45,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown[700],
                          minimumSize: const Size(400, 70)),
                      icon: const Icon(
                        Icons.delete_forever,
                        size: 50, color: Colors.red,
                      ),
                      onPressed: () async {
                        // TODo: cambios arturo elimina todas las ubicaciones usando el controlador [deleteAll]
                        controller.deleteAll();
                      },
                      label: const Text(
                        "  Eliminar Todos",
                        style: TextStyle(fontSize: 25),
                      ),
                      
                      
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
