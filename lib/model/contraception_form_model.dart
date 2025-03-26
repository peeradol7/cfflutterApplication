class ContraceptionFormModel {
  final String maritalStatus;
  final String haveChildren;
  final String planChildren;
  final String healthIssues;
  final String sideEffects;
  final String planContraception;
  final String plannedDuration;
  final String knowledge;
  final String satisfaction;
  final String regularUse;
  final String followUp;
  final String riskyActivities;
  final String reversibleMethod;
  final String hormoneSideEffects;
  final String interestedMethod;
  final String consultedExpert;
  final String wantConsultation;

  ContraceptionFormModel({
    required this.maritalStatus,
    required this.haveChildren,
    required this.planChildren,
    required this.healthIssues,
    required this.sideEffects,
    required this.planContraception,
    required this.plannedDuration,
    required this.knowledge,
    required this.satisfaction,
    required this.regularUse,
    required this.followUp,
    required this.riskyActivities,
    required this.reversibleMethod,
    required this.hormoneSideEffects,
    required this.interestedMethod,
    required this.consultedExpert,
    required this.wantConsultation,
  });

  factory ContraceptionFormModel.fromMap(Map<String, dynamic> map) {
    return ContraceptionFormModel(
      maritalStatus: map['marital_status'],
      haveChildren: map['have_children'],
      planChildren: map['plan_children'],
      healthIssues: map['health_issues'],
      sideEffects: map['side_effects'],
      planContraception: map['plan_contraception'],
      plannedDuration: map['planned_duration'],
      knowledge: map['knowledge'],
      satisfaction: map['satisfaction'],
      regularUse: map['regular_use'],
      followUp: map['follow_up'],
      riskyActivities: map['risky_activities'],
      reversibleMethod: map['reversible_method'],
      hormoneSideEffects: map['hormone_side_effects'],
      interestedMethod: map['interested_method'],
      consultedExpert: map['consulted_expert'],
      wantConsultation: map['want_consultation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'marital_status': maritalStatus,
      'have_children': haveChildren,
      'plan_children': planChildren,
      'health_issues': healthIssues,
      'side_effects': sideEffects,
      'plan_contraception': planContraception,
      'planned_duration': plannedDuration,
      'knowledge': knowledge,
      'satisfaction': satisfaction,
      'regular_use': regularUse,
      'follow_up': followUp,
      'risky_activities': riskyActivities,
      'reversible_method': reversibleMethod,
      'hormone_side_effects': hormoneSideEffects,
      'interested_method': interestedMethod,
      'consulted_expert': consultedExpert,
      'want_consultation': wantConsultation,
    };
  }
}
