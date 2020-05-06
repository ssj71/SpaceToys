extends StaticBody

#nukular bombs bruh, very fragile

# Declare member variables here. Examples:
var t = 0.0
var exploded = false
var blowing = false
const tex = .25
const tdis = 2
const exspeed = .7/tex

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if blowing:
		t += delta
		if t < tex:
			$explosion/CSGSphere.radius = .1+t*exspeed
			$explosion/CollisionShape.shape.radius = .1+t*exspeed
			$mine2.visible = false
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
		elif not $booooooom.playing:
			queue_free()
		

	
		
func hit(damage):
	return boom()
		
func boom():
	return annihilate()

func annihilate():
	if not blowing:
		blowing = true
		$booooooom.play()
		$explosion.visible = true
		$"../../scorekeeper".add_score(100)
		return true
	return false

func hit_ship():
	boom()
