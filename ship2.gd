extends "res://OQ_Toolkit/OQ_Classes/OQClass_GrabbableRigidBody.gd"

onready var room = $"../.."
var lenable = false
var renable = false

	
func grab_init(node, grab_type: int) -> void:
	target_node = node
	_grab_type = grab_type
	
	is_grabbed = true
	sleeping = false;
	_orig_can_sleep = can_sleep;
	can_sleep = false;
	
	room.tut(1)
	var grabber = node.get_parent()
	if grabber.get_name().match("*eft*"):
		lenable = true
		renable = false
		grabber.connect("button_pressed",self,"_on_OQ_LeftController_button_pressed")
	else:
		lenable = false
		renable = true
		grabber.connect("button_pressed",self,"_on_OQ_RightController_button_pressed")
		
	collision_layer = 0x0f
	sleeping = false

func _on_OQ_RightController_button_pressed(button):
	if renable and button == 15:
		$Crosshair.shoot()

func _on_OQ_LeftController_button_pressed(button):
	if lenable and button == 15:
		$Crosshair.shoot()

func _on_ship2_body_entered(body):
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
	
func _process(_delta):
	if dead and not $Particles.emitting and not $boom.playing and visible:
		kill()
		$"..".ship_down()
		
func birth(place = Vector3(0,1,-.4)):
	dead = false
	global_transform.origin = place
	rotation = Vector3(0,atan2(-place[0],-place[2]),0)
	visible = true
	$fighterjet2.visible = true
	lenable = false
	renable = false
	
func kill():
	if is_grabbed:
		$"..".release()
	lenable = false
	renable = false
	collision_layer = 0x01
	sleeping = true
	visible = false
	$Crosshair.streak = 0
	global_transform.origin = Vector3(0,-.1,0)
	

func _ready():
	#$Particles.visible = false
	$Particles.restart()
