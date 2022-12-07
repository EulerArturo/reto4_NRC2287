import 'package:f_gps_tracker/domain/models/location.dart';
import 'package:f_gps_tracker/domain/use_cases/location_manager.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final Rx<List<TrackedLocation>> _locations = Rx([]);

  List<TrackedLocation> get locations => _locations.value;

  Future<void> initialize() async {
    await LocationManager.initialize();
  }

  Future<void> saveLocation({
    required TrackedLocation location,
  }) async {
    LocationManager.save(location: location);
    _locations.value = await getAll();
    /* TODo: cambios arturo Usa [LocationManager] para guardar [save] la ubicacion [location] */
  }

  Future<List<TrackedLocation>> getAll({
    String? orderBy,
  }) async {
    return LocationManager.getAll();
    /* TODo: cambios arturo Usa [getAll] de [LocationManager] para obtener la lista de ubicaciones guardadas y retornalas */
  }

  Future<void> updateLocation({required TrackedLocation location}) async {
    LocationManager.update(location: location);
    _locations.value = await getAll();
    /* TODo: cambios arturo Usa [LocationManager.update] para actualizar la ubicacion y luego obten todas las ubicaciones de nuevo */
  }

  Future<void> deleteLocation({required TrackedLocation location}) async {
    /* TOD0: cambios arturo Con [LocationManager.delete] elimina la ubicacion y luego usa [removeWhere] para eliminar la ubicacion de [_locations.value] usando [_locations.update de GetX] */
    /* TODo: cambios arturo Ejemplo [https://github.com/jonataslaw/getx/blob/master/documentation/en_US/state_management.md]
     */
    LocationManager.delete(location: location);
    _locations.update((location) {
      _locations.value
          .removeWhere((element) => element.toString == location.toString);
    });
    _locations.value = await getAll();
  }

  Future<void> deleteAll() async {
    /* TODo: cambios arturo Con [LocationManager.deleteAll] elimina todas las ubicaciones guardas y asigna una lista vacia a [_locations.value] */
    LocationManager.deleteAll();
    _locations.value = [];
  }
}
