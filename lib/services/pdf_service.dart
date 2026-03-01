import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/benefit.dart';

class PdfService {
  /// Auto-fills a claim form PDF with user data and answers.
  static Future<File?> generateClaimPdf({
    required Benefit benefit,
    required List<String> answers,
    required String userName,
  }) async {
    try {
      // 1. Load the template PDF from assets (assuming assets/forms/claim_template.pdf exists)
      // For this demo, we'll create a new document if the template is missing.
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      // 2. Add Content
      page.graphics.drawString(
        'OFFICIAL BENEFIT CLAIM FORM',
        PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 0, 500, 30),
      );

      page.graphics.drawString(
        'Provider: ${benefit.providerName}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 50, 500, 20),
      );

      page.graphics.drawString(
        'Card/Plan: ${benefit.cardName}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 70, 500, 20),
      );

      page.graphics.drawString(
        'Benefit: ${benefit.perkName}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 90, 500, 20),
      );

      page.graphics.drawString(
        'Claimant Name: $userName',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 120, 500, 20),
      );

      // 3. Add Answers
      double currentY = 160;
      page.graphics.drawString(
        'Claim Details:',
        PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(0, currentY, 500, 20),
      );
      
      currentY += 30;
      for (int i = 0; i < answers.length; i++) {
        page.graphics.drawString(
          'Q${i + 1}: ${answers[i]}',
          PdfStandardFont(PdfFontFamily.helvetica, 11),
          bounds: Rect.fromLTWH(20, currentY, 460, 40),
        );
        currentY += 40;
      }

      // 4. Save the document
      final List<int> bytes = await document.save();
      document.dispose();

      // 5. Write to local storage
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/claim_${benefit.id}.pdf');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      print('Error generating PDF: $e');
      return null;
    }
  }
}
