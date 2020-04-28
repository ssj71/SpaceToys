extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var start = true
var level = 0
onready var top = $"../walls".height
onready var rad = $"../walls".radius
const buffer = .05
var rng
var prox = preload("res://proximitymine.tscn")
var plas = preload("res://plasmamine.tscn")
var lasr = preload("res://lasermine.tscn")
var bulletmaterial


# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	#the first time a mine blows it takes a while to load the particles
	#so we force an explosion on startup
	var a = prox.instance()
	a.translation = Vector3(0,3,0)
	add_child(a)
	a.boom()
	a = plas.instance()
	add_child(a)
	a.boom()
	#the factory does the glow animation on the bullets
	#so we grab the material here
	a = load("res://bullet.tscn").instance()
	bulletmaterial = a.find_node("CSGSphere").material
	


func saw(x, mn, mx, period):
	var rng = mx - mn
	return fmod(x,period)/period*rng + mn
	
func tri(x, mn, mx, period):
	var rng = mx - mn
	var half = period/2.0
	return abs(fmod(x,period)-half)/half*rng + mn
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
var t = 0.0
const glowdecimate = 10
var gc = 0
func _process(delta):
	if start and get_child_count() == 0:
		level += 1
		produce(level)
		if(level > 1):
			$"..".tut(3)
		$"../newlevel".play()
	t += delta
	gc += 1
	if gc >= glowdecimate:
		var v = tri(t,.5,4,2.0)
		bulletmaterial.emission_energy = v
		gc = 0
#	pass

func place(mine, i=0):
	var z = rng.randf_range(buffer,top-buffer)
	var ang = rng.randf_range(0,2*PI)
	var dist = rng.randf_range(0,rad-buffer)
	mine.translation = Vector3(dist*cos(ang), z, dist*sin(ang))
	#mine.translation = Vector3(0,0,.1*i)
	
func twist(mine):
	var xr = rng.randi_range(-1,2)
	var yr = rng.randi_range(-1,2)
	var ninety = PI/2.0
	mine.rotate_x(ninety*xr)
	mine.rotate_y(ninety*yr)

func produce(n):
	var nprox = rng.randi_range(1,level)
	#nprox = 0
	for i in range(nprox):
		var m = prox.instance()
		place(m,i)
		add_child(m)
		
	if nprox == level:
		return
	var nplas = rng.randi_range(1,level-nprox)
	#nplas = 0
	for i in range(nplas):
		var m = plas.instance()
		m.t = rng.randf_range(0,m.period)
		place(m,nprox + i)
		add_child(m)
		
	if nplas+nprox == level:
		return
	var nlasr = rng.randi_range(1,level-nprox-nplas)
	for i in range(nlasr):
		var m = lasr.instance()
		m.t = rng.randf_range(0,m.period)
		twist(m)
		place(m,nprox + nplas + i)
		add_child(m)