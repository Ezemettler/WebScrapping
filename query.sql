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
VALUES	('Pan rallado Preferido 500 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-pan-rallado-fortificado-preferido-500g/_/A-00575395-00575395-200', 'https://www.carrefour.com.ar/pan-rallado-preferido-fortificado-500-g-731020/p', 'https://diaonline.supermercadosdia.com.ar/pan-rallado-fortificado-preferido-500-gr-162447/p'),
		('Pan rallado Preferido 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-pan-rallado-fortificado-preferido-1kg/_/A-00575394-00575394-200', 'https://www.carrefour.com.ar/?returnUrl=/pan-rallado-preferido-fortificado-1-kg-731021/p', 'https://diaonline.supermercadosdia.com.ar/pan-rallado-preferido-1-kg-104371/p'),
		('Rebozador Preferido crunch 450 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-rebozador-crunch-preferido-450g/_/A-00578903-00578903-200', 'https://www.carrefour.com.ar/rebozador-preferido-crunch-450-g-733218/p', 'https://diaonline.supermercadosdia.com.ar/pan-rallado-crunch-preferido-450-gr-291409/p'),
		('Rebozador Preferido horno 500 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-rebozador-para-horno-preferido-500g/_/A-00578900-00578900-200', 'https://www.carrefour.com.ar/rebozador-preferido-horno-en-bolsa-500-g-733215/p', 'https://diaonline.supermercadosdia.com.ar/rebozador-para-horno-fortificado-preferido-500-gr-301006/p'),
		('Rebozador Preferido clásico 500 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-rebozador-con-harina-preferido-500g/_/A-00578906-00578906-200', 'https://www.carrefour.com.ar/rebozador-preferido-en-bolsa-500-g-733211/p', 'https://diaonline.supermercadosdia.com.ar/robozador-fortificado-preferido-500-gr-300850/p'),
		('Pan Rallado Ajo & Perejil Preferido 500 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-rebozador-ajo-y-perejil-preferido-500g/_/A-00578901-00578901-200', 'https://www.carrefour.com.ar/pan-rallado-preferido-de-ajo-y-perejil-500-g-733217/p', 'https://diaonline.supermercadosdia.com.ar/pan-rallado-ajo---perejil-preferido-500-gr-301008/p'),
		('Gaseosa Coca-Cola Sabor Original 2,25 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-gaseosa-coca-cola-sabor-original--225-lt/_/A-00014450-00014450-200', 'https://www.carrefour.com.ar/gaseosa-coca-cola-sabor-original-225-l/p', 'https://diaonline.supermercadosdia.com.ar/gaseosa-coca-cola-sabor-original-225-lt-14837/p'),
		('Gaseosa Fanta Naranja 2,25 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-gaseosa-fanta-naranja-225-lt/_/A-00016477-00016477-200', 'https://www.carrefour.com.ar/gaseosa-fanta-naranja-225-l/p', 'https://diaonline.supermercadosdia.com.ar/gaseosa-fanta-naranja-225-lt-84975/p'),
		('Gaseosa Paso de Los Toros Pomelo 2,45 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-gaseosa-pomelo-paso-de-los-toros-2450c/_/A-00572315-00572315-200', 'https://www.carrefour.com.ar/gaseosa-paso-de-los-toros-regular-de-pomelo-245-lts-727730/p', 'https://diaonline.supermercadosdia.com.ar/gaseosa-pomelo-paso-de-los-toros-245-lt-299566/p'),
		('Gaseosa 7UP Lima Limon 2,45 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-gaseosa-lima-limon-seven-up-2450c/_/A-00574248-00574248-200', 'https://www.carrefour.com.ar/gaseosa-lima-limon-7-up-regular-2-45-lts-727732/p', 'https://diaonline.supermercadosdia.com.ar/gaseosa-lima-limon-regular-7up-245-lt-299565/p'),
		('Cerveza Brahma 1 Lt', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-cerveza-dorada-brahma-1l/_/A-00566207-00566207-200', 'https://www.carrefour.com.ar/cerveza-rubia-brahma-1-l/p', 'https://diaonline.supermercadosdia.com.ar/cerveza-brahma-dorada-botella-retornable-1-lt-297612/p'),
		('Cerveza Stella Artois 1 Lt', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-cerveza-lager-stella-artois---botella-975-cc/_/A-00164527-00164527-200', 'https://www.carrefour.com.ar/cerveza-blanca-stella-artois-vintage-975-cc-734914/p', 'https://diaonline.supermercadosdia.com.ar/cerveza-vintage-stella-artois-1-lt-301036/p'),
		('Cerveza Schneider 1 Lt', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-cerveza-lager-schneider---botella-1-l/_/A-00576920-00576920-200', 'https://www.carrefour.com.ar/cerveza-rubia-schneider-1-l/p', 'https://diaonline.supermercadosdia.com.ar/cerveza-schneider-retornable-970-ml-27365/p'),
		('Dulce de Leche La Serenísima Colonial 400 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-dulce-leche-colonial-la-serenisima-400g/_/A-00510307-00510307-200', 'https://www.carrefour.com.ar/dulce-de-leche-la-serenisima-colonial-400-g-678862/p', 'https://diaonline.supermercadosdia.com.ar/dulce-de-leche-la-serenisima-colonial-con-calcio-400-gr-273373/p'),
		('Dulce de Leche La Serenísima Colonial 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-dulce-leche-estilo-colonial-la-serenisima-1-kg/_/A-00510308-00510308-200', 'https://www.carrefour.com.ar/dulce-de-leche-colonial-la-serenisima-pote-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/dulce-de-leche-colonial-la-serenisima-1-kg-243810/p'),
		('Dulce de Leche La Serenísima Clásico 400 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-dulce-leche-la-serenisima-clasico-fuente-de-calcio-400-gr/_/A-00510306-00510306-200', 'https://www.carrefour.com.ar/dulce-de-leche-clasico-la-serenisima-400-g/p', 'https://diaonline.supermercadosdia.com.ar/dulce-de-leche-clasico-la-serenisima-con-calcio-400-gr-273372/p'),
		('Dulce de Leche La Serenisima Repostero 400 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-dulce-de-leche-repostero-la-serenisima-400g/_/A-00298995-00298995-200', 'https://www.carrefour.com.ar/dulce-de-leche-repostero-la-serenisima-400-g/p', 'https://diaonline.supermercadosdia.com.ar/dulce-de-leche-repostero-la-serenisima-400-gr-227719/p'),
		('Dulce de Leche Milkaut Clásico 400 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-dulce-de-leche-milkaut-clasico-400g/_/A-00166221-00166221-200', 'https://www.carrefour.com.ar/dulce-de-leche-milkaut-familiar-en-pote-400-g-722429/p', 'https://diaonline.supermercadosdia.com.ar/dulce-de-leche-milkaut-400-gr-297589/p')
		;

INSERT INTO productos (nombre_producto, link_coto, link_carrefour, link_dia) 
VALUES  ('Fernet Branca 750 cc', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-fernet-branca---botella-750-cc/_/A-00005525-00005525-200', 'https://www.carrefour.com.ar/fernet-branca-botella-750-cc/p', 'https://diaonline.supermercadosdia.com.ar/aperitivo-fernet-branca-750-ml-40267/p'),
		('Fernet Branca 450 cc', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-fernet-branca---botella-450-cc/_/A-00016291-00016291-200', 'https://www.carrefour.com.ar/aperitivo-fernet-branca-450-cc/p', 'https://diaonline.supermercadosdia.com.ar/aperitivo-fernet-branca-450-ml-102405/p'),
		('Fernet 1882 750 cc', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-fernet-1882---botella-750-cc/_/A-00203962-00203962-200', 'https://www.carrefour.com.ar/fernet-1882-750-cc/p', 'https://diaonline.supermercadosdia.com.ar/aperitivo-fernet-1882-750-ml-131815/p'),
		('Mayonesa Natura 475 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mayonesa-natura-pouch-475-gr/_/A-00075721-00075721-200', 'https://www.carrefour.com.ar/mayonesa-natura-475-g/p', 'https://diaonline.supermercadosdia.com.ar/mayonesa-natura-500-ml-5527/p'),
		('Mayonesa Heinz 200 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mayonesa-original-heinz-doy-200-grm/_/A-00475553-00475553-200', 'https://www.carrefour.com.ar/mayonesa-heinz-limon-200-g/p', 'https://diaonline.supermercadosdia.com.ar/mayonesa-heinz-200-gr-248314/p'),
		('Mayonesa Clásica Hellmanns 237 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mayonesa-clasica-hellmanns-237gr/_/A-00530668-00530668-200', 'https://www.carrefour.com.ar/?returnUrl=/mayonesa-hellmann-s-regular-doy-pack-237-g-694754/p', 'https://diaonline.supermercadosdia.com.ar/mayonesa-clasica-hellmann-s-sin-tacc-doypack-237-gr-283567/p'),
		('Mayonesa Clásica Hellmanns 475 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mayonesa-clasica-hellmanns-475gr/_/A-00530669-00530669-200', 'https://www.carrefour.com.ar/mayonesa-hellmann-s-regular-doy-pack-475-g-694755/p', 'https://diaonline.supermercadosdia.com.ar/mayonesa-clasica-hellmann-s-sin-tacc-doypack-475-gr-283568/p'),
		('Mayonesa Clásica Hellmanns 950 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mayonesa-clasica-hellmanns-950g/_/A-00530667-00530667-200', 'https://www.carrefour.com.ar/mayonesa-clasica-hellmann-s-sin-tacc-doypack-950-g-694756/p', 'https://diaonline.supermercadosdia.com.ar/mayonesa-clasica-hellmann-s-sin-tacc-doypack-950-gr-283566/p'),
		('Leche En Polvo La Serenisima Descremada 200 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-leche-e-polvo-desc-fortc-v-la-serenisi-paq-200-grm/_/A-00510583-00510583-200', 'https://www.carrefour.com.ar/leche-en-polvo-descremada-fortificada-la-serenisima-200-g/p', 'https://diaonline.supermercadosdia.com.ar/leche-en-polvo-la-serenisima-descremada-200-gr-273683/p'),
		('Galletitas Oreo Original 118 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-galletitas-oreo-rellenas-con-crema-sabor-original-118g-menos-sodio/_/A-00532297-00532297-200', 'https://www.carrefour.com.ar/galletitas-dulce-oreo-rellenas-con-crema-118-g-715949/p', 'https://diaonline.supermercadosdia.com.ar/galletitas-oreo-rellenas-con-crema-sabor-original-menos-sodio-118-gr-271629/p'),
		('Galletitas Oreo Original 182,5 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-galletitas-oreo-rellenas-con-crema-sabor-original-1825g-menos-sodio/_/A-00507347-00507347-200', 'https://www.carrefour.com.ar/galletitas-dulces-oreo-rellena-con-crema-1825-g-715950/p', 'https://diaonline.supermercadosdia.com.ar/galletitas-oreo-rellenas-con-crema-sabor-original-menos-sodio-1825-gr-271631/p'),
		('Bizcochos 9 de Oro Clásico 200 Gr', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-bizcochos-grasa-9-de-oro-paq-200-grm/_/A-00004606-00004606-200', 'https://www.carrefour.com.ar/bizcochos-9-de-oro-de-grasa-200-g/p', 'https://diaonline.supermercadosdia.com.ar/bizcochos-de-grasa-9-de-oro-clasico-200-gr-58648/p'),
		('Yerba Mate Taragüi 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-yerba-mate-4-flex-taragui-1-kg/_/A-00499474-00499474-200', 'https://www.carrefour.com.ar/yerba-mate-taragui-con-palo-origen-controlado-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/yerba-mate-taragui-4-flex-1-kg-269666/p'),
		('Yerba Mate Cbse Hierbas Serranas 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-yerba-mate-cbse-hierbas-serranas-1-kg/_/A-00512968-00512968-200', 'https://www.carrefour.com.ar/yerba-mate-cbse-con-hierbas-serranas-1-kg-71040/p', 'https://diaonline.supermercadosdia.com.ar/yerba-mate-cbse-hierbas-serranas-1-kg-274351/p'),
		('Yerba Mate Mañanita 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-yerba-mate-4-flex-mananita-paq-1-kgm/_/A-00499475-00499475-200', 'https://www.carrefour.com.ar/yerba-mate-mananita-bajo-polvo-4flex-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/yerba-mate-mananita-4-flex-1-kg-269667/p'),
		('Mate Cocido Taragui 50 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-mate-cocido-x50-saq-filtro-taragui-est-150-grm/_/A-00510766-00510766-200', 'https://www.carrefour.com.ar/mate-cocido-saquitos-diamantados-taragui-x-50-uni/p', 'https://diaonline.supermercadosdia.com.ar/mate-cocido-taragui-diamantado-50-un-273384/p'),
		('Té La Virginia Verde 20 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-te-verde-la-virginia-40-grm/_/A-00542996-00542996-200', 'https://www.carrefour.com.ar/?returnUrl=/te-verde-la-virginia-citrus-en-saquitos-20-g/p', 'https://diaonline.supermercadosdia.com.ar/te-la-virginia-verde-20-un-261772/p'),
		('Té La Virginia 25 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-te-x25-saquitos-la-virginia-cja-50-grm/_/A-00516582-00516582-200', 'https://www.carrefour.com.ar/?returnUrl=/te-la-virginia-en-saquitos-x-25-uni/p', 'https://diaonline.supermercadosdia.com.ar/te-clasico-la-virginia-naturalidad-intacta-25-un-280379/p'),
		('Té La Virginia 50 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-te-x50-saquitos-la-virginia-cja-100-grm/_/A-00516580-00516580-200', 'https://www.carrefour.com.ar/?returnUrl=/te-molienda-controlada-la-virginia-x-50-uni/p', 'https://diaonline.supermercadosdia.com.ar/te-comun-la-virginia-saquitos-50-un-276572/p'),
		('Té Taragui 25 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-te-en-saquito-taragui-x-25-saquitos-cja-50-grm/_/A-00530605-00530605-200', 'https://www.carrefour.com.ar/?returnUrl=/te-taragui-filtro-diamantado-x-25-uni-694892/p', 'https://diaonline.supermercadosdia.com.ar/te-taragui-sin-ensobrado-25-un-283639/p'),
		('Té Taragui 50 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-te-x50-saq-filtro-taragui-est-50-uni/_/A-00511775-00511775-200', 'https://www.carrefour.com.ar/?returnUrl=/te-en-saquitos-diamantado-taragui-x-50-uni/p', 'https://diaonline.supermercadosdia.com.ar/te-taragui-diamantado-50-ud-274695/p'),
		('Aceite de Girasol Lira 1,5 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-aceite-girasol--lira--botella-15-l/_/A-00495429-00495429-200', 'https://www.carrefour.com.ar/aceite-de-girasol-lira-15-l/p', 'https://diaonline.supermercadosdia.com.ar/aceite-de-girasol-lira-15-lts-264923/p'),
		('Aceite de Girasol Pureza 1,5 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-aceite-girasol--pureza---botella-15-l/_/A-00497066-00497066-200', 'https://www.carrefour.com.ar/aceite-de-girasol-pureza-1500-cc/p', 'https://diaonline.supermercadosdia.com.ar/aceite-de-girasol-pureza-15-lts-265505/p'),
		('Aceite de Girasol Natura 1,5 Lts', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-aceite-girasol-natura-botella-15-l/_/A-00014076-00014076-200', 'https://www.carrefour.com.ar/aceite-de-girasol-natura-15-l/p', 'https://diaonline.supermercadosdia.com.ar/aceite-de-girasol-natura-15-lts-78856/p'),
		('Vinagre de Alcohol Menoyo 500 Ml', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-vinagre-alcohol-menoyo-pet-500-cmq/_/A-00005933-00005933-200', 'https://www.carrefour.com.ar/vinagre-de-alcohol-menoyo-500-cc/p', 'https://diaonline.supermercadosdia.com.ar/vinagre-de-alcohol-menoyo-500-ml-178256/p'),
		('Vinagre de Alcohol Menoyo 1 L', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-vinagre-alcohol-menoyo-pet-1-ltr/_/A-00007197-00007197-200', 'https://www.carrefour.com.ar/vinagre-de-alcohol-menoyo-1-l/p', 'https://diaonline.supermercadosdia.com.ar/vinagre-de-alcohol-menoyo-1-l-27264/p'),
		('Vinagre de Manzana Menoyo 500 Ml', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-vinagre-manzana-menoyo-pet-500-cmq/_/A-00005935-00005935-200', 'https://www.carrefour.com.ar/vinagre-de-manzana-menoyo-500-cc/p', 'https://diaonline.supermercadosdia.com.ar/vinagre-de-manzana-menoyo-500-ml-27285/p'),
		('Edulcorante Stevia Hileret 50 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-edulcorante-hileret-stevia-caja-sobres-x-50/_/A-00265524-00265524-200', 'https://www.carrefour.com.ar/edulcorante-en-sobres-hileret-con-stevia-50-u/p', 'https://diaonline.supermercadosdia.com.ar/edulcorante-stevia-hileret-40-gr-300090/p'),
		('Edulcorante Stevia Hileret 100 Un', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-edulcorante-hileret-stevia-caja-sobres-x-100/_/A-00265523-00265523-200', 'https://www.carrefour.com.ar/edulcorante-en-sobres-hileret-con-stevia-100-u/p', 'https://diaonline.supermercadosdia.com.ar/endulzante-hileret-stevia-100-sobrecitos-183477/p'),
		('Edulcorante Hileret Stevia 200 Ml', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-edulcorante-hileret-stevia-botella-200-cc/_/A-00298196-00298196-200', 'https://www.carrefour.com.ar/edulcorante-liquido-hileret-con-stevia-200-cc/p', 'https://diaonline.supermercadosdia.com.ar/edulcorante-hileret-stevia-200-ml-277350/p'),
		('Edulcorante Hileret Sweet 200 Ml', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-edulcorante-hileret-sweet-botella-200-cc/_/A-00119983-00119983-200', 'https://www.carrefour.com.ar/edulcorante-liquido-hileret-sweet-200-cc/p', 'https://diaonline.supermercadosdia.com.ar/edulcorante-sweet-hileret-200-ml-298335/p'),
		('Harina Pureza 0000 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-de-trigo-pureza-0000-paquete-1-kg/_/A-00253696-00253696-200', 'https://www.carrefour.com.ar/harina-de-trigo-pureza-0000-1-kg-551284/p', 'https://diaonline.supermercadosdia.com.ar/harina-0000-pureza-ultra-refinada-1-kg-167177/p'),
		('Harina Morixe 000 1kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-trigo-000-morixe-1kg/_/A-00480051-00480051-200', 'https://www.carrefour.com.ar/harina-000-fortivac-morixe-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-de-trigo-fotivac-morixe-000-1-kg-283565/p'),
		('Harina Caserita 000 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-trigo-caserita-1kg/_/A-00005235-00005235-200', 'https://www.carrefour.com.ar/harina-de-trigo-000-caserita-x-1-kg-7757/p', 'https://diaonline.supermercadosdia.com.ar/harina-000-caserita-1-kg-54869/p'),
		('Harina Pureza Integral 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-integral--pureza-paq-1-kgm/_/A-00489266-00489266-200', 'https://www.carrefour.com.ar/harina-integral-pureza-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-integral-pureza-1-kg-259281/p'),
		('Harina Pureza 000 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-trigo-000-ultra-refinada-pureza-1kg/_/A-00251877-00251877-200', 'https://www.carrefour.com.ar/harina-de-trigo-000-pureza-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-000-pureza-ultra-refinada-1-kg-166079/p'),
		('Harina Morixe Leudante 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-leudante--morixe-paq-1-kgm/_/A-00480053-00480053-200', 'https://www.carrefour.com.ar/harina-de-trigo-morixe-leudante-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-leudante-morixe-1-kg-258551/p'),
		('Harina Caserita 0000 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-de-trigo-0000-caserita-1kg/_/A-00015287-00015287-200', 'https://www.carrefour.com.ar/harina-de-trigo-0000-caserita-1-kg/p', 'https://diaonline.supermercadosdia.com.ar/harina-0000-caserita-1-kg-54870/p'),
		('Harina Caserita Leudante 1 Kg', 'https://www.cotodigital3.com.ar/sitios/cdigi/producto/-harina-leudante-caserita-1-kgm/_/A-00022251-00022251-200', 'https://www.carrefour.com.ar/harina-leudante-caserita-x-1-kg-131557/p', 'https://diaonline.supermercadosdia.com.ar/harina-leudante-caserita-1-kg-74146/p')
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

CREATE INDEX idx_producto ON precios_productos (producto);

SELECT * FROM precios_productos;
SELECT * FROM productos;


SELECT precio_coto
FROM precios_productos
WHERE producto = 'Azúcar Ledesma 1kg'
ORDER BY fecha DESC
LIMIT 1;

DELETE FROM precios_productos
WHERE fecha = '2024-04-09';





