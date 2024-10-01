// lib/controllers/polyline_controller.dart
import 'dart:io';
import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import '../models/polyline_model.dart';

class PolylineController {
  final PolylineModel model;

  PolylineController(this.model);

  void addPoint(double latitude, double longitude) {
    model.addPoint(LatLng(latitude, longitude));
  }

  Future<String> exportToGeoJSON() async {
    if (model.isEmpty()) {
      return 'No points to export';
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/polyline.geojson';

    final Map<String, dynamic> geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'geometry': {
            'type': 'LineString',
            'coordinates': model.toCoordinates(),
          },
          'properties': {},
        },
      ],
    };

    final file = File(filePath);
    await file.writeAsString(jsonEncode(geoJson));

    return 'LineString exported to $filePath';
  }

  Future<String> exportToShapefile() async {
    // Note: Actual Shapefile export is not implemented here due to library limitations.
    // This is a placeholder that creates a simple text file with coordinates.
    if (model.isEmpty()) {
      return 'No points to export';
    }

    final directory = await getApplicationDocumentsDirectory();
    final shpFilePath = '${directory.path}/polyline.txt';

    try {
      final file = File(shpFilePath);
      final sink = file.openWrite();
      for (var point in model.points) {
        sink.writeln('${point.longitude},${point.latitude}');
      }
      await sink.close();

      return 'LineString coordinates exported to $shpFilePath';
    } catch (e) {
      return 'Error exporting LineString: $e';
    }
  }

  void clearPolyline() {
    model.clearPoints();
  }
}