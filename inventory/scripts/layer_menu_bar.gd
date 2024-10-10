extends MenuBar


## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
##
##
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	


func _on_background_pressed() -> void:
	Global.backgroundLayer = true
	Global.playerLayer = false
	Global.foregroundLayer = false
	pass # Replace with function body.




func _on_player_area_pressed() -> void:
	Global.backgroundLayer = false
	Global.playerLayer = true
	Global.foregroundLayer = false
	pass # Replace with function body.
	



func _on_foreground_pressed() -> void:
	Global.backgroundLayer = false
	Global.playerLayer = false
	Global.foregroundLayer = true
	pass # Replace with function body.
