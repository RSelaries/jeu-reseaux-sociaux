class_name QcmStreakTemplate
extends Template


var qcm_streak: Array[DataAccess.QCMQuestion]
var current_qcm: int = 0


static func generate_rdm_qcm_streak() -> QcmStreakTemplate:
	var new_qcm_streak_tplt := QcmStreakTemplate.new()
	new_qcm_streak_tplt.qcm_streak = DataAccess.get_qcm_streak(3)
	return new_qcm_streak_tplt


func _ready() -> void:
	if qcm_streak.size() == 0:
		qcm_streak = DataAccess.get_qcm_streak()
	set_position(Vector2(0, 0))
	set_size(get_viewport_rect().size)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	
	var new_cqm := QCMTemplate.generate_qcm(qcm_streak[current_qcm])
	_change_child(new_cqm)


func _change_child(new_child: Template) -> void:
	for child in get_children():
		child.queue_free()
	new_child.question_finished.connect(_on_current_qcm_finished)
	add_child(new_child)


func _on_current_qcm_finished() -> void:
	current_qcm += 1
	if current_qcm == qcm_streak.size():
		question_finished.emit()
		print("Répondu a tout")
		return
	
	var new_cqm := QCMTemplate.generate_qcm(qcm_streak[current_qcm])
	_change_child(new_cqm)
