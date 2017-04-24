
extends Control

const PDB = preload("PersonalityDatabase.gd")
onready var personality_db = PDB.new()

var mon = null
var comp_depo = []

var battle_num
var mon1_battle_state
var mon2_battle_state


func generate_enemies(rank, number):
	# Placeholder, deve depender do rank para gerar os monstros.
	for num in range (0, number):
		g_monster.monster_generate(comp_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 1)


func process_battle(enemy_num):
	# The battle will have a couple of commands that can be
	# chosen by the monsters. When a command is issued, the
	# respective animation should be played, hence why all
	# commands are separated on their on functions.

	# Getting player monster
	var mon1 = mon
	
	# The monster's battle state: monster, HP, status conditions
	mon1_battle_state = [mon1, mon1.stats[2] * 3, []]
	mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, []]

	comp_depo.pop_front()
	
	# The battle number
	battle_num = 1
	
	# A monster's turn happens when the counter reaches 100
	var mon1_turn = 0
	var mon2_turn = 0
	
	
	while (true):
		# Adding the speed to the turn counter
		mon1_turn += mon1_battle_state[0].stats[1]
		mon2_turn += mon2_battle_state[0].stats[1]
		
		if (mon1_turn >= 100 and mon2_turn >= 100):
			if (randf() < 0.5):
				# Turno do monster 1 primeiro
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", enemy_num)):
					return true
				# Reset monster 1 turn counter
				mon1_turn = 0
				# Turno do monstro 2 em seguida
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", enemy_num)):
					return false
				mon2_turn = 0
				
			else:
				# Turno do monster 2 primeiro
				process_action(mon2_battle_state, mon1_battle_state)
				if(check_win_lose("lose", enemy_num)):
					return false
				mon2_turn = 0
				# Turno do monstro 1 em seguida
				process_action(mon1_battle_state, mon2_battle_state)
				if(check_win_lose("win", enemy_num)):
					return true
				mon1_turn = 0
		elif (mon1_turn >= 100):
			# Turno do monstro 1
			process_action(mon1_battle_state, mon2_battle_state)
			if(check_win_lose("win", enemy_num)):
				return true
			mon1_turn = 0
		elif (mon2_turn >= 100):
			# Turno do monster 2
			process_action(mon2_battle_state, mon1_battle_state)
			if(check_win_lose("lose", enemy_num)):
				return false
			mon2_turn = 0

func check_win_lose(wl, enemy_num):
	if (wl == "win"):
		if (mon2_battle_state[1] <= 0):
			print(mon2_battle_state)
			print(comp_depo)
			print(battle_num)
			print(str("Mon2 = ", mon2_battle_state[0].idn, " hp = ", mon2_battle_state[1]))
			#test
			print("Player Victory")
			if (battle_num < enemy_num):
#				print("Entrei")
				battle_num += 1
				mon2_battle_state = [comp_depo[0], comp_depo[0].stats[2] * 3, []]
				comp_depo.pop_front()
			else:
				return true
	if (wl == "lose"):
		if (mon1_battle_state[1] <= 0):
			#test
			print("Enemy Victory")
			return true
	
	return false
			
func process_action(attacker_bs, reciever_bs):
	#fazer baseado no WIS do monstro, por ora apenas gera um ataque normal
	regular_attack(attacker_bs, reciever_bs)
	
func regular_attack(attacker_bs, reciever_bs):
	reciever_bs[1] -= abs(ceil(attacker_bs[0].stats[0] * 0.85))

####### BUTTON FUNCIONALITY #######

func _on_Rank1_pressed():
	if (mon.acts == 0):
		print("Monster has no action points")
		return
	mon.acts = 0

	get_node("MonsterSelect/SelectBox").kill()
	get_node("MonsterSelect/SelectBox").generate_members()
	# Vai ter que gerar os monstros para uma batalha de Rank 1,
	# e começar a representação visual.
	generate_enemies(1, 3)
	if (process_battle(2)):
		print ("Total victory!")
		get_node("RankSelect/Rank2").show()
	else:
		print ("Ya lost boi")
	comp_depo.clear()


func _on_Rank2_pressed():
	print("Im fucking useless")


func _on_Rank3_pressed():
	print("I can literally do nothing")


func _on_BackRank_pressed():
	get_node("MonsterSelect").show()
	get_node("RankSelect").hide()


func select_monster(monster, select_box):
		mon = monster
		get_node("MonsterSelect/BattleDisplay").show()
		get_node("MonsterSelect/BattleDisplay").display(mon)
		get_node("MonsterSelect/Proceed").set_disabled(false)