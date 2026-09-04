# LevelsManager
extends Node

const levels_pck_scene: PackedScene = preload("uid://b4353ymoppx64")


var levels_scene: LevelsScene


func _ready() -> void:
	levels_scene = levels_pck_scene.instantiate()


func next_level() -> void:
	levels_scene.next_level()


func level_scene_freed() -> void:
	levels_scene = levels_pck_scene.instantiate()
