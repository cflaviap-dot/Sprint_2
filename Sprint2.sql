Select count(*) from company;
-- 100 registros
Select count(*) from transaction;
-- 100000

select * from transaction where id ='3EFB1984-E1FC-4F43-8A9C-4E89ACD86605';

/*
Ejercicio 2
Utilizando JOIN realizarás las siguientes consultas:

Listado de los países que están generando ventas.*/

SELECT DISTINCT country FROM company
	INNER JOIN transaction
	ON transaction.company_id = company.id 
	ORDER BY country;

SELECT COUNT(DISTINCT country) cant_paises FROM company
	INNER JOIN transaction
	ON transaction.company_id = company.id 
	ORDER BY country ;
 
SELECT company.company_name,company_id, AVG(amount) media FROM transaction
	INNER JOIN company
	ON company.id = transaction.company_id
	GROUP BY company_id
	ORDER BY media desc
	LIMIT 1;
-- si hay dos con la misma media solo mostrare uno . temdria que hacer sunconsulta para mostrar los empates


/* Ejercicio 3
Utilizando sólo subconsultas (sin utilizar JOIN):*/

-- Muestra todas las transacciones realizadas por empresas de Alemania.
SELECT * FROM transaction
WHERE company_id IN  (
	SELECT id FROM company
	WHERE country='Germany') ;


-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.
SELECT company_id,AVG(amount) as media_t  
FROM transaction
GROUP BY company_id
HAVING media_t >
	(SELECT AVG(amount) as media FROM transaction);

-- Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.
/* SELECT * FROM company
WHERE ID NOT IN ( 
		SELECT company_id FROM transaction);*/
        
SELECT * FROM company 
WHERE NOT EXISTS (
    SELECT * FROM transaction 
    WHERE transaction.company_id = company.id);


/*Ejercicio 4
Tu tarea es diseñar y crear una tabla llamada "credit_card" que almacene detalles cruciales sobre 
las tarjetas de crédito. La nueva tabla debe ser capaz de identificar de forma única cada tarjeta 
y establecer una relación adecuada con las otras dos tablas ("transaction" y "company"). 
Después de crear la tabla será necesario que ingreses la información del documento denominado 
"datos_introducir_credit". Recuerda mostrar el diagrama y realizar una breve descripción del mismo.*/

    -- Creamos la tabla credit_card
DROP TABLE IF EXISTS credit_card;
    
CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(15) PRIMARY KEY,
        iban VARCHAR(34), 
        pan VARCHAR(19),
        pin VARCHAR(4), 
        cvv VARCHAR(3),
        expiring_date VARCHAR(10)
    );

-- AGREGO LOS DATOS
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

/*Ejercicio 5
El departamento de Recursos Humanos ha identificado un error en el número de cuenta asociado a su tarjeta 
de crédito con ID CcU-2938. La información que debe mostrarse para este registro es: TR323456312213576817699999.
 Recuerda mostrar que el cambio se realizó.*/
 
 SELECT * FROM credit_card
 WHERE id='CcU-2938';
 
 UPDATE credit_card 
 SET iban='TR323456312213576817699999'
 WHERE id='CcU-2938';
 
 select * from credit_card
 where iban='TR323456312213576817699999';
 
 /*Ejercicio 6
ingresa un nuevo registro en la tabla transacción
Id 
108B1D1D-5B23-A76C-55EF-C568E49A99DD 
credit_card_id 
CcU-9999 
company_id 
b-9999 
user_id 
9999 
lat 
829.999 
longitude 
-117.999 
amount 
111.11 
declined 
0
.*/

SELECT * FROM company WHERE ID = 'b-9999';
-- no existe 
SELECT * FROM credit_card WHERE id = 'CcU-9999';
-- no existe 'CcU-9999' 

-- no se puede hacer el insert proque fallan las claves foráneas. 
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999 ', 'b-9999', '9999', '829.999', '-117.999', current_timestamp(), '111.11', '0');

 /*Ejercicio 7
Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.*/

ALTER TABLE credit_card
DROP COLUMN pan; 

describe credit_card;

 /*Ejercicio 8
Crear una nueva base de.*/


CREATE DATABASE IF NOT EXISTS transaction2;
USE transaction2;

-- es para no de error la importacion de los csv
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'local_infile';
-- 

-- Creamos la tabla company
CREATE TABLE IF NOT EXISTS company (
        company_id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(25),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255),
        merchant_category VARCHAR(20),
        merchant_price_position VARCHAR(20)
);


-- LOAD DATA LOCAL INFILE '/Volumes/NO NAME/N1-Ex.8__companies.csv'
LOAD DATA LOCAL INFILE 'C:/TEMP/N1-Ex.8__companies.csv'
INTO TABLE company
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Omite l

SELECT * FROM company;


-- Creamos la tabla usuarios
CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY,
        name VARCHAR(50),
        surname VARCHAR(50),
        phone VARCHAR(15),
        email VARCHAR(100),
        birth_date VARCHAR(12),
        country VARCHAR(100),
        city VARCHAR(100),
        postal_code  VARCHAR(20),
        address VARCHAR(255),
        signup_date   VARCHAR(10),
        user_segment  VARCHAR(30),
        income_band VARCHAR(10),
		origen VARCHAR(10) 
);
-- origen VARCHAR(10) ES EL CAMPO QUE IDENTIFICA SI ES USA O EUROPA


CREATE TABLE IF NOT EXISTS credit_card (
        id VARCHAR(15) PRIMARY KEY,
        user_id VARCHAR(15),
        iban VARCHAR(34), 
        pan VARCHAR(19),
        pin VARCHAR(4), 
        cvv VARCHAR(3),
        track1 VARCHAR(60),
        track2 VARCHAR(60),
        expiring_date VARCHAR(10),
        card_type VARCHAR(15),
        card_renewal_flag BOOLEAN
);

LOAD DATA LOCAL INFILE 'C:/TEMP/N1-Ex.8__credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Omite l

-- comprobamos
-- select * from credit_card;
-- drop table transactio;
-- Creamos la tabla transaction
CREATE TABLE IF NOT EXISTS transactio (
        id VARCHAR(255) PRIMARY KEY,
        card_id VARCHAR(15),
        business_id VARCHAR(20), 
        timestamp TIMESTAMP,
		amount DECIMAL(10, 2),
		declined BOOLEAN,
        product_ids VARCHAR(255),
        user_id INT,
        lat FLOAT,
        longitude FLOAT,
        discount_amount FLOAT,
        tax_amount FLOAT,
        shipping_amount FLOAT,
        channel VARCHAR(20),
        campaign_id VARCHAR(20),
        device_type  VARCHAR(20),
        is_international BOOLEAN,
        decline_reason  VARCHAR(50),
        distance_km FLOAT,
        FOREIGN KEY (business_id) REFERENCES company(company_id), 
		FOREIGN KEY (user_id) REFERENCES users(id),
		FOREIGN KEY (card_id) REFERENCES credit_card(id)
);


LOAD DATA LOCAL INFILE 'C:/TEMP/N1-Ex.8__american_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    name,
    surname,
    phone,
    email,
    birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band
)
SET origen = 'USA';

LOAD DATA LOCAL INFILE 'C:/TEMP/N1-Ex.8__european_users.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    name,
    surname,
    phone,
    email,
    birth_date,
    country,
    city,
    postal_code,
    address,
    signup_date,
    user_segment,
    income_band
)
SET origen = 'EUROPA';

SELECT * FROM users;


-- LOAD DATA LOCAL INFILE '/Volumes/NO NAME/N1-Ex.8__transactions.csv'
LOAD DATA LOCAL INFILE 'C:/temp/N1-Ex.8__transactions.csv'
INTO TABLE transactio
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Omite l

select * from transactio;



-- Ejercicio 9
-- Realiza una subconsulta que muestre a todos los usuarios con más de 80 transacciones utilizando al menos 2 tablas.--

SELECT user_id,users.name as nombre ,count(*) as cantidad
FROM transactio
LEFT JOIN users
ON users.id = transactio.user_id
GROUP BY user_id
HAVING cantidad > 80
ORDER BY cantidad DESC;



-- Ejercicio 10
-- Muestra la media de amount por IBAN de las tarjetas de crédito en la compañía Donec Ltd., utiliza por lo menos 2 tablas.
SELECT credit_card.iban,AVG(transactio.amount) AS MEDIA FROM transactio
LEFT JOIN company
ON transactio.business_id = company.company_id
LEFT JOIN credit_card
ON transactio.card_id= credit_card.id
WHERE company.company_name= 'Donec Ltd'
GROUP BY credit_card.iban;




 /*Nivel 2
Ejercicio 1
Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
Muestra la fecha de cada transacción junto con el total de las ventas.*/

/* tendriamos que descartar las que TRANSACCIONES que se rechazaron
porque estamos hablando de ingresos y no ingresaron esas cantidades */

SELECT DATE(transactio.timestamp) AS fecha, sum(amount) as ventas 
FROM transactio
WHERE declined=0
GROUP BY FECHA
ORDER BY VENTAS DESC
LIMIT 5;


 /*Ejercicio 2
Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido 
entre 350 y 400 euros y en alguna de estas fechas: 29 de abril de 2015, 20 de julio de 2018 y 13 de marzo de 2024.
 Ordena los resultados de mayor a menor cantidad. */


SELECT company.company_name,company.phone,company.country,DATE(transactio.timestamp) AS fecha,amount
FROM transactio
LEFT JOIN company
ON transactio.business_id=company.company_id
WHERE DATE(transactio.timestamp) in (date('2015-04-29'),date('2018-07-20'),date('2024-03-13'))
AND amount BETWEEN 350 AND 400
ORDER BY amount DESC;






 /*Ejercicio 3
Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera,
 por lo que te piden la información sobre la cantidad de transacciones que realizan las empresas, pero el departamento de
 recursos humanos es exigente y quiere un listado de las empresas en las que especifiques si tienen igual o más de 400 transacciones o menos.*/


SELECT company.company_id,company.company_name, 
	if(cant_transac.cantidad >= 400, '400 o más','Menos de 400')  AS Transacciones 
    FROM  company
LEFT JOIN 
		(SELECT business_id, COUNT(*) AS cantidad
			FROM transactio
			GROUP BY business_id) AS cant_transac
ON company.company_id=cant_transac.business_id   ;   


 /*Ejercicio 4
Elimina de la tabla transacción el registro con ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de datos.*/
-- para comprobarar antes y despues
SELECT * FROM  transactio 
WHERE  id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transactio
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

 /*Ejercicio 5
La sección de marketing desea tener acceso a información específica para realizar análisis y estrategias efectivas.
 Se ha solicitado crear una vista que proporcione detalles clave sobre las compañías y sus transacciones. 
 Será necesaria que crees una vista llamada VistaMarketing que contenga la siguiente información: Nombre de la compañía.
 Teléfono de contacto. País de residencia. Media de compra realizado por cada compañía. Presenta la vista creada, ordenando 
 los datos de mayor a menor promedio de compra.*/

CREATE VIEW VistaMarketing AS
	SELECT company.company_name,company.phone,company.country,ROUND(AVG(transactio.amount),2) as Media_compra
	FROM  company
	LEFT JOIN transactio
	ON company.company_id=transactio.business_id
	GROUP BY 1,2,3;

SELECT * FROM VistaMarketing
ORDER BY Media_compra DESC;



/*Nivel 3

Ejercicio 1
Crea una nueva tabla que refleje el estado de las tarjetas de crédito basado en si las tres últimas transacciones 
han sido declinadas entonces es inactivo, si por lo menos una no es rechazada entonces es activo.
 Partiendo de esta tabla responde:
👉 ¿Cuántas tarjetas están activas?
*/

SELECT SUM(if(Estado='Activo',1,0)) AS activas, SUM(if(Estado='Activo',0,1)) AS inactivas
FROM (
		SELECT credit_card.id as tarjeta,
		CASE 
		WHEN 
			(SELECT sum(declined) from (
					SELECT declined FROM transactio
					WHERE card_id = credit_card.id
					ORDER BY timestamp DESC
					LIMIT 3) as ultima3 
                    ) = 3
		THEN 'Inactivo'
		ELSE 'Activo'
		END AS Estado
		FROM CREDIT_CARD) AS TARJETAS;



/*Ejercicio 2
Crea una tabla con la que podamos unir los datos del archivo de products.csv con la base de datos creada
 (ya que hasta ahora no podíamos hacerlo), teniendo en cuenta que desde transaction tienes product_ids. 
 Genera la siguiente consulta:
👉 Necesitamos conocer el número de veces que se ha vendido cada producto.*/

-- BASE DE DATOS
USE transaction2;

CREATE TABLE IF NOT EXISTS products (
        id INT PRIMARY KEY,
        product_name VARCHAR(255),
		price DECIMAL(10, 2),
        colour VARCHAR(20), 
        weight DECIMAL(10, 1),
        warehouse_id VARCHAR(5),
        category VARCHAR(20),
        brand VARCHAR(20),
        cost  DECIMAL(10, 2),
        launch_date VARCHAR(10));

LOAD DATA LOCAL INFILE 'C:/temp/N1-Ex.8__products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, product_name, @price, colour, weight, warehouse_id, category, brand, @cost, launch_date)
SET
  price = CAST(REPLACE(TRIM(@price), '$', '') AS DECIMAL(10, 2)),
  cost  = CAST(REPLACE(TRIM(@cost), '$', '') AS DECIMAL(10, 2));
  
/* el precio y el costo en el csv viene con el caracter $ por eso lo cargamos en dos como variables y despues reemplazamos*/
/* opcion sin grabar la tabla intermedia */

SELECT jt.prod_id,products.product_name,count(*) as VENTAS
 FROM transactio,
 JSON_TABLE (CONCAT('[', TRIM(transactio.product_ids), ']'),
    '$[*]' COLUMNS (
        prod_id INT PATH '$'
    )
) AS jt 
LEFT JOIN products
ON products.ID=jt.prod_id
WHERE transactio.product_ids IS NOT NULL 
  AND TRIM(transactio.product_ids) != ''
GROUP BY 1
ORDER BY 1;

-- OPCION 2 CON TABLA INTERMEDIA 
-- tabla intermedia para relacionar productos con transacciones

CREATE TABLE IF NOT EXISTS produtran (
        produc_id INT,
        transac_id varchar(255),
		FOREIGN KEY (produc_id) REFERENCES products(id), 
		FOREIGN KEY (transac_id) REFERENCES transactio(id));
        
        
INSERT INTO produtran (produc_id, transac_id)
SELECT distinct jt.prod_id,transactio.id from transactio,
	JSON_TABLE (CONCAT('[', TRIM(transactio.product_ids), ']'),
		'$[*]' COLUMNS (
			prod_id INT PATH '$')) AS jt 
WHERE transactio.product_ids IS NOT NULL 
AND TRIM(transactio.product_ids) != '';

SELECT produc_id,products.product_name,count(*) as ventas
FROM produtran
LEFT JOIN products
ON products.ID = produtran.produc_id
GROUP BY 1,2
ORDER BY 1,2
