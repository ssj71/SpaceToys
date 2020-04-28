extends StaticBody


# Declare member variables here. Examples:
const tgrow = 4
const thold = 2
const trotate = 1
const period = tgrow+thold+trotate
const rspeed = 45*PI/180/trotate
const gspeed = 150/tgrow
var t = 0.0
var exploded = false
var rotated45 = false
var life = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t <= trotate:
		if rotated45:
			#rotation[1] -= rspeed*delta
			rotate_object_local(Vector3(0,1,0), -rspeed*delta)
		else:
			#rotation[1] += rspeed*delta
			rotate_object_local(Vector3(0,1,0), 
			rspeed*delta)
			pass
		pass
	elif t <= tgrow:
		$laserx.scale[2] += gspeed*delta
		$laserz.scale[2] += gspeed*delta
		scanforship()
	elif t >= period:
		$laserx.scale[2] = 1
		$laserz.scale[2] = 1
		rotated45 = not rotated45
		t -= period #if delta is ever greater than period this could be problematic
	else:
		#hold
		scanforship()
	
	if exploded and not $Particles.emitting and not $boom.playing:
		self.queue_free()
		
func scanforship():
	var b = $laserx.get_overlapping_bodies()
	b += $laserz.get_overlapping_bodies()
	for body in b:
		print(body.get_name())
		if body.get_name() == "ship2":
			body.boom()
		
func hit(damage):
	life -= damage
	if life <= 0:
		boom()
	else:
		$hurt.play()
		
func boom():
	if not exploded:
		$boom.play()
		$Particles.restart()
		annihilate()

func annihilate():
	exploded = true
	$"../..".add_score(300)

func hit_ship():
	pass
