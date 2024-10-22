extends Node2D

#@onready var menu_item_select = $CombatMenu/MenuItemSelect

# 0 = attack, 1 = item, 2 = block, 3 = <reset ke 0>
# 0 = attack, -1 = block, -2 = item, -3 = <reset ke 0>
var button_index = null

var selected_item = "i_fire_extinguisher"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_index = 0
	
	$CombatMenu/MenuItemSelect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match button_index:
		-3:
			button_index = 0
		-2:
			$CombatMenu/MenuAttackButton.disabled = true
			$CombatMenu/MenuAttackButton.position = Vector2(14, 18)
			$CombatMenu/MenuItemButton.disabled = false
			$CombatMenu/MenuItemButton.position = Vector2(17, 1)
			$CombatMenu/MenuBlockButton.disabled = true
			$CombatMenu/MenuBlockButton.position = Vector2(30, -10)
		-1:
			$CombatMenu/MenuAttackButton.disabled = true
			$CombatMenu/MenuAttackButton.position = Vector2(30, -10)
			$CombatMenu/MenuItemButton.disabled = true
			$CombatMenu/MenuItemButton.position = Vector2(14, 18)
			$CombatMenu/MenuBlockButton.disabled = false
			$CombatMenu/MenuBlockButton.position = Vector2(17, 1)
		0:
			$CombatMenu/MenuAttackButton.disabled = false
			$CombatMenu/MenuAttackButton.position = Vector2(17, 1)
			$CombatMenu/MenuItemButton.disabled = true
			$CombatMenu/MenuItemButton.position = Vector2(30, -10)
			$CombatMenu/MenuBlockButton.disabled = true
			$CombatMenu/MenuBlockButton.position = Vector2(14, 18)
		1:
			$CombatMenu/MenuAttackButton.disabled = true
			$CombatMenu/MenuAttackButton.position = Vector2(14, 18)
			$CombatMenu/MenuItemButton.disabled = false
			$CombatMenu/MenuItemButton.position = Vector2(17, 1)
			$CombatMenu/MenuBlockButton.disabled = true
			$CombatMenu/MenuBlockButton.position = Vector2(30, -10)
		2:
			$CombatMenu/MenuAttackButton.disabled = true
			$CombatMenu/MenuAttackButton.position = Vector2(30, -10)
			$CombatMenu/MenuItemButton.disabled = true
			$CombatMenu/MenuItemButton.position = Vector2(14, 18)
			$CombatMenu/MenuBlockButton.disabled = false
			$CombatMenu/MenuBlockButton.position = Vector2(17, 1)
		3:
			button_index = 0

func _on_menu_up_button_pressed() -> void:
	button_index -= 1
	$CombatMenu/SwitchSound.play()
	$CombatMenu/MenuItemSelect.visible = false

func _on_menu_down_button_pressed() -> void:
	button_index += 1
	$CombatMenu/SwitchSound.play()
	$CombatMenu/MenuItemSelect.visible = false

func _on_menu_item_button_pressed() -> void:
	$CombatMenu/MenuItemSelect.visible = true

func _on_menu_attack_button_pressed() -> void:
	SignalManager.player_attack.emit()

func _on_menu_block_button_pressed() -> void:
	SignalManager.player_block.emit()

func _on_selected_item_pressed() -> void:
	SignalManager.player_use_item.emit(selected_item)
