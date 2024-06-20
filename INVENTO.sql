/*Nueva Nomenclatura para toda tabla sera ITO
ahora habrán más comentarios para que puedan correr todo mejor
Antes de Ejecutar todo hacer lo siguiente
1.	Abrir SQL Plus
2.	CONN /AS SYSDBA LUEGO ENTER Y OTRA VEZ ENTER
3.	Alter Session Set "_ORACLE_SCRIPT" = TRUE;
4.	CREATE USER Admin_INV identified by 1234;
5.	GRANT DBA TO Admin_INV;
*/
--1
Create Table Usuarios_ITO(
    USU_ID Number(3),
    USU_Usuario Varchar(BYTE 64),
    USU_COntraseña Varchar(BYTE 64),
    Constraint PK_USU_ID Primary Key (USU_ID)
);

--2
CREATE SEQUENCE seq_usu_id START WITH 1 INCREMENT BY 1;

--3
ALTER TABLE Usuarios_ITO
MODIFY (USU_ID DEFAULT seq_usu_id.nextval);

--4
CREATE TABLE Empleados_ITO (
    EMP_ID Number(3),
    EMP_PrimerNombre VARCHAR2(10),
    EMP_SegundoNombre Varchar2(10),
    EMP_PrimerApellido Varchar2(10),
    EMP_SegundoApellido Varchar2(10),
    EMP_Puesto varchar2(15),
    USU_ID Number(3),
    Constraint PK_EMP_ID Primary Key (EMP_ID),
    CONSTRAINT fk_usu_id FOREIGN KEY (USU_ID) REFERENCES Usuarios_ITO(USU_ID)
);

--5
CREATE SEQUENCE seq_emp_id START WITH 1 INCREMENT BY 1;

--6
ALTER TABLE Empleados_ITO
MODIFY (EMP_ID DEFAULT seq_emp_id.nextval);

--7
CREATE TABLE Oficinas_ITO (
    OFI_ID Number(3),
    OFI_Nombre VARCHAR2(20),
    OFI_Numero Varchar2(3),
    OFI_Calle Number(3),
    OFI_Avenida Varchar2(15),
    OFI_Zona Varchar2(15),
    OFI_Municipio Varchar2(15),
    OFI_Departamento Varchar2(15),
    Constraint PK_OFI_ID Primary Key (OFI_ID)
);
--8
CREATE SEQUENCE seq_ofi_id START WITH 1 INCREMENT BY 1;

--9
ALTER TABLE Oficinas_ITO
MODIFY (OFI_ID DEFAULT seq_ofi_id.nextval);

--10
CREATE TABLE Producto_ITO (
    PRO_ID Number(3) Null,
    PRO_Nombre VARCHAR2(20),
    PRO_UnidadDeMedida Number(2),
    PRO_Descripcion Varchar2(30),
    PRO_Cantidad Number(5),
    PRO_Valor Number(5),
    OFI_ID Number(3),
    Constraint PK_PRO_ID Primary Key (PRO_ID),
    Constraint FK_OFI_ID FOREIGN Key (OFI_ID) References Oficinas_ITO(OFI_ID)
);
--11
CREATE SEQUENCE seq_pro_id START WITH 1 INCREMENT BY 1;
--12
ALTER TABLE Producto_ITO
MODIFY (PRO_ID DEFAULT seq_pro_id.nextval);

--13
CREATE TABLE Requisicion_ITO (
    REQ_ID Number(3),
    REQ_Fecha Date,
    PRO_ID Number(3),
    REQ_Cantidad Number(2),
    EMP_ID Number(3),
    OFI_ID Number(3),
    Constraint PK_REQ_ID Primary Key (REQ_ID),
    Constraint FK_OFIR_ID FOREIGN Key (OFI_ID) References Oficinas_ITO(OFI_ID),
    Constraint FK_EMPR_ID FOREIGN Key (EMP_ID) References Empleados_ITO(EMP_ID),
    Constraint FK_PROR_ID FOREIGN Key (PRO_ID) References Producto_ITO(PRO_ID)
);
--14
CREATE SEQUENCE seq_req_id START WITH 1 INCREMENT BY 1;
--15
ALTER TABLE Requisicion_ITO
MODIFY (REQ_ID DEFAULT seq_req_id.nextval);

--16
Create Table DetalleProducto_ITO(
    DTP_ID Number(3),
    PRO_ID Number(3),
    DTP_NombreCategoria Varchar2(20),
    DTP_Categoria Number(2),
    DTP_StockMinimo Number(1),
    Constraint PK_DTP_ID Primary Key (DTP_ID),
    Constraint FK_DTP_ID Foreign Key (PRO_ID) References Producto_ITO(PRO_ID)
);

--17
CREATE SEQUENCE seq_dtp_id START WITH 1 INCREMENT BY 1;
--18
ALTER TABLE DetalleProducto_ITO
MODIFY (DTP_ID DEFAULT seq_DTP_id.nextval);

--19
Create Table Traslado_ITO(
    TRA_ID Number(3),
    TRA_SerieInterna Varchar(10),
    TRA_DetallesCourier Varchar2(10),
    Constraint PK_TRA_ID Primary Key (TRA_ID)
);
--20
CREATE SEQUENCE seq_tra_id START WITH 1 INCREMENT BY 1;
--21
ALTER TABLE Traslado_ITO
MODIFY (TRA_ID DEFAULT seq_tra_id.nextval);

--22
Create Table Ordenes_ITO(
    ORD_ID Number(3),
    TRA_ID Number(3),
    OFI_ID Number(3),
    ORD_Fecha Date,
    ORD_Cantidad Number(2),
    Constraint PK_ORD_ID Primary Key (ORD_ID),
    Constraint FK_TRAO_ID Foreign Key (TRA_ID) References Traslado_ITO(TRA_ID),
    Constraint FK_OFIO_ID Foreign Key (OFI_ID) References Oficinas_ITO(OFI_ID)
);
--23
CREATE SEQUENCE seq_ord_id START WITH 1 INCREMENT BY 1;
--24
ALTER TABLE Ordenes_ITO
MODIFY (ORD_ID DEFAULT seq_ord_id.nextval);

--25 y 26 revisar el Procedimiento y Triggers.sql

--27
Create Table DetalleOrdenes_ITO(
    DTO_ID Number(3),
    ORD_ID Number(3),
    PRO_ID Number(3),
    DTO_GranTotal Number(5),
    Constraint DTO_ID Primary Key (DTO_ID),
    Constraint ORDD_ID Foreign Key (ORD_ID) References Ordenes_ITO(ORD_ID),
    Constraint PROD_ID Foreign Key (PRO_ID) References Producto_ITO(PRO_ID)
);

--28
CREATE SEQUENCE seq_dto_id START WITH 1 INCREMENT BY 1;

--29
ALTER TABLE DetalleOrdenes_ITO
MODIFY (DTO_ID DEFAULT seq_dto_id.nextval);

--30
Create Table CLientes_ITO(
    CLI_ID Number(3),
    CLI_NIT Number(7),
    CLI_PrimerNombre Varchar2(15),
    CLI_SegundoNombre Varchar2(15),
    CLI_PrimerApellido Varchar2(15),
    CLI_SegundoApellido VARCHAR2(15),
    CLI_NCasa Number(3),
    CLI_Calle Number(3),
    CLI_Zona Number(3),
    CLI_Avenida Varchar2(15),
    CLI_Municipio Varchar2(15),
    CLI_Departamento Varchar2(15),
    Constraint CLI_ID Primary Key (CLI_ID)
);

--31
CREATE SEQUENCE seq_cli_id START WITH 1 INCREMENT BY 1;
--32
ALTER TABLE Clientes_ITO
MODIFY (CLI_ID DEFAULT seq_cli_id.nextval);
--33
Create Table Salida_ITO(
    SAL_ID Number(3),
    PRO_ID Number(3),
    SAL_FechaSalida Date,
    SAL_Movimiento Number(1),
    SAL_UnidadMedida Number(2),
    SAL_Cantidad Number(2),
    SAL_PrecioSalida Number(3),
    SAL_Serie Varchar2(10),
    SAL_NFEL Number(10),
    CLI_ID Number(3),
    Constraint PK_SAL_ID Primary Key (SAL_ID),
    Constraint FK_PROS_ID Foreign Key (PRO_ID) References Producto_ITO(PRO_ID),
    Constraint FK_CLIS_ID Foreign Key (CLI_ID) References Clientes_ITO(CLI_ID)
);
--34
CREATE SEQUENCE seq_sal_id START WITH 1 INCREMENT BY 1;
--35
ALTER TABLE Salida_ITO
MODIFY (SAL_ID DEFAULT seq_sal_id.nextval);

--36
Create Table Proveedor_ITO(
    PRV_ID Number(3),
    PRV_NIT Number(7),
    PRV_RazonSocial Varchar2(20),
    PRV_Nombre Varchar2(20),
    PRV_NLocal Number(3),
    PRV_Calle Number(3),
    PRV_Zona Number(3),
    PRV_Avenida Varchar2(15),
    PRV_Municipio Varchar2(15),
    PRV_Departamento Varchar2(15),
    Constraint PRV_ID Primary Key (PRV_ID)
);

--37
CREATE SEQUENCE seq_prv_id START WITH 1 INCREMENT BY 1;
--38
ALTER TABLE Proveedor_ITO
MODIFY (PRV_ID DEFAULT seq_prv_id.nextval);
--39
Create Table Entrada_ITO(
    ENT_ID Number(3),
    PRO_ID Number(3),
    ENT_FechaEntrada Date,
    ENT_Movimiento Number(1),
    ENT_UnidadMedida Number(2),
    ENT_Cantidad Number(2),
    ENT_PrecioSalida Number(3),
    ENT_Serie Varchar2(10),
    ENT_NFEL Number(10),
    PRV_ID Number(3),
    Constraint PK_ENT_ID Primary Key (ENT_ID),
    Constraint FK_PROE_ID Foreign Key (PRO_ID) References Producto_ITO(PRO_ID),
    Constraint FK_PRVE_ID Foreign Key (PRV_ID) References Proveedor_ITO(PRV_ID)
);
--40
CREATE SEQUENCE seq_ent_id START WITH 1 INCREMENT BY 1;
--41
ALTER TABLE Entrada_ITO
MODIFY (ENT_ID DEFAULT seq_ent_id.nextval);