extends StaticBody


# Declare member variables here. Examples:
const period = 2.5
const cluster = 3
var t = 0.0
var cnt = 0
var plas = preload("res://bullet.tscn")
var exploded = false
const startlife = 11
var life = startlife
onready var pool = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	t += delta
	if t >= period:
		if cnt < cluster:
			$"../..".fire(global_transform.origin)
			cnt += 1
		else:
			cnt = 0
		t -= period #if delta is ever greater than period this could be problematic
	if exploded and not $Particles.emitting and not $boom.playing:
		$"..".remove_child(self)
		exploded = false
		life = startlife
		$CollisionShape.disabled = true
		global_transform.origin = Vector3(0,-.25,0)
		pool.add_child(self)
		
		
func hit(damage):
	life -= damage
	var ret = false
	if life <= 0:
		ret = not exploded
		boom()
	else:
		$hurt.play()
	return ret
		
func boom():
	if not exploded:
		$boom.play()
		$Particles.restart()
		annihilate()

func annihilate():
	exploded = true
	$"../../../gamemode/scorekeeper".add_score(200)

func hit_ship():
	pass
