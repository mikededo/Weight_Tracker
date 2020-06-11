import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class CsvParser {
  /// Parses the item list
  static Future<String> parseToCsv(List<String> titles, List<List<dynamic>> items) async {
    final File csvFile = await _fileLocation;

    String csvTitles = const ListToCsvConverter().convert([titles]);
    String csvItems = const ListToCsvConverter().convert(items);
    
    csvFile..writeAsString(csvTitles)..writeAsString(csvItems);

    return csvFile.path;
  }

  /// Returns the directory path
  static Future<String> get _docsPath async {
    final Directory directory = await getExternalStorageDirectory();

    return directory.absolute.path;
  }

  /// Creates a local file to the docs path
  static Future<File> get _fileLocation async {
    final String path = await _docsPath;
    return File(
      '$path/${DateTime.now().millisecondsSinceEpoch.abs().toString()}.csv',
    );
  }
}
