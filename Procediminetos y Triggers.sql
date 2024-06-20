--25
-- Trigger para crear automáticamente un nuevo traslado al insertar una orden
CREATE OR REPLACE TRIGGER CrearTrasladoAlInsertarOrden
BEFORE INSERT ON Ordenes_ITO
FOR EACH ROW
DECLARE
    v_TRA_ID Traslado_ITO.TRA_ID%TYPE;
BEGIN
    -- Insertar un nuevo traslado
    INSERT INTO Traslado_ITO (TRA_DetallesCourier)
    VALUES ('NUEVO')
    RETURNING TRA_ID INTO v_TRA_ID;

    -- Asignar el ID del nuevo traslado a la orden
    :NEW.TRA_ID := v_TRA_ID;
END;
/
--26
-- Trigger para generar una serie interna aleatoria para el traslado
create or replace TRIGGER GenerarSerieInternaParaTraslado
AFTER INSERT ON Ordenes_ITO
FOR EACH ROW
Declare
    v_SerieInterna Varchar2(10);
BEGIN
    -- Generar una serie interna aleatoria
    v_SerieInterna := 'GUA' || LPAD(TRUNC(DBMS_RANDOM.VALUE(10000, 9999999)), 7, '0');
    UPDATE Traslado_ITO
    SET TRA_SerieInterna = v_SerieInterna
    WHERE TRA_ID = :NEW.TRA_ID;
END;

--42
CREATE OR REPLACE TRIGGER GenerarSerieYNumeroFel
BEFORE INSERT ON Salida_ITO
FOR EACH ROW
DECLARE
    v_Serie VARCHAR2(10);
    v_NFel VARCHAR2(10);
BEGIN
    -- Generar SAL_Serie: una combinación de letras mayúsculas y números con un máximo de 10 caracteres
    v_Serie := '';
    FOR i IN 1..10 LOOP
        IF i <= 5 THEN
            v_Serie := v_Serie || CHR(FLOOR(DBMS_RANDOM.VALUE(65, 90))); -- Letras mayúsculas ASCII
        ELSE
            v_Serie := v_Serie || TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(0, 9))); -- Números aleatorios
        END IF;
    END LOOP;

    -- Generar SAL_NFel: una combinación de números con un mínimo de 7 y un máximo de 10 caracteres numéricos
    v_NFel := TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1000000, 9999999999))); -- Números aleatorios entre 7 y 10 dígitos

    -- Asignar los valores generados a las columnas correspondientes
    :NEW.SAL_Serie := v_Serie;
    :NEW.SAL_NFel := v_NFel;
END;
/

--43
CREATE OR REPLACE TRIGGER GenerarSerieYNumeroFelEmtrada
BEFORE INSERT ON Entrada_ITO
FOR EACH ROW
DECLARE
    v_Serie VARCHAR2(10);
    v_NFel VARCHAR2(10);
BEGIN
    -- Generar SAL_Serie: una combinación de letras mayúsculas y números con un máximo de 10 caracteres
    v_Serie := '';
    FOR i IN 1..10 LOOP
        IF i <= 5 THEN
            v_Serie := v_Serie || CHR(FLOOR(DBMS_RANDOM.VALUE(65, 90))); -- Letras mayúsculas ASCII
        ELSE
            v_Serie := v_Serie || TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(0, 9))); -- Números aleatorios
        END IF;
    END LOOP;

    -- Generar SAL_NFel: una combinación de números con un mínimo de 7 y un máximo de 10 caracteres numéricos
    v_NFel := TO_CHAR(FLOOR(DBMS_RANDOM.VALUE(1000000, 9999999999))); -- Números aleatorios entre 7 y 10 dígitos

    -- Asignar los valores generados a las columnas correspondientes
    :NEW.ENT_Serie := v_Serie;
    :NEW.ENT_NFel := v_NFel;
END;
/

--44
CREATE OR REPLACE TRIGGER restar_stock_despues_salida
AFTER INSERT ON Salida_ITO
FOR EACH ROW
DECLARE
    v_stock_actual NUMBER;
BEGIN
    -- Obtener el stock actual del producto
    SELECT PRO_Cantidad INTO v_stock_actual
    FROM Producto_ITO
    WHERE PRO_ID = :NEW.PRO_ID;

    -- Restar la cantidad de productos salidos al stock actual
    UPDATE Producto_ITO
    SET PRO_Cantidad = v_stock_actual - :NEW.SAL_Cantidad
    WHERE PRO_ID = :NEW.PRO_ID;
END;

--45
CREATE OR REPLACE TRIGGER trg_procesar_entrada
BEFORE INSERT ON Entrada_ITO
FOR EACH ROW
DECLARE
    v_cantidad_actual Producto_ITO.PRO_Cantidad%TYPE;
    v_valor Producto_ITO.PRO_Valor%TYPE;
BEGIN
    -- Obtener la cantidad actual de productos y el valor del producto
    SELECT PRO_Cantidad, PRO_Valor
    INTO v_cantidad_actual, v_valor
    FROM Producto_ITO
    WHERE PRO_ID = :NEW.PRO_ID;

    -- Si el valor del producto está definido, no se aplica el aumento del precio de salida
    IF v_valor IS NULL THEN
        -- Aplicar un aumento del 5% al precio de salida de la entrada
        :NEW.ENT_PrecioSalida := :NEW.ENT_PrecioSalida * 1.05;
    ELSE
        -- Si el valor del producto está definido, se ignora el precio de salida de la entrada
        :NEW.ENT_PrecioSalida := NULL;
    END IF;

    -- Actualizar la cantidad de productos en la tabla Producto_ITO
    :NEW.ENT_PrecioSalida := v_valor * 1.05;
    
     -- Actualizar la cantidad de productos en la tabla Producto_ITO
    UPDATE Producto_ITO
    SET PRO_Cantidad = v_cantidad_actual + :NEW.ENT_Cantidad
    WHERE PRO_ID = :NEW.PRO_ID;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el producto especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al procesar la entrada: ' || SQLERRM);
END;
/

--46
CREATE OR REPLACE TRIGGER trg_requisicion_restar
AFTER INSERT ON Requisicion_ITO
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad de productos en la tabla Producto_ITO
    UPDATE Producto_ITO
    SET PRO_Cantidad = PRO_Cantidad - :NEW.REQ_Cantidad
    WHERE PRO_ID = :NEW.PRO_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el producto especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al procesar la requisición: ' || SQLERRM);
END;
/


--47
CREATE OR REPLACE TRIGGER trg_requisicion_sumar
AFTER INSERT ON Requisicion_ITO
FOR EACH ROW
BEGIN
    -- Actualizar la cantidad de productos en la tabla Producto_ITO
    UPDATE Producto_ITO
    SET PRO_Cantidad = PRO_Cantidad + :NEW.REQ_Cantidad
    WHERE OFI_ID = :NEW.OFI_ID;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró el producto especificado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al procesar la requisición: ' || SQLERRM);
END;
/


