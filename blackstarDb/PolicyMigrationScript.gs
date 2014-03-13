/******************************************************************************
** File:	PolicyMigrationScript.gs   
** Name:	PolicyMigrationScript
** Desc:	transfiere los datos de polizas a una base de datos temporal de transferencia
**			Este script debe ser ejecutado sobre el archivo de polizas de google apps
** Auth:	Sergio A Gomez
** Date:	17/09/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/09/2013  SAG  	Version inicial: Exporta el archivo de polizas a BD blackstarDbTransfer
** --   --------   -------  ------------------------------------
** 1    06/03/2014  SAG  	Version inicial: Exporta el archivo de polizas a BD blackstarDbTransfer
*****************************************************************************/

function policyMain() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de polizas a base de datos: %s", formattedDate);
	// sqlLog
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
		Logger.log("Carga de polizas finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al cargar polizas en la base de datos");
		Logger.log(err);
		Logger.log("Carga de polizas finalizada con errores", formattedDate);
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

function startPolicyLoadJob(conn, sqlLog) {

	// Load the equipment type Ids
	var eqTypes = loadEquipmentTypes(conn);

	// Get the selected range in the spreadsheet that stores policy data.
	var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName("polizasData");

	// For every row of data, generate an policy object.
	var data = pd.getValues();
	
	for(var i = 1; i < data.length; i++){
		var currPolicy = data[i];
		sqlLog = sendToDatabase(currPolicy, conn, eqTypes, sqlLog);
	}  
	
	return sqlLog;
}

String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}

function sendPolicyToDatabase(policy, conn, eqTypes, sqlLog){
	// sql string initialization
	var sql = "	INSERT INTO `blackstarDbTransfer`.`policy`	\
	(	\
	`office`,	\
	`policyType`,	\
	`customerContract`,	\
	`customer`,	\
	`finalUser`,	\
	`project`,	\
	`cst`,	\
	`equipmentTypeId`,	\
	`brand`,	\
	`model`,	\
	`serialNumber`,	\
	`capacity`,	\
	`equipmentAddress`,	\
	`equipmentLocation`,	\
	`contact`,	\
	`contactEmail`,	\
	`contactPhone`,	\
	`startDate`,	\
	`endDate`,	\
	`visitsPerYear`,	\
	`responseTimeHr`,	\
	`solutionTimeHr`,	\
	`penalty`,	\
	`service`,	\
	`includesParts`,	\
	`exceptionParts`,	\
	`serviceCenter`,	\
	`observations`,	\
	`created`,	\
	`createdBy`,	\
	`createdByUsr`)	\
	VALUES(";
	
	// reading the values
	var ix = 1;
	var office = policy[ix]; ix++;
	var policyType = policy[ix]; ix++;
	var customerContract = policy[ix]; ix++;
	var customer = policy[ix]; ix++;
	var finalUser = policy[ix]; ix++;
	var project = policy[ix]; ix++;
	var cst = policy[ix]; ix++;
	var equipmentType = policy[ix]; ix++;
	var brand = policy[ix]; ix++;
	var model = policy[ix]; ix++;
	var serialNumber = policy[ix]; ix++;
	var capacity = policy[ix]; ix++;
	var equipmentAddress = policy[ix]; ix++;
	var equipmentLocation = policy[ix]; ix++;
	var contact = policy[ix]; ix++;
	var contactEmail = policy[ix]; ix++;
	var contactPhone = policy[ix]; ix++;
	var startDate = policy[ix]; ix++;
	var endDate = policy[ix]; ix++;
	var visitsPerYear = policy[ix]; ix++;
	var responseTimeHr = policy[ix]; ix++;
	if(responseTimeHr == "NA"){
		responseTimeHr = "168";
	}
	var solutionTimeHr = policy[ix]; ix++;
	if(solutionTimeHr == "NA"){
		solutionTimeHr = "408";
	}
	var penalty = policy[ix]; ix++;
	var service = policy[ix]; ix++;
	var includesParts = policy[ix]; ix++;
	var exceptionParts = policy[ix]; ix++;
	var serviceCenter = policy[ix]; ix++;
	var observations = policy[ix]; ix++;
	var created = new Date();
	var createdBy = "PolicyMigrationScript";
	var createdByUsr = "sergio.aga";

	// fetching derived values
	var equipmentTypeId = eqTypes[equipmentType.trim()];
	
	if(equipmentTypeId == null){
		throw Utilities.formatString("equipmentType %s could not be found", equipmentType);
	}
	
	var includesPartsBool = 0;
	if(includesParts == "SI"){
		includesPartsBool = 1;
	}
	
	if(visitsPerYear == "NA"){
		visitsPerYear = null;
	}
	// appending the values to the sql string
	sql = sql + Utilities.formatString("'%s',",office);
	sql = sql + Utilities.formatString("'%s',",policyType);
	sql = sql + Utilities.formatString("'%s',",customerContract);
	sql = sql + Utilities.formatString("'%s',",customer);
	sql = sql + Utilities.formatString("'%s',",finalUser);
	sql = sql + Utilities.formatString("'%s',",project);
	sql = sql + Utilities.formatString("'%s',",cst);
	sql = sql + Utilities.formatString("'%s',",equipmentTypeId);
	sql = sql + Utilities.formatString("'%s',",brand);
	sql = sql + Utilities.formatString("'%s',",model);
	sql = sql + Utilities.formatString("'%s',",serialNumber);
	sql = sql + Utilities.formatString("'%s',",capacity);
	sql = sql + Utilities.formatString("'%s',",equipmentAddress);
	sql = sql + Utilities.formatString("'%s',",equipmentLocation);
	sql = sql + Utilities.formatString("'%s',",contact);
	sql = sql + Utilities.formatString("'%s',",contactEmail);
	sql = sql + Utilities.formatString("'%s',",contactPhone);
	sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(startDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(endDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	if(parseInt(visitsPerYear, 10) > 0) {
		sql = sql + Utilities.formatString("'%s',",visitsPerYear);
	}
	else{
		sql = sql + Utilities.formatString("NULL,");
	}
	sql = sql + Utilities.formatString("'%s',",responseTimeHr);
	sql = sql + Utilities.formatString("'%s',",solutionTimeHr);
	sql = sql + Utilities.formatString("'%s',",penalty);
	sql = sql + Utilities.formatString("'%s',",service);
	sql = sql + Utilities.formatString("'%s',",includesPartsBool);
	sql = sql + Utilities.formatString("'%s',",exceptionParts);
	sql = sql + Utilities.formatString("'%s',",serviceCenter);
	sql = sql + Utilities.formatString("'%s',",observations);
	sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',",createdBy);
	sql = sql + Utilities.formatString("'%s');",createdByUsr);
	
	Logger.log(Utilities.formatString("Inserting Policy %s", serialNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
	return sqlLog;
}


function loadEquipmentTypes(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var eqTypes = { };
	
	rs = stmt.executeQuery("select * from equipmentType;");
	while(rs.next()){
		eqTypes[rs.getString(2)] = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return eqTypes;
}

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_PolicyMigrationScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_PolicyMigrationScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}

function policySync(){
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando sincronizacion de polizas a base de datos: %s", formattedDate);
	// sqlLog
	var sqlLog = "";
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start syncing
		sqlLog = startSyncJob(conn, sqlLog);
		closeDbConnection(conn);
		
		// Log out
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Sincronizacion de polizas finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al sincronizar polizas en la base de datos");
		Logger.log(err);
		Logger.log("Sincronizacion de polizas finalizada con errores", formattedDate);
	}
	
	saveLog(formattedDate, sqlLog);

}

function startPolicySyncJob(conn, sqlLog){

	// Load the equipment type Ids
	var eqTypes = loadEquipmentTypes(conn);
	
	// how many records do we have?
	var policyCount = getPolicyCount(conn);
	
	// start point at the spreadsheet
	const offset = 4;
	var startRec = policyCount + offset + 1;
	
	// iterate looking for new policies
	var range = "A" + startRec.toString() + ":AC" + startRec.toString();
	var data = SpreadsheetApp.getActiveSpreadsheet().getRange(range).getValues();
	var currPolicy = data[0];
	
	while(currPolicy != null && currPolicy[0] != null && currPolicy[0].toString() != ""){
		sqlLog = sendToDatabase(currPolicy, conn, eqTypes, sqlLog);
		startRec++;
		range = "A" + startRec.toString() + ":AC" + startRec.toString();
		data = SpreadsheetApp.getActiveSpreadsheet().getRange(range).getValues();
		currPolicy = data[0];
	}	
}


function getPolicyCount(conn){

	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var policyCount = 0;
	
	rs = stmt.executeQuery("select count(*) from blackstarDbTransfer.policy;");
	while(rs.next()){
		policyCount = rs.getInt(1);
	}
	
	rs.close();
	stmt.close();
	
	return policyCount;
}