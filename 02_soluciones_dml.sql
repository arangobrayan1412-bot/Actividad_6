/* ===================================================
   TALLER PRÁCTICO: CONSULTAS DML SQL
   Autor: Brayan Garcia
   Fecha: 25/08/2026
   Motor: PostgreSQL
   =================================================== */

-- ---------------------------------------------------
-- SECCIÓN 1: Filtros Básicos y Ordenación
-- ---------------------------------------------------

-- Ejercicio 1: Consulta general
-- Obtener nombre, email, ciudad y saldo de clientes activos ordenados por nombre.
select nombre, email, ciudad, saldo
from clientes
where activo is true
order by nombre asc;

-- Ejercicio 2: Filtrado por rango
-- Listar productos con precio entre $100.00 y $500.00.
select nombre, precio, stock
from productos
where precio >= 100.00 and precio <= 500.00;

-- Ejercicio 3: Búsqueda por patrones
-- Filtrar clientes con correo @mail.com residentes en Medellín o Bogotá.
select id_cliente, nombre, email, ciudad, telefono, saldo, activo, fecha_registro
from clientes
where ciudad in ('Medellín', 'Bogotá')
  and email like '%@mail.com';

-- Ejercicio 4: Valores nulos y operadores lógicos
-- Clientes sin teléfono registrado.
select nombre, ciudad
from clientes
where telefono is null;

-- Ejercicio 5: Cálculo de columnas derivadas
-- Nombre de producto, precio base, descuento e importe final calculado.
select 
    nombre, 
    precio, 
    descuento_porcentaje,
    round(precio * (1 - (descuento_porcentaje / 100.0)), 2) as precio_con_descuento
from productos;

-- Ejercicio 6: Top y ordenamiento descendente
-- Los 3 productos disponibles con mayor costo.
select *
from productos
where disponible = true
order by precio desc
limit 3;


-- ---------------------------------------------------
-- SECCIÓN 2: Funciones Agregadas y Agrupamientos
-- ---------------------------------------------------

-- Ejercicio 7: Métricas globales
-- Total de catálogo, promedio, mínimo y máximo valor monetario.
select 
    count(id_producto) as total_productos,
    round(avg(precio)::numeric, 2) as precio_promedio,
    min(precio) as precio_minimo,
    max(precio) as precio_maximo
from productos;

-- Ejercicio 8: Conteo agrupado
-- Cantidad de clientes activos por localidad.
select ciudad, count(1) as total_clientes_activos
from clientes
where activo = true
group by ciudad;

-- Ejercicio 9: Suma agrupada
-- Recaudación por estado de orden/pedido.
select estado, sum(total) as total_recaudado
from pedidos
group by estado;

-- Ejercicio 10: Promedio y filtrado de grupos
-- Categorías cuyo precio promedio de artículos supera los $300.00.
select id_categoria, round(avg(precio)::numeric, 2) as precio_promedio
from productos
group by id_categoria
having avg(precio) > 300.00;

-- Ejercicio 11: Conteo con condición agrupada
-- Identificación de clientes con más de una compra realizada.
select id_cliente, count(id_pedido) as total_pedidos
from pedidos
group by id_cliente
having count(id_pedido) > 1;

-- Ejercicio 12: Métricas de inventario
-- Cantidad total de inventario según la categoría.
select id_categoria, sum(stock) as total_stock
from productos
group by id_categoria
order by total_stock desc;


-- ---------------------------------------------------
-- SECCIÓN 3: Actualización e Integridad de Datos (UPDATE)
-- ---------------------------------------------------

-- Ejercicio 13: Actualización simple
-- Asignación de saldo en $100.00 para el cliente id_cliente = 2.
update clientes
set saldo = 100.00
where id_cliente = 2;

-- Ejercicio 14: Actualización con cálculo porcentual
-- Incremento del 10% en el precio de productos de la categoría 1.
update productos
set precio = round(precio * 1.10, 2)
where id_categoria = 1;

-- Ejercicio 15: Actualización condicional múltiple
-- Deshabilitar productos sin existencias en bodega.
update productos
set disponible = false
where stock = 0;

-- Ejercicio 16: Actualización masiva de estado
-- Actualizar estado a 'Entregado' para pedidos etiquetados como 'Enviado'.
update pedidos
set estado = 'Entregado'
where estado = 'Enviado';


-- ---------------------------------------------------
-- SECCIÓN 4: Operaciones DML Restantes (INSERT, DELETE)
-- ---------------------------------------------------

-- Ejercicio 17: Inserción de nuevo registro
-- Registro de nuevo perfil de cliente activo.
insert into clientes (nombre, email, ciudad, telefono, saldo, activo, fecha_registro)
values ('Brayan Garcia', 'brayan.garcia@mail.com', 'Medellín', '3000000000', 250.00, true, current_date);

-- Ejercicio 18: Subconsulta de comparación
-- Productos con precio mayor a la media general del catálogo.
select nombre, precio
from productos
where precio > (select avg(precio) from productos);

-- Ejercicio 19: Eliminación condicional
-- Remover clientes inactivos sin saldo pendiente.
delete from clientes
where activo = false 
  and saldo = 0;

-- Ejercicio 20: Subconsulta con borrado selectivo
-- Depurar pedidos cancelados y su detalle vinculado.
delete from detalle_pedidos
where id_pedido in (
    select id_pedido 
    from pedidos 
    where estado = 'Cancelado'
);

delete from pedidos
where estado = 'Cancelado';