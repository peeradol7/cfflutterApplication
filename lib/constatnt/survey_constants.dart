import 'package:fam_care/controller/user_controller.dart';
import 'package:get/get.dart';

class SurveyConstants {
  static const String FORM_TITLE = 'แบบสอบถามการคุมกำเนิด';
  static const String PDF_BUTTON = 'สร้าง PDF';
  static const String PDF_SUCCESS = 'สร้าง PDF สำเร็จ';
  static const String PDF_FILENAME = 'survey.pdf';
  final controler = Get.put(UserController());

  static const String role = '';
  static const Map<String, dynamic> roleInfo = {
    'role': {
      'label': 'ระบุสถานะของคุณ',
      'type': 'radio',
      'options': [
        'บุคคลทั่วไป',
        'บุคลากรทางการแพทย์',
        'ผู้ป่าวยของรพ. (บันทึกข้อมูลเอง)',
        'ผู้ป่าวยของรพ. (บุคลากรทางการแพทย์ช่วยบันทึกข้อมูล)'
      ],
    },
  };
  static const String SECTION_1_TITLE = '1. ข้อมูลทั่วไป';
  static const Map<String, dynamic> GENERAL_INFO = {
    'age': {
      'label': 'อายุ: ปี',
    },
    'role': {
      'label': 'คุณเป็นบุคคลทั่วไปหรือผู้ป่วยของโรงพยาบาล ',
      'type': 'radio',
      'options': [
        'บุคคลทั่วไป',
        'บุคลากรทางการแพทย์',
        'ผู้ป่าวยของรพ. (บันทึกข้อมูลเอง)',
        'ผู้ป่าวยของรพ.\n(บุคลากรทางการแพทย์ช่วยบันทึกข้อมูล)'
      ],
    },
    'marital_status': {
      'label': 'สถานภาพการสมรส:',
      'type': 'radio',
      'options': ['โสด', 'สมรส/มีคู่นอน', 'หย่าร้าง'],
    },
    'have_children': {
      'label': 'คุณมีบุตรแล้วหรือไม่:',
      'type': 'radio',
      'options': ['มี', 'ไม่มี'],
    },
    'plan_children': {
      'label': 'คุณวางแผนจะมีบุตรในอนาคตหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่', 'ไม่แน่ใจ'],
    },
  };

  static const String SECTION_2_TITLE = '2. สุขภาพทั่วไป';
  static const Map<String, dynamic> HEALTH_INFO = {
    'health_issues': {
      'label':
          'คุณมีปัญหาสุขภาพที่ต้องระวังเป็นพิเศษในการเลือกวิธีการคุมกำเนิดหรือไม่ เช่น โรคหัวใจ เบาหวาน หรือปัญหาในการใช้ฮอร์โมน:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'side_effects': {
      'label':
          'คุณเคยมีประสบการณ์ผลข้างเคียงจากการใช้วิธีการคุมกำเนิดใดๆ ในอดีตหรือไม่:',
      'type': 'radio',
      'options': ['มี', 'ไม่มี'],
    },
    'side_effects_detail': {
      'label': 'ถ้ามี โปรดระบุ:',
      'type': 'text',
      'dependent_on': {'side_effects': 'มี'},
    },
    'current_situation': {
      'label': 'สถานการณ์ปัจจุบันของคุณเป็นอย่างไร (เลือกได้มากกว่า 1):',
      'type': 'checkbox',
      'options': [
        'มีโรคประจำตัว',
        'เป็นคุณแม่หลังคลอด',
        'มีแผลติดเชื้อ',
        'เครียด',
        'ประจำเดือนมาไม่ปกติ',
        'ไข้หลังคลอด',
        'เลือดไหลไม่หยุด',
        'ท้องผูก',
        'ปัสสาวะเล็ด',
        'อื่นๆ'
      ],
    },
    'history_drug_allergy': {
      'label': 'คุณมีประวัติการแพ้ยาไหม:',
      'type': 'radio',
      'options': ['มี', 'ไม่มี'],
    },
    'history_drug_allergy_detail': {
      'label': 'โปรดระบุ',
      'type': 'text',
      'placeholder': 'โปรดระบุยาที่แพ้',
      'dependent_on': {'history_drug_allergy': 'มี'},
    },
  };

  static const String SECTION_3_TITLE = '3. การวางแผนคุมกำเนิด';
  static const Map<String, dynamic> PLANNING_INFO = {
    'plan_contraception': {
      'label': 'คุณวางแผนคุมกำเนิดหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'reason_for_contraception': {
      'label': 'เหตุผลที่คุณควรคุมกำเนิด',
      'type': 'checkbox',
      'options': [
        'มีจำนวนบุตรเพียงพอแล้ว',
        'เว้นระยะการตั้งครรภ์ไม่ให้ถี่เกินไป',
        'มีปัญหาสุขภาพที่ยังไม่ควรตั้งครรภ์',
        'มีเพศสัมพันธ์ที่ยังไม่ต้องการตั้งครรภ์',
        'อื่นๆ:'
      ],
      'dependent_on': {'plan_contraception': 'ใช่'},
    },
    'other_reason': {
      'label': 'โปรดระบุเหตุผลอื่นๆ:',
      'type': 'text',
      'dependent_on': {'reason_for_contraception': 'อื่นๆ:'},
    },
    'planned_duration': {
      'label': 'คุณวางเป้าหมายจะคุมกำเนิดนานกี่ปี',
      'type': 'radio',
      'options': [
        '1-3 ปี',
        '3-5 ปี',
        '>5 ปี',
        '>10 ปี',
        'ไม่ต้องการตั้งครรภ์อีกในอนาคต'
      ],
      'dependent_on': {'plan_contraception': 'ใช่'},
    },
  };

  static const String SECTION_4_TITLE = '4. ความรู้เกี่ยวกับวิธีการคุมกำเนิด';
  static const Map<String, dynamic> KNOWLEDGE_INFO = {
    'knowledge': {
      'label':
          'คุณรู้จักวิธีกำรคุมกำเนิดและวิธีใช้หรือไม่ วิธีใดบ้ำง (เลือกได้หลายข้อ):',
      'type': 'checkbox',
      'options': [
        'ยาคุมกำเนิดชนิดฮอร์โมนรวม',
        'ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว',
        'ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว',
        'ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี',
        'ห่วงอนามัยชนิดมีฮอร์โมน',
        'ห่วงอนามัยชนิดทองแดง (ไม่มีฮอร์โมน)',
        'รู้จักแต่ไม่รู้วิธีใช้',
        'รู้จักและรู้วิธีใช้แค่บางวิธี แต่ไม่รู้ทั้งหมด',
        'ไม่รู้จักเลย'
      ],
    },
    'previous_methods': {
      'label': 'คุณเคยใช้วิธีคุมกำเนิดแบบใดมาก่อน: (โปรดระบุทั้งหมดที่เคยใช้)',
      'type': 'checkbox',
      'options': [
        'หลั่งนอกช่องคลอด',
        'การนับระยะปลอดภัย',
        'ถุงยางอนามัยชาย (คู่นอนของคุณใช้)หรือหญิง (คุณใช้เอง)',
        'ยาคุมฉุกเฉิน',
        'ยาเม็ดคุมกำเนิด',
        'แผ่นแปะคุมกำเนิด',
        'ยาฉีดคุมกำเนิด',
        'ยาฝังคุมกำเนิด',
        'ห่วงอนามัยคุมกำเนิด',
        'วิธีอื่นๆ:'
      ],
    },
    'other_methods': {
      'label': 'โปรดระบุวิธีอื่นๆ:',
      'type': 'text',
      'dependent_on': {'previous_methods': 'วิธีอื่นๆ:'},
    },
    'satisfaction': {
      'label': 'คุณรู้สึกว่าวิธีที่เคยใช้เหมาะสมกับคุณหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'satisfaction_detail': {
      'label': 'โปรดระบุอาการข้ำงเคียง/ผลที่เกิดขึ้น (เช่น'
          'น้ำหนักขึ้น , สิวขึ้น , ตัวบวม, อำเจียน, ฯลฯ )',
      'type': 'text',
      'placeholder': 'โปรดระบุอาการข้างเคียง/ผลที่เกิดขึ้น',
      'dependent_on': {'satisfaction': 'ไม่ใช่'},
    },
  };

  static const String SECTION_5_TITLE =
      '5. ความสะดวกสบายและความสม่ำเสมอในการใช้';
  static const Map<String, dynamic> CONVENIENCE_INFO = {
    'regular_use': {
      'label':
          'คุณสามารถใช้วิธีคุมกำเนิดที่ต้องใช้เป็นประจำ (เช่น ยาเม็ดคุมกำเนิด) ได้สม่ำเสมอหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'follow_up': {
      'label': 'คุณสะดวกที่จะใช้วิธีคุมกำเนิดที่ต้องมีการตรวจติดตามหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
  };

  static const String SECTION_6_TITLE = '6. ความต้องการในอนาคตและความเสี่ยง';
  static const Map<String, dynamic> RISK_INFO = {
    'risky_activities': {
      'label':
          'คุณมีกิจกรรมทางเพศที่เสี่ยงต่อการตั้งครรภ์โดยไม่ได้วางแผนหรือไม่:',
      'type': 'radio',
      'options': ['มี', 'ไม่มี'],
    },
    'reversible_method': {
      'label':
          'คุณต้องการวิธีคุมกำเนิดที่สามารถยกเลิกได้ง่ายเพื่อวางแผนมีบุตรในอนาคตหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'hormone_side_effects': {
      'label': 'คุณยอมรับผลข้างเคียงที่อาจเกิดขึ้นได้จำกกำรใช้ฮอร์โมนในการ'
          'คุมกำเนิดหรือไม่(น้ำหนักขึ้น , สิวขึ้น , ความเสี่ยงต่อกาเป็นมะเร็งเต้ำนม/โรคหลอดเลือดดำอุดตัน,'
          'ฯลฯ)',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
  };

  static const String SECTION_7_TITLE = '7. ความคิดเห็นส่วนตัว';
  static const Map<String, dynamic> PERSONAL_OPINION = {
    'important_factors': {
      'label':
          'คุณให้ความสำคัญกับปัจจัยใดในการเลือกวิธีคุมกำเนิด \n(เลือก 3 ข้อที่สำคัญที่สุดสำหรับคุณ):',
      'type': 'checkbox_limited',
      'max_selection': 3,
      'options': [
        'ความปลอดภัยสูง',
        'ประสิทธิภาพป้องกันการตั้งครรภ์สูง',
        'อาการข้างเคียงต่ำ',
        'ความสะดวกในการใช้',
        'ราคาถูก',
        'ระยะเวลาการออกฤทธิ์คุมกำเนิดนาน',
        'ไม่ขัดขวางการร่วมเพศ',
        'เมื่อหยุดใช้แล้วสามารถกลับมาตั้งครรภ์ได้เลย',
        'สามารถเข้าถึงง่าย\nไม่ต้องมารับบริการจากบุคลากรทางการแพทย์',
        'อื่นๆ:'
      ],
    },
    'other_factors': {
      'label': 'โปรดระบุปัจจัยอื่นๆ:',
      'type': 'text',
      'dependent_on': {'important_factors': 'อื่นๆ:'},
    },
    'interested_method': {
      'label': 'คุณสนใจวิธีคุมกำเนิดวิธีใด:',
      'type': 'dropdown',
      'options': [
        'ยาคุมกำเนิดชนิดฮอร์โมนรวม',
        'ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว\n(มีโปรเจสโตเจนอย่างเดียว)',
        'ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว',
        'ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี',
        'ห่วงอนามัยชนิดมีฮอร์โมน',
        'ห่วงอนามัยชนิดทองแดง \n(ไม่มีฮอร์โมน)',
      ],
    },
  };

  // ส่วนที่ 8: การปรึกษาผู้เชี่ยวชาญ
  static const String SECTION_8_TITLE = '8. การปรึกษาผู้เชี่ยวชาญ';
  static const Map<String, dynamic> EXPERT_CONSULTATION = {
    'consulted_expert': {
      'label':
          'คุณเคยปรึกษาแพทย์หรือผู้เชี่ยวชาญเกี่ยวกับวิธีการคุมกำเนิดหรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
    'want_consultation': {
      'label': 'คุณสนใจที่จะขอคำปรึกษาเพิ่มเติมจากแพทย์หรือไม่:',
      'type': 'radio',
      'options': ['ใช่', 'ไม่ใช่'],
    },
  };

  static const String MAX_SELECTION_WARNING =
      'เลือกได้สูงสุด {max} ข้อเท่านั้น';
  static const String SELECTED_COUNT = 'เลือกแล้ว {count}/{max} ข้อ';
}
