@tool
class_name Level
extends TextureRect


const texture_qcm: Texture2D = preload("uid://bnqgy7pa2wnbe") # Cyan
const texture_vf: Texture2D = preload("uid://dds72wh80nxx6") # Vert
const texture_sondage: Texture2D = preload("uid://c17wba2lvyaup") # Jaune
const texture_intru: Texture2D = preload("uid://diekdae8rbeqh") # Rouge
const texture_petit_bac: Texture2D = preload("uid://c2fr6oul3sh3i") # Violet
const texture_last: Texture2D = preload("uid://cylr88voctvjl") # Étoile


const texture_state_locked: Texture2D = preload("uid://byc6jdgxh8570")
const texture_state_finished: Texture2D = preload("uid://dksonsh7d4hpo")

enum States { LOCKED, UNLOCKED, FINISHED }

@export var level_nbr: int = 0
@export var lvl_type: DataAccess.QuestionTypes
@export var dernier_niv: bool = false


var state: States = States.LOCKED: set = _set_state

@onready var levels_scene: LevelsScene = owner
@onready var level_state: TextureRect = %LevelState


func _ready() -> void:
	DebugScene.restart.connect(restart)
	levels_scene.current_level_finished.connect(_on_current_level_finished)
	levels_scene.next_level_unlocked.connect(_on_next_level_unlocked)
	if level_nbr == 0:
		state = States.UNLOCKED
	else:
		state = States.LOCKED


func restart() -> void:
	if level_nbr == 0:
		state = States.UNLOCKED
	else:
		state = States.LOCKED


func _on_current_level_finished() -> void:
	if levels_scene.current_level == level_nbr:
		state = States.FINISHED


func _on_next_level_unlocked() -> void:
	if levels_scene.current_level + 1 == level_nbr:
		state = States.UNLOCKED


func set_level_type(value: DataAccess.QuestionTypes) -> void:
	lvl_type = value
	
	if dernier_niv:
		texture = texture_last
		return
	
	match value:
		DataAccess.QuestionTypes.QCM: texture = texture_qcm
		DataAccess.QuestionTypes.VRAI_FAUX: texture = texture_vf
		DataAccess.QuestionTypes.SONDAGE: texture = texture_sondage
		DataAccess.QuestionTypes.INTRU: texture = texture_intru
		DataAccess.QuestionTypes.PETIT_BAC: texture = texture_petit_bac
		
		# Le reste à faire
		#DataAccess.QuestionTypes.PENDU: texture = texture_pendu
		#DataAccess.QuestionTypes.RESEAU_PIXEL: texture = texture_reseau_pixel
		#DataAccess.QuestionTypes.QUESTION_INDICE: texture = texture_indice


func _set_state(value):
	state = value
	match value:
		States.LOCKED:
			level_state.texture = texture_state_locked
			custom_minimum_size = Vector2(120, 120)
			size = Vector2(0, 0)
		States.FINISHED:
			level_state.texture = texture_state_finished
			custom_minimum_size = Vector2(120, 120)
			size = Vector2(0, 0)
		States.UNLOCKED:
			level_state.texture = null
			custom_minimum_size = Vector2(180, 180)
