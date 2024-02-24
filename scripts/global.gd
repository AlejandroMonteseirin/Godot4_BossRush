extends Node2D

var vidas=3

#Value use by lvls to store global data. example in lvl 1 the number of slimes destroyed.
var tempValue=0

func shake_camera(tiempo,intesidad):
	get_node("/root/odin/player/Camera2D").shake_camera(tiempo,intesidad)

func modificarVidas(modificacion):
	get_node("/root/odin/HUD").updateVidas(modificacion)
	
func mostrarReiniciarPopUp():
	get_node("/root/odin/HUD/Retry").show()


func freeze_engine(slow=0.1,time=0.2):
	Engine.time_scale = slow
	get_node("/root/odin/player/Camera2D").zoomIn()
	await get_tree().create_timer(slow*time).timeout
	Engine.time_scale = 1
	get_node("/root/odin/player/Camera2D").zoomReset()








###MENU

var play_sfx = true
var play_music = true
var fullscreen = false
const SCENE_MAIN_MENU = "res://menu/main_menu/main_menu.tscn"


const SETTINGS_FILE = "user://settings.cfg"
const CONFIG_SETTINGS_SECTION = "settings"

func _ready():
	Engine.max_fps = 60
	load_settings()
	
func load_settings():
	var config = ConfigFile.new()
	var load_res = config.load(SETTINGS_FILE)

	if load_res != OK:
		print("failed to load settings")
		return

	for setting_key in config.get_section_keys(CONFIG_SETTINGS_SECTION):
		set_setting(setting_key, config.get_value(CONFIG_SETTINGS_SECTION, setting_key), false)

## persist all settings to disk
## add a new setting in the array to ensure it persists
func save_settings():
	var config = ConfigFile.new()
	for setting in ["fullscreen", "play_sfx", "play_music"]:
		config.set_value(CONFIG_SETTINGS_SECTION, setting, self[setting])
	config.save(SETTINGS_FILE)

## val is a bool representing whether or not to toggle on fullscreen
func set_fullscreen(val:bool):
	fullscreen = val
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## Assigns the value to the Global setting variable.
## Defaults to saving all settings after one gets set, but can be disabled
## with the `save` argument.
func set_setting(setting, val, save := true):
	self[setting] = val
	if setting == "fullscreen":
		set_fullscreen(val)

	if save:
		save_settings()


func musica(track):
	if(play_music):
		get_node("/root/odin").musica(track)
	
