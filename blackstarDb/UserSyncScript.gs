/******************************************************************************
** File:	UserSyncScript.gs   
** Name:	UserSyncScript
** Desc:	Sincroniza el catalogo de usuarios y grupos con el cache en BD
** Auth:	Sergio A Gomez
** Date:	08/10/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/09/2013  SAG  	Version inicial: Carga la lista de usuarios en el cache de BD
** --   --------   -------  ------------------------------------
** 2    20/04/2014  SAG  	Se implementa modelo STTP
*****************************************************************************/

function userSync(){
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando sincronizacion de usuarios a base de datos: %s", formattedDate);
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
		Logger.log("Sincronizacion de usuarios finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al sincronizar usuarios en la base de datos");
		Logger.log(err);
		Logger.log("Sincronizacion de usuarios finalizada con errores", formattedDate);
	}
	
	saveLog(formattedDate, sqlLog);

}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_UsersSyncScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_UsersSyncScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}

function getDbConnection(){
	var conn = Jdbc.getCloudSqlConnection("jdbc:google:rdbms://gposac-blackstar-pro:gposac-blackstar-pro/blackstarDb");
	return conn;
}

function closeDbConnection(conn){
	if(!conn.isClosed()){
		conn.close();
	}
}

function startSyncJob(conn, sqlLog){

	// Get users list
	// iterate looking for new employees
  	const offset = 2; // Ajustar de acuerdo al numero de polizas cargadas en el sistema
	var startRec = offset;
	var range = "A" + startRec.toString() + ":E" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[0];
	var data = sheet.getRange(range).getValues();
	var currUser = data[0];

  	while(currUser != null && currUser[0] != null && currUser[0].toString() != ""){
        var userEmail = currUser[0];
        var userName = currUser[1];
        var syncSeed = currUser[4];

        if(syncSeed == 1){
        	sqlLog = sendUserToDatabase(conn, userEmail, userName, sqlLog);
	        
	        var groupId = currUser[2];
	        var groupName = currUser[3];
	        if(groupId.indexOf("sys") == 0){
					sqlLog = sendGroupToDatabase(conn, groupId, groupName, userEmail, sqlLog, sheet.getRange("E" + startRec.toString()));
			}
        }
		
		startRec++;
		range = "A" + startRec.toString() + ":E" + startRec.toString();
		data = sheet.getRange(range).getValues();
		currUser = data[0];
	}
}

function sendUserToDatabase(conn, userEmail, userName, sqlLog){
	var sql = "CALL UpsertUser('" + userEmail + "','" + userName + "')" ;
	
		Logger.log("Inserting " + userEmail);
		
		sqlLog = saveSql(sqlLog, sql);
	
		var stmt = conn.createStatement();
		stmt.execute(sql);
		
		return sqlLog; 
}

function sendGroupToDatabase(conn, groupId, groupName, userEmail, sqlLog, range){
		var sql = "CALL CreateUserGroup('" + groupId + "', '" + groupName + "', '" + userEmail + "')" ;
	
		Logger.log("Inserting Group " + groupName + " for user " + userEmail);
		
		sqlLog = saveSql(sqlLog, sql);
	
		var stmt = conn.createStatement();
		stmt.execute(sql);
		
		// mark sent
		range.setValue(2); 

		return sqlLog; 
}

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}