extends KinematicBody


# Declare member variables here. Examples:
var lenable = false #these are just here for compatability with classic ship
var renable = false
onready var room = $"../.."
onready var lctl = $"../../OQ_ARVROrigin/OQ_LeftController"
onready var rctl = $"../../OQ_ARVROrigin/OQ_RightController"
var first = 0.0
var movetime = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Particles.visible = false
	$Particles.restart()
	$"../../OQ_ARVROrigin/OQ_RightController".connect("button_pressed",self,"buttonpress")
	first = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	global_transform.basis = rctl.global_transform.basis
	var a = vr.get_controller_axis(vr.AXIS.LEFT_INDEX_TRIGGER)
	if a or first > movetime:
		a = 1.0+a #axis is E[-1,1]
		if first > movetime:
			room.tut(1)
		if a > .1:
			first += delta
	var u = Vector3(0,0,-a)
	var m = lctl.global_transform.basis.xform(u)
	var c = move_and_collide(.005*m)
	if c and not dead:
		_on_ship2_body_entered(c.collider)
	if dead and not $Particles.emitting and not $boom.playing and visible:
		kill()
		$"..".ship_down()


	
func buttonpress(button):
	if button == 15 and not dead and first > movetime:
		$Crosshair.shoot()

func _on_ship2_body_entered(body):
	var name = body.get_name()
	if name == "walls":
		self.linear_velocity = Vector3(0,0,0);
		self.angular_velocity = Vector3(0,0,0)
	elif name.match("*ine*"):
		boom()
		body.hit_ship()
	elif name.match("PowerUp"):
		if body.type == "points":
			room.bonus(5000,"Bonus! ")
		elif body.type == "upgrade":
			$Crosshair.power = int(1.155*$Crosshair.power)
			room.show_prompt("Weapon Upgrade!",3)
		$bonus.play()
		body.hide()
		
var dead = false
func boom():
	if dead:
		return
	$boom.play()
	$fighterjet2.visible = false
	$Particles.restart()
	dead = true
	
func kill():
	visible = false
	global_transform.origin = Vector3(0,-.1,0)
	$Crosshair.streak = 0
	
func birth():
	dead = false
	global_transform.origin = Vector3(0,1,-.4)
	visible = true
	$fighterjet2.visible = true
	


