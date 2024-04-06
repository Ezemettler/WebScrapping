import db
import web_scrapping
from datetime import datetime
import pandas as pd


def actualizar_tabla_precios():  
    data = []  # Lista para almacenar los datos de precios
    fecha_actual = datetime.now().strftime("%Y-%m-%d")  # Obtiene la fecha actual en formato YYYY-MM-DD

    # Consulta para obtener los nombres de los productos y sus enlaces a los supermercados desde la base de datos
    consulta = "SELECT nombre_producto, link_coto, link_carrefour, link_dia FROM productos"
    resultado = db.ejecutar_consulta(consulta)  # Ejecuta la consulta en la base de datos
    productos = {}  # Diccionario para almacenar los enlaces de productos a los supermercados
    for row in resultado:  # Itera sobre los resultados de la consulta
        nombre_producto = row[0]  # Nombre del producto
        # Crea un diccionario con los enlaces a los supermercados para el producto actual
        enlaces = {
            "Coto": row[1],
            "Carrefour": row[2],
            "Día": row[3]
        }
        productos[nombre_producto] = enlaces  # Agrega el diccionario de enlaces al diccionario de productos

    for producto, urls in productos.items():  # Itera sobre los productos y sus enlaces
        precios = {"producto": producto, "fecha": fecha_actual}  # Inicializa un diccionario para almacenar los precios del producto actual
        for supermercado, url in urls.items():  # Itera sobre los enlaces del producto actual
            precio = None  # Inicializa el precio como None
            try:  # Intenta obtener el precio del producto en el supermercado actual
                if supermercado == "Coto":  # Si es el enlace de Coto
                    precio = web_scrapping.extraer_precio_coto(url)  # Extrae el precio de Coto
                elif supermercado == "Carrefour":  # Si es el enlace de Carrefour
                    precio = web_scrapping.extraer_precio_carrefour(url)  # Extrae el precio de Carrefour
                elif supermercado == "Día":  # Si es el enlace de Día
                    precio = web_scrapping.extraer_precio_dia(url)  # Extrae el precio de Día
            except Exception as e:  # Captura cualquier error que ocurra durante la extracción del precio
                print(f"Error al extraer el precio del producto {producto} en {supermercado}: {e}")
            # Asigna el precio obtenido al supermercado correspondiente en el diccionario de precios
            precios[supermercado] = precio if precio is not None else None
        data.append(precios)  # Agrega el diccionario de precios del producto a la lista de datos

    df = pd.DataFrame(data)     # Convertimos a dataframe.
    df.head()
    # Renombrar las columnas del DataFrame para que coincidan con las columnas de la tabla de la base de datos
    df = df.rename(columns={"Coto": "precio_coto", "Carrefour": "precio_carrefour", "Día": "precio_dia"})
    engine = db.conectar_bd()
    if engine:
        try:
            df.to_sql('precios_productos', con=engine, if_exists='append', index=False)  # Insertar DataFrame en la tabla
            print("Datos cargados en la base de datos correctamente.")
        except Exception as e:
            print("Error al cargar datos en la base de datos:", e)
        finally:
            engine.dispose()
    else:
        print("Error al conectar a la base de datos.")
    
actualizar_tabla_precios()