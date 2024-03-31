import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime
import streamlit as st
import locale

# Diccionario de productos y listas de URLs asociadas a cada supermercado
productos = {
    "Azúcar Ledesma 1kg": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-azucar-superior-real-ledesma-1kg/_/A-00218834-00218834-200",
        "Carrefour": "https://www.carrefour.com.ar/azucar-ledesma-molida-superior-bolsa-1-kg/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/azucar-ledesma-refinado-superior-1-kg-129208/p"
    },
    "Harina Morixe 0000 1kg": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-trigo-0000-morixe-paq-1-kgm/_/A-00480052-00480052-200",
        "Carrefour": "https://www.carrefour.com.ar/harina-de-trigo-morixe-0000-1-kg/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/harina-0000-morixe-1-kg-258543/p"
    },
    "Harina Leudante Pureza 1 Kg": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-leudante-ultra-refinada-pureza-paq-1-kgm/_/A-00532008-00532008-200",
        "Carrefour": "https://www.carrefour.com.ar/harina-leudante-pureza-con-vitamina-d-1-kg-694963/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/harina-leudante-pureza-1-kg-57371/p"
    },
    "Arroz Integral Molinos Ala 500 Gr": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-arroz-integ--molinos-ala-paq-500-grm/_/A-00029055-00029055-200",
        "Carrefour": "https://www.carrefour.com.ar/arroz-integral-molinos-ala-bolsa-500-g/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/arroz-integral-grano-mas-entero-molinos-ala-500-gr-300526/p"
    },
    "Yerba Mate Playadito Suave 1 Kg": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-yerba-mate-suave-playadito-1-kg/_/A-00502038-00502038-200",
        "Carrefour": "https://www.carrefour.com.ar/yerba-mate-playadito-suave-con-palo-1-kg/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/yerba-mate-playadito-suave-1-kg-269577/p"
    },
     "Aceite de Girasol Natura 1,5 Lts": {
        "Coto": "https://www.cotodigital3.com.ar/sitios/cdigi/producto/-aceite-girasol-natura-botella-15-l/_/A-00014076-00014076-200",
        "Carrefour": "https://www.carrefour.com.ar/aceite-de-girasol-natura-15-l/p",
        "Día": "https://diaonline.supermercadosdia.com.ar/aceite-de-girasol-natura-15-lts-78856/p"
    },
    # Agregar más productos y URLs según sea necesario
}

def formatear_moneda(precio):
    # Configura la ubicación para formatear los números como moneda
    '''
    locale.setlocale(locale.LC_ALL, 'es_AR.UTF-8')
    return locale.currency(precio, grouping=True)
    '''
    return round(precio, 2)

def limpiar_precio(precio_str):
    # Eliminar el símbolo de moneda ($) y el . de separador de mil
    precio_str = precio_str.replace('$', '').replace('.', '')
    # Eliminar los caracteres a partir del punto decimal
    precio_str = precio_str.split(',')[0]
    return float(precio_str)    # Convertir el precio a un valor numérico
        

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

# Agrega la decoración st.cache a la función para almacenar en caché los resultados
@st.cache_data
def extraer_precio(productos):
    data = []
    fecha_actual = datetime.now().strftime("%Y-%m-%d")

    for producto, urls in productos.items():
        precios = {"Producto": producto, "Fecha": fecha_actual}
        for supermercado, url in urls.items():
            precio = None
            if supermercado == "Coto":
                precio = extraer_precio_coto(url)
            elif supermercado == "Carrefour":
                precio = extraer_precio_carrefour(url)
            elif supermercado == "Día":
                precio = extraer_precio_dia(url)
            precios[supermercado] = precio
        data.append(precios)

    return pd.DataFrame(data)

# Ejemplo de uso
tabla_precios = extraer_precio(productos)

# Interfaz de usuario con Streamlit
st.title('Planificá tus Compras en Supermercados')

# Obtener los productos seleccionados por el usuario
productos_seleccionados = st.multiselect('Seleccione los productos que desea comprar:', list(productos.keys()))

# Calcular el monto total en cada supermercado
tabla_precios = extraer_precio({producto: productos[producto] for producto in productos_seleccionados})

# Calcular el monto total para cada supermercado y agregarlo como una fila en el DataFrame
for supermercado in tabla_precios.columns[2:]:
    tabla_precios.loc['Total', supermercado] = tabla_precios[supermercado].sum()

# Convertir las columnas a tipo numérico, excluyendo la fila 'Total'
tabla_precios.iloc[:-1, 2:] = tabla_precios.iloc[:-1, 2:].apply(pd.to_numeric, errors='coerce')

# Calcular el mínimo de los totales
minimo_total = tabla_precios.iloc[-1, 2:].min()

# Guardamos el total de cada supermercado en variables
total_coto = tabla_precios.loc['Total', 'Coto']
total_carrefour = tabla_precios.loc['Total', 'Carrefour']
total_dia = tabla_precios.loc['Total', 'Día']

# Calcular el ahorro para cada supermercado
ahorros_coto = total_coto - minimo_total
ahorros_carrefour = total_carrefour - minimo_total
ahorros_dia = total_dia - minimo_total

# Agregar fila 'Ahorrás' al DataFrame
ahorros_df = pd.DataFrame({'Producto': 'Ahorrás', 'Fecha': '', 
                           'Coto': formatear_moneda(ahorros_coto),
                           'Carrefour': formatear_moneda(ahorros_carrefour),
                           'Día': formatear_moneda(ahorros_dia)
                           }, index=[0])

# Concatenar la fila 'Ahorrás' al DataFrame original
tabla_precios = pd.concat([tabla_precios, ahorros_df])

# Mostrar la tabla con el formato aplicado
st.table(tabla_precios)