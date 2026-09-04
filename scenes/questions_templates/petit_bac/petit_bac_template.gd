class_name PetitBacTemplate
extends Template


var themes: Array[String] = ["Youtube", "Instagram", "Influenceur"]
var current_theme: int = 0

@onready var theme_annonce: Label = %ThemeAnnonce
@onready var theme_label: Label = %ThemeLabel
@onready var tab_container: TabContainer = $TabContainer


static func generate_petit_bac() -> PetitBacTemplate:
	var petit_bac_instance: PetitBacTemplate
	petit_bac_instance = DataAccess.petit_bac_scene.instantiate()
	petit_bac_instance.themes = DataAccess.get_petit_bac_streak()
	return petit_bac_instance


func _ready() -> void:
	next_theme()


func next_theme() -> void:
	if current_theme >= themes.size():
		question_finished.emit()
		return
	
	var theme_text = themes[current_theme]
	
	theme_annonce.text = theme_text
	theme_label.text = theme_text
	
	tab_container.current_tab = 0
	
	current_theme += 1


func _on_petit_bac_next_theme() -> void:
	next_theme()
