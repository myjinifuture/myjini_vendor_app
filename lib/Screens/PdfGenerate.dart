import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';

class PdfGenerate extends StatefulWidget {
  String PaymentId;
  PdfGenerate({this.PaymentId});
  @override
  _PdfGenerateState createState() => _PdfGenerateState();
}

class _PdfGenerateState extends State<PdfGenerate> {
  String _header;
  String billingId = '--';



  @override
  void initState() {
    billingId=widget.PaymentId;
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    var _logo = await rootBundle.loadString('assets/Freesample.svg');
    var _header = await rootBundle.loadString('assets/header.svg');

    // String billingId = '${widget.PaymentId}';



    DateTime date = new DateTime.now();
    var date1 = date.add(Duration(days: 365));
    var dateParse = DateTime.parse(date.toString());
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    final Date = formattedDate.toString();
    var dateParse1 = DateTime.parse(date1.toString());
    var formattedDate1 =
        "${dateParse1.day}/${dateParse1.month}/${dateParse1.year}";
    final Date1 = formattedDate1.toString();

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        // pageTheme: _buildTheme(),
        margin: pw.EdgeInsets.all(30),
        maxPages: 1,
        pageFormat: format,
        build: (context) => [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Container(
                // width: 580,
                child: pw.Column(children: [
                  pw.Container(
                    height: 50,
                    width: 535,
                    padding: pw.EdgeInsets.only(right: 10),
                    alignment: pw.Alignment.centerRight,
                    child: pw.Text(
                      'Invoice',
                      style: pw.TextStyle(
                        // color: ,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#ffffff'),
                        fontSize: 40,
                      ),
                    ),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#7222a9'),
                    ),
                  ),
                  pw.Row(
                    children: [
                      pw.Container(
                          height: 80,
                          width: 100,
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'My Jini',
                            style: pw.TextStyle(
                                color: PdfColor.fromHex('#ffffff'),
                                fontSize: 25),
                          ),
                          // child: _logo != null
                          //     ? pw.SvgImage(svg: _logo)
                          //     : pw.PdfLogo(),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromHex('#7222a9'),
                          )),
                      pw.Container(
                        height: 80,
                        width: 435,
                        color: PdfColor.fromHex('#868388'),
                        padding: pw.EdgeInsets.only(right: 10),
                        child: pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              // pw.SizedBox(height: 10),
                              pw.Text(
                                'Invoice No : 123',
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex('#ffffff'),
                                ),
                              ),
                              pw.Text(
                                'Date : ' + Date.toString(),
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex('#ffffff'),
                                ),
                              ),
                              pw.Text(
                                'Account No : 23456',
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex('#ffffff'),
                                ),
                              ),
                            ]),
                      )
                    ],
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(height: 10),
                              pw.Text('Bill To:'),
                              pw.Text('Company Name'),
                              pw.Text('Contact No'),
                              pw.Text('mail id or other detail'),
                            ]),
                      ]),
                  pw.Row(children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(height: 10),
                          pw.Text('Details'),
                          pw.Text('Invoice number..................123'),
                          pw.Text('Date.........................$Date'),
                          pw.Text('Billing Id......................$billingId'),
                          pw.Text('Account Id..................$billingId'),
                        ]),
                  ]),
                  pw.Container(
                    margin: pw.EdgeInsets.only(
                        left: 72, top: 10, right: 72, bottom: 10),
                    // padding: pw.EdgeInsets.all(5),
                    color: PdfColor.fromHex('#7222a9'),
                    child: pw.Column(
                      children: [
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),
                                // height: 30,
                                child: pw.Text(
                                  'No',
                                  style: pw.TextStyle(color: PdfColors.white),
                                ),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 2, color: PdfColors.white),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),
                                // height: 30,
                                child: pw.Text(
                                  'Product Description'.toUpperCase(),
                                  style: pw.TextStyle(color: PdfColors.white),
                                ),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 2, color: PdfColors.white),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),

                                // height: 30,
                                child: pw.Text(
                                  'Unit Price'.toUpperCase(),
                                  style: pw.TextStyle(color: PdfColors.white),
                                ),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 2, color: PdfColors.white),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),
                                // height: 30,
                                child: pw.Text(
                                  'Qty'.toUpperCase(),
                                  style: pw.TextStyle(color: PdfColors.white),
                                ),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 2, color: PdfColors.white),
                                ),
                              ),
                              pw.Container(
                                padding: pw.EdgeInsets.only(
                                    left: 10, top: 8, right: 10, bottom: 8),
                                // height: 30,
                                child: pw.Text(
                                  'Total'.toUpperCase(),
                                  style: pw.TextStyle(color: PdfColors.white),
                                ),
                                decoration: pw.BoxDecoration(
                                  border: pw.Border.all(
                                      width: 2, color: PdfColors.white),
                                ),
                              ),
                            ]),
                        pw.Container(
                          color: PdfColor.fromHex('#d9b2f4'),
                          child: pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      left: 15, top: 8, right: 13, bottom: 8),
                                  // height: 30,
                                  child: pw.Text(
                                    '1',
                                    style: pw.TextStyle(color: PdfColors.white),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: 2, color: PdfColors.white),
                                  ),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      left: 10, top: 8, right: 10, bottom: 8),
                                  // height: 30,
                                  child: pw.Text(
                                    'MyJini Advertisement'.toUpperCase(),
                                    style: pw.TextStyle(color: PdfColors.white),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: 2, color: PdfColors.white),
                                  ),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      left: 25, top: 8, right: 26, bottom: 8),
                                  // height: 30,
                                  child: pw.Text(
                                    '21,000'.toUpperCase(),
                                    style: pw.TextStyle(color: PdfColors.white),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: 2, color: PdfColors.white),
                                  ),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      left: 20, top: 8, right: 18, bottom: 8),

                                  // height: 30,
                                  child: pw.Text(
                                    '1'.toUpperCase(),
                                    style: pw.TextStyle(color: PdfColors.white),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: 2, color: PdfColors.white),
                                  ),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      left: 10, top: 8, right: 12, bottom: 8),
                                  // height: 30,
                                  child: pw.Text(
                                    '21,000'.toUpperCase(),
                                    style: pw.TextStyle(color: PdfColors.white),
                                  ),
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                        width: 2, color: PdfColors.white),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // pw.Column(
                        //     crossAxisAlignment: pw.CrossAxisAlignment.start,
                        //     children: [
                        //       pw.Container(height: 10),
                        //       pw.Text('Details'),
                        //       pw.Text('Invoice number..................123'),
                        //       pw.Text('Date...........................$Date'),
                        //       pw.Text('Billing Id..................$billingId'),
                        //       pw.Text('Account Id..................$billingId'),
                        //     ]),
                        // pw.Container(
                        pw.SizedBox(height: 20),
                        pw.Column(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(height: 10),
                              pw.Text('HSN: '),
                              pw.Text('MyGini Advertisement'),
                              pw.Container(
                                  margin: pw.EdgeInsets.symmetric(vertical: 4),
                                  height: 1,
                                  width: 200,
                                  decoration: pw.BoxDecoration(
                                      color: PdfColor.fromRYB(0.5, 0.5, 0.5))),
                              pw.Container(
                                  width: 200,
                                  child: pw.Expanded(
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('Total in Rupees'),
                                          pw.Text(_formatCurrency(21000)),
                                        ]),
                                  )),
                              pw.Container(height: 10),
                              pw.Text('Summay Form $Date to $Date1'),
                              pw.Container(height: 10),
                              pw.Text('MyGini Advertisement'),
                              pw.Container(
                                  margin: pw.EdgeInsets.symmetric(vertical: 4),
                                  height: 1,
                                  width: 200,
                                  decoration: pw.BoxDecoration(
                                      color: PdfColor.fromRYB(0.5, 0.5, 0.5))),
                              pw.Container(
                                  width: 200,
                                  child: pw.Expanded(
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('SubTotal in Rupees'),
                                          pw.Text(_formatCurrency(9322)),
                                        ]),
                                  )),
                              pw.Container(
                                  width: 200,
                                  child: pw.Expanded(
                                    child: pw.Row(
                                        mainAxisAlignment:
                                            pw.MainAxisAlignment.spaceBetween,
                                        children: [
                                          pw.Text('Integrated GST(18%)'),
                                          pw.Text(_formatCurrency(1678)),
                                        ]),
                                  )),
                              // pw.Container(
                              //     width: 200,
                              //     child: pw.Row(
                              //         mainAxisAlignment:
                              //         pw.MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           pw.Expanded(child: pw.Text('Integrated GST(18%)')),
                              //           pw.Expanded(child: pw.Text(_formatCurrency(1678))),
                              //         ])),

                              pw.Container(
                                width: 200,
                                child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Total in Rupees'),
                                      pw.Text(_formatCurrency(21000)),
                                    ]),
                              ),
                              // pw.Divider(height: 50,thickness: 2,color: PdfColor.fromRYB(1, 1, 1)),
                            ]),
                        // ),
                      ]),
                  pw.Container(height: 20),
                  pw.Row(
                    children: [
                      pw.Container(
                          width: 480,
                          child: pw.Text(
                              'Note: Unless otherwise stated, tax on this invoice is not payable under reverse charge. Supplies under reverse charge are to mentioned separately')),
                    ],
                  ),
                ]),
              ),
              pw.Container(
                margin: pw.EdgeInsets.only(top: 10),
                alignment: pw.Alignment.center,
                height: 20,
                color: PdfColor.fromHex('#7222a9'),
                child: pw.Text('Thank You For Your Business'.toUpperCase(),
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
    // final output = await getTemporaryDirectory();
    // print('s');
    // final file = File('${output.path}/invoice.pdf');
    // print('${output.path}');
    // print('ss');
    // file.writeAsBytes(await pdf.save());
    print('success');

    //to share
    // await Printing.sharePdf(bytes: await pdf.save(), filename: 'my-document.pdf');
    //if we want to print
    // final pdf1=await rootBundle.load('assets/ladufashion.pdf');
    // await Printing.layoutPdf(onLayout: (_)=>pdf1.buffer.asUint8List());
    return pdf.save();
  }

  pw.PageTheme _buildTheme() {
    return pw.PageTheme(
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _header),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)}';
    // ₹
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf'),
        foregroundColor: Color.fromRGBO(114, 34, 169, 1),
      ),
      body: PdfPreview(
        // pdfPreviewPageDecoration: pw.B,
        build: (format) => _generatePdf(format),
      ),
    );
  }
}
