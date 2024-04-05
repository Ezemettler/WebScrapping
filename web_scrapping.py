import requests
from bs4 import BeautifulSoup


def limpiar_precio(precio_str):
    precio_str = precio_str.replace('$', '').replace('.', '')   # Eliminar el símbolo de moneda ($) y el . de separador de mil
    precio_str = precio_str.split(',')[0]   # Eliminar los caracteres a partir del punto decimal
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
