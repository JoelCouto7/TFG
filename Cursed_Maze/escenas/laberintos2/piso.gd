extends Node2D

var tablero: Array
@export var lado_tablero: int = 20
@export var numero_salas: int = 8
var lista_subtableros: Array

@onready var mapa: TileMap = $TileMap
@onready var prota = $TileMap/Jugador/prota
@onready var jugador_p = $TileMap/Jugador
@onready var salida = $TileMap/portal2
var baldosas_mapa: Array

var escena_enemigo = preload("res://enemigos/slime.tscn")
@export var probabilidad_enemigo: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	laberinto_bsp()
	pass # Replace with function body.

func laberinto_bsp():
	radimensionar_tablero()
	
	var medidas_tablero = [[0,lado_tablero-1],[0,lado_tablero-1]]
	lista_subtableros.append(medidas_tablero)
	
	var subtablero_a
	var subtablero_b
	var tablero_dividido
	
	while (lista_subtableros.size() < numero_salas):
		#ver(lista_subtableros)
		#print("")
		tablero_dividido = dividir_tablero(lista_subtableros.pop_front())
		subtablero_a = tablero_dividido.pop_front()
		subtablero_b = tablero_dividido.pop_front()
		
		lista_subtableros.append(subtablero_a)
		if (subtablero_b != null):
			lista_subtableros.append(subtablero_b)
		
		#lista_subtableros.shuffle() #mezclar para garantizar aleatorioedad
		pass
	#en este punto ya esta el tablero dividido en subtableros aleatorios
	#ver(lista_subtableros)
	definir_salas()
	#ver(lista_subtableros)
	#en este punto ya tenemos las corrdenadas de las salas del laberinto
	#ver(tablero)
	colocar_salas()
	
	unir_salas()
	#ver(tablero)
	convertir_matriz_a_tilemap()
	pass

func colocar_enemigo(x: int, y: int):
	#función para colocar un enemigo en una sala del laberinto
	var enemigo = escena_enemigo.instantiate()
	enemigo.position = Vector2(x, y)
	add_child(enemigo)
	pass

func decidir_probabilidad_enemigo():
	return (RandomNumberGenerator.new().randi_range(0,100) < probabilidad_enemigo)

func convertir_matriz_a_tilemap():
	var jugado_colocado = false
	var salida_colocada = false #false
	var x = 0
	while (x<lado_tablero):
		var y = 0
		while (y<lado_tablero):
			if(tablero[x][y] == 0):
				if(x>0 and y>0) and (x<lado_tablero-1 and y<lado_tablero-1):
					mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(3,0), 1) #escenario
				else:
					mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(3,0), 0)
					pass
				pass
			else:
				mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(0,0), 1) #escenario
				baldosas_mapa.append(Vector2i(x,y))
				if(jugado_colocado==false and tablero[x][y] == 1):
					jugado_colocado = true
					#var jugador = $TileMap/Jugador
					prota.position.x = x*16 + (mapa.cell_quadrant_size * 1 / 2)
					prota.position.y = y*16 + (mapa.cell_quadrant_size * 1 / 2)
					#print("jugador movido")
				pass
				if (decidir_probabilidad_enemigo()):
					if(tablero[x][y] > 1 and tablero[x][y] < numero_salas):
						var x_enemigo = x*mapa.cell_quadrant_size
						var y_enemigo = y*mapa.cell_quadrant_size
						colocar_enemigo(x_enemigo, y_enemigo)
				pass
				if(salida_colocada==false and tablero[x][y] == numero_salas):
					salida_colocada = true
					salida.transportar.connect(self.iraotromapa)
					#var jugador = $TileMap/Jugador
					salida.position.x = x*16 + (mapa.cell_quadrant_size * 2 / 2)
					salida.position.y = y*16 + (mapa.cell_quadrant_size * 2 / 2)
					#print("jugador movido")
				pass
			y +=1
		x+=1
	prota.preparar_camara()
	jugador_andando()
	pass

func iraotromapa(otro_mapa: String):
	get_tree().change_scene_to_file(otro_mapa)
	pass

func descubrir(posiciones: Vector2i):
	var coordenadas = mapa.get_cell_atlas_coords(0, posiciones)
	mapa.set_cell(0, posiciones, 0, coordenadas, 0)
	for celda in mapa.get_surrounding_cells(posiciones):
		coordenadas = mapa.get_cell_atlas_coords(0, celda)
		mapa.set_cell(0, celda, 0, coordenadas, 0)
	pass

func jugador_andando():
	var pos_x = prota.position.x / 16
	var pos_y = prota.position.y / 16
	var posicion_jugador = Vector2i(pos_x,pos_y)
	if baldosas_mapa.has(posicion_jugador):
		descubrir(posicion_jugador)
		baldosas_mapa.erase(posicion_jugador)

func poner_pasillo(x:int, y:int):
	#if (tablero[x][y] == 0): tablero[x][y] = 2
	if (tablero[x][y] == 0): tablero[x][y] = 2
	pass

func conectar_dos_puntos(inicio: Array, fin: Array):
	var x_inicio = inicio[0]
	var y_inicio = inicio[1]
	var x_fin = fin[0]
	var y_fin = fin[1]
	while (x_inicio != x_fin) or (y_inicio != y_fin):
		if (x_inicio < x_fin):
			x_inicio +=1
		elif (x_inicio > x_fin):
			x_inicio -=1
		#if (tablero[x_inicio][y_inicio] == 0): tablero[x_inicio][y_inicio] = 'z'
		poner_pasillo(x_inicio, y_inicio)
		if (y_inicio < y_fin):
			y_inicio +=1
		elif (y_inicio > y_fin):
			y_inicio -=1
		#if (tablero[x_inicio][y_inicio] == 0): tablero[x_inicio][y_inicio] = 'z'
		poner_pasillo(x_inicio, y_inicio)
		#print([x_inicio, y_inicio])
		pass
	pass

func unir_salas():
	var salas_unidas: Array
	var secuencia: Array
	for subtablero in lista_subtableros:
		var x_min = subtablero[0][0]
		var x_max = subtablero[0][1]
		var y_min = subtablero[1][0]
		var y_max = subtablero[1][1]
		
		var x_aleatorio = RandomNumberGenerator.new().randi_range(x_min, x_max)
		var y_aleatorio = RandomNumberGenerator.new().randi_range(y_min, y_max)
		
		secuencia.append([x_aleatorio, y_aleatorio])
	#print(secuencia)
	#secuencia.shuffle() #se mezcla el orden de la secuencia
	var x_aterior = null
	var y_anterior = null
	for punto in secuencia:
		if (x_aterior != null):
			conectar_dos_puntos([x_aterior, y_anterior], punto)
		pass
		x_aterior = punto[0]
		y_anterior = punto[1]
	#print(secuencia)
	pass

func colocar_salas():
	var numero_sala = 1
	for subtablero in lista_subtableros:
		var i = subtablero[0][0] #iterador de x
		var x = subtablero[0][1] #meta de i
		var j = subtablero[1][0] #iterador de y
		var y = subtablero[1][1] #meta de j
		
		while (i <= x):
			j = subtablero[1][0]
			while (j <= y):
				#tablero[i][j] = numero_sala
				tablero[i][j] = numero_sala
				j += 1
			i += 1
		pass
		numero_sala += 1
	pass

func definir_salas():
	for subtablero in lista_subtableros:
		#print("definir_salas")
		#print(subtablero)
		subtablero[0][0] += 1
		subtablero[0][1] -= 1
		subtablero[1][0] += 1
		subtablero[1][1] -= 1
	pass

func dividir_tablero(matriz: Array):
	#[[ancho],[alto]]
	#[[0,19],[0,19]]
	#[[0,9],[0,19]] [[10,19],[0,19]]
	#print("dividr_tablero")
	#print(matriz)
	
	var corte_horizontal = false
	
	var xmin = matriz[0][0]
	var xmax = matriz[0][1]
	var ymin = matriz[1][0]
	var ymax = matriz[1][1]
	
	var diferenciax = xmax - xmin
	var diferenciay = ymax - ymin
	
	var minimo = ymin
	var maximo = ymax
	
	if (diferenciax > diferenciay):
		corte_horizontal = true
		minimo = xmin
		maximo = xmax
	
	if(maximo-minimo < 6):
		#no se puede dividir
		#print("no se puede dividir")
		return [matriz, null]
	
	var punto
	var punto_valido = false
	while (punto_valido == false):
		punto = RandomNumberGenerator.new().randi_range(minimo, maximo)
		if(punto - minimo > 1 and maximo-punto > 1):
			punto_valido = true
	
	var respuesta: Array = [0,1]
	if (corte_horizontal):
		respuesta[0] = [[xmin, punto],[ymin, ymax]]
		respuesta[1]= [[punto, xmax],[ymin, ymax]]
	else:
		respuesta[0] = [[xmin, xmax],[ymin, punto]]
		respuesta[1] = [[xmin, xmax],[punto, ymax]]
	
	return respuesta
	pass

func radimensionar_tablero():
	tablero.resize(lado_tablero) #numero de columnas
	var i=0
	while(i<lado_tablero): #numero de filas
		var j=0
		var fila: Array
		#fila.resize(lado) #todas las filas deben tener el mismo numero de columnas
		while(j<lado_tablero):
			#fila.append(0)
			fila.append(0)
			j = j+1
		tablero[i] = fila
		i = i+1
	#tablero redimensionado

func ver(matriz: Array):
	var i=0
	while(i<matriz.size()): #numero de filas
		print(matriz[i])
		i = i+1

func generador_2():
	var salas: Array
	
	#var sala_inicio: Array
	#var sala_fin: Array
	
	var sala1: Array
	sala1 = [[1,1,1,0],[1,1,1,2],[1,1,1,0]]
	#print(sala1)
	var sala2: Array
	sala2 = [[0,1,1,1],[2,1,1,1],[0,1,1,1],[1,1,1,0],[2,1,1,1],[1,1,1,0]]
	
	var sala3: Array
	sala3 = [[0,1,1,1],[2,1,1,1],[0,1,1,1]]
	
	var juntable = false
	print("sala1 y sala2 son juntables = %s" % juntable)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_jugador_andando():
	jugador_andando()
	pass # Replace with function body.
