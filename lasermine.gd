extends StaticBody


# Declare member variables here. Examples:
const tgrow = 5
const thold = 1
const trotate = 1
const period = tgrow+thold+trotate
const rspeed = 45*PI/180/trotate
const gspeed = 5.0/tgrow
var t = 0.0
var exploded = false
var rotated45 = false
const startlife = 5
var life = startlife
var first = true
onready var pool = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$minelasers.extend(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	t += delta
	if t <= trotate:
		if rotated45:
			rotate_object_local(Vector3(0,1,0), -rspeed*delta)
		else:
			rotate_object_local(Vector3(0,1,0), rspeed*delta)
		first = false
	elif t <= tgrow-trotate:
		if not first:
			$minelasers.extend(gspeed*(t-trotate))
	elif t >= period:
		$minelasers.extend(0)
		rotated45 = not rotated45
		t -= period #if delta is ever greater than period this could be problematic
		first = false
	else:
		#hold
		pass
	$minelasers.scanforship()
	if exploded and not $Particles.emitting and not $boom.playing:
		$"..".remove_child(self)
		exploded = false
		$minelasers.extend(0)
		$minelasers.visible = true
		first = true
		life = startlife
		$CollisionShape.disabled = true
		rotation = Vector3(0,0,0)
		t = 0
		global_transform.origin = Vector3(0,-.25,0)
		pool.add_child(self)


func hit(damage):
	life -= damage
	var ret = false
	if life <= 0:
		ret = !exploded
		boom()
	else:
		$hurt.play()
	return ret

func boom():
	if not exploded:
		$boom.play()
		$Particles.restart()
		annihilate()
		$minelasers.visible = false

func annihilate():
	exploded = true
	$"../../../gamemode/scorekeeper".add_score(300)

func hit_ship():
	pass
