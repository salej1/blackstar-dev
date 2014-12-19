/******************************************************************************
** File:	Jobs.gs   
** Name:	Jobs
** Desc:	Ejecuta stored procedures automaticamente - Frecuencia configurable
** Auth:	Sergio A Gomez
** Date:	17/12/2014
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/12/2014  SAG  	Version inicial: bloomTicketAutoProcess
*******************************************************************************/
// errStack
var errStack = [];

function jobsMain() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando Jobs: %s", formattedDate);
	// sqlLog
	var sqlLog = "";
	// init errStack
	errStack = [];
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start loading
		sqlLog = startJobs(conn, sqlLog);
		closeDbConnection(conn);
		
		// Log out
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Carga de tickets finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error procesar Jobs");
		Logger.log(err);
		Logger.log("Jobs ejecutados con errores", formattedDate);
	}
	
	// send errors by email
	mailErrors();

	saveLog(formattedDate, sqlLog);
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

function startJobs(conn, sqlLog){
	// Ejecutar Job por cada comando
	const offset = 1;
	var startRec = offset;
	var range = "A" + startRec.toString() + ":A" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[0];
	var data = sheet.getRange(range).getValues();
	var currJob = data[0][0];

	while(currJob != ""){
		try{
			sqlLog = executeJob(currJob, conn, sqlLog);
		}
		catch(err){
			var errStr = "Error al ejecutar Job " + currJob + ": " + err;
			Logger.log(errStr);
			errStack.push(errStr);
		}

		// next ticket please
		startRec++;
		range = "A" + startRec.toString() + ":A" + startRec.toString();
		data = sheet.getRange(range).getValues();
		currJob = data[0][0];
	}
}

function executeJob(jobName, conn, sqlLog){
	// Command
	var sql = Utilities.formatString("CALL %s;", jobName);

	// Log
	Logger.log(Utilities.formatString("Corriendo Job %s", jobName));
	sqlLog = saveSql(sqlLog, sql);
	
	// Execution
	var stmt = conn.createStatement();
	stmt.execute(sql);

	// Return
	return sqlLog;
}

// mail errors
function mailErrors(){
	if(errStack.length > 0){
		var body = '';
		for(var i = 0; i < errStack.length; i++){
			body = body + "\r\n" + errStack[i];
		}
		
		MailApp.sendEmail('sergio.aga@gmail.com', 'Error al ejecutar jobs', body);
	}
}


function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_JobsScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_JobsScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}