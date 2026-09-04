@tool
extends VBoxContainer


var parcour: Parcour: set = set_parcour


var set_all_button: Button
var set_all_options: OptionButton


func set_parcour(p: Parcour) -> void:
	parcour = p
	_update_inspect()

func _on_niv_type_selected(reponse_selected: int, niv_index: int) -> void:
	parcour.niveaux[niv_index].level_type = reponse_selected
	#_update_inspect()


func _update_inspect() -> void:
	set_all_button = $HBoxContainer/HBoxContainer/SetAllButton
	set_all_options = $HBoxContainer/HBoxContainer/SetAllOptions
	
	set_all_button.pressed.connect(func():
		for niveau in parcour.niveaux:
			niveau.level_type = set_all_options.selected
			#_update_inspect()
	)
	
	for qst_type_key in DataAccess.QuestionTypes.keys():
		set_all_options.add_item(qst_type_key)
	
	for i in range(parcour.niveaux.size()):
		var new_niv := HBoxContainer.new()
		
		var niv_name := Label.new()
		niv_name.text = "Niveau " + str(i + 1)
		niv_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_niv.add_child(niv_name)
		
		var niv_options := OptionButton.new()
		for qst_type_key in DataAccess.QuestionTypes.keys():
			niv_options.add_item(qst_type_key)
		niv_options.selected = parcour.niveaux[i].level_type
		niv_options.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		niv_options.item_selected.connect(_on_niv_type_selected.bind(i))
		new_niv.add_child(niv_options)
		
		add_child(new_niv)
