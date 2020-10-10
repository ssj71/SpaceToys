extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const mag = .5 #magnetic strength
const damp = 1 #velocity damping
var exploded = false
const startlife = 550
var life = startlife
var t = 0 #this is just to keep format consistent with other mines
var period = 0 ##this is just to keep format consistent with other mines
onready var pool = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func process(delta):
	var b = $PromityDetection.get_overlapping_bodies()
	var forced = false
	for body in b:
		if body.get_name() == "ship2":
				#$"../../InfoLabel".set_label_text("mag")
				var vec = body.global_transform.origin - self.global_transform.origin #self.translation - body.translation
				var m = vec.length()/mag
				var vel = self.linear_velocity
				var wrongway = vel - vel.dot(vec)*vec.normalized() #this is to damp out only the movememnt in the wrong direction
				#$"../../InfoLabel".set_label_text(str(v))
				self.add_central_force(vec/(m*m) - damp*wrongway)
				forced = true
	if !forced:
		self.add_central_force(Vector3(0,0,0))
	if exploded and not $Particles.emitting and not $boom.playing:
		$"..".remove_child(self)
		exploded = false
		life = startlife
		$CollisionShape.disabled = true
		global_transform.origin = Vector3(0,-.25,0)
		rotation = Vector3(0,0,0)
		angular_velocity = Vector3(0,0,0)
		linear_velocity = Vector3(0,0,0)
		pool.add_child(self)

func _on_ProximityMine_body_entered(body):
	var name = body.get_name()
	if name == "walls":
		self.angular_velocity = Vector3(0,0,0)
		self.linear_velocity = Vector3(0,0,0)
	elif name.match("*ship*"):
		body.boom()
		hit_ship()

func hit(damage):
	life -= damage
	if life <= 0:
		boom()
	else:
		$hurt.play()
	return !exploded
		
func boom():
	if not exploded:
		$boom.play()
		$Particles.restart()
		annihilate()

	
func annihilate():
	if not exploded:
		exploded = true
		$"../../../gamemode/scorekeeper".add_score(100)
	
func hit_ship():
	exploded = true
	
func reset():
	pass
