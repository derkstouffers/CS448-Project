extends CharacterBody2D

@onready var object_cursor = get_node("/root/main/editor_object")
@onready var path_follow : PathFollow2D = $".."
@export var speed = 25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if Global.playing: #and _current_level():
		
		# gravity
		if not is_on_floor():
				
			velocity += get_gravity() * delta
				
				
		# Activates the made path for the slimes		
		path_follow.progress += speed * delta
		
		
		$AnimatedSprite2D.play("bounce")
		
		## based on this implementation we need this to have the gravity work
		move_and_slide()

			


func _on_area_2d_area_entered(area: Area2D) -> void:
	$AnimatedSprite2D.play("hit")
	Global.level_dict[Global.level.name]["enemies"] -= 1
	#print(Global.level_dict)
	queue_free()
	pass # Replace with function body.


#func _current_level():
	#var player_present = Global.playerArea.get_node_or_null("dwarf")
	#print(player_present)
	#if player_present:
		#print("IM HERE")
		#return true	
	#return false
