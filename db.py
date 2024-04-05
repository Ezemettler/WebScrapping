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
        consulta = 'SELECT nombre_producto FROM productos'
        nombres_productos = ejecutar_consulta(consulta)
        # Transformar la lista de tuplas en una lista plana de nombres de productos
        return [nombre[0] for nombre in nombres_productos] if nombres_productos else [] 
    except Exception as e:
        print("Error al consultas los nombres de los productos:", e)
        return None


def consultar_precios_productos():
    try:
        consulta = "SELECT * FROM precios_productos"
        precios = ejecutar_consulta(consulta)
        df_precios = pd.DataFrame(precios)
        df_precios = df_precios.drop(columns=df_precios.columns[0])  # Eliminar la primera columna, que es 'index'
        # Supongamos que quieres cambiar los nombres de las columnas 'precio_coto', 'precio_carrefour' y 'precio_dia' a minúsculas
        nuevos_nombres = {'precio_coto': 'Coto', 'precio_carrefour': 'Carrefour', 'precio_dia': 'Día'}
        # Utiliza el método rename() para cambiar los nombres de las columnas
        df_precios = df_precios.rename(columns=nuevos_nombres)
        return df_precios
    except Exception as e:
        print("Error al consultar los precios de los productos:", e)
        return None
