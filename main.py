import pandas as pd
import streamlit as st
import db   

# Llamada a la función para obtener los nombres de los productos desde la base de datos
productos = db.obtener_nombres_productos()

st.title('Planificá tus Compras en Supermercados')      # Titulo de la Interfaz de usuario con Streamlit

# Obtener los productos seleccionados por el usuario
productos_seleccionados = st.multiselect('Seleccione los productos que desea comprar:', {producto: producto for producto in productos})
# Itera sobre cada elemento de la lista productos_seleccionados y crear un par clave-valor en el diccionario para cada elemento. 
productos_seleccionados_dict = {producto: producto for producto in productos_seleccionados}

# Calcular el monto total en cada supermercado solo si hay productos seleccionados
if productos_seleccionados:
    tabla_precios = db.consultar_precios_productos()

    # Filtrar los datos del DataFrame según los productos seleccionados por el usuario
    tabla_precios_filtrados = tabla_precios[tabla_precios['producto'].isin(productos_seleccionados)]

    # Calcular el monto total para cada supermercado y agregarlo como una fila en el DataFrame
    for supermercado in tabla_precios_filtrados.columns[2:]:
        tabla_precios_filtrados.loc['Total', supermercado] = tabla_precios_filtrados[supermercado].sum()

    # Convertir las columnas a tipo numérico, excluyendo la fila 'Total'
    tabla_precios_filtrados.iloc[:-1, 2:] = tabla_precios_filtrados.iloc[:-1, 2:].apply(pd.to_numeric, errors='coerce')

    minimo_total = tabla_precios_filtrados.iloc[-1, 2:].min()             # Calcular el mínimo de los totales
    supermercado_minimo = tabla_precios_filtrados.iloc[-1, 2:].idxmin()   # Determinar en qué supermercado se encuentra el total mínimo

    # Generar el mensaje de ahorro
    mensaje_ahorro = f"El supermercado donde te conviene comprar es: **{supermercado_minimo}**"

    # Guardamos el total de cada supermercado en variables
    total_coto = tabla_precios_filtrados.loc['Total', 'Coto']
    total_carrefour = tabla_precios_filtrados.loc['Total', 'Carrefour']
    total_dia = tabla_precios_filtrados.loc['Total', 'Día']


    # Calcular el ahorro para cada supermercado
    ahorros_coto = total_coto - minimo_total
    ahorros_carrefour = total_carrefour - minimo_total
    ahorros_dia = total_dia - minimo_total

    # Calcular el gasto adicional en cada supermercado
    gasto_adicional = {}
    for supermercado in tabla_precios_filtrados.columns[2:]:
        if supermercado != supermercado_minimo:
            gasto_adicional[supermercado] = tabla_precios_filtrados.loc['Total', supermercado] - tabla_precios_filtrados.loc['Total', supermercado_minimo]

    # Generar los mensajes de gasto adicional para cada supermercado
    mensajes_gasto_adicional = [f"Si compraras en **{supermercado}**, gastarías **{(gasto)}** más" for supermercado, gasto in gasto_adicional.items()]

    st.table(tabla_precios_filtrados)     # Mostrar la tabla con el formato aplicado
    st.write(mensaje_ahorro)    # Mostrar el mensaje de ahorro

    # Mostrar los mensajes de gasto adicional
    for mensaje in mensajes_gasto_adicional:
        st.write(mensaje)
else:
    st.write("No se han seleccionado productos.")