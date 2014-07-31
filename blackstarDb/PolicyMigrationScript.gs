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
** 2    13/03/2014  SAG  	Se Integra equipmentUser
** --   --------   -------  ------------------------------------
** 3	09/04/2014	SAG 	Se implementa sincronizacion selectiva
** --   --------   -------  ------------------------------------
** 4	30/07/2014	SAG 	Se implementa upsert
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
		sqlLog = startPolicyLoadJob(conn, sqlLog);
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
	var conn = Jdbc.getCloudSqlConnection("jdbc:google:rdbms://gposac-blackstar-pro:gposac-blackstar-pro/blackstarDbTransfer");
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
	
	for(var i = 0; i < data.length; i++){
		var currPolicy = data[i];
		sqlLog = sendPolicyToDatabase(currPolicy, conn, eqTypes, sqlLog);
	}  
	
	return sqlLog;
}

String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}

function sendPolicyToDatabase(policy, conn, eqTypes, sqlLog){
	// sql string initialization
	var sql = "CALL upsertPolicy(VALUES_PLACEHOLDER);";
	
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
	var zone = policy[ix]; ix++;
	var equipmentUser = policy[ix]; ix++;
	var created = new Date();
	var createdBy = "PolicyMigrationScript";
	var createdByUsr = "sergio.aga";

	// fetching derived values
	if(equipmentType == "SERVICIO DE DESCONTAMINACIÓN DATA CENTER"){
		equipmentType = "SERVICIO DE DESCONTAMINACION DATA CENTER";
	}
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

	var values = "";
	values = values + Utilities.formatString("'%s',",office);
	values = values + Utilities.formatString("'%s',",policyType);
	values = values + Utilities.formatString("'%s',",customerContract);
	values = values + Utilities.formatString("'%s',",customer);
	values = values + Utilities.formatString("'%s',",finalUser);
	values = values + Utilities.formatString("'%s',",project);
	values = values + Utilities.formatString("'%s',",cst);
	values = values + Utilities.formatString("'%s',",equipmentTypeId);
	values = values + Utilities.formatString("'%s',",brand);
	values = values + Utilities.formatString("'%s',",model);
	values = values + Utilities.formatString("'%s',",serialNumber);
	values = values + Utilities.formatString("'%s',",capacity);
	values = values + Utilities.formatString("'%s',",equipmentAddress);
	values = values + Utilities.formatString("'%s',",equipmentLocation);
	values = values + Utilities.formatString("'%s',",contact);
	values = values + Utilities.formatString("'%s',",contactEmail);
	values = values + Utilities.formatString("'%s',",contactPhone);
	values = values + Utilities.formatString("'%s',",Utilities.formatDate(startDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	values = values + Utilities.formatString("'%s',",Utilities.formatDate(endDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	if(parseInt(visitsPerYear, 10) > 0) {
		values = values + Utilities.formatString("'%s',",visitsPerYear);
	}
	else{
		values = values + Utilities.formatString("NULL,");
	}
	values = values + Utilities.formatString("'%s',",responseTimeHr);
	values = values + Utilities.formatString("'%s',",solutionTimeHr);
	values = values + Utilities.formatString("'%s',",penalty);
	values = values + Utilities.formatString("'%s',",service);
	values = values + Utilities.formatString("'%s',",includesPartsBool);
	values = values + Utilities.formatString("'%s',",exceptionParts);
	values = values + Utilities.formatString("'%s',",serviceCenter);
	values = values + Utilities.formatString("'%s',",observations);
	values = values + Utilities.formatString("'%s',",equipmentUser);
	values = values + Utilities.formatString("'%s',",Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	values = values + Utilities.formatString("'%s',",createdBy);
	values = values + Utilities.formatString("'%s'",createdByUsr);
	
	sql = sql.replace("VALUES_PLACEHOLDER", values);

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
		sqlLog = startPolicySyncJob(conn, sqlLog);
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
	
	// start point at the spreadsheet
	const offset = 4; // Ajustar de acuerdo al numero de polizas cargadas en el sistema
	var startRec = offset;
	
	// iterate looking for new policies
	var range = "A" + startRec.toString() + ":AE" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[4];
	var data = sheet.getRange(range).getValues();
	var currPolicy = data[0];
	
	while(currPolicy != null && currPolicy[0] != null && currPolicy[0].toString() != ""){
		try{
			sqlLog = sendPolicyToDatabase(currPolicy, conn, eqTypes, sqlLog);
		}
		catch(err){
			Logger.log("Error al sincronizar poliza # " + startRec);
			Logger.log(err);
		}
		startRec++;
		range = "A" + startRec.toString() + ":AE" + startRec.toString();
		data = SpreadsheetApp.getActiveSpreadsheet().getRange(range).getValues();
		currPolicy = data[0];
	}	
}

