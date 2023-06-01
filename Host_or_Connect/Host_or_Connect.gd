extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.multiplayer_peer = null
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func _on_host_pressed():
	if !FileAccess.file_exists("user://config.json"):
		OS.alert("Vous devez d'abord entrer un fichier de config")
		return
	Global._setup_config()
	if Global.server_adress.is_empty():
		OS.alert("Vous devez d'abord entrer un fichier de config")
		return
	if Global._is_linux():
		OS.execute("bash",["-c","pkill rathole_odyss"])
	elif Global._is_windows():
		OS.execute("cmd",["/C","taskkill /F /IM rathole_odysshey.exe"])
	if $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/getPseudo.get_text().strip_edges().is_empty():
		OS.alert("Veuillez entrer un pseudo","Pseudo !")
		return
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Host.set_disabled(true)
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(Global.host_port, Global.max_player)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Le server n'as pas pu  démarrer.")
		var error_message = NativeNotification.new()
		error_message.notification_text = "Le server n'as pas pu démarrer."
		error_message.notification_icon = NativeNotification.ICON_ERROR
		add_child(error_message)
		error_message.send()
		$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Host.set_disabled(false)
		return
	multiplayer.multiplayer_peer = peer
	#Start rathole
	var configRatholeFile = FileAccess.open("user://client.toml", FileAccess.WRITE)
	configRatholeFile.store_string("[client]\nremote_addr = \""+ Global.server_adress +":"+ str(Global.server_accept_port) +"\"\n[client.services."+ Global.server_service_name +"]\ntype = \"udp\"\ntoken = \""+ Global.server_token +"\"\nlocal_addr = \"127.0.0.1:"+ str(Global.host_port) + "\"")
	configRatholeFile.close()
	if Global._is_linux():
		download("https://github.com/rapiz1/rathole/releases/download/v0.4.8/rathole-x86_64-unknown-linux-gnu.zip","user://rathole.zip")
	elif Global._is_windows():
		download("https://github.com/rapiz1/rathole/releases/download/v0.4.8/rathole-x86_64-pc-windows-msvc.zip","user://rathole.zip")
	else :
		OS.alert("Votre système d'exploitation n'est pour l'instant pas supporté.")
		$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Host.set_disabled(false)
		return
	var ratholePIDLIST
	if FileAccess.file_exists("user://list_pid.log"):
		ratholePIDLIST = FileAccess.open("user://list_pid.log", FileAccess.READ_WRITE)
	else:
		ratholePIDLIST = FileAccess.open("user://list_pid.log", FileAccess.WRITE)		
	ratholePIDLIST.seek_end()
	ratholePIDLIST.store_string("\n" + str(Global.ratholePID))
	ratholePIDLIST.close()


func _on_join_pressed():
	if !FileAccess.file_exists("user://config.json"):
		OS.alert("Vous devez d'abord entrer un fichier de config")
		return
	Global._setup_config()
	if Global.server_adress.is_empty():
		OS.alert("Vous devez d'abord entrer un fichier de config")
		return
	if $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/getPseudo.get_text().strip_edges().is_empty():
		OS.alert("Veuillez entrer un pseudo","Pseudo !")
		return
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Join.set_disabled(true)
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(Global.server_adress,Global.server_port)
	multiplayer.multiplayer_peer = peer
	
	_go_to_lobby()

func _go_to_lobby():
	Global.pseudo = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/getPseudo.get_text().strip_edges()
	if multiplayer.is_server():
		var register_user = User.new(1)
		register_user.setPseudo(Global.pseudo)
		Global.liste_joueur.append(register_user)
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Host.set_disabled(false)
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HBoxContainer/Join.set_disabled(false)
	get_tree().change_scene_to_file("res://Main/Main.tscn")

	#On envoie le pseudo
var http
func download(link, path):
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_http_request_completed)

	http.set_download_file(path)
	var request = http.request(link)
	if request != OK:
		push_error("Http request error")

func _http_request_completed(result, _response_code, _headers, _body):
	if result != OK:
		push_error("Download Failed")
	remove_child(http)
	var unzip_rathole = ZIPReader.new()
	var err = unzip_rathole.open("user://rathole.zip")
	if err != OK:
		OS.alert("Soucis de connection")
		return
	if Global._is_windows():
		var ratholeEXE = FileAccess.open("user://rathole_odysshey.exe", FileAccess.WRITE)
		ratholeEXE.store_buffer(unzip_rathole.read_file("rathole.exe"))
		Global.ratholePID = OS.create_process("powershell",["-Command","cd \\\"" + OS.get_user_data_dir() + "\\\";"+"./rathole_odysshey.exe client.toml"],true)
	elif Global._is_linux():
		var ratholeEXE = FileAccess.open("user://rathole_odysshey", FileAccess.WRITE)
		ratholeEXE.store_buffer(unzip_rathole.read_file("rathole"))
		ratholeEXE.close()
		OS.execute("bash",["-c","chmod a+rwx " + OS.get_user_data_dir()+"/rathole_odysshey"])
		Global.ratholePID = OS.create_process("bash",["-c",OS.get_user_data_dir()+"/rathole_odysshey " + OS.get_user_data_dir()+"/client.toml"], true)
		print(Global.ratholePID)
	else:
		OS.alert("Votre systeme n'est pas supporter !")
		get_tree().quit()
		return
	unzip_rathole.close()
	_go_to_lobby()



func _on_import_config_pressed():
	$MarginContainer/import_config.set_disabled(true)
	$NativeFileDialog.add_filter("*.json","*.json")
	$NativeFileDialog.show()
	$NativeFileDialog.connect("file_selected", on_file_selected)
	pass # Replace with function body.

func on_file_selected(path:String):
	print(path)
	if !path.ends_with(".json"):
		OS.alert("Le fichier de config n'est pas détecter")
		$MarginContainer/import_config.set_disabled(false)
		return
	var configFile = FileAccess.open(path,FileAccess.READ)
	var all_error = ""
	var config = JSON.parse_string(configFile.get_as_text())
	$MarginContainer/import_config.set_disabled(false)
	if config == null:
		OS.alert("Le fichier de config n'est pas compatible")
		return
	elif !config.has_all(["serverRathole","hosting"]):
		OS.alert("Le fichier de config n'est pas compatible")
		return
	elif !config.get("serverRathole").has_all(["ip","UDPport","clientPort","token","serviceName"]) and !config.get("hosting").has_all(["maxConnection","openPort"]):
		OS.alert("Le fichier de config n'est pas compatible")
		return
	@warning_ignore("shadowed_variable_base_class")
	for set in ["ip","token","serviceName"]:
		if !typeof(config.get("serverRathole").get(set)) == TYPE_STRING:
			all_error += "- Le " + set + " n'est pas valide\n"
		elif config.get("serverRathole").get(set).is_empty():
				all_error += "- Le " + set + " est vide\n"
	@warning_ignore("shadowed_variable_base_class")
	for set in ["UDPport","clientPort"]:
		if !typeof(config.get("serverRathole").get(set)) == TYPE_FLOAT:
			all_error += "- Le " + set + " n'est pas valide\n"
		elif config.get("serverRathole").get(set) <= 0:
			all_error += "- Le " + set + " n'est pas valide\n"
	@warning_ignore("shadowed_variable_base_class")
	for set in ["maxConnections","openPort"]:
		if !typeof(config.get("hosting").get(set)) == TYPE_FLOAT:
			all_error += "- Le " + set + " n'est pas valide\n"
		elif int(config.get("hosting").get(set)) <= 0:
			all_error += "- Le " + set + " n'est pas valide\n"
	if config.get("hosting").get("maxConnections") > 8:
		all_error += "- OdyssHey n'accepte pour l'instant que 8 joueurs au maximum"
	if !all_error.is_empty():
		OS.alert("Liste des erreurs :\n" + all_error)
		return
	var configFileLocal = FileAccess.open("user://config.json",FileAccess.WRITE)
	configFileLocal.store_string(configFile.get_as_text())
	configFile.close()
	configFileLocal.close()
	Global._setup_config()
