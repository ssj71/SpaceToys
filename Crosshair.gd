extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const rad = .001
const tau = .1
const alph = 0
const autoshot = false
var timer = 0 


# Called when the node enters the scene tree for the first time.
func _ready():
	$laser.radius = rad
	$laser.material.albedo_color.a = alph

func shoot():
	$laser.radius = .007
	$laser.material.albedo_color.a = 255
	$"../fighterjet2/pew".play()
	var b = get_overlapping_bodies()
	$"../../InfoLabel".set_label_text(str(b.size()))
	print(b)
	for body in b:
		#$"../../../InfoLabel".set_label_text("boom")
		#TODO: only hit the closest mine, add damage
		if body.get_name().to_lower().ends_with("mine"):
			body.boom()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$laser.radius += (rad-$laser.radius)*delta/tau
	$laser.material.albedo_color.a += (alph-$laser.material.albedo_color.a)*delta/tau
	if autoshot:
		if timer == 100:
			shoot()
			timer = 0
		if timer <= 100:
			timer += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
