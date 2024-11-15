extends Node2D
@onready var transition = $SceneTransitionRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_build_btn_pressed() -> void:
	transition.transition_to("res://scenes/main.tscn")


func _on_load_btn_pressed() -> void:	
	$FileDialog.access = FileDialog.ACCESS_USERDATA
	$FileDialog.mode = FileDialog.FILE_MODE_OPEN_FILE
	$FileDialog.popup_centered()


func _on_file_dialog_file_selected(path: String) -> void:
	Global.dungeon_loaded = true
	var scene_name = path.get_file().get_basename()
	Global.load_path = "user://dungeon_save_data/%s.tres" % scene_name
	transition.transition_to(path)
