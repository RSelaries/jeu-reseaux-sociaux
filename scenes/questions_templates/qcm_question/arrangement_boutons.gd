@tool
class_name QCMArrangementBoutons
extends TabContainer


const btn_true_sbox: StyleBoxFlat = preload("uid://dqaxm58v2m6q8")


signal reponse_selectionee(reponse_index: int)


# Références des boutons
@onready var reponse_courte_1: Button = %ReponseCourte1
@onready var reponse_courte_2: Button = %ReponseCourte2
@onready var reponse_courte_3: Button = %ReponseCourte3
@onready var reponse_courte_4: Button = %ReponseCourte4

@onready var reponse_longue_1: Button = %ReponseLongue1
@onready var reponse_longue_2: Button = %ReponseLongue2
@onready var reponse_longue_3: Button = %ReponseLongue3
@onready var reponse_longue_4: Button = %ReponseLongue4


var btn_array: Array[Button]


func _ready() -> void:
	btn_array = [
		reponse_courte_1, reponse_longue_1, reponse_courte_2, reponse_longue_2,
		reponse_courte_3, reponse_longue_3, reponse_courte_4, reponse_longue_4,
	]
	
	# Connecte le signal du bouton appuyé avec la fonction
	# _on_reponse_button_pressed() en passant le nombre de la réponse
	# (1, 2, 3, 4) comme index.
	for button in btn_array:
		var btn_name: String = button.name
		btn_name.replace("ReponseCourte", "")
		btn_name.replace("ReponseLongue", "")
		var btn_index := int(btn_name)
		button.pressed.connect(_on_reponse_button_pressed.bind(btn_index))


# btn_index est le nombre de la réponse (1, 2, 3 ou 4)
func _on_reponse_button_pressed(btn_index: int) -> void:
	reponse_selectionee.emit(btn_index)


func disable_button(index: int) -> void:
	index -= 1
	btn_array[index * 2].disabled = true
	btn_array[index * 2 + 1].disabled = true


func show_correct_button(correct_index: int) -> void:
	var crr_index = correct_index - 1
	for i in range(4):
		disable_button(i + 1)
		if i == crr_index:
			btn_array[i*2].add_theme_stylebox_override("disabled", btn_true_sbox)
			btn_array[i*2].add_theme_color_override("font_disabled_color", Color.BLACK)
			
			btn_array[i*2+1].add_theme_stylebox_override("disabled", btn_true_sbox)
			btn_array[i*2+1].add_theme_color_override("font_disabled_color", Color.BLACK)


func update_buttons_text(button_texts: Array[String]) -> void:
	current_tab = 0
	for i in button_texts.size():
		var btn_text: String = button_texts[i]
		match i:
			0: btn_text = "A. " + button_texts[i]
			1: btn_text = "B. " + button_texts[i]
			2: btn_text = "C. " + button_texts[i]
			3: btn_text = "D. " + button_texts[i]
		btn_array[i*2].text = btn_text
		btn_array[i*2+1].text = btn_text
		
		if button_texts[i].length() > 22:
			current_tab = 1
