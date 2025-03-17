extends Node2D


@export var lado: int
@export var numero_salas: int
@export var tamaño_salas: int
var tablero: Array
var salas: Array

@onready var mapa: TileMap = $TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	tablero.resize(lado) #numero de columnas
	var i=0
	while(i<lado): #numero de filas
		var j=0
		var fila: Array
		#fila.resize(lado) #todas las filas deben tener el mismo numero de columnas
		while(j<lado):
			fila.append(0)
			j = j+1
		tablero[i] = fila
		i = i+1
	# En este momento tenemos un tablero completamente vacio
	#print_debug(tablero[9][1])
	#ver_tablero()
	llenar_tablero()
	#unir_salas()
	unir_salas_alt()
	#print(tablero)
	#ver_tablero()
	# En este punto el tablero está completo
	# A partir de aquí hay que pasar la matriz a TileMap
	var jugado_colocado = false
	var x = 0
	while (x<lado):
		var y = 0
		while (y<lado):
			if(tablero[x][y] == 0):
				if(x>0 and y>0) and (x<lado-1 and y<lado-1):
					if((tablero[x+1][y] == 0 and tablero[x-1][y] ==0 and tablero[x][y+1] == 0 and tablero[x][y-1]==0)==false):
						mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(3,0), 0)
				else:
					mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(3,0), 0)
				pass
			else:
				mapa.set_cell(0, Vector2i(x,y), 0, Vector2i(0,0), 0)
				if(jugado_colocado==false and tablero[x][y] == 1):
					jugado_colocado = true
					var jugador = $TileMap/Jugador
					jugador.position.x = x*16 + (mapa.cell_quadrant_size * tamaño_salas / 2)
					jugador.position.y = y*16 + (mapa.cell_quadrant_size * tamaño_salas / 2)
					print("jugador movido")
				pass
			y +=1
		x+=1
	pass # Replace with function body.

func ver_tablero():
	var i=0
	while(i<lado): #numero de filas
		print(tablero[i])
		i = i+1

func llenar_tablero():
	#Primero hay que poner las salas
	#Para ello crearé 4 salas de 3x3
	var n=0
	while(n < numero_salas):
		crear_sala(tamaño_salas)
		n = n+1
	# En este punto tenemos todas las salas creadas
	#Lo segundo es situarlas en el tablero sin que haya colisiones
	#Para esto hay que buscar zonas aleatorias sin conflictos
	var x = 0
	var y = 0
	var salas_colocadas = 0
	while(salas_colocadas < numero_salas):
		# hay que hacer uso de los margenes para evitar generar posiciones invalidas
		#genera un numero entre 0 y el tamaño del tablero debido a la operacion modulo
		var sala_actual: Array = salas[salas_colocadas]
		var tam_sala_actual: int = sala_actual.size()
		#print(sala_actual)
		
		#para determinar si es posible poner una salas en el lugar escogido
		#hay que asegurar la zona generando posiciones hasta encontrar una libre
		var lugar_ideal: bool = false
		while(lugar_ideal == false):
			lugar_ideal = true
			x = 1 + RandomNumberGenerator.new().randi() % (lado - tam_sala_actual - 1)
			y = 1 + RandomNumberGenerator.new().randi() % (lado - tam_sala_actual - 1)
			
			var a = 0
			while(a<tam_sala_actual):
				var b = 0
				while(b<tam_sala_actual):
					if (tablero[x+a][y+b] > 0): lugar_ideal = false
					b = b+1
				a = a+1
		
		var a = 0
		while(a<tam_sala_actual):
			var b = 0
			while(b<tam_sala_actual):
				tablero[x+a][y+b] = sala_actual[a][b]
				b = b+1
			a = a+1
		
		salas_colocadas = salas_colocadas+1
		
	pass

func buscar_sala(numero: int):
	var x = 0
	var y = 0
	var resultado: Array = []
	while (x<lado):
		y = 0
		while (y<lado):
			if(tablero[x][y] == numero):
				resultado.append(x)
				resultado.append(y)
				return resultado
			y = y+1
		x = x+1

func poner_pasillo(x:int, y:int):
	if (tablero[x][y] == 0): tablero[x][y] = 9
	pass

func conectar_dos_salas(inicio: Array, fin: Array):
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

func unir_salas_alt():
	var numero_salas: int = salas.size()
	var camino_principal: Array = []
	var camino_secundario: Array = []
	var salas_conectadas: Array = []
	var salas_sueltas: Array = []
	# Seleccionar las salas a juntar, asegurando que el inicio y la meta están conectados
	var secuencia = 1
	salas_conectadas.append(secuencia)
	while (secuencia < numero_salas):
		var salto = 1 + RandomNumberGenerator.new().randi() % (numero_salas - 1)
		if ((secuencia + salto) > numero_salas):
			camino_principal.append([secuencia,numero_salas])
			secuencia = numero_salas
		else:
			camino_principal.append([secuencia,(secuencia + salto)])
			secuencia = (secuencia + salto)
		salas_conectadas.append(secuencia)
		
	#print(camino_principal)
	var i = 0
	while (i < camino_principal.size()):
		#salas_conectadas.append([1,4])
		#print(salas_conectadas[0][0])
		var posicion_sala_inicio = buscar_sala(camino_principal[i][0])
		#print(posicion_sala_inicio)
		var posicion_sala_fin = buscar_sala(camino_principal[i][1])
		#print(posicion_sala_fin)
		# Crear el camino más corto que une esas salas
		# [0][0] ... [9][9]
		# camino en forma de escalera:
		conectar_dos_salas(posicion_sala_inicio, posicion_sala_fin)
		i += 1
	
	# Seleccionar el resto de salas y juntarlas con las salas del camino principal
	i = 0
	while (i<numero_salas):
		i += 1
		if (salas_conectadas.has(i) == false):
			salas_sueltas.append(i)
	#print(salas_conectadas)
	#print(salas_sueltas)
	
	i = 0
	while (i<salas_sueltas.size()):
		camino_secundario.append([salas_sueltas[i],salas_conectadas.pick_random()])
		i += 1
	#print(camino_secundario)
	
	# Crear los caminos más cortos entre las salas secundarias y las del camino principal
	i = 0
	while (i < camino_secundario.size()):
		var posicion_sala_inicio = buscar_sala(camino_secundario[i][0])
		var posicion_sala_fin = buscar_sala(camino_secundario[i][1])
		conectar_dos_salas(posicion_sala_inicio, posicion_sala_fin)
		i += 1
	# Seleccionar uniones de salas no existentes y redundantes, el numero de conexiones redundantes sera aleatorio entre 1 y el número de salas -1
	# Crear caminos que hagan las uniones redundantes
	# No importa si los caminos se cruzan entre sí, pero no deben atravesar las salas (eso puede ser dificil)
	pass

func crear_sala(tam: int):
	#Esta función crea salas de un tamaño especifico
	var sala: Array
	sala.resize(tam) #numero de columnas
	var i=0
	while(i<tam): #numero de filas
		var j=0
		var fila: Array
		while(j<tam):
			fila.append(salas.size()+1)
			#fila.append(1)
			j = j+1
		sala[i] = fila
		i = i+1
	salas.append(sala)
	#print(sala)
	# En este momento tenemos un tablero completamente vacio
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
