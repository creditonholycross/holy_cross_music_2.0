import 'dart:async';

import 'package:flutter/material.dart';
import 'package:holy_cross_music/models/month.dart';
import 'package:holy_cross_music/models/music.dart';
import 'package:holy_cross_music/screens/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MonthOverviewPage extends StatelessWidget {
  const MonthOverviewPage({super.key, required this.monthlyMusic});
  final MonthlyMusic monthlyMusic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          '${monthlyMusic.monthName} Overview',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () {
              printDoc(monthlyMusic);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              elevation: 2,
            ),
            child: const Text(
              'Print',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ],
      ),
      body: MonthOverviewWidget(monthlyMusic: monthlyMusic),
    );
  }
}

class MonthOverviewWidget extends StatelessWidget {
  const MonthOverviewWidget({super.key, required this.monthlyMusic});

  final MonthlyMusic monthlyMusic;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: monthlyMusic.services.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceTitleWidget(
                    currentService: monthlyMusic.services[index],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Text(
                      Music.parseDate(monthlyMusic.services[index].date),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (monthlyMusic.services[index].organist! != '')
                    ServiceOrganistWidget(
                      currentService: monthlyMusic.services[index],
                    ),
                  ServiceOverviewWidget(
                    currentService: monthlyMusic.services[index],
                  ),
                  if (index != monthlyMusic.services.length - 1)
                    const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> printDoc(MonthlyMusic monthlyMusic) async {
  final doc = pw.Document();

  var numOfServices = monthlyMusic.services.length;
  // [[0, 1], [2, 3], [4]]
  var intList = [];
  var interList = [];

  for (var i = 0; i < numOfServices; i++) {
    interList.add(i);
    if (interList.length == 2 || i == numOfServices - 1) {
      intList.add(interList);
      interList = [];
    }
  }
  for (var j = 0; j < intList.length; j++) {
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.ListView.builder(
                itemCount: intList[j].length,
                itemBuilder: (context, index) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Text(
                          monthlyMusic.services[intList[j][index]].serviceType,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Text(
                          Music.parseDate(
                            monthlyMusic.services[intList[j][index]].date,
                          ),
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      if (monthlyMusic.services[intList[j][index]].organist! !=
                          '')
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Text(
                            'Organist: ${monthlyMusic.services[intList[j][index]].organist!}',
                            style: const pw.TextStyle(fontSize: 12),
                          ),
                        ),
                      pw.ListView.builder(
                        itemCount: monthlyMusic
                            .services[intList[j][index]]
                            .music
                            .length,
                        itemBuilder: (c, i) {
                          return pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              if (monthlyMusic
                                      .services[intList[j][index]]
                                      .music[i]
                                      .musicType !=
                                  '')
                                pw.SizedBox(
                                  width: double.infinity,
                                  child: pw.Text(
                                    monthlyMusic
                                        .services[intList[j][index]]
                                        .music[i]
                                        .musicType,
                                    style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              if (monthlyMusic
                                      .services[intList[j][index]]
                                      .music[i]
                                      .title !=
                                  '')
                                pw.SizedBox(
                                  width: double.infinity,
                                  child: pw.Text(
                                    monthlyMusic
                                        .services[intList[j][index]]
                                        .music[i]
                                        .title
                                        .replaceFirst('#', ' '),
                                    style: const pw.TextStyle(fontSize: 12),
                                  ),
                                ),
                              if (monthlyMusic
                                      .services[intList[j][index]]
                                      .music[i]
                                      .composer !=
                                  '')
                                pw.SizedBox(
                                  width: double.infinity,
                                  child: pw.Text(
                                    monthlyMusic
                                            .services[intList[j][index]]
                                            .music[i]
                                            .composer
                                        as String,
                                    style: pw.TextStyle(
                                      fontStyle: pw.FontStyle.italic,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                      if (index != monthlyMusic.services.length - 1)
                        pw.Divider(),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => doc.save(),
  );
}
