import requests
from bs4 import BeautifulSoup


def limpiar_precio(precio_str):
    precio_str = precio_str.replace('$', '').replace('.', '')   # Eliminar el símbolo de moneda ($) y el . de separador de mil
    precio_str = precio_str.split(',')[0]   # Eliminar los caracteres a partir del punto decimal
    return float(precio_str)    # Convertir el precio a un valor numérico


def limpiar_precio_desc_coto(precio_str):
    # Eliminar caracteres no numéricos y convertir el precio a formato decimal
    precio_str = precio_str.replace('$', '').replace(',', '')
    precio_float = float(precio_str)
    
    # Ajustar el formato decimal a dos decimales
    precio_decimal = round(precio_float, 2)
    
    return precio_decimal


def extraer_precio_coto(url):
    headers = {'User-Agent': 'Mozilla/5.0'}     # Se establece el User-Agent para evitar bloqueos por parte del servidor
    response = requests.get(url, headers=headers)   # Se realiza una solicitud GET a la URL proporcionada
    if response.status_code == 200:     # Se verifica si la solicitud fue exitosa (código de estado 200)
        soup = BeautifulSoup(response.text, 'html.parser')      # Se crea un objeto BeautifulSoup para analizar el contenido HTML de la página web
        
        precio_descuento_element = soup.find('span', class_='price_discount')       # Buscar precio en las etiquetas de descuento
        if precio_descuento_element:
            # Si se encuentra el precio en las etiquetas de descuento, se limpia y se devuelve
            return limpiar_precio_desc_coto(precio_descuento_element.text.strip())
        
        precio_descuento_gde_element = soup.find('span', class_='price_discount_gde')       # Buscar precio en las etiquetas de descuento grandes (gde)
        if precio_descuento_gde_element:
            # Si se encuentra el precio en las etiquetas de descuento grandes, se limpia y se devuelve
            return limpiar_precio_desc_coto(precio_descuento_gde_element.text.strip())
        
        atg_store_newprice = soup.find('span', class_='atg_store_newPrice')     # Si no se encontró el precio en las etiquetas de descuento, se busca en 'atg_store_newprice'
        if atg_store_newprice:
            # Se limpia el precio y se devuelve
            return limpiar_precio(atg_store_newprice.text.strip())
                
    else:  
        return "Error al acceder a la página"       # Si la solicitud no fue exitosa, se devuelve un mensaje de error


def extraer_precio_carrefour(url):
    # Función para extraer el precio del producto desde la página web de Carrefour
    headers = {'User-Agent': 'Mozilla/5.0'}     # Se establece el User-Agent para evitar bloqueos por parte del servidor
    response = requests.get(url, headers=headers)   # Se realiza una solicitud GET a la URL proporcionada
    if response.status_code == 200:     # Se verifica si la solicitud fue exitosa (código de estado 200)
        soup = BeautifulSoup(response.text, 'html.parser')  # Se crea un objeto BeautifulSoup para analizar el contenido HTML de la página web
        precio_element = soup.find('span', class_='valtech-carrefourar-product-price-0-x-currencyContainer')
        if precio_element:  # Si se encuentra el elemento del precio, se limpia el texto y se devuelve
            return limpiar_precio(precio_element.text.strip())
        else:
            return None   # Si no se encuentra el elemento del precio, se devuelve None
    else:
        return "Error al acceder a la página"   # Si la solicitud no fue exitosa, se devuelve un mensaje de error


def extraer_precio_dia(url):
    # Función para extraer el precio del producto desde la página web de Día
    headers = {'User-Agent': 'Mozilla/5.0'}     # Se establece el User-Agent para evitar bloqueos por parte del servidor
    response = requests.get(url, headers=headers)   # Se realiza una solicitud GET a la URL proporcionada
    if response.status_code == 200:     # Se verifica si la solicitud fue exitosa (código de estado 200)
        soup = BeautifulSoup(response.text, 'html.parser')  # Se crea un objeto BeautifulSoup para analizar el contenido HTML de la página web
        precio_element = soup.find('span', class_='vtex-product-price-1-x-sellingPriceValue')
        if precio_element:  # Si se encuentra el elemento del precio, se limpia el texto y se devuelve
            return limpiar_precio(precio_element.text.strip())
        else:
            return None   # Si no se encuentra el elemento del precio, se devuelve None
    else:
        return "Error al acceder a la página"   # Si la solicitud no fue exitosa, se devuelve un mensaje de error
