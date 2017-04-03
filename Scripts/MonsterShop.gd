
extends Control

var BoxColumns = 3
var PageAmount = 15

var selected_id = -1

var shop_depo =  []

func _ready():
	# LEMBRAR QUE QUANDO FOR GERAR UM SHOP NOVO,
	# TEM QUE LIBERAR TODOS OS IDS NÃO UTILIZADOS
	generate_shop()

func generate_shop():
	# Devera receber alguns argumentos que definam seu progresso no jogo.
	# Pode ser o rank na Arena, ou o número de dinheiro pago no débito.
	
	# O shop gerará uma nova seleção a cada dia (ou semana?), ainda baseada
	# em seu progresso. O número gerado também dependerá do progresso no
	# jogo.

	for num in range (0, 12):
		get_parent().get_parent().monster_generate(shop_depo, "nhi", Color(-1, -1, -1), [], [2, 2, 1, 0, 0, 0], 3)
	

func _on_Buy_pressed():
	var count = 0
	
	for monster in shop_depo:
		if monster.idn == selected_id:
			#checagem de dinheiro aqui
			global.mon_depo.append(monster)
			shop_depo.remove(count)
			
			get_node("SelectBox").clear_box()
			get_node("SelectBox").update_config(shop_depo, PageAmount, BoxColumns)
			get_node("SelectBox").generate_members()
			
			get_node("Buy").set_disabled(true)
			selected_id = -1
			
			break
		count += 1

func _on_Back_pressed():
	hide()
	get_node("Buy").set_disabled(true)
	get_parent().get_node("VBox").show()