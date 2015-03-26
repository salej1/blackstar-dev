-- IVA --
create table iva(ivaId int not null primary key, percentage decimal(3, 2) default 0.0);
insert into iva values(11, 0.11);
insert into iva values(16, 0.16);

-- Moneda --
create table currency(currencyId varchar(3) not null primary key, singleName varchar(10) not null, pluralName varchar(10));
insert into currency values('MXP', 'Peso', 'Pesos');
insert into currency values('USD', 'Dólar', 'Dólares');

-- Clasificación --
create table classification(classificationId int not null auto_increment primary key, name varchar(15) not null);
insert into classification values(0, 'Gobierno');
insert into classification values(0, 'Integrador');
insert into classification values(0, 'IP');

-- Origen --
create table origin(originId int not null auto_increment primary key, name varchar(15) not null);
insert into origin values(0, 'CLIENTE');
insert into origin values(0, 'CST');
insert into origin values(0, 'INTERNET');
insert into origin values(0, 'MAILING');
insert into origin values(0, 'REVISTA');
insert into origin values(0, 'REFERIDO');
insert into origin values(0, 'OTRO');

-- Condiciones --
create table paymentTerms(paymentTermsId int not null auto_increment primary key, name varchar(15) not null);
insert into paymentTerms values(0, 'Contado');
insert into paymentTerms values(0, 'Crédito');

-- Vendedores --
Call UpsertUser('vendedor1@baloosoftware.com', 'Vendedor 1');
Call CreateUserGroup('sysSales', 'Vendedor', 'vendedor1@baloosoftware.com');
Call UpsertUser('vendedor2@baloosoftware.com', 'Vendedor 2');
Call CreateUserGroup('sysSales', 'Vendedor', 'vendedor2@baloosoftware.com');
Call UpsertUser('vendedor3@baloosoftware.com', 'Vendedor 3');
Call CreateUserGroup('sysSales', 'Vendedor', 'vendedor3@baloosoftware.com');
Call UpsertUser('vendedor4@baloosoftware.com', 'Vendedor 4');
Call CreateUserGroup('sysSales', 'Vendedor', 'vendedor4@baloosoftware.com');
Call UpsertUser('vendedor5@baloosoftware.com', 'Vendedor 5');
Call CreateUserGroup('sysSales', 'Vendedor', 'vendedor5@baloosoftware.com');

-- Estados --
create table government(governmentId int not null auto_increment primary key, name varchar(25) not null);
insert into government values(0, 'Aguascalientes');
insert into government values(0, 'Baja California');
insert into government values(0, 'Baja California Sur');
insert into government values(0, 'Campeche');
insert into government values(0, 'Coahuila');
insert into government values(0, 'Colima');
insert into government values(0, 'Chiapas');
insert into government values(0, 'Chihuahua');
insert into government values(0, 'Distrito Federal');
insert into government values(0, 'Durango');
insert into government values(0, 'Guanajuato');
insert into government values(0, 'Guerrero');
insert into government values(0, 'Hidalgo');
insert into government values(0, 'Jalisco');
insert into government values(0, 'México');
insert into government values(0, 'Michoacán');
insert into government values(0, 'Morelos');
insert into government values(0, 'Nayarit');
insert into government values(0, 'Nuevo León');
insert into government values(0, 'Oaxaca');
insert into government values(0, 'Puebla');
insert into government values(0, 'Querétaro');
insert into government values(0, 'Quintana Roo');
insert into government values(0, 'San Luis Potosí');
insert into government values(0, 'Sinaloa');
insert into government values(0, 'Sonora');
insert into government values(0, 'Tabasco');
insert into government values(0, 'Tamaulipas');
insert into government values(0, 'Tlaxcala');
insert into government values(0, 'Veracruz');
insert into government values(0, 'Yucatán');
insert into government values(0, 'Zacatecas');

-- Ciudades --
create table city(cityId int not null auto_increment primary key, governmentId int not null, name varchar(30) not null, constraint city_government foreign key (governmentId) references government(governmentId));
insert into city values(0, 16, 'Acuitzio');
insert into city values(0, 16, 'Aguililla');
insert into city values(0, 16, 'Álvaro Obregón');
insert into city values(0, 16, 'Angamacutiro');
insert into city values(0, 16, 'Angangueo');
insert into city values(0, 16, 'Apatzingán');
insert into city values(0, 16, 'Aporo');
insert into city values(0, 16, 'Aquila');
insert into city values(0, 16, 'Ario');
insert into city values(0, 16, 'Arteaga');
insert into city values(0, 16, 'Briseñas');
insert into city values(0, 16, 'Buenavista');
insert into city values(0, 16, 'Carácuaro');
insert into city values(0, 16, 'Charapan');
insert into city values(0, 16, 'Charo');
insert into city values(0, 16, 'Chavinda');
insert into city values(0, 16, 'Cherán');
insert into city values(0, 16, 'Chilchota');
insert into city values(0, 16, 'Chinicuila');
insert into city values(0, 16, 'Chucándiro');
insert into city values(0, 16, 'Churintzio');
insert into city values(0, 16, 'Churumuco');
insert into city values(0, 16, 'Coahuayana');
insert into city values(0, 16, 'Coalcomán de Vázquez Pallares');
insert into city values(0, 16, 'Coeneo');
insert into city values(0, 16, 'Cojumatlán de Régules');
insert into city values(0, 16, 'Contepec');
insert into city values(0, 16, 'Copándaro');
insert into city values(0, 16, 'Cotija');
insert into city values(0, 16, 'Cuitzeo');
insert into city values(0, 16, 'Ecuandureo');
insert into city values(0, 16, 'Epitacio Huerta');
insert into city values(0, 16, 'Erongarícuaro');
insert into city values(0, 16, 'Gabriel Zamora');
insert into city values(0, 16, 'Hidalgo');
insert into city values(0, 16, 'Huandacareo');
insert into city values(0, 16, 'Huaniqueo');
insert into city values(0, 16, 'Huetamo');
insert into city values(0, 16, 'Huiramba');
insert into city values(0, 16, 'Indaparapeo');
insert into city values(0, 16, 'Irimbo');
insert into city values(0, 16, 'Ixtlán');
insert into city values(0, 16, 'Jacona');
insert into city values(0, 16, 'Jiménez');
insert into city values(0, 16, 'Jiquilpan');
insert into city values(0, 16, 'José Sixto Verduzco');
insert into city values(0, 16, 'Juárez');
insert into city values(0, 16, 'Jungapeo');
insert into city values(0, 16, 'La Huacana');
insert into city values(0, 16, 'La Piedad');
insert into city values(0, 16, 'Lagunillas');
insert into city values(0, 16, 'Lázaro Cárdenas');
insert into city values(0, 16, 'Los Reyes');
insert into city values(0, 16, 'Madero');
insert into city values(0, 16, 'Maravatío');
insert into city values(0, 16, 'Marcos Castellanos');
insert into city values(0, 16, 'Morelia');
insert into city values(0, 16, 'Morelos');
insert into city values(0, 16, 'Múgica');
insert into city values(0, 16, 'Nahuatzen');
insert into city values(0, 16, 'Nocupétaro');
insert into city values(0, 16, 'Nuevo Parangaricutiro');
insert into city values(0, 16, 'Nuevo Urecho');
insert into city values(0, 16, 'Numarán');
insert into city values(0, 16, 'Ocampo');
insert into city values(0, 16, 'Pajacuarán');
insert into city values(0, 16, 'Panindícuaro');
insert into city values(0, 16, 'Paracho');
insert into city values(0, 16, 'Parácuaro');
insert into city values(0, 16, 'Pátzcuaro');
insert into city values(0, 16, 'Penjamillo');
insert into city values(0, 16, 'Peribán');
insert into city values(0, 16, 'Purépero');
insert into city values(0, 16, 'Puruándiro');
insert into city values(0, 16, 'Queréndaro');
insert into city values(0, 16, 'Quiroga');
insert into city values(0, 16, 'Sahuayo');
insert into city values(0, 16, 'Salvador Escalante');
insert into city values(0, 16, 'San Lucas');
insert into city values(0, 16, 'Santa Ana Maya');
insert into city values(0, 16, 'Senguio');
insert into city values(0, 16, 'Susupuato');
insert into city values(0, 16, 'Tacámbaro');
insert into city values(0, 16, 'Tancítaro');
insert into city values(0, 16, 'Tangamandapio');
insert into city values(0, 16, 'Tangancícuaro');
insert into city values(0, 16, 'Tanhuato');
insert into city values(0, 16, 'Taretan');
insert into city values(0, 16, 'Tarímbaro');
insert into city values(0, 16, 'Tepalcatepec');
insert into city values(0, 16, 'Tingambato');
insert into city values(0, 16, 'Tinguindín');
insert into city values(0, 16, 'Tiquicheo de Nicolás Romero');
insert into city values(0, 16, 'Tlalpujahua');
insert into city values(0, 16, 'Tlazazalca');
insert into city values(0, 16, 'Tocumbo');
insert into city values(0, 16, 'Tumbiscatío');
insert into city values(0, 16, 'Turicato');
insert into city values(0, 16, 'Tuxpan');
insert into city values(0, 16, 'Tuzantla');
insert into city values(0, 16, 'Tzintzuntzan');
insert into city values(0, 16, 'Tzitzio');
insert into city values(0, 16, 'Uruapan');
insert into city values(0, 16, 'Venustiano Carranza');
insert into city values(0, 16, 'Villamar');
insert into city values(0, 16, 'Vista Hermosa');
insert into city values(0, 16, 'Yurécuaro');
insert into city values(0, 16, 'Zacapu');
insert into city values(0, 16, 'Zamora');
insert into city values(0, 16, 'Zináparo');
insert into city values(0, 16, 'Zinapécuaro');
insert into city values(0, 16, 'Ziracuaretiro');
insert into city values(0, 16, 'Zitácuaro');
insert into city values(0, 22, 'Amealco de Bonfil ');
insert into city values(0, 22, 'Arroyo Seco ');
insert into city values(0, 22, 'Cadereyta de Montes ');
insert into city values(0, 22, 'Colón ');
insert into city values(0, 22, 'Corregidora ');
insert into city values(0, 22, 'El Marqués ');
insert into city values(0, 22, 'Ezequiel Montes ');
insert into city values(0, 22, 'Huimilpan ');
insert into city values(0, 22, 'Jalpan de Serra ');
insert into city values(0, 22, 'Landa de Matamoros ');
insert into city values(0, 22, 'Pedro Escobedo ');
insert into city values(0, 22, 'Peñamiller ');
insert into city values(0, 22, 'Pinal de Amoles ');
insert into city values(0, 22, 'Querétaro ');
insert into city values(0, 22, 'San Joaquín ');
insert into city values(0, 22, 'San Juan del Río ');
insert into city values(0, 22, 'Tequisquiapan ');
insert into city values(0, 22, 'Tolimán ');

-- Clientes --
create table if not exists `blackstarDb`.`customer` (
  `customerId` int not null auto_increment ,
  `customerType` enum('P', 'C') not null default 'P',
  `rfc` varchar(14) not null ,
  `companyName` varchar(60) not null ,
  `tradeName` varchar(40) not null ,
  `phoneCode1` varchar(3) not null ,
  `phoneCode2` varchar(3) not null ,
  `phone1` varchar(7) not null ,
  `phone2` varchar(7) not null ,
  `extension1` varchar(6) not null ,
  `extension2` varchar(6) not null ,
  `email1` varchar(50) not null ,
  `email2` varchar(50) not null ,
  `street` varchar(30) not null ,
  `externalNumber` varchar(5) not null ,
  `internalNumber` varchar(3) not null ,
  `colony` varchar(30) not null ,
  `town` varchar(30) not null ,
  `country` varchar(20) not null ,
  `postcode` varchar(5) not null ,
  `advance` double not null ,
  `timeLimit` varchar(20) not null ,
  `settlementTimeLimit` varchar(20) not null ,
  `curp` varchar(18) not null ,
  `contactPerson` varchar(50) not null ,
  `retention` double default 0.0,
  `cityId` int not null ,
  `paymenttermsId` int not null ,
  `currencyId` varchar(3) not null ,
  `ivaId` int not null ,
  `classificationId` int not null ,
  `originId` int not null ,
  `seller` int not null ,
  primary key (`customerId`) ,
  unique index `rfc_unique` (`rfc` asc) ,
  unique index `curp_unique` (`curp` asc),
  constraint customer_city foreign key (cityId) references city(cityId),
  constraint customer_payment_terms foreign key (paymentTermsId) references paymentTerms(paymenttermsId),
  constraint customer_currency foreign key (currencyId) references currency(currencyId),
  constraint customer_iva foreign key (ivaId) references iva(ivaId),
  constraint customer_classification foreign key (classificationId) references classification(classificationId),
  constraint customer_origin foreign key (originId) references origin(originId),
  constraint customer_seller foreign key (seller) references blackstarUser(blackstaruserId)
) ENGINE = InnoDB;

