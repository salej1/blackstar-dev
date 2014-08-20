/******************************************************************************
** File:	ServiceOrderMigrationScript.gs   
** Name:	ServiceOrderMigrationScript
** Desc:	Transfiere las ordenes de servicio a la base de datos de transferencia
** Auth:	Sergio A Gomez
** Date:	17/09/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/09/2013  SAG  	Version inicial: Exporta el archivo de OS a BD blackstarDbTransfer
** --   --------   -------  ------------------------------------
** 2    26/05/2014  SAG  	Se elimina carga de polizas, se seleccionan las hojas por indice.
** --   --------   -------  ------------------------------------
** 3 	23/06/2014	SAG 	Se agregan detalles del equipo
** --   --------   -------  ------------------------------------
** 4	18/08/2014	SAG 	Se implementa sincronizacion upsert
*****************************************************************************/

function main() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de ordenes de servicio a base de datos: %s", formattedDate);
	// SQL Log
	var sqlLog = "";
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start loading
		sqlLog = startLoadJob(conn, sqlLog);
		closeDbConnection(conn);
		
		// Log out
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Carga de ordenes de servicio finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al cargar ordenes de servicio en la base de datos");
		Logger.log(err);
		Logger.log("Carga de ordenes de servicio finalizada con errores", formattedDate);
	}
	
	saveLog(formattedDate, sqlLog);
}

function getDbConnection(){
	var conn = Jdbc.getCloudSqlConnection("jdbc:google:rdbms://gposac-blackstar-pro:gposac-blackstar-pro/blackstarDbTransfer");
	return conn;
}

function closeDbConnection(conn){
	if(!conn.isClosed()){
		conn.close();
	}
}

function startLoadJob(conn, sqlLog) {
	// Load the equipment & service type Ids
	var serviceTypes = loadServiceTypes(conn);
	var equipmentTypes = loadEquipmentTypes(conn);

	var sheets = new Array(4,8,11);
	
	for(var ofIx = 0; ofIx < sheets.length; ofIx++){
		var startRec = 6;
		var office = sheets[ofIx];

		// ajuste
		if(office == 4){
			startRec = startRec + 0;
		}
		
		// Get the selected range in the spreadsheet that stores service order data.
		var pd = SpreadsheetApp.getActiveSpreadsheet().getSheets()[office];

		// For every row of data, generate an object.
		var data = pd.getSheetValues(startRec,1,pd.getLastRow(),25);

		for(var i = 0; i < data.length; i++){
			var currOrder = data[i];
			sqlLog = sendToDatabase(currOrder, conn, serviceTypes, equipmentTypes, sqlLog);
		} 
	}
}

function sendToDatabase(serviceOrder, conn, serviceTypes, equipmentTypes, sqlLog){
	// sql string initialization
	
	var sql = Utilities.formatString("DELETE FROM serviceTx WHERE serviceNumber = '%s';", serviceOrder[ 6 ]);;
	var stmt = conn.createStatement();
	stmt.execute(sql);

	sql = "CALL upsertServiceOrder(";
				
	// reading the values
	var serviceUnit = serviceOrder[ 0 ];
	var project = serviceOrder[ 1 ];
	var customer = serviceOrder[ 2 ];
	var city = serviceOrder[ 3 ];
	var address = serviceOrder[ 4 ];
	var rawServiceTypeId = serviceOrder[ 5 ];
	var serviceTypeId = serviceTypes[rawServiceTypeId];
	var serviceNumber = serviceOrder[ 6 ];
	var ticketNumber = serviceOrder[ 7 ];
	var serviceDate = serviceOrder[ 8 ];
	var serialNumber = serviceOrder[ 12 ];
	var responsible = serviceOrder[ 14 ];
	var employeeId = serviceOrder[ 15 ];
	var receivedBy = serviceOrder[ 16 ];
	var serviceComments = serviceOrder[ 17 ];
	var closed = serviceOrder[ 18 ];
	var followUp = serviceOrder[ 19 ];
	var spares = serviceOrder[ 20 ];
	var consultant = serviceOrder[ 21 ];
	var contractorCompany = serviceOrder[ 22 ];
	var serviceRate = serviceOrder[ 23 ];
	var customerComments = serviceOrder[ 24 ];
	var created = new Date();
	var createdBy = "ServiceOrderMigrationScript";
	var createdByUsr = "sergio.aga"; 
	var rawEquipmentType = serviceOrder[9];
	var equipmentTypeId = equipmentTypes[rawEquipmentType];
	var brand = serviceOrder[10];
	var model = serviceOrder[11];
	var capacity = serviceOrder[13];

	// appending the values to the sql string
	sql = sql + Utilities.formatString("'%s',", serviceNumber);
	if(ticketNumber != "" && ticketNumber != "NA"){
			sql = sql + Utilities.formatString("'%s',", ticketNumber);
	}
	else{
		sql = sql + "NULL, "; 
	}
	sql = sql + Utilities.formatString("'%s',", serviceUnit);
	sql = sql + Utilities.formatString("'%s',", project);
	sql = sql + Utilities.formatString("'%s',", customer);
	sql = sql + Utilities.formatString("'%s',", city);
	sql = sql + Utilities.formatString("'%s',", address);
	sql = sql + Utilities.formatString("'%s',", serviceTypeId);
	sql = sql + Utilities.formatString("'%s',", Utilities.formatDate(serviceDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',", serialNumber);
	sql = sql + Utilities.formatString("'%s',", responsible);
	sql = sql + Utilities.formatString("'%s',", receivedBy);
	sql = sql + Utilities.formatString("'%s',", serviceComments);
	if(closed != "" && closed != "NA" && closed != 'PENDIENTE'){
		sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(closed, "CST", "yyyy-MM-dd HH:mm:ss"));
	}
	else{
		sql = sql + "NULL, "; 
	}
	sql = sql + Utilities.formatString("'%s',", followUp);
	sql = sql + Utilities.formatString("'%s',", spares);
	sql = sql + Utilities.formatString("'%s',", consultant);
	sql = sql + Utilities.formatString("'%s',", contractorCompany);
	if(serviceRate != null && serviceRate != "NA" && serviceRate != "N/A" && serviceRate != ""){
		sql = sql + Utilities.formatString("'%s',", serviceRate);
	}
	else{
		sql = sql + "NULL, "; 
	}
	sql = sql + Utilities.formatString("'%s',", customerComments);
	sql = sql + Utilities.formatString("'%s',", Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',", createdBy);
	sql = sql + Utilities.formatString("'%s',", createdByUsr);	
	sql = sql + Utilities.formatString("'%s',", equipmentTypeId);	
	sql = sql + Utilities.formatString("'%s',", brand);	
	sql = sql + Utilities.formatString("'%s',", model);	
	sql = sql + Utilities.formatString("'%s',", capacity);	
	sql = sql + Utilities.formatString("'%s');", employeeId);	
	
	Logger.log(Utilities.formatString("Upserting ServiceOrder %s", serviceNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	stmt = conn.createStatement();
	stmt.execute(sql);
	
	return sqlLog;
}

function loadServiceTypes(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var serviceTypes = { };
	
	rs = stmt.executeQuery("select serviceTypeId, serviceType from serviceType");
	while(rs.next()){
		serviceTypes[rs.getString(2)] = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return serviceTypes;
}

function loadEquipmentTypes(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var equipmentTypes = { };
	
	rs = stmt.executeQuery("select equipmentTypeId, equipmentType from equipmentType");
	while(rs.next()){
		equipmentTypes[rs.getString(2)] = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return equipmentTypes;
}

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_ServiceOrderMigrationScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_ServiceOrderMigrationScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}
