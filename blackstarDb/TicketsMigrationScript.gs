/******************************************************************************
** File:	TicketsMigrationScript.gs   
** Name:	TicketsMigrationScript
** Desc:	Transfiere los tickets a la base de datos de transferencia
** Auth:	Sergio A Gomez
** Date:	17/09/2013
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    17/09/2013  SAG  	Version inicial: Exporta el archivo de tickets a BD blackstarDbTransfer
** --   --------   -------  ------------------------------------
** 2    05/11/2013  SAG  	Se agrega job de sincronizacion
** --   --------   -------  ------------------------------------
** 3    12/11/2013  SAG  	Se agrega deteccion de ultimo ticket en BD
** --   --------   -------  ------------------------------------
** 4    19/11/2013  SAG  	Correccion de AutoComit
** --   --------   -------  ------------------------------------
** 5    17/12/2013  SAG  	Soporte para lineas en blanco
** --   --------   -------  ------------------------------------
** 6    13/03/2014  SAG  	Adaptaciones
*****************************************************************************/

function ticketMain() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de tickets a base de datos: %s", formattedDate);
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
		Logger.log("Carga de tickets finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al cargar tickets en la base de datos");
		Logger.log(err);
		Logger.log("Carga de tickets finalizada con errores", formattedDate);
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

	// Load the equipment type Ids
	var policies = loadPolicies(conn);

	// Get the selected range in the spreadsheet that stores tickets data.
	var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName("ticketsData");

	// For every row of employee data, generate an ticket object.
	var data = pd.getValues();

	for(var i = 1; i < data.length; i++){
		var currTicket = data[i];
		sqlLog = sendToDatabase(currTicket, conn, policies, sqlLog);
	}  
}

function sendToDatabase(ticket, conn, policies, sqlLog){
	// sql string initialization
	var sql = "INSERT INTO `blackstarDbTransfer`.`ticket` \
			( \
			 `policyId`, \
			 `created`, \
			 `user`, \
			 `contact`, \
			 `contactPhone`, \
			 `contactEmail`, \
			 `serialNumber`, \
			 `observations`, \
			 `ticketNumber`, \
			 `phoneResolved`, \
			 `followUp`, \
			 `closed`, \
			 `arrival`, \
			 `serviceOrderNumber`, \
			 `employee`, \
			 `createdBy`, \
			 `createdByUsr`) \
			VALUES(";
				
	// reading the values
	var ix = 0;
	var created = ticket[ ix ]; ix++;
	var user = ticket[ ix ]; ix++;
	var contact = ticket[ ix ]; ix++;
	var contactPhone = ticket[ ix ]; ix++;
	var contactEmail = ticket[ ix ]; ix++;
	var serialNumber = ticket[ ix ]; ix++;
	var observations = ticket[ ix ]; ix++;
	ix = 22;
	var ticketNumber = ticket[ ix ]; ix++;
	var rawPhoneResolved = ticket[ ix ]; ix++;
	var phoneResolved = 0;
	if(rawPhoneResolved == "SI"){
		phoneResolved = 1;
	}
	var arrival = ticket[ ix ]; ix++;
	ix = 26;
	var followUp = ticket[ ix ]; ix++;
	var closed = ticket[ ix ]; ix++;
	var serviceOrderNumber = ticket[ ix ]; ix++;
	var employee = ticket[ ix ]; ix++;
	var createdBy = "TicketMigrationScript";
	var createdByUsr = "sergio.aga";

	if(created == ""){
		Logger.log(Utilities.formatString("Ticket %s ignorado. Sin marca temporal", ticketNumber));
		return;
	}

	// fetching derived values
	var policyId = policies[serialNumber];
	
	if(policyId == null){
		Logger.log(Utilities.formatString("Ticket %s ignorado, no se encontro poliza %s", ticketNumber, serialNumber));
		return;
	}
	
	// appending the values to the sql string
	sql = sql + Utilities.formatString("'%s',",policyId);
	sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',",user);
	sql = sql + Utilities.formatString("'%s',",contact);
	sql = sql + Utilities.formatString("'%s',",contactPhone);
	sql = sql + Utilities.formatString("'%s',",contactEmail);
	sql = sql + Utilities.formatString("'%s',",serialNumber);
	sql = sql + Utilities.formatString("'%s',",observations);
	sql = sql + Utilities.formatString("'%s',",ticketNumber);
	sql = sql + Utilities.formatString("'%s',",phoneResolved);
	sql = sql + Utilities.formatString("'%s',",followUp);
	if(closed != ""){
		sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(closed, "CST", "yyyy-MM-dd HH:mm:ss"));
	}
	else{
		sql = sql + "NULL, "; 
	}
	if(arrival != ""){
		sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(arrival, "CST", "yyyy-MM-dd HH:mm:ss"));
	}
	else{
		sql = sql + "NULL, "; 
	}
	sql = sql + Utilities.formatString("'%s',",serviceOrderNumber);
	sql = sql + Utilities.formatString("'%s',",employee);
	sql = sql + Utilities.formatString("'%s',",createdBy);
	sql = sql + Utilities.formatString("'%s');",createdByUsr);
	
	Logger.log(Utilities.formatString("Inserting Ticket %s", ticketNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
	return sqlLog;
}


function loadPolicies(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var policies = { };
	
	rs = stmt.executeQuery("select policyId, serialNumber from policy where NOW() > startDate AND NOW() < endDate;");
	while(rs.next()){
		policies[rs.getString(2)] = rs.getInt(1);
	}
	
	rs.close();
	stmt.close();
	
	return policies;
}


function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_TicketsMigrationScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_TicketsMigrationScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}


function ticketSync(){
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando sincronizacion de tickets a base de datos: %s", formattedDate);
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
		Logger.log("Sincronizacion de tickets finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al sincronizar tickets en la base de datos");
		Logger.log(err);
		Logger.log("Sincronizacion de tickets finalizada con errores", formattedDate);
	}
	
	saveLog(formattedDate, sqlLog);

}

function startSyncJob(conn, sqlLog){

	// Load the equipment type Ids
	var policies = loadPolicies(conn);
	
	// start point at the spreadsheet
	const offset = 3;
	
	var lastTicketNumber = getLastTicketNumber(conn);
	var startRec = offset;
	var range = "A" + startRec.toString() + ":AF" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[4];
	var data = sheet.getRange(range).getValues();
	var currTicket = data[0];
	var found = 0;
	var blanks = 0;
	var fuBuffer = [];
	
	while(found == 0 && blanks < 5){
		var thisTktNum = currTicket[21];
		var thisFollowUp = currTicket[25];

		if(thisTktNum != null && thisTktNum != ""){
			fuBuffer = accumulateFollowUpUdate(thisTktNum, thisFollowUp, fuBuffer);
			blanks = 0;
		}
		else{
			blanks++;
		}
		if(thisTktNum == lastTicketNumber){
			found = 1;
			break;
		}
		startRec++;
		range = "A" + startRec.toString() + ":AF" + startRec.toString();
		data = sheet.getRange(range).getValues();
		currTicket = data[0];
	}	
	
	// updating the follow up data
	executeFollowUpUpdate(conn, fuBuffer);
	
	// if we have new tickets
	if(found){
		startRec++;
	
		// iterate looking for new tickets
		range = "A" + startRec.toString() + ":AF" + startRec.toString();
		data = sheet.getRange(range).getValues();
		currTicket = data[0];
	
		while(blanks < 5){
			if(currTicket == null || currTicket[0] == null || currTicket[0].toString() == ""){
				blanks++;
			}
			else{
				sqlLog = sendToDatabase(currTicket, conn, policies, sqlLog);
				blanks = 0;
			}
			
			startRec++;
			range = "A" + startRec.toString() + ":AF" + startRec.toString();
			data = sheet.getRange(range).getValues();
			currTicket = data[0];
		}	
		
		sqlLog = executeTransfer(conn, sqlLog);
	}
	
	return sqlLog;
}

function getLastTicketNumber(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	rs = stmt.executeQuery("select ticketNumber from ticket order by ticketId desc limit 1;");
	var lastTicketNumber = "";

	while(rs.next()){
		lastTicketNumber = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return lastTicketNumber;
}

function executeTransfer(conn, sqlLog){
	var stmt = conn.createStatement();
	var sql = "call executeTransfer();";

	Logger.log("Executing Transfer...");
	
	sqlLog = saveSql(sqlLog, sql);
	
	stmt.execute(sql);
	stmt.close();

	return sqlLog;
}

function executeFollowUpUpdate(conn, buffer){
	var stmt = conn.createStatement();
	stmt.execute("use blackstarDbTransfer;");

	conn.setAutoCommit(false);
	stmt = conn.prepareStatement("update ticket set followUp = ? where ticketNumber = ?;");
	
	var item = buffer.shift();
	while(item != null){
		Logger.log(Utilities.formatString("Updating Ticket FollowUp %s", item[1]));
		stmt.setObject(1, item[0]);
		stmt.setObject(2, item[1]);
		stmt.addBatch();
		item = buffer.shift();
	}
	
	var res = stmt.executeBatch();
	conn.commit();
	conn.setAutoCommit(true);
	Logger.log("Ticket followUps updated");
}

function accumulateFollowUpUdate(ticketNum, followUp, buffer){
	if(followUp == null){
		followUp = "";
	}
	
	var fuSet = [followUp, ticketNum];
	buffer.push(fuSet);
	
	return buffer;
}