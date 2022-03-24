extends TextureButton

export (String) var link_text;

func _on_TextureButton2_pressed():
	var _r = OS.shell_open(link_text)


func _on_TextureButton3_pressed():
	OS.clipboard = link_text
