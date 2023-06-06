extends Node


# Info concernant le server du reverse proxy
var server_adress:String = ""
var server_port:int = 0
var server_accept_port:int = 0
var server_token:String = ""
var server_service_name:String = ""


# Info sur les propriétés du server
var max_player:int = 0
var host_port:int = 0


# Variable sys
var ratholePID = 0
var peer

#Variable Tmp
var partie:String = "grp1"


var pseudo:String = ""

@rpc("any_peer","call_local")
func get_user_from_ID(id:int):
	for elem in liste_joueur:
		if elem.getID() == id:
			return elem
	print_debug("Aucun utilisateur trouvé")
	return 0
	
func remove_user_from_ID(id:int):
	for i in range(liste_joueur.size()):
		if liste_joueur[i].getID() == id:
			liste_joueur.remove_at(i)
			return liste_joueur
	return liste_joueur

var liste_joueur:Array[User] = []

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if _is_windows():
			OS.execute("cmd",["/C","taskkill /F /IM rathole_odysshey.exe"])
		if Global.ratholePID != 0:
			OS.kill(Global.ratholePID)
		get_tree().quit()
		
		
func _is_windows():
	return (OS.get_name() == "Windows")
	
func _is_linux():
	return (OS.get_name() == "Linux")

func _setup_config():
	var configFile = FileAccess.open("user://config.json",FileAccess.READ)
	var config = JSON.parse_string(configFile.get_as_text())
	configFile.close()
	if config == null:
		OS.alert("Erreur de lecture du fichier de config !")
		return
	server_adress = config.get("serverRathole").get("ip")
	server_port = int(config.get("serverRathole").get("UDPport"))
	server_accept_port = int(config.get("serverRathole").get("clientPort"))
	server_token = config.get("serverRathole").get("token")
	server_service_name = config.get("serverRathole").get("serviceName")
	max_player = int(config.get("hosting").get("maxConnections"))
	host_port = int(config.get("hosting").get("openPort"))
	
