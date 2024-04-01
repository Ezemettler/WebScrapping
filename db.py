import psycopg2

def conectar():
    try:
        conn = psycopg2.connect(
            dbname="bot_super",
            user="administrador",
            password="admin391",
            host="localhost"
        )
        return conn
    except psycopg2.Error as e:
        print("Error al conectar a la base de datos:", e)
        return None

def ejecutar_consulta(conn, consulta):
    try:
        cur = conn.cursor()
        cur.execute(consulta)
        if cur.description:
            resultados = cur.fetchall()
        else:
            resultados = None
        cur.close()
        return resultados
    except psycopg2.Error as e:
        print("Error al ejecutar la consulta:", e)
        return None

def cerrar_conexion(conn):
    try:
        conn.close()
    except psycopg2.Error as e:
        print("Error al cerrar la conexión:", e)

def obtener_nombres_productos():
    # Función para obtener los nombres de los productos desde la base de datos
    # Realiza la conexión a la base de datos
    conexion = conectar()
    if conexion:
        # Ejecuta la consulta para obtener los nombres de los productos
        consulta = "SELECT nombre_producto FROM productos"
        nombres_productos = ejecutar_consulta(conexion, consulta)
        # Cierra la conexión después de usarla
        cerrar_conexion(conexion)
        return [nombre[0] for nombre in nombres_productos] if nombres_productos else []
    else:
        return []

def obtener_enlaces_producto(producto):
    consulta = f"SELECT link_coto, link_carrefour, link_dia FROM productos WHERE nombre_producto = '{producto}'"
    conexion = conectar()
    if conexion:
        enlaces = ejecutar_consulta(conexion, consulta)
        cerrar_conexion(conexion)
        if enlaces:
            return {
                "Coto": enlaces[0][0],
                "Carrefour": enlaces[0][1],
                "Día": enlaces[0][2]
            }
        else:
            return None
    else:
        return None
