"""
	slime object
	
	if in playing mode and slime is in the current level being played:
		slime follows predetermined path (moves back and forth)
		if fireball enters slime area2D slime is defeated 
"""


extends CharacterBody2D

@onready var object_cursor = get_node("/root/main/editor_object")
@onready var path_follow : PathFollow2D = $".."
@export var speed = 25

var level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Global.playing:
		_current_level()
		
		if level == get_parent().get_parent().get_parent().get_parent().get_parent().name:
			
			# gravity
			if not is_on_floor():
					
				velocity += get_gravity() * delta
					
					
			# Activates the made path for the slimes		
			path_follow.progress += speed * delta
			
			
			$AnimatedSprite2D.play("bounce")
			
			## allows the movement of character to work
			move_and_slide()

			

# checks for anything interacting with slime's area2D, slime dies and is removed from enemy count for current level for objective completion check
func _on_area_2d_area_entered(_area: Area2D) -> void:
	
	queue_free()
	Global.level_dict[Global.level.name]["enemies"] -= 1


# checks if slime is in the current level being played 
func _current_level():
	
	for lev in Global.level_array:
		if get_node("/root/main/" + lev + "/Player Area").has_node("dwarf") or get_node("/root/main/" + lev + "/Player Area").has_node("wizard") or get_node("/root/main/" + lev + "/Player Area").has_node("witch"):
			level = lev
			
