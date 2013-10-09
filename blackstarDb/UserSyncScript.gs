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

function startSyncJob(conn, sqlLog){

	// Get users list
	var users = UserManager.getAllUsers();
	
	// Iterate through each user
	for (var i in users) {
		// Write it
		var userEmail = users[i].getEmail();
		var userName = users[i].getGivenName() + " " + users[i].getFamilyName();
		sqlLog = sendUserToDatabase(conn, userEmail, userName, sqlLog);
		
		  // Get groups
		var groups = GroupsManager.getAllGroups(userEmail);
		
		// Iterate through users groups
		for (var j in groups) {
			// Write group & relationship
			var groupName =  groups[j].getName();
			var groupId = groups[j].getId();
			
			if(groupName.indexOf("sys") == 0){
				sqlLog = sendGroupToDatabase(conn, groupName, groupId, userEmail);
			}
		}
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

function sendGroupToDatabase(conn, groupId, groupName, userEmail, sqlLog){
		var sql = "CALL CreateUserGroup('" + groupId + "', '" + groupName + "', '" + userEmail + "')" ;
	
		Logger.log("Inserting Group" + groupName + " for user " + userEmail);
		
		sqlLog = saveSql(sqlLog, sql);
	
		var stmt = conn.createStatement();
		stmt.execute(sql);
		
		return sqlLog; 
}

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}