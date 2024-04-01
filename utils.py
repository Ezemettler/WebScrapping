import pandas as pd
from datetime import datetime
import db
import requests
from bs4 import BeautifulSoup
import streamlit as st

def extraer_precio_coto(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        precio_element = soup.find('span', class_='atg_store_newPrice')
        return limpiar_precio(precio_element.text.strip()) if precio_element else "Precio no encontrado"
    else:
        return "Error al acceder a la página"

def extraer_precio_carrefour(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        precio_element = soup.find('span', class_='valtech-carrefourar-product-price-0-x-currencyContainer')
        return limpiar_precio(precio_element.text.strip()) if precio_element else "Precio no encontrado"
    else:
        return "Error al acceder a la página"

def extraer_precio_dia(url):
    headers = {'User-Agent': 'Mozilla/5.0'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        precio_element = soup.find('span', class_='vtex-product-price-1-x-sellingPriceValue')
        return limpiar_precio(precio_element.text.strip()) if precio_element else "Precio no encontrado"
    else:
        return "Error al acceder a la página"

@st.cache_data
def extraer_precio(productos):
    # Crear una lista para almacenar los datos de los precios
    data = []
    fecha_actual = datetime.now().strftime("%Y-%m-%d")

    for producto in productos:
        precios = {"Producto": producto, "Fecha": fecha_actual}
        
        # Obtener los enlaces desde la base de datos
        enlaces = db.obtener_enlaces_producto(producto)
        
        for supermercado, enlace in enlaces.items():
            precio = None
            if supermercado == "Coto":
                precio = extraer_precio_coto(enlace)
            elif supermercado == "Carrefour":
                precio = extraer_precio_carrefour(enlace)
            elif supermercado == "Día":
                precio = extraer_precio_dia(enlace)
            precios[supermercado] = precio
        
        # Agregar los precios del producto a la lista de datos
        data.append(precios)

    # Crear un DataFrame a partir de la lista de datos
    return pd.DataFrame(data)

def formatear_moneda(precio):
    return round(precio, 2)

def limpiar_precio(precio_str):
    # Eliminar el símbolo de moneda ($) y el . de separador de mil
    precio_str = precio_str.replace('$', '').replace('.', '')
    # Eliminar los caracteres a partir del punto decimal
    precio_str = precio_str.split(',')[0]
    return float(precio_str)    # Convertir el precio a un valor numérico