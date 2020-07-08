extends Control


func _ready():
	$MenuButtonFile.get_popup().add_item("Open File")
	$MenuButtonFile.get_popup().add_item("Save as File")
	$MenuButtonFile.get_popup().add_item("Exit and Quit")
	$MenuButtonFile.get_popup().connect("id_pressed", self, "_on_item_file_pressed")
	
	$MenuButtonEdit.get_popup().add_item("Cut")
	$MenuButtonEdit.get_popup().add_item("Copy")
	$MenuButtonEdit.get_popup().add_item("Paste")
	$MenuButtonEdit.get_popup().connect("id_pressed", self, "on_item_edit_pressed")
	
	$MenuButtonHelp.get_popup().add_item("About")
	$MenuButtonHelp.get_popup().connect("id_pressed", self, "_on_item_help_pressed")
	
	
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
			_on_OpenFile_pressed()
		1:
			_on_SaveFile_pressed()
		2:
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
	$FileDialog.popup()


func _on_SaveFile_pressed():
	$SaveFileDialog.popup()


func _on_FileDialog_file_selected(path):
	var f = File.new()
	f.open(path, File.READ)
	$TextEdit.text = f.get_as_text()
	f.close()


func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_string($TextEdit.text)
	f.close()


func _on_Exit_pressed():
	get_tree().quit()


func _on_New_pressed():
	$TextEdit.text = ""
