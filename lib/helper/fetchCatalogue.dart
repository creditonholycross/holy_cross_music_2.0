import 'package:csv/csv.dart';
import 'package:holy_cross_music/database/database.dart';
import 'package:holy_cross_music/database/db_functions.dart';
import 'package:holy_cross_music/models/catalogue.dart';
import 'package:http/http.dart' as http;

var catalogueLink =
    'https://docs.google.com/spreadsheets/d/1d73dFdGKOk1-bhHmff_SGQXnzcQat1y5Y8Fa69sViOY/gviz/tq?tqx=out:csv';

Future<void> fetchCatalogue(AppDatabase db) async {
  final count = await DbFunctions().getCatalogueCount(db);
  if (count == 0) {
    print('fetching catalogue');
    updateCatalogueDb(db);
  }
  // return await DbFunctions().getCatalogue();
}

Future<void> updateCatalogueDb(AppDatabase db) async {
  print('updating db');
  http.Response response;
  try {
    response = await http.get((Uri.parse(catalogueLink)));
  } catch (e) {
    return;
  }

  if (response.statusCode == 200) {
    var parsedCatalogue = parseCsv(response.body);
    if (parsedCatalogue.isEmpty) {
      return;
    }
    await DbFunctions().deleteCatalogue(db);
    await DbFunctions().addCatalogue(db, parsedCatalogue);
  } else {
    return;
  }
}

List<Catalogue> parseCsv(String csv) {
  List<List<dynamic>> parsedList = const CsvToListConverter().convert(
    csv,
    eol: '\n',
  );
  final keys = parsedList.first;

  var mappedList = parsedList
      .skip(1)
      .map((v) => Map.fromIterables(keys, v))
      .toList();

  var catalogueList = mappedList.map((e) => Catalogue.fromCsv(e)).toList();

  return catalogueList;
}
