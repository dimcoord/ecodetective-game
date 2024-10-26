extends Camera2D

@onready var top_left
@onready var bottom_right

func setLimits() -> void:
	match GameManager.current_map:
		"cibiru":
			top_left = $Limits/Cibiru/TopLeft
			bottom_right = $Limits/Cibiru/BottomRight
		"stage1_1":
			top_left = $Limits/Forest/TopLeft
			bottom_right = $Limits/Forest/BottomRight
		"stage1_2":
			top_left = $Limits/ForestFull/Pos1/TopLeft
			bottom_right = $Limits/ForestFull/Pos1/BottomRight
		"stage1_3":
			top_left = $Limits/ForestFull/Pos2/TopLeft
			bottom_right = $Limits/ForestFull/Pos2/TopLeft
		"stage1_4":
			top_left = $Limits/ForestFull/Pos3/TopLeft
			bottom_right = $Limits/ForestFull/Pos3/BottomRight
		"stage1_5":
			top_left = $Limits/ForestFull/Pos4/TopLeft
			bottom_right = $Limits/ForestFull/Pos4/BottomRight
	limit_top = top_left.position.y
	limit_left = top_left.position.x
	limit_bottom = bottom_right.position.y
	limit_right = bottom_right.position.x

func _ready():
	setLimits()

func _process(delta):
	pass
