import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ContraceptionFormData {
  int? age;
  String? maritalStatus;
  bool? hasChildren;
  String? planToHaveChildren;
  bool? hasHealthIssues;
  bool? hasSideEffects;
  String? sideEffectsDescription;
  bool? planContraception;
  List<String>? contraceptionReasons;
  String? otherContraceptionReason;
  String? contraceptionDuration;
  bool? knowsContraceptionMethods;
  List<String>? usedContraceptionMethods;
  String? otherUsedContraceptionMethod;
  bool? satisfiedWithMethod;
  bool? canUseRegularly;
  bool? comfortableWithFollowUp;
  bool? hasRiskyBehavior;
  bool? wantReversibleMethod;
  bool? acceptsHormonalSideEffects;
  List<String>? importantFactors;
  String? otherImportantFactor;
  String? interestedMethod;
  bool? hasConsultedExpert;
  bool? interestedInMoreConsultation;

  ContraceptionFormData({
    this.age,
    this.maritalStatus,
    this.hasChildren,
    this.planToHaveChildren,
    this.hasHealthIssues,
    this.hasSideEffects,
    this.sideEffectsDescription,
    this.planContraception,
    this.contraceptionReasons,
    this.otherContraceptionReason,
    this.contraceptionDuration,
    this.knowsContraceptionMethods,
    this.usedContraceptionMethods,
    this.otherUsedContraceptionMethod,
    this.satisfiedWithMethod,
    this.canUseRegularly,
    this.comfortableWithFollowUp,
    this.hasRiskyBehavior,
    this.wantReversibleMethod,
    this.acceptsHormonalSideEffects,
    this.importantFactors,
    this.otherImportantFactor,
    this.interestedMethod,
    this.hasConsultedExpert,
    this.interestedInMoreConsultation,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'maritalStatus': maritalStatus,
      'hasChildren': hasChildren,
      'planToHaveChildren': planToHaveChildren,
      'hasHealthIssues': hasHealthIssues,
      'hasSideEffects': hasSideEffects,
      'sideEffectsDescription': sideEffectsDescription,
      'planContraception': planContraception,
      'contraceptionReasons': contraceptionReasons,
      'otherContraceptionReason': otherContraceptionReason,
      'contraceptionDuration': contraceptionDuration,
      'knowsContraceptionMethods': knowsContraceptionMethods,
      'usedContraceptionMethods': usedContraceptionMethods,
      'otherUsedContraceptionMethod': otherUsedContraceptionMethod,
      'satisfiedWithMethod': satisfiedWithMethod,
      'canUseRegularly': canUseRegularly,
      'comfortableWithFollowUp': comfortableWithFollowUp,
      'hasRiskyBehavior': hasRiskyBehavior,
      'wantReversibleMethod': wantReversibleMethod,
      'acceptsHormonalSideEffects': acceptsHormonalSideEffects,
      'importantFactors': importantFactors,
      'otherImportantFactor': otherImportantFactor,
      'interestedMethod': interestedMethod,
      'hasConsultedExpert': hasConsultedExpert,
      'interestedInMoreConsultation': interestedInMoreConsultation,
    };
  }
}

class ContraceptionFormService {
  final String baseUrl;

  ContraceptionFormService({required this.baseUrl});

  Future<File?> submitFormAndDownloadPdf(ContraceptionFormData formData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/create-pdf'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(formData.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to submit form: ${response.statusCode}, ${response.body}');
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String fileName = responseData['fileName'];

      if (fileName.isEmpty) {
        throw Exception('No PDF file name received from server');
      }

      return await downloadPdf(fileName);
    } catch (e) {
      print('Error submitting form and downloading PDF: $e');
      return null;
    }
  }

  Future<File?> downloadPdf(String fileName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/uploads/$fileName'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  Future<void> openPdf(File file) async {
    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        throw Exception('Could not open the PDF: ${result.message}');
      }
    } catch (e) {
      print('Error opening PDF: $e');
      throw Exception('Error opening PDF: $e');
    }
  }
}
