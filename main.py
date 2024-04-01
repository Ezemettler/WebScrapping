import pandas as pd
import streamlit as st
import db
import utils

# Intenta conectar a la base de datos
conexion = db.conectar()

# Verifica si la conexión fue exitosa
if conexion:
    print("Conexión exitosa a la base de datos.")
    # Llamada a la función para obtener los nombres de los productos desde la base de datos
    productos = db.obtener_nombres_productos()
    # Llamada a la función para extraer los precios desde la base de datos
    tabla_precios = utils.extraer_precio(productos)
    # Cierra la conexión después de usarla
    db.cerrar_conexion(conexion)
else:
    print("No se pudo conectar a la base de datos.")

# Interfaz de usuario con Streamlit
st.title('Planificá tus Compras en Supermercados')

# Obtener los productos seleccionados por el usuario
productos_seleccionados = st.multiselect('Seleccione los productos que desea comprar:', {producto: producto for producto in productos})
productos_seleccionados_dict = {producto: producto for producto in productos_seleccionados}

# Calcular el monto total en cada supermercado solo si hay productos seleccionados
if productos_seleccionados:
    tabla_precios = utils.extraer_precio(productos_seleccionados_dict)

    # Calcular el monto total para cada supermercado y agregarlo como una fila en el DataFrame
    for supermercado in tabla_precios.columns[2:]:
        tabla_precios.loc['Total', supermercado] = tabla_precios[supermercado].sum()

    # Convertir las columnas a tipo numérico, excluyendo la fila 'Total'
    tabla_precios.iloc[:-1, 2:] = tabla_precios.iloc[:-1, 2:].apply(pd.to_numeric, errors='coerce')

    minimo_total = tabla_precios.iloc[-1, 2:].min()             # Calcular el mínimo de los totales
    supermercado_minimo = tabla_precios.iloc[-1, 2:].idxmin()   # Determinar en qué supermercado se encuentra el total mínimo

    # Generar el mensaje de ahorro
    mensaje_ahorro = f"El supermercado donde te conviene comprar es: **{supermercado_minimo}**"

    # Guardamos el total de cada supermercado en variables
    total_coto = tabla_precios.loc['Total', 'Coto']
    total_carrefour = tabla_precios.loc['Total', 'Carrefour']
    total_dia = tabla_precios.loc['Total', 'Día']

    # Calcular el ahorro para cada supermercado
    ahorros_coto = total_coto - minimo_total
    ahorros_carrefour = total_carrefour - minimo_total
    ahorros_dia = total_dia - minimo_total

    # Calcular el gasto adicional en cada supermercado
    gasto_adicional = {}
    for supermercado in tabla_precios.columns[2:]:
        if supermercado != supermercado_minimo:
            gasto_adicional[supermercado] = tabla_precios.loc['Total', supermercado] - tabla_precios.loc['Total', supermercado_minimo]

    # Generar los mensajes de gasto adicional para cada supermercado
    mensajes_gasto_adicional = [f"Si compraras en **{supermercado}**, gastarías **{utils.formatear_moneda(gasto)}** más" for supermercado, gasto in gasto_adicional.items()]

    st.table(tabla_precios)     # Mostrar la tabla con el formato aplicado
    st.write(mensaje_ahorro)    # Mostrar el mensaje de ahorro

    # Mostrar los mensajes de gasto adicional
    for mensaje in mensajes_gasto_adicional:
        st.write(mensaje)
else:
    st.write("No se han seleccionado productos.")