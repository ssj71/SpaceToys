extends "res://OQ_Toolkit/OQ_Classes/OQClass_GrabbableRigidBody.gd"

onready var room = get_parent()

	
func grab_init(node, grab_type: int) -> void:
	target_node = node
	_grab_type = grab_type
	
	is_grabbed = true
	sleeping = false;
	_orig_can_sleep = can_sleep;
	can_sleep = false;
	
	room.tut(1)
	$Crosshair.enabled = true
	$Particles.visibile = true

func _on_OQ_RightController_button_pressed(button):
	if button == 15:
		$Crosshair.shoot()
		
func _on_OQ_RightController_button_released(button):
	pass
	
func _on_OQ_LeftController_button_pressed(button):
	if button == 15:
		$Crosshair.shoot()
		
func _on_ship2_body_entered(body):
	var p = body.get_parent()
	var name = body.get_name()
	if name == "walls":
		if is_grabbed:
			$"..".release()
		self.linear_velocity = Vector3(0,0,0);
		self.angular_velocity = Vector3(0,0,0)
	elif name.match("*ine*"):
		boom()
		body.hit_ship()
		
var dead = false
func boom():
	if dead:
		return
	$boom.play()
	$fighterjet2.visible = false
	$Particles.restart()
	dead = true
	if is_grabbed:
		$"..".release()
	
func _process(delta):
	if dead and not $Particles.emitting and not $boom.playing:
		if is_grabbed:
			$"..".release()
		room.get_node("scorekeeper").show_scores()
		room.get_node("MineFactory").ship = null
		queue_free()

func _ready():
	#$Particles.visible = false
	$Particles.restart()
	room.get_node("scorekeeper").hide_scores()
