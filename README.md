ES:
El proyecto esta realizado en Oracle 19C.
En los docuemtos estan detallados los pasos que debes de tomar para ejecutar las instrucciones, además puedes utilizar el mismo usuario y contraseña que se creo en SQL Plus, si utilizas otro no hay problema
solo debes de modificar la cadena de conexion del repositorio de @Josuear10 llamada Inventory-Module-BackEnd
![imagen](https://github.com/RatixxJM/DB-Inventario/assets/114269446/1b6b3f90-7f7c-48f4-92a6-90c47f9179ec)

Luego ejecutaremos 

node prueba.js

con esto crearemos el usuario que necesitamos en nuestra base de datos para loggearnos en el usuario.

EXPLICACION TRIIGGERS:

El proyecto estuvo pensado que todos se unificaran en solo una API, pero ni uno de los demás grupos de la universidad lograron acabar su proyecto adecuadamente para poder
consumir la api adecuada para poder utilizar su data, lo que se hizo es que en muchas instancias del proyecto se utilizaron triggers para llenar parametros que se necesitaban
con datos randomizados y otros calculos matematicos luego de una insercion de data en la base de datos.
