import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_care/model/contraception_form_model.dart';

class ContraceptionFormService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String contraceptionForm = 'contraceptionForm';

  Future<void> saveContraceptionForm(ContraceptionFormModel survey) async {
    try {
      String documentId = DateTime.now().millisecondsSinceEpoch.toString();

      await _firestore
          .collection(contraceptionForm)
          .doc(documentId)
          .set(survey.toMap());

      print("Survey saved successfully!");
    } catch (e) {
      print("Error saving survey: $e");
    }
  }

  Future<List<ContraceptionFormModel>> getContraceptionForm() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(contraceptionForm).get();

      return snapshot.docs.map((doc) {
        return ContraceptionFormModel.fromMap(
            doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching surveys: $e");
      return [];
    }
  }
}
