import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:file_saver/file_saver.dart';
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

    try {
      final geoJsonString = jsonEncode(geoJson);
      final bytes = utf8.encode(geoJsonString);
      final fileName = 'polyline';

      // Use FileSaver to save the file
      await FileSaver.instance.saveFile(
        name: fileName, // Nome do arquivo
        bytes: bytes,   // Conteúdo em bytes do arquivo
        ext: 'geojson', // Extensão do arquivo
      );

      return 'LineString exported successfully';
    } catch (e) {
      return 'Error exporting LineString: $e';
    }
  }

  Future<String> exportToShapefile() async {
    if (model.isEmpty()) {
      return 'No points to export';
    }

    try {
      final fileName = 'polyline.txt';
      final content = model.points
          .map((point) => '${point.longitude},${point.latitude}')
          .join('\n');
      final bytes = utf8.encode(content);

      // Use FileSaver to save the file
      await FileSaver.instance.saveFile(
        name: fileName, // Nome do arquivo
        bytes: bytes,   // Conteúdo em bytes do arquivo
        ext: 'txt',     // Extensão do arquivo
      );

      return 'LineString coordinates exported successfully';
    } catch (e) {
      return 'Error exporting LineString: $e';
    }
  }

  void clearPolyline() {
    model.clearPoints();
  }
}
