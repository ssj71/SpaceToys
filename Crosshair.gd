extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const rad = .001
const tau = .1
const alph = 0
const autoshot = false #for debugging only
var timer = 0 
var streak = 0
var power = 2


# Called when the node enters the scene tree for the first time.
func _ready():
	$laser.radius = rad
	$laser.material.albedo_color.a = alph

func shoot():
	$"..".room.tut(2)
	$laser.radius = .007
	$laser.material.albedo_color.a = 255
	#$"../fighterjet2/pew".play()
	var b = get_overlapping_bodies()
	$"../pew".play()
	var miss = true
	var hit = 0
	for body in b:
		#$"../../../InfoLabel".set_label_text("boom")
		#TODO: only hit the closest mine
		if body.get_name().match("*ine*"):
			if body.get_parent().get_name() == "activemines":
				if body.hit(power):
					$"..".room.find_node("scorekeeper").mine_cleared()
					hit = 1
				miss = false
	streak += hit
	if miss:
		streak = 0
	elif hit:
		if streak == 10:
			$"..".room.bonus(1000,"Nice Shooting.")
			$"../bonus".play()
		elif streak == 25:
			$"..".room.bonus(10000,"Great Shooting.")
			$"../bonus".play()
		elif streak == 50:
			$"..".room.bonus(50000,"Amazing Shooting!")
			$"../bonus".play()
		elif streak == 100:
			$"..".room.bonus(500000,"Incredible Shooting!")
			$"../bonus".play()

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
