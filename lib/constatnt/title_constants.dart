class ContentConstants {
  static final String firstTitle = 'ยาคุมกำเนิดชนิดฮอร์โมนรวม';
  static final String secondtTitle =
      'ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว\n(มีโปรเจสโตเจนอย่างเดียว)';
  static final String thirdTitle = 'ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว';
  static final String fourthTitle = 'ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี';
  static final String fivethitle = 'ห่วงอนามัยชนิดมีฮอร์โมน"';
  static final String sixthitle = 'ห่วงอนามัยชนิดทองแดง \n(ไม่มีฮอร์โมน)';

  static final String description = 'คำอธิบายตาราง:';

  static final String firstDescription = 'หมวด 1 = ใช้วิธีนี้ได้ทุกกรณี';
  static final String secondDescription =
      'หมวด 2 = ใช้วิธีนี้ได้โดยทั่วไป (หากใช้ได้ทั้งวิธีในหมวด 1 และ 2 ให้เลือกใช้หมวด 1 ก่อน)';
  static final String thirdDescription =
      'หมวด 3 = ไม่ควรใช้วิธีนี้ ยกเว้นไม่สามารถจัดหาวิธีที่เหมาะสมกว่านี้ ใช้ได้ภายใต้ข้อพิจารณาของบุคลากรทางการแพทย์';
  static final String fourthDescription = 'หมวด 4 = ห้ามใช้วิธีนี้';
  static final String fivethDescription =
      'หมายเหตุ: ทุกวิธีแนะนำให้ใช้ร่วมกับถุงยางอนามัยสำหรับผู้ชายหรือผู้หญิง เพื่อป้องกันโรคติดต่อทางเพศสัมพันธ์/ เชื้อเอชไอวี';
  static final String sixthescription =
      '• วิธีคุมกำเนิดที่ปลอดภัยสำหรับคุณ (เรียงตามหมวด 1-4) คือ ';
  static String getTitle(String methodKey) {
    switch (methodKey) {
      case "first":
        return firstTitle;
      case "second":
        return secondtTitle;
      case "third":
        return thirdTitle;
      case "four":
        return fourthTitle;
      case "five":
        return fivethitle;
      case "six":
        return sixthitle;
      default:
        return "ไม่พบข้อมูล"; // กรณีที่ key ไม่ตรงกับที่กำหนด
    }
  }

  static final List<String> contraceptiveTitles = [
    'ยาคุมกำเนิดชนิดฮอร์โมนรวม',
    'ยาเม็ดคุมกำเนิดชนิดฮอร์โมนเดี่ยว\n(มีโปรเจสโตเจนอย่างเดียว)',
    'ยาฉีดคุมกำเนิดชนิดฮอร์โมนเดี่ยว',
    'ยาฝังคุมกำเนิดชนิด 3 ปี/5 ปี',
    'ห่วงอนามัยชนิดมีฮอร์โมน',
    'ห่วงอนามัยชนิดทองแดง \n(ไม่มีฮอร์โมน)',
  ];
  static final List<String> keys = [
    'first',
    'second',
    'third',
    'four',
    'five',
    'six',
  ];
}
