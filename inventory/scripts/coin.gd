"""
	coin object
	
	registers when a character enters the area of the coin, then adds 1 to the number of coins collected by character.
	Reduces the number of coins registered within the log for number of different objects present in a level,
	used for checking if level objective is completed 
"""



extends Node2D



func _on_area_2d_area_entered(_area: Area2D) -> void:
	Global.gain_coins(1)
	queue_free()
	Global.level_dict[Global.level.name]["coins"] -= 1
	
	
	
