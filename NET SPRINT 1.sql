use transactions;
    -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );
    
    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15) REFERENCES credit_card(id),
        company_id VARCHAR(20), 
        user_id INT REFERENCES user(id),
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id));
        USE transactions;
        
-- 2.1Llistat dels països que estan generant vendes.
SELECT DISTINCT company.country
FROM company
JOIN transaction ON company.id=transaction.company_id
WHERE transaction.declined=0 
and transaction.amount >=0 
and company_name IS NOT NULL;


-- 	2.2Des de quants països es generen les vendes.
SELECT COUNT(DISTINCT company.country ) as num_paisos_vendedors
FROM company
JOIN transaction ON company.id=transaction.company_id
WHERE transaction.declined=0 
and transaction.amount >=0 
and company_name IS NOT NULL;

-- o	2.3Identifica la companyia amb la mitjana més gran de vendes.
SELECT company.company_name
FROM company
JOIN transaction ON company.id = transaction.company_id
WHERE transaction.declined = 0 
  AND transaction.amount >= 0 
GROUP BY company.company_name
ORDER BY AVG(transaction.amount) DESC
LIMIT 1;

-- 	Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT*
FROM transaction
WHERE amount>=0 
     and declined=0 
     and company_id in(
				SELECT id
			    FROM company
				WHERE country="Germany");


-- o	Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE declined =0
    GROUP BY company_id
    HAVING AVG(amount)>(
        SELECT AVG(amount)
        FROM transaction));
-- o	Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE NOT EXISTS (
SELECT company_id
FROM transaction);
-- Exercici 4Exercici 4
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
--  La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules 
-- ("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del 
-- document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest
DROP TABLE credit_card;
CREATE TABLE credit_card (
    id VARCHAR(15) PRIMARY KEY,
    company_id VARCHAR(50),
    iban VARCHAR(40),
    pan VARCHAR(40),
    pin VARCHAR(40),
    cvv VARCHAR(40),
    expiring_date VARCHAR(50),
    FOREIGN KEY (company_id) REFERENCES company(id)
);
UPDATE credit_card
JOIN transaction ON credit_card.id = transaction.credit_card_id
SET credit_card.company_id = transaction.company_id;


-- Exercici 5
-- El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938.
--  La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
UPDATE credit_card
SET 
    iban="TR323456312213576817699999"
WHERE id="CcU-2938";
SELECT iban,id FROM credit_card
WHERE id="CcU-2938";

-- Exercici 6
-- En la taula "transaction" ingressa una nova transacció amb la següent informació:
INSERT INTO company(id)
values ("b-9999");
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES("108B1D1D-5823-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", 9999, 829.999, -117.999, 111.11, 0);
SELECT*
FROM transaction
WHERE id="108B1D1D-5823-A76C-55EF-C568E49A99DD";

-- Exercici 7
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.
ALTER TABLE credit_card
DROP COLUMN pan;
SELECT*
FROM credit_card;

-- Descarrega els arxius CSV que trobaràs a l'apartat de recursos:
-- american_users.csv
-- european_users.csv
-- companies.csv
-- credit_cards.csv
-- transactions.csv
-- Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:
-- La taula de products.csv l'utilitzarem més endavant.

USE ejercicio_8;

DROP TABLE transactions;
CREATE TABLE transactions(
	id VARCHAR(250),
	card_id VARCHAR (20),
	business_id VARCHAR(250),
	timestamp VARCHAR(50),
	amount FLOAT,
	declined TINYINT,	
    product_ids VARCHAR(200),	
    user_id VARCHAR(255),	
    lat FLOAT,	
    longitude FLOAT,	
    discount_amount FLOAT,	
    tax_amount FLOAT,	
    shipping_amount FLOAT,	
    channel VARCHAR(30),	
    campaign_id VARCHAR(30),	
    device_type VARCHAR (50),	
    is_international TINYINT,
    decline_reason VARCHAR (50),	
    distance_km FLOAT,
	FOREIGN KEY (business_id) REFERENCES companies(company_id),
    FOREIGN KEY (user_id)REFERENCES users_id(user_id),
    FOREIGN KEY (product_ids) REFERENCES products(id));
    ALTER TABLE transactions ADD COLUMN dia DATE;
    ALTER TABLE transactions ADD COLUMN hora TIME;
    UPDATE transactions
    SET
    dia = LEFT(timestamp, 10),
    hora = RIGHT(timestamp, 8);
    SET SQL_SAFE_UPDATES = 0;
SET GLOBAL local_infile = 1;
SET FOREIGN_KEY_CHECKS = 0;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__transactions.csv'
INTO TABLE transactions
FIELDS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES
(id, card_id, business_id, timestamp, amount, declined, product_ids, user_id, lat, longitude, discount_amount, tax_amount, shipping_amount, channel, campaign_id, device_type, is_international, decline_reason, distance_km);



DROP TABLE products;
CREATE TABLE products(
id VARCHAR(200) PRIMARY KEY,
product_name VARCHAR (50),
price VARCHAR(10),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR (50),
category  VARCHAR(50),
brand VARCHAR(50),
cost VARCHAR(50),
launch_date VARCHAR(50));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;



DROP TABLE american_users;
CREATE TABLE american_users(
id VARCHAR (255),
name VARCHAR (255),
surname VARCHAR (50),
phone VARCHAR(50),
email VARCHAR (50),
birth_date VARCHAR(50),
country VARCHAR (50),
city VARCHAR(50),
postal_code VARCHAR(50),
address VARCHAR (100),
signup_date VARCHAR(50),
user_segment VARCHAR (50),
income_band VARCHAR(50),
FOREIGN KEY (id) REFERENCES users_id(user_id));

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE american_users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;



DROP TABLE europe_users;
CREATE TABLE europe_users(
id VARCHAR (255) PRIMARY KEY,
name VARCHAR(50),
surname VARCHAR(50),
phone VARCHAR(50),
email VARCHAR(50),
birth_date VARCHAR(50),
country VARCHAR(50),
city VARCHAR(50),
postal_code VARCHAR(50),
address VARCHAR(50),
signup_date VARCHAR(50),
user_segment VARCHAR(50),
income_band VARCHAR(50));
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv"
INTO TABLE europe_users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;





DROP TABLE companies;
CREATE TABLE companies(
company_id VARCHAR (250) PRIMARY KEY,
company_name VARCHAR (50),
phone VARCHAR (50),
email VARCHAR (50),
country VARCHAR (50),
website VARCHAR (255),
merchant_category VARCHAR (50),
merchant_price_position VARCHAR (50));

LOAD DATA INFILE"C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__companies.csv"
INTO TABLE companies
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
DROP TABLE users_id;
CREATE table users_id(
user_id varchar(255)PRIMARY KEY);
INSERT INTO users_id (user_id)
SELECT id 
FROM american_users;
INSERT INTO users_id (user_id)
SELECT id
FROM europe_users;
select* from users_id;


CREATE TABLE total_users(
id VARCHAR (255) PRIMARY KEY,
name VARCHAR (255),
surname VARCHAR (50),
phone VARCHAR(50),
email VARCHAR (50),
birth_date VARCHAR(50),
country VARCHAR (50),
city VARCHAR(50),
postal_code VARCHAR(50),
address VARCHAR (100),
signup_date VARCHAR(50),
user_segment VARCHAR (50),
income_band VARCHAR(50));
-- europe dates
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__european_users.csv"
INTO TABLE total_users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
-- american dates
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/N1-Ex.8__american_users.csv'
INTO TABLE total_users
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;
-- Exercici 9
-- Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.

SELECT total_users.id,total_users.name,total_users.surname
FROM transactions
JOIN total_users ON transactions.user_id=total_users.id
GROUP BY total_users.id
HAVING COUNT(transactions.id) >80;
-- Exercici 10
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT transactions.card_id, ROUND(AVG(transactions.amount),2) as media_amount
FROM transactions
JOIN companies ON transactions.business_id=companies.company_id
WHERE companies.company_name="Donec Ltd" and
		transactions.declined=0
GROUP BY transactions.card_id;

-- -- EXERCICI 1 nivell 2
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.


SELECT timestamp,
DATE(timestamp) AS dia,
TIME(timestamp) AS hora
FROM transactions;

ALTER TABLE transactions 
ADD COLUMN dia DATE,
ADD COLUMN hora TIME;

UPDATE transactions 
SET 
dia = DATE(timestamp),
hora = TIME(timestamp);

SELECT dia, ROUND(SUM(amount),2)
FROM transactions
GROUP BY dia
ORDER BY SUM(amount) DESC
LIMIT 5;
-- Exercici 2
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions 
-- amb un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates:
-- 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.


SELECT companies.company_name, companies.phone, companies.country,transactions.amount,transactions.dia
FROM transactions
JOIN companies ON transactions.business_id=companies.company_id
WHERE transactions.declined=0 and 
transactions.amount>350 and 
transactions.amount<400 and 
transactions.dia in("2015-04-29","2018-06-20","2024-03-13")
ORDER BY transactions.amount DESC;
-- Exercici 3
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.


ALTER TABLE companies 
ADD COLUMN te_mes_de_400_transaccions VARCHAR(10);
SELECT companies.company_id, companies.company_name,COUNT(transactions.id) AS total_transactions,
CASE 
	WHEN COUNT(transactions.id) > 400 THEN 'si'
	WHEN COUNT(transactions.id) =400 THEN 'igual'
	ELSE 'no' 
    END AS te_mes_de_400_transaccions
FROM transactions
JOIN companies ON transactions.business_id = companies.company_id
GROUP BY companies.company_name, companies.company_id;


-- Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE
FROM transactions
WHERE id='000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';


CREATE VIEW VistaMarketing AS
SELECT companies.company_name,companies.phone,companies.country,ROUND(AVG(transactions.amount),2)as media_amount, COUNT(transactions.id) as total_transactions
FROM companies
JOIN transactions ON companies.company_id=transactions.business_id
GROUP BY  companies.company_name,companies.phone,companies.country
ORDER BY media_amount DESC;
select*
from VistaMarketing;
-- Exercici 5
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
-- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
-- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
-- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
-- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
CREATE VIEW VistaMarketing AS
SELECT companies.company_name,companies.phone,companies.country,ROUND(AVG(transactions.amount),2)as media_amount
FROM companies
JOIN transactions ON companies.company_id=transactions.business_id
WHERE transactions.declined=0 and transactions.amount >=0
GROUP BY  companies.company_name,companies.phone,companies.country
ORDER BY media_amount DESC;
select*
from VistaMarketing;

-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:

-- 👉 Quantes targetes estan actives?