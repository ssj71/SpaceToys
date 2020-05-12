extends StaticBody

#nukular bombs bruh, very fragile

# Declare member variables here. Examples:
var t = 0.0
var blowing = false
const tex = .25 #expand
const tdis = 2 #disperse
const exspeed = .7/tex
onready var pool = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	if blowing:
		t += delta
		if t < tex:
			$explosion/CSGSphere.radius = .1+t*exspeed
			$explosion/CollisionShape.shape.radius = .1+t*exspeed
		elif t < tex+tdis:
			var v = 1.0-(t-tex)/tdis
			$explosion/CSGSphere.material.albedo_color.a = v
			$explosion/CSGSphere.material.emission_energy = 2*v
			var b = $explosion.get_overlapping_bodies()
			for body in b:
				var name = body.get_name()
				if name == "ship2":
					body.boom()
				elif name.match("*ine*"):
					body.annihilate()
		elif not $boooom.playing:
			$"..".remove_child(self)
			reset()
			pool.add_child(self)

func reset():
	blowing = false
	t = 0
	$mine2.visible = true
	$explosion.visible = false
	$explosion/CSGSphere.radius = .1
	$explosion/CollisionShape.shape.radius = .1
	$explosion/CSGSphere.material.albedo_color.a = 1.0
	$explosion/CSGSphere.material.emission_energy = 2
	$CollisionShape.disabled = true
	global_transform.origin = Vector3(0,-.25,0)

	
		
func hit(damage):
	return boom()
		
func boom():
	return annihilate()

func annihilate():
	if not blowing:
		blowing = true
		$boooom.play()
		$explosion.visible = true
		$mine2.visible = false
		$"../../../scorekeeper".add_score(100)
		return true
	return false

func hit_ship():
	boom()
