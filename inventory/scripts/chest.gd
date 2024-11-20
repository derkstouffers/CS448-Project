extends Node2D



func _on_area_2d_area_entered(_area: Area2D) -> void:
	$AnimatedSprite2D.play("open")
	await get_tree().create_timer(1.0).timeout
	Global.gain_coins(randi_range(0, 100))
	Global.level_dict[Global.level.name]['chests'] -= 1
	queue_free()
	
