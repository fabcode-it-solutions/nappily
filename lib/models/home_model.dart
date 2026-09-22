class HomeModel {
  final String id;
  final String title;
  final String description;
  final String task;
  final String why;
  final List<dynamic> checklist;
  final String note;
  final String? status;

  HomeModel({
    required this.id,
    required this.title,
    required this.description,
    this.task = '',
    this.why = '',
    this.checklist = const [],
    this.note = '',
    this.status,
  });

  factory HomeModel.fromMap(Map<String, dynamic> data) {
    return HomeModel(
      id: data['id'] ?? '',
      title: data['title'],
      description: data['description'],
      task: data['task'] ?? '',
      why: data['why'] ?? '',
      checklist: List<dynamic>.from(data['checklist'] ?? []),
      note: data['note'] ?? '',
      status: data['status'] ?? 'not_started',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'task': task,
      'why': why,
      'checklist': checklist,
      'note': note,
    };
  }
}

class ChecklistItem {
  final String id;
  final bool isChecked;

  ChecklistItem({required this.id, required this.isChecked});

  Map<String, dynamic> toMap() => {'checklist_id': id, 'isChecked': isChecked};

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['checklist_id'],
      isChecked: map['isChecked'] ?? false,
    );
  }
}
