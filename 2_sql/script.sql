/* CREACION DE LA BASE DE DATOS*/

drop database if exists telecom;

create database telecom;

use telecom;

/* SE IMPORTARON LOS REGISTROS, VERIFICAMOS */

select * from customers_info limit 20;

select count(*) customer_id from customers_info;

select count(distinct customer_id) from customers_info;

/* PROCEDIMIENTO ALMACENADO PARA EL SELECT */

DELIMITER //

CREATE PROCEDURE info()
begin
select * from customers_info;
end //

DELIMITER ;

call info();

/* MODIFICANDO TABLA Y NOMBRES DE COLUMNAS */

describe customers_info;

alter table customers_info change column customerID customer_id varchar(75) not null primary key;

alter table customers_info change column gender gender varchar (15);

alter table customers_info change column SeniorCitizen senior_citizen varchar(15);

alter table customers_info change column Partner partner varchar(10);

alter table customers_info change column Dependents dependents varchar(10);

alter table customers_info change column tenure account_age int;

ALTER TABLE customers_info
CHANGE COLUMN PhoneService phone_service VARCHAR(50),
CHANGE COLUMN MultipleLines multiple_lines VARCHAR(50),
CHANGE COLUMN InternetService internet_service VARCHAR(50),
CHANGE COLUMN OnlineSecurity online_security VARCHAR(50),
CHANGE COLUMN OnlineBackup online_backup VARCHAR(50),
CHANGE COLUMN DeviceProtection device_protection VARCHAR(50),
CHANGE COLUMN TechSupport tech_support VARCHAR(50),
CHANGE COLUMN StreamingTV streaming_tv VARCHAR(50),
CHANGE COLUMN StreamingMovies streaming_movies VARCHAR(50),
CHANGE COLUMN Contract contract VARCHAR(50),
CHANGE COLUMN PaperlessBilling paperless_billing VARCHAR(15),
CHANGE COLUMN PaymentMethod payment_method VARCHAR(100),
CHANGE COLUMN MonthlyCharges monthly_charges DECIMAL(10,2),
CHANGE COLUMN TotalCharges total_charges DECIMAL(10,2),
CHANGE COLUMN Churn subscription_status VARCHAR(15);

call info();

/* IDENTIFICANDO DUPLICADOS */


/* Se valida que no hay duplicados */
SELECT customer_id, count(*) as cantidad_duplicados
from customers_info
group by customer_id
having count(*) >1;

call info();

/* Validamos espacios innecesarios en columnas criticas */

select count(*) as con_espacios
from customers_info
where customer_id != trim(customer_id);

select count(*) as con_espacios
from customers_info
where gender != trim(gender);

select count(*) as con_espacios
from customers_info
where internet_Service != trim(internet_service);

select count(*) as con_espacios
from customers_info
where contract != trim(contract);

select count(*) as con_espacios
from customers_info
where payment_method != trim(payment_method);

call info();

/* Reemplazando 0 y 1 por texto */

select senior_citizen,
case 
when senior_citizen = 0 then "No"
when senior_citizen = 1 then "Yes"
else "Other"
end
from customers_info;

SET SQL_SAFE_UPDATES = 0;

update customers_info set senior_citizen = case 
when senior_citizen = 0 then "No"
when senior_citizen = 1 then "Yes"
else "Other"
end;

call info(); 

/* PREGUNTAS DE NEGOCIO */

/* Clientes por genero */

select gender, count(*) as total
from customers_info
group by gender;

/* Clientes con linea telefonica */

call info();

select count(*) as with_phone_service 
from customers_info
where phone_service = "Yes";

/* Porcentaje de clientes que usan techsupport */

SELECT 
  COUNT(*) AS total_con_support,
  ROUND(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_info),
    2
  ) AS porcentaje_support
FROM customers_info
WHERE tech_support = "Yes";

/* Tipo de contrato con mas usuarios */

call info(); 

select contract, count(*) as total
from customers_info
group by contract
order by total desc;

/* Clientes que han abandonado y porcentaje */

SELECT 
  COUNT(*) AS total_abandonos,
  ROUND(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_info),
    2
  ) AS porcentaje_abandonos
FROM customers_info
WHERE subscription_status = "No";

call info();

/* Total, ingreso estimado al mes y promedio mensual por tipo de contrato */

SELECT 
  contract,
  COUNT(*) AS clientes,
  SUM(monthly_charges) AS ingreso_mensual_estimado,
  SUM(total_charges) AS ingreso_total,
  AVG(monthly_charges) AS promedio_mensual
FROM customers_info
GROUP BY contract
ORDER BY ingreso_total DESC;

/* Metodo de pago mas usado */

call info();

select payment_method, count(*) as total
from customers_info
group by payment_method
order by total desc;

/* Analisis de usuarios, serviciow y operacion */
 
/* Total de usuarios activos */

select count(*) as clientes_activos
from customers_info
where subscription_status = "Yes";

/* Porcentaje de abandono */

SELECT 
  COUNT(*) AS clientes_abandono,
  ROUND(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_info),
    2
  ) AS porcentaje_abandono
FROM customers_info
WHERE subscription_status = 'No';

/* Total de clientes por tipo de contrato */

select contract, count(*) as total
from customers_info 
group by contract
order by total desc;

/* Abandono de clientes por tipo de contrato */

SELECT 
  contract,
  COUNT(*) AS total_clientes,
  SUM(CASE WHEN subscription_status = 'No' THEN 1 ELSE 0 END) AS abandonos,
  ROUND(
    SUM(CASE WHEN subscription_status = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS porcentaje_abandono
FROM customers_info
GROUP BY contract
ORDER BY porcentaje_abandono DESC;

/* Abandono vs tech support */

SELECT 
  tech_support,
  COUNT(*) AS total,
  SUM(CASE WHEN subscription_status = 'No' THEN 1 ELSE 0 END) AS abandonos,
  ROUND(
    SUM(CASE WHEN subscription_status = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS churn_rate
FROM customers_info
GROUP BY tech_support;

call info();

