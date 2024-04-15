-- Database: bot_super

-- DROP DATABASE IF EXISTS bot_super;
CREATE DATABASE bot_super
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_AR.UTF-8'
    LC_CTYPE = 'es_AR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE USER administrador WITH PASSWORD 'admin391';	-- Crear nuevo usuario y contraseña
GRANT ALL PRIVILEGES ON DATABASE bot_super TO administrador; -- Darle al usuario los privilegios para gestionar la bbdd.
GRANT ALL PRIVILEGES ON TABLE productos TO administrador; -- Darle al usuario permisos sobre la tabla productos
GRANT ALL PRIVILEGES ON TABLE precios_productos TO administrador; -- Darle al usuario permisos sobre la tabla precios_productos
GRANT USAGE, SELECT ON SEQUENCE precios_productos_id_seq TO administrador;

-- Crear tabla productos
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(255) NOT NULL,
    link_coto VARCHAR(255),
    link_carrefour VARCHAR(255),
    link_dia VARCHAR(255)
);

-- Insertar registros en la tabla productos
INSERT INTO productos (nombre_producto, link_coto, link_carrefour, link_dia) VALUES 	
	('Afeitadora Bic Comfort 3 hojas 4 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-maquina-de-afeitar-confort-3-acti-bic-4-uni/_/A-00493712-00493712-200', 'https://www.carrefour.com.ar/maquina-de-afeitar-bic-desechable-confort-3-advance-4-uni-720921/p', 'https://diaonline.supermercadosdia.com.ar/maquina-de-afeitar-bic-comfort-3-normal-3-hojas-4x3-un-242239/p'),
	('Afeitadora Gillette Derma Protección 2 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-maquina-de-afeitar-derma-proteccion-gillette-2-uni/_/A-00558103-00558103-200', 'https://www.carrefour.com.ar/maquina-de-afeitar-gillette-derma-proteccion-x-2-uni-698586/p', 'https://diaonline.supermercadosdia.com.ar/maquina-de-afeitar-derma-proteccion-con-barra-anti-irritacion-gillette-2-ud-120701/p')
;

-- Creación de tabla para registro diario de precios de cada supermercado.
CREATE TABLE precios_productos (
    id SERIAL PRIMARY KEY,
    producto VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL,
    precio_coto DECIMAL(10, 2),
    precio_carrefour DECIMAL(10, 2),
    precio_dia DECIMAL(10, 2)
);

-- Crear tabla rubros
CREATE TABLE tipo_producto (
    rubro_id SERIAL PRIMARY KEY,
    nombre_rubro VARCHAR(255) NOT NULL
);

-- Insertar registros en la tabla tipo_productos
INSERT INTO tipo_producto (nombre_rubro) VALUES
	('Aceites y condimentos'),
	('Aderezos'),
	('Arroz y Legumbres'),
	('Bebidas'),
	('Crema de leche'),
	('Dulces y mermeladas'),
	('Endulzantes'),
	('Frutas y Verduras'),
	('Galletitas'),
	('Harinas'),
	('Higiene personal'),
	('Huevos'),
	('Infusiones y Yerba'),
	('Leches'),
	('Pan rallado y Rebozadores')
;	

DROP TABLE tipo_producto;

CREATE INDEX idx_producto ON precios_productos (producto);

SELECT * FROM precios_productos;
SELECT * FROM productos ORDER BY nombre_producto;
SELECT * FROM tipo_producto;

-- Eliminar productos cargados en fecha
DELETE FROM precios_productos
WHERE fecha = '2024-04-09';


-- Listado de precios con valor null en supermercado coto
SELECT *
FROM precios_productos
WHERE precio_coto IS NULL
	AND fecha = '2024-04-12';

-- Listado de precios con valor null en supermercado carrefour
SELECT *
FROM precios_productos
WHERE precio_carrefour IS NULL
	AND fecha = '2024-04-12';
-- Listado de precios con valor null en supermercado dia
SELECT *
FROM precios_productos
WHERE precio_dia IS NULL
	AND fecha = '2024-04-12';

-- Completar precio
UPDATE precios_productos
SET precio_dia = 2225.00
WHERE producto = 'Dulce de Leche La Serenísima Clásico 400 Gr'
	AND fecha= '2024-04-12';