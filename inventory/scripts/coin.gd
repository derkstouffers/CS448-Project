extends Node2D



func _on_area_2d_area_entered(area: Area2D) -> void:
	Global.gain_coins(1)
	queue_free()
	Global.level_dict[Global.level.name]["coins"] -= 1
	
	
	
