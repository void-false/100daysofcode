extends Control


func _ready():
	pass 


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


func _on_Exit2_pressed():
	$TextEdit.text = ""
