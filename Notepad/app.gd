extends Control

var app_name = "Unbloated"
var current_file = "Untitled"


func _ready():
	update_window_title()
	$MenuButtonFile.get_popup().add_item("New", 0, KEY_N | KEY_MASK_CTRL)
	$MenuButtonFile.get_popup().add_item("Open File", 1, KEY_O | KEY_MASK_CTRL)
	$MenuButtonFile.get_popup().add_item("Save", 2, KEY_S | KEY_MASK_CTRL)
	$MenuButtonFile.get_popup().add_item("Save as File", 3, KEY_S | KEY_MASK_CTRL | KEY_MASK_SHIFT)
	$MenuButtonFile.get_popup().add_item("Exit and Quit", 4, KEY_Q | KEY_MASK_CTRL)
	$MenuButtonFile.get_popup().connect("id_pressed", self, "_on_item_file_pressed")
	
	$MenuButtonEdit.get_popup().add_item("Cut", 0, KEY_X | KEY_MASK_CTRL)
	$MenuButtonEdit.get_popup().add_item("Copy", 1, KEY_C | KEY_MASK_CTRL)
	$MenuButtonEdit.get_popup().add_item("Paste", 2, KEY_V | KEY_MASK_CTRL)
	$MenuButtonEdit.get_popup().connect("id_pressed", self, "on_item_edit_pressed")
	
	$MenuButtonHelp.get_popup().add_item("About")
	$MenuButtonHelp.get_popup().connect("id_pressed", self, "_on_item_help_pressed")
	
	
func update_window_title():
	OS.set_window_title(app_name + " - " + current_file)
	
func on_item_edit_pressed(id):
	match id:
		0:
			$TextEdit.cut()
		1:
			$TextEdit.copy()
		2:
			$TextEdit.paste()
		_:
			print("WFT")	
	
func _on_item_file_pressed(id):
	match id:
		0:
			_on_New_pressed()
		1:
			_on_OpenFile_pressed()
		2:
			_on_save_pressed()
		3:
			_on_SaveFile_pressed()
		4:
			_on_Exit_pressed()
		_:
			print("WFT")

func _on_item_help_pressed(id):
	match id:
		0:
			$AboutDialog.popup()
		_:
			print("WFT")

func _on_OpenFile_pressed():
	$FileDialog.invalidate()
	$FileDialog.popup()

func _on_save_pressed():
	var path = current_file
	if path == "Untitled":
		_on_SaveFile_pressed()
	else:
		_on_SaveFileDialog_file_selected(path)
	
func _on_SaveFile_pressed():
	$SaveFileDialog.invalidate()
	$SaveFileDialog.popup()


func _on_FileDialog_file_selected(path):
	var f = File.new()
	f.open(path, File.READ)
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	update_window_title()


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_string($TextEdit.text)
	f.close()
	current_file = path
	update_window_title()


func _on_Exit_pressed():
	get_tree().quit()


func _on_New_pressed():
	current_file = "Untitled"
	update_window_title()
	$TextEdit.text = ""


func _on_Minimize_pressed() -> void:
	OS.set_window_minimized(true)
