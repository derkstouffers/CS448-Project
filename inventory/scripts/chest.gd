"""
	chest object
	
	registers when a character enters the area of the chest, activates the chest animation,
	then assigns a random amount of coins between 0 and 100 to the character.
	Reduces the number of chests registered within the log for number of different objects present in a level,
	used for checking if level objective is completed 
"""

extends Node2D



func _on_area_2d_area_entered(_area: Area2D) -> void:
	$AnimatedSprite2D.play("open")
	await get_tree().create_timer(1.0).timeout
	Global.gain_coins(randi_range(0, 100))
	Global.level_dict[Global.level.name]['chests'] -= 1
	queue_free()
	
