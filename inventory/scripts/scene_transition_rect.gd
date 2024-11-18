extends ColorRect

@export_file var next_scene_path: String
@onready var anim_player := $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play_backwards("fade")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func transition_to(next_scene := next_scene_path):
	anim_player.play("fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(next_scene)

func transition():
	anim_player.play("fade")
	await anim_player.animation_finished
