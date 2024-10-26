extends TextureButton

func showTexts(iterator: int):
	match iterator:
		1:
			$Text1.visible = true
			$Text2.visible = false
			$Text3.visible = false
			$Text4.visible = false
			$Text5.visible = false
		2:
			$Text1.visible = false
			$Text2.visible = true
			$Text3.visible = false
			$Text4.visible = false
			$Text5.visible = false
		3:
			$Text1.visible = false
			$Text2.visible = false
			$Text3.visible = true
			$Text4.visible = false
			$Text5.visible = false
		4:
			$Text1.visible = false
			$Text2.visible = false
			$Text3.visible = false
			$Text4.visible = true
			$Text5.visible = false
		5:
			$Text1.visible = false
			$Text2.visible = false
			$Text3.visible = false
			$Text4.visible = false
			$Text5.visible = true
