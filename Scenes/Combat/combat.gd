extends Control

# 0 = attack, 1 = item, 2 = block, 3 = <reset ke 0>
# 0 = attack, -1 = block, -2 = item, -3 = <reset ke 0>
var button_index = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Music.play()
	button_index = 0
	$CanvasLayer/CombatMenu/MenuItemSelect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match button_index:
		-3:
			button_index = 0
		-2:
			$CanvasLayer/CombatMenu/MenuAttackButton.disabled = true
			$CanvasLayer/CombatMenu/MenuAttackButton.position = Vector2(14, 18)
			$CanvasLayer/CombatMenu/MenuItemButton.disabled = false
			$CanvasLayer/CombatMenu/MenuItemButton.position = Vector2(17, 1)
			$CanvasLayer/CombatMenu/MenuBlockButton.disabled = true
			$CanvasLayer/CombatMenu/MenuBlockButton.position = Vector2(30, -10)
		-1:
			$CanvasLayer/CombatMenu/MenuAttackButton.disabled = true
			$CanvasLayer/CombatMenu/MenuAttackButton.position = Vector2(30, -10)
			$CanvasLayer/CombatMenu/MenuItemButton.disabled = true
			$CanvasLayer/CombatMenu/MenuItemButton.position = Vector2(14, 18)
			$CanvasLayer/CombatMenu/MenuBlockButton.disabled = false
			$CanvasLayer/CombatMenu/MenuBlockButton.position = Vector2(17, 1)
		0:
			$CanvasLayer/CombatMenu/MenuAttackButton.disabled = false
			$CanvasLayer/CombatMenu/MenuAttackButton.position = Vector2(17, 1)
			$CanvasLayer/CombatMenu/MenuItemButton.disabled = true
			$CanvasLayer/CombatMenu/MenuItemButton.position = Vector2(30, -10)
			$CanvasLayer/CombatMenu/MenuBlockButton.disabled = true
			$CanvasLayer/CombatMenu/MenuBlockButton.position = Vector2(14, 18)
		1:
			$CanvasLayer/CombatMenu/MenuAttackButton.disabled = true
			$CanvasLayer/CombatMenu/MenuAttackButton.position = Vector2(14, 18)
			$CanvasLayer/CombatMenu/MenuItemButton.disabled = false
			$CanvasLayer/CombatMenu/MenuItemButton.position = Vector2(17, 1)
			$CanvasLayer/CombatMenu/MenuBlockButton.disabled = true
			$CanvasLayer/CombatMenu/MenuBlockButton.position = Vector2(30, -10)
		2:
			$CanvasLayer/CombatMenu/MenuAttackButton.disabled = true
			$CanvasLayer/CombatMenu/MenuAttackButton.position = Vector2(30, -10)
			$CanvasLayer/CombatMenu/MenuItemButton.disabled = true
			$CanvasLayer/CombatMenu/MenuItemButton.position = Vector2(14, 18)
			$CanvasLayer/CombatMenu/MenuBlockButton.disabled = false
			$CanvasLayer/CombatMenu/MenuBlockButton.position = Vector2(17, 1)
		3:
			button_index = 0

func _on_menu_up_button_pressed() -> void:
	button_index -= 1
	$CanvasLayer/CombatMenu/SwitchSound.play()

func _on_menu_down_button_pressed() -> void:
	button_index += 1
	$CanvasLayer/CombatMenu/SwitchSound.play()

func _on_menu_item_button_pressed() -> void:
	$CanvasLayer/CombatMenu/MenuItemSelect.visible = true
