extends StaticBody


# Declare member variables here. Examples:
const period = 2.5
const cluster = 3
var t = 0.0
var cnt = 0
var plas = preload("res://bullet.tscn")
var exploded = false
var life = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	if t >= period:
		if cnt < cluster:
			var b = plas.instance()
			$"../..".add_child(b)
			b.global_transform.origin = global_transform.origin
			b.fire()
			cnt += 1
		else:
			cnt = 0
		t -= period #if delta is ever greater than period this could be problematic
	if exploded and not $Particles.emitting and not $boom.playing:
		self.queue_free()
		
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
	$"../..".add_score(200)

func hit_ship():
	pass
