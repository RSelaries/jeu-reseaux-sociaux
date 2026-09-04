class_name IntruStreak
extends Template


var questions: Array[DataAccess.IntruQuestion]

var current_question: int = 0


static func generate_intru_streak(nbr_of_question: int = 3) -> IntruStreak:
	var intru_stk_scene := preload("uid://cstsfa4uxjjwq")
	var new_intru_scene: IntruStreak = intru_stk_scene.instantiate()
	new_intru_scene.questions = DataAccess.get_intru_streak(nbr_of_question)
	return new_intru_scene


func _ready() -> void:
	_next_question()


func _next_question() -> void:
	for child in get_children(): child.queue_free()
	
	var new_intru_qst := IntruTemplate.generate_intru_streak()
	new_intru_qst.intru_question = questions[current_question]
	new_intru_qst.question_finished.connect(_on_question_finished)
	add_child(new_intru_qst)
	current_question += 1


func _on_question_finished() -> void:
	if current_question == questions.size():
		question_finished.emit()
	else:
		_next_question()
