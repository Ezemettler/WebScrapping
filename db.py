from sqlalchemy import create_engine
from sqlalchemy import text
import pandas as pd


def conectar_bd():
    # Funcion para conectarse a la base de datos.
    # Variables para cada parte de la cadena de conexión
    dbname = "bot_super"
    user = "administrador"
    password = "admin391"
    host = "localhost"
    # Combinar las variables en una cadena de conexión
    connection_string = f"postgresql://{user}:{password}@{host}/{dbname}"
    try:
        # Crear el motor SQLAlchemy con la cadena de conexión
        engine = create_engine(connection_string)
        return engine
    except Exception as e:
        print("Error al conectar a la base de datos:", e)
        return None


def cerrar_conexion(conn):
    try:
        conn.close()
        print("Conexión cerrada correctamente.")
    except Exception as e:
        print("Error al cerrar la conexión:", e)


def ejecutar_consulta(consulta):
    engine = conectar_bd()  # Conecta a la base de datos
    if engine:
        try:
            with engine.connect() as conn:
                result = conn.execute(text(consulta))
                if result.returns_rows:
                    return result.fetchall()  # Devuelve los resultados de la consulta
                else:
                    return "Consulta ejecutada correctamente."  # Retorna un mensaje de confirmación
        except Exception as e:
            print("Error al ejecutar la consulta:", e)
        finally:
            cerrar_conexion(conn)
    else:
        print("Error: No se pudo conectar a la base de datos")
        return []


def obtener_nombres_productos():
    try:
        # Función para obtener los nombres de los productos desde la base de datos
        consulta = 'SELECT nombre_producto FROM productos ORDER BY nombre_producto ASC;'
        nombres_productos = ejecutar_consulta(consulta)
        # Transformar la lista de tuplas en una lista plana de nombres de productos
        return [nombre[0] for nombre in nombres_productos] if nombres_productos else [] 
    except Exception as e:
        print("Error al consultas los nombres de los productos:", e)
        return None


def consultar_precios_productos():
    try:
        consulta = '''SELECT DISTINCT ON (producto) producto, fecha, precio_coto, precio_carrefour, precio_dia
                      FROM precios_productos
                      ORDER BY producto, fecha DESC;'''
        precios = ejecutar_consulta(consulta)
        df_precios = pd.DataFrame(precios)
        # Supongamos que quieres cambiar los nombres de las columnas 'precio_coto', 'precio_carrefour' y 'precio_dia' a minúsculas
        nuevos_nombres = {'precio_coto': 'Coto', 'precio_carrefour': 'Carrefour', 'precio_dia': 'Día'}
        # Utiliza el método rename() para cambiar los nombres de las columnas
        df_precios = df_precios.rename(columns=nuevos_nombres)
        return df_precios
    except Exception as e:
        print("Error al consultar los precios de los productos:", e)
        return None


def obtener_ultimo_precio(supermercado, producto):
# Consulta SQL dinámica para obtener el último precio según el supermercado y el producto
    consulta = """
        SELECT 
            CASE
                WHEN :supermercado = 'Coto' THEN precio_coto
                WHEN :supermercado = 'Carrefour' THEN precio_carrefour
                WHEN :supermercado = 'Día' THEN precio_dia
            END AS precio
        FROM precios_productos
        WHERE producto = :producto
        ORDER BY fecha DESC
        LIMIT 1;
    """
    parametros = {"supermercado": supermercado, "producto": producto}       # Parámetros de la consulta
    engine = conectar_bd()  # Conecta a la base de datos
    with engine.connect() as conn:
        resultado = conn.execute(text(consulta), parametros)        # Ejecutar la consulta y obtener el resultado
    precio = resultado.fetchone()[0] if resultado.fetchone() is not None else None     # Obtener el precio del resultado
    return precio
