extends Bumper_Ship

func get_shatter_texture():
	var vp_img = $SubViewport.get_texture().get_image()
	var img_tex = ImageTexture.create_from_image(vp_img)
	return img_tex
