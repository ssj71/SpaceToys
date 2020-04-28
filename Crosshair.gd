extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const rad = .001
const tau = .1
const alph = 0
const autoshot = false #for debugging only
var timer = 0 
var enabled = false
var streak = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$laser.radius = rad
	$laser.material.albedo_color.a = alph
	if(autoshot):
		enabled = true

func shoot():
	if not enabled:
		return
	$"..".room.tut(2)
	$laser.radius = .007
	$laser.material.albedo_color.a = 255
	#$"../fighterjet2/pew".play()
	var b = get_overlapping_bodies()
	$"../fighterjet2/pew".play()
	var miss = true
	for body in b:
		#$"../../../InfoLabel".set_label_text("boom")
		#TODO: only hit the closest mine
		if body.get_name().match("*ine*"):
			body.hit(2)
			miss = false
	if miss:
		streak == 0
	elif streak == 10:
		$"..".room.add_score(1000)
	elif streak == 25:
		$"..".room.add_score(10000)
	elif streak == 50:
		$"..".room.add_score(50000)
	elif streak == 100:
		$"..".room.add_score(500000)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$laser.radius += (rad-$laser.radius)*delta/tau
	$laser.material.albedo_color.a += (alph-$laser.material.albedo_color.a)*delta/tau
	if autoshot:
		if timer == 70:
			shoot()
			timer = 0
		if timer <= 70:
			timer += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
