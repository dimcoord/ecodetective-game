extends Node

# Combat Signals
signal instantiate_battle(monster_code)
signal monster_hp_changed(value)
signal monster_dead
signal player_dead
signal player_hp_changed(value)
signal monster_animation_finished(anim_name)
signal player_animation_finished

signal player_attack
signal player_block
signal player_use_item(item_id)
