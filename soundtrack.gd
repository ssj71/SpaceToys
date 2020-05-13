extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const credits = [

"""Will I? by ADERIN
https://soundcloud.com/andrei-burcea-20972653
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""ORBITAL_StriKe by B E T T O G H
https://soundcloud.com/bettogh/orbitalstrike
https://bettogh.bandcamp.com 
https://open.spotify.com/artist/3zDlqRsvoNTRRyFjmWN456
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution 3.0 Unported License
https://creativecommons.org/licenses/by/3.0/deed.en_US

""",
"""THIRD SECTION by B E T T O G H
https://soundcloud.com/bettogh
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution 3.0 Unported License
https://creativecommons.org/licenses/by/3.0/deed.en_US

""",
"""Runaway by Diamond Ace
https://soundcloud.com/diamond-ace-music
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""127 by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""A Little Disagreement by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""Anemona by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""Exess - 1 by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""From Within by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""Leyla by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""Lost Tapes by Electronic Senses
https://soundcloud.com/electronicsenses
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution-ShareAlike 3.0 Unported
https://creativecommons.org/licenses/by-sa/3.0/deed.en_US

""",
"""Flying Home by | e s c p
https://escp-music.bandcamp.com
Music promoted by https://www.free-stock-music.com
Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/

""",
"""Abyss by | e s c p
https://escp-music.bandcamp.com
Music promoted by https://www.free-stock-music.com
Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/

""",
"""Sail Away by | e s c p
https://escp-music.bandcamp.com
Music promoted by https://www.free-stock-music.com
Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/

""",
"""Kill Synthwave by Elemented
https://soundcloud.com/xxelementedxx/kill-synthwave
Creative Commons Attribution 4.0
https://creativecommons.org/licenses/by/4.0

""",
"""A Journey Through The Universe by Lesion X
https://soundcloud.com/lesionxbeats
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution 3.0 Unported License
https://creativecommons.org/licenses/by/3.0/deed.en_US

""",
"""A New Way by Lesion X
https://soundcloud.com/lesionxbeats
Music promoted by https://www.free-stock-music.com
Creative Commons Attribution 3.0 Unported License
https://creativecommons.org/licenses/by/3.0/deed.en_US
""",
"""Twilight Echo by Scott Buckley
https://soundcloud.com/scottbuckley
Music promoted by https://www.free-stock-music.com
Attribution 4.0 International (CC BY 4.0)
https://creativecommons.org/licenses/by/4.0/

""",
]
var trackorder = range(len(credits))
var track = -1



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	trackorder.shuffle()
	var tracks = [$"0",$"1",$"2",$"3",$"4",$"5",$"6",$"7",$"8",$"9",$"10",$"11",$"12",$"13",$"14",$"15",$"16",$"17"]
	for t in tracks:
		t.connect("finished",self,"_on_track_finished")
		t.volume_db = 1
	_on_track_finished()


func skip():
	var n = trackorder[track]
	get_node(str(n)).stop()
	#stopping calls the finished cb
	

func _on_track_finished():
	track += 1
	if track >= len(credits):
		track = 0
	var n = trackorder[track]
	print("track ",n )
	get_node(str(n)).play()
	$trackinfo.set_label_text(credits[n])


func _on_OQ_LeftController_button_pressed(button):
	if button == 1: #y button
		skip()
