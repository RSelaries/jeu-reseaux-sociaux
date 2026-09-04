extends Control


const ANNONCE_TIME = 3.0


@onready var theme_label: Label = %ThemeLabel
@onready var annonce_timer_progress: ProgressBar = %AnnonceTimerProgress


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed() -> void:
	if not visible: return
	
	var tween := get_tree().create_tween()
	annonce_timer_progress.value = 0.0
	tween.tween_property(annonce_timer_progress, "value", 1.0, ANNONCE_TIME)
	
	await get_tree().create_timer(ANNONCE_TIME).timeout
	if get_parent() is TabContainer:
		get_parent().current_tab = 1
