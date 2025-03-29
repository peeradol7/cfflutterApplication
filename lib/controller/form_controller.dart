import 'package:fam_care/model/contraception_form_model.dart';
import 'package:fam_care/service/contraception_form_service.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  final ContraceptionFormService service = ContraceptionFormService();

  Future<void> saveData(ContraceptionFormModel reqObj) async {
    try {
      await service.saveContraceptionForm(reqObj);
    } catch (e) {
      print('Error  $e');
    }
  }
}
