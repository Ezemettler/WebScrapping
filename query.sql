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

CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(255) NOT NULL,
    link_coto VARCHAR(255),
    link_carrefour VARCHAR(255),
    link_dia VARCHAR(255)
);

INSERT INTO productos (nombre_producto, link_coto, link_carrefour, link_dia) 
VALUES	('Azúcar Ledesma 1kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-azucar-superior-real-ledesma-1kg/_/A-00218834-00218834-200', 'https://www.carrefour.com.ar/azucar-ledesma-molida-superior-bolsa-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/azucar-ledesma-refinado-superior-1-kg-129208/p'),
		('Harina Morixe 0000 1kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-trigo-0000-morixe-paq-1-kgm/_/A-00480052-00480052-200', 'https://www.carrefour.com.ar/harina-de-trigo-morixe-0000-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-0000-morixe-1-kg-258543/p'),
		('Harina Leudante Pureza 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-leudante-ultra-refinada-pureza-paq-1-kgm/_/A-00532008-00532008-200', 'https://www.carrefour.com.ar/harina-leudante-pureza-con-vitamina-d-1-kg-694963/p', 'https://diaonline.supermercadosdia.com.ar/harina-leudante-pureza-1-kg-57371/p'),
		('Arroz Integral Molinos Ala 500 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-arroz-integ--molinos-ala-paq-500-grm/_/A-00029055-00029055-200', 'https://www.carrefour.com.ar/arroz-integral-molinos-ala-bolsa-500-g/p', 'https://diaonline.supermercadosdia.com.ar/arroz-integral-grano-mas-entero-molinos-ala-500-gr-300526/p'),
		('Yerba Mate Playadito Suave 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-yerba-mate-suave-playadito-1-kg/_/A-00502038-00502038-200', 'https://www.carrefour.com.ar/yerba-mate-playadito-suave-con-palo-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/yerba-mate-playadito-suave-1-kg-269577/p'),
		('Aceite de Girasol Natura 1,5 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-aceite-girasol-natura-botella-15-l/_/A-00014076-00014076-200', 'https://www.carrefour.com.ar/aceite-de-girasol-natura-15-l/p', 'https://diaonline.supermercadosdia.com.ar/aceite-de-girasol-natura-15-lts-78856/p');

-- Creación de tabla para registro diario de precios de cada supermercado.
CREATE TABLE precios_productos (
    id SERIAL PRIMARY KEY,
    producto VARCHAR(255) NOT NULL,
    fecha DATE NOT NULL,
    precio_coto DECIMAL(10, 2),
    precio_carrefour DECIMAL(10, 2),
    precio_dia DECIMAL(10, 2)
);


SELECT * FROM precios_productos;
SELECT * FROM productos;

INSERT INTO precios_productos (producto, fecha, precio_coto, precio_carrefour, precio_dia)
VALUES ('Polenta Blanca Flor', '2024-04-06', 809.00, NULL, 709.00);

SELECT DISTINCT ON (producto) producto, fecha, precio_coto, precio_carrefour, precio_dia
FROM precios_productos
ORDER BY producto, fecha DESC;

