"""
	Ghost object
	
	not finished, should function similar to slime but has bug 
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
			#if not is_on_floor():
					
			velocity += get_gravity() * delta
					
					
			# Activates the made path for the ghosts		
			path_follow.progress += speed * delta
			
			
			$AnimatedSprite2D.play("ghost_float")
			
			## based on this implementation we need this to have the gravity work
			move_and_slide()

			


func _current_level():
	
	for lev in Global.level_array:
		if get_node("/root/main/" + lev + "/Player Area").has_node("dwarf"):
			level = lev
			#print(level)
