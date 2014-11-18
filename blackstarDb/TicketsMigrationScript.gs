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
** --   --------   -------  ------------------------------------
** 7    19/03/2014  SAG  	Se agrega Project a inserciones
** --   --------   -------  ------------------------------------
** 8    01/04/2014  SAG  	Se agrega modelo STTP
** --   --------   -------  ------------------------------------
** 9	09/04/2014	SAG 	Se corrige asignacion de sync seed
** --   --------   -------  ------------------------------------
** 10 	06/11/2014	SAG 	Se implementa errStack y envio de errores por mail
*****************************************************************************/
// errStack
var errStack = [];

// functions
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

// Transfer
function sendToDatabase(ticket, conn, policies, sqlLog, range){
	// sql string initialization
	var sql = Utilities.formatString("DELETE FROM blackstarDbTransfer.ticket WHERE ticketNumber = '%s';", ticket[22]);
	sqlLog = saveSql(sqlLog, sql);
	var stmt = conn.createStatement();
	stmt.execute(sql);

	sql = "INSERT INTO `blackstarDbTransfer`.`ticket` \
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
			 `project`, \
			 `createdBy`, \
			 `createdByUsr`, \
			 `processed`) \
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
	ix = 20;
	var project = ticket[ix]; ix++;
	ix++; 
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
	var processed = 0;

	if(created == ""){
		var errStr = Utilities.formatString("Ticket %s ignorado. Sin marca temporal", ticketNumber);
		Logger.log(errStr);
		errStack.push(errStr);
		return;
	}

	// fetching derived values
	var policyId = policies[serialNumber];
	
	if(policyId == null){
		var errStr2 = Utilities.formatString("Ticket %s ignorado, no se encontro poliza %s", ticketNumber, serialNumber);
		Logger.log(errStr2);
		errStack.push(errStr2);
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
	sql = sql + Utilities.formatString("'%s',",project);
	sql = sql + Utilities.formatString("'%s',",createdBy);
	sql = sql + Utilities.formatString("'%s',",createdByUsr);
	sql = sql + Utilities.formatString("'%s');",processed);
	
	Logger.log(Utilities.formatString("Insertando Ticket %s", ticketNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	stmt = conn.createStatement();
	stmt.execute(sql);

	// remove seed
	range.setValue(2); // sent
	
	return sqlLog;
}


function loadPolicies(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDbTransfer;");
	var policies = { };
	
	rs = stmt.executeQuery("select policyId, serialNumber from policy where NOW() > startDate AND NOW() < DATE_ADD(endDate, interval 3 MONTH);");
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

// Trigger
function ticketSync(){
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando sincronizacion de tickets a base de datos: %s", formattedDate);
	// sqlLog
	var sqlLog = "";
	// init errStack
	errStack = [];

	try{
		// start syncing
		sqlLog = startSyncJob(sqlLog);
		
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

	// send errors by email
	mailErrors();

	saveLog(formattedDate, sqlLog);
}

function startSyncJob(sqlLog){
	const offset = 3;
	var startRec = offset;
	var range = "A" + startRec.toString() + ":AS" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[2];
	var data = sheet.getRange(range).getValues();
	var currTicket = data[0];
	var blanks = 0;
	var seedFound = false;
	var gotConnection = false;
	var policiesLoaded = false;
	var conn;
	var policies;

	while(blanks < 5){
		// is blank?
		var thisTktNum = currTicket[22];
		if(thisTktNum == null || thisTktNum == ""){
			blanks++;
		}
		else{
			// is ticket
			blanks = 0;
			var seed = currTicket[44];

			// has seed?
			if(seed == 1){
				seedFound = true;

				// db connection
				if(!gotConnection){
					conn = getDbConnection();
					gotConnection = true;
				}

				// policies
				if(!policiesLoaded){
					policies = loadPolicies(conn);
					policiesLoaded = true;
				}

				sqlLog = sendToDatabase(currTicket, conn, policies, sqlLog, sheet.getRange("AS" + startRec.toString()));
			}
		}
		
		// next ticket please
		startRec++;
		range = "A" + startRec.toString() + ":AS" + startRec.toString();
		data = sheet.getRange(range).getValues();
		currTicket = data[0];
	}

	// process tickets
	if(seedFound){
		sqlLog = executeTransfer(conn, sqlLog);
	}

	// close DB connection
	if(gotConnection){
		closeDbConnection(conn);
	}

	return sqlLog;
}

// Process
function executeTransfer(conn, sqlLog){
	var stmt = conn.createStatement();
	var sql = "call executeTransfer();";

	Logger.log("Executing Transfer...");
	
	sqlLog = saveSql(sqlLog, sql);
	
	stmt.execute(sql);
	stmt.close();

	return sqlLog;
}

// Seed
function onEdit(event)
{
	try{
		var s = SpreadsheetApp.getActiveSheet();
		if( s.getName() == "Seguimiento" ) { 
		    var actSht = event.source.getActiveSheet();
		    var actRng = event.source.getActiveRange();

		    var index = actRng.getRowIndex();
		    var seedCell = actSht.getRange(index,44);
		    var ticketNumber = actSht.getRange(index,22).getValue();
		    if(ticketNumber != ""){
			    lastCell.setValue(1);
		    }
		}
	}
	catch(err){
		Logger.log(err);
	}
}

// mail errors
function mailErrors(){
	if(errStack.length > 0){
		var body = '';
		for(var i = 0; i < errStack.length; i++){
			body = body + "\r\n" + errStack[i];
		}
		
		MailApp.sendEmail('sergio.aga@gmail.com', 'Error al sincronizar tickets', body);
	}
}