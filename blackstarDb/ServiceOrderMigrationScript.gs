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
	var conn = Jdbc.getCloudSqlConnection("jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/blackstarDbTransfer");
	return conn;
}

function closeDbConnection(conn){
	if(!conn.isClosed()){
		conn.close();
	}
}

function startLoadJob(conn, sqlLog) {

	// Load the equipment type Ids
	var policies = loadPolicies(conn);
	var serviceTypes = loadServiceTypes(conn);

	var sheets = new Array("osMxo","osGDL","osQRO");
	
	for(var ofIx = 0; ofIx < sheets.length; ofIx++){
		var office = sheets[ofIx];
		
		// Get the selected range in the spreadsheet that stores service order data.
		var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName(office);

		// For every row of data, generate an object.
		var data = pd.getValues();

		for(var i = 0; i < data.length; i++){
			var currOrder = data[i];
			sqlLog = sendToDatabase(currOrder, conn, policies, serviceTypes, sqlLog);
		} 
	}
}

function sendToDatabase(serviceOrder, conn, policies, serviceTypes, sqlLog){
	// sql string initialization
	
	var sql = "INSERT INTO blackstarDbTransfer.serviceTx( \
			serviceNumber, \
			ticketNumber, \
			serviceUnit, \
			project, \
			customer, \
			city, \
			address, \
			serviceTypeId, \
			serviceDate, \
			serialNumber, \
			responsible, \
			receivedBy, \
			serviceComments, \
			closed, \
			followUp, \
			spares, \
			consultant, \
			contractorCompany, \
			serviceRate, \
			customerComments, \
			created, \
			createdBy, \
			createdByUsr) \
			VALUES(";
				
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
	var receivedBy = serviceOrder[ 15 ];
	var serviceComments = serviceOrder[ 16 ];
	var closed = serviceOrder[ 17 ];
	var followUp = serviceOrder[ 18 ];
	var spares = serviceOrder[ 19 ];
	var consultant = serviceOrder[ 20 ];
	var contractorCompany = serviceOrder[ 21 ];
	var serviceRate = serviceOrder[ 22 ];
	var customerComments = serviceOrder[ 23 ];
	var created = new Date();
	var createdBy = "ServiceOrderMigrationScript";
	var createdByUsr = "sergio.aga";   

	
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
	if(serviceRate != null && serviceRate != "NA" && serviceRate != ""){
		sql = sql + Utilities.formatString("'%s',", serviceRate);
	}
	else{
		sql = sql + "NULL, "; 
	}
	sql = sql + Utilities.formatString("'%s',", customerComments);
	sql = sql + Utilities.formatString("'%s',", Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',", createdBy);
	sql = sql + Utilities.formatString("'%s');", createdByUsr);	
	
	Logger.log(Utilities.formatString("Inserting ServiceOrder %s", serviceNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
	return sqlLog;
}


function loadPolicies(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var policies = { };
	
	rs = stmt.executeQuery("select policyId, serialNumber from policy");
	while(rs.next()){
		policies[rs.getString(2)] = rs.getInt(1);
	}
	
	rs.close();
	stmt.close();
	
	return policies;
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

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
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
