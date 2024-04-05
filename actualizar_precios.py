import db
import web_scrapping
from datetime import datetime
import pandas as pd


def actualizar_tabla_precios():  
    data = []
    fecha_actual = datetime.now().strftime("%Y-%m-%d")

    # Extraemos los productos y sus enlaces a la web de cada supermercado, y creamos un diccionario.     
    consulta = "SELECT nombre_producto, link_coto, link_carrefour, link_dia FROM productos"
    resultado = db.ejecutar_consulta(consulta)
    productos = {}
    for row in resultado:
        nombre_producto = row[0]
        enlaces = {
            "Coto": row[1],
            "Carrefour": row[2],
            "Día": row[3]
        }
        productos[nombre_producto] = enlaces

    for producto, urls in productos.items():
        precios = {"producto": producto, "fecha": fecha_actual}
        for supermercado, url in urls.items():
            precio = None
            if supermercado == "Coto":
                precio = web_scrapping.extraer_precio_coto(url)
            elif supermercado == "Carrefour":
                precio = web_scrapping.extraer_precio_carrefour(url)
            elif supermercado == "Día":
                precio = web_scrapping.extraer_precio_dia(url)
            precios[supermercado.lower()] = precio
        data.append(precios)

    df = pd.DataFrame(data)     # Convertimos a dataframe.
    # Renombrar las columnas del DataFrame para que coincidan con las columnas de la tabla de la base de datos
    df = df.rename(columns={"producto": "producto", "fecha": "fecha", "coto": "precio_coto", "carrefour": "precio_carrefour", "día": "precio_dia"})

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