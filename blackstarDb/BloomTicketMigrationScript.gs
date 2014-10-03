/******************************************************************************
** File:	BloomTicketMigrationScript.gs   
** Name:	BloomTicketMigrationScript
** Desc:	Transfiere las requisiciones historicas a una base de datos temporal de transferencia
**			Este script debe ser ejecutado sobre el archivo de requisiciones de google apps
** Auth:	Sergio A Gomez
** Date:	29/09/2014
*******************************************************************************
** Change History
*******************************************************************************
** PR   Date    	Author	Description
** --   --------   -------  ------------------------------------
** 1    09/29/2014  SAG  	Version inicial: Exportacion de tickets de requisicion
*****************************************************************************/

function policyMain() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de requisiciones a base de datos: %s", formattedDate);
	// sqlLog
	var sqlLog = "";
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start loading
		sqlLog = startBloomTicketLoadJob(conn, sqlLog);
		closeDbConnection(conn);
		
		// Log out
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Carga de requisiciones finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al cargar requisiciones en la base de datos");
		Logger.log(err);
		Logger.log("Carga de requisiciones finalizada con errores", formattedDate);
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

function startBloomTicketLoadJob(conn, sqlLog) {

	// Load the tiquet type Ids
	var ticketTypes = loadTicketTypes(conn);

	// Get the selected range in the spreadsheet that stores req tickets
	var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName("ticketsData");

	// For every row of data, generate an policy object.
	var data = pd.getValues();
	
	for(var i = 0; i < data.length; i++){
		var currTicket = data[i];
		sqlLog = sendTicketToDatabase(currTicket, conn, ticketTypes, sqlLog);
	}  
	
	return sqlLog;
}

String.prototype.trim = function() {
	return this.replace(/^\s+|\s+$/g,"");
}

function sendTicketToDatabase(ticket, conn, ticketTypes, sqlLog, range){
	// sql string initialization
	var sql = "CALL UpsertBloomTicket(VALUES_PLACEHOLDER);";
	
	// reading the values
	var ix = 0;
	var created = ticket[ix]; ix++;
	var createdBy = ticket[ix]; 
	ix = 3;
	var rawTicketType = "";
	if(ticket[ix] != ""){
		rawTicketType = ticket[ix]; ix++;
	}
	else{
		ix++;
		if(ticket[ix] != ""){
			rawTicketType = ticket[ix]; ix++;
		}
		else{
			ix++;
			if(ticket[ix] != ""){
				rawTicketType = ticket[ix]; ix++;
			}
			else{
				ix = 8;
				if(ticket[ix] != ""){
					rawTicketType = ticket[ix];
				}
				else{
					throw "Tipo de requisicion no encontrada";
				}
			}
		}
	}
	var ticketType = ticketTypes[rawTicketType];
	ix = 6;
	var dueDate = ticket[ix]; ix++;
	var description = ticket[ix];
	ix = 9;
	var project = ticket[ix]; ix++;
	var office = ticket[ix]; ix++;
	var ticketNumber = ticket[ix]; ix++;
	var followUp = ticket[ix]; ix++;
	var followUp2 = ticket[ix]; ix++;
	ix = 15;
	var responseTime = ticket[ix]; ix++;
	var rawResolved = ticket[ix]; ix++;
	var resolved = 0;
	if(rawResolved == "Si"){
		resolved = 1;
	}
	ix = 17;
	var rawStatus = ticket[ix]; ix++;
	var status = 1;
	if(rawStatus == "C"){
		status = 6;
	}

	// quotes
	description = description.replace("'", "''");
	followUp = followUp.replace("'", "''");
	followUp2 = followUp2.replace("'", "''");

	var values = "";
	values = values + Utilities.formatString("'%s',",Utilities.formatDate(created, "CST", "yyyy-MM-dd HH:mm:ss"));
	values = values + Utilities.formatString("'%s',",createdBy);
	values = values + Utilities.formatString("'%s',",ticketType);
	values = values + Utilities.formatString("'%s',",Utilities.formatDate(dueDate, "CST", "yyyy-MM-dd HH:mm:ss"));
	values = values + Utilities.formatString("'%s',",description);
	values = values + Utilities.formatString("'%s',",project);
	values = values + Utilities.formatString("'%s',",office);
	values = values + Utilities.formatString("'%s',",ticketNumber);
	values = values + Utilities.formatString("'%s.\r\n%s',",followUp, followUp2);
	if(responseTime != ""){
		values = values + Utilities.formatString("'%s',",Utilities.formatDate(responseTime, "CST", "yyyy-MM-dd HH:mm:ss"));		
	}
	else{
		values = values + Utilities.formatString("%s,","NULL");		
	}
	values = values + Utilities.formatString("'%s',",resolved);
	values = values + Utilities.formatString("'%s',",status);
	values = values + Utilities.formatString("'%s'",0);

	sql = sql.replace("VALUES_PLACEHOLDER", values);

	Logger.log(Utilities.formatString("Inserting Ticket %s", ticketNumber));
	
	sqlLog = saveSql(sqlLog, sql);
	
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
	// remove seed
	range.setValue(2); // sent

	return sqlLog;
}

function loadTicketTypes(conn){
	var ticketTypes = { };
	
	ticketTypes["Levantamiento"] = 1;
	ticketTypes["Apoyo del Ingeniero de Soporte de acompañar a cita a un Consultor"] = 2;
	ticketTypes["Apoyo del Ingeniero de Soporte"] = 2;
	ticketTypes["Elaboración diagrama en CAD (Se entregarán diagramas Genéricos, si se desea solicitar uno exacto se deberá incluir la cedula de proyectos)"] = 3;
	ticketTypes["Elaboración de Plano e Imagenes 3D del SITE (se deben anexar planos del edificio y dibujos de levantamiento)"] = 4;
	ticketTypes["Realización de Cédula de Costos (Cuando sea necesario instalación o servicio adicional)"] = 5;
	ticketTypes["Pregunta técnica"] = 6;
	ticketTypes["Solicitud de aprobación de proyectos mayores a 50 KUSD y con mínimo 3 líneas diferentes"] = 7;
	ticketTypes["Solicitud de Precio de Lista de algùn producto que no se encuentre en la lista de precio"] = 8;
	ticketTypes["Elaboracion de Diagrama CAD o de Plano en 3D"] = 9;
	ticketTypes["Reporte de Calidad de Energía"] = 10;
	ticketTypes["Soporte en Monitoreo, Requisición de elaboración de Mapeo, etc.(Incluir la marca y modelo del dispositivo y de preferencia las MIBS)"] = 11;
	ticketTypes["Pregunta tecnica"] = 12;
	ticketTypes["Requisición de Parte o refacción (Indicar al final el número de ticket u orden de servicio)"] = 13;
	ticketTypes["Solicitud de Costo"] = 14;
	ticketTypes["Requerimiento de Compra de Activos"] = 15;
	ticketTypes["Aumento de sueldo"] = 16;
	ticketTypes["Contratacion de personal"] = 17;
	ticketTypes["Nueva Creacion"] = 18;
	ticketTypes["Finiquito"] = 19;
	ticketTypes["Acta Adminsitrativa"] = 20;
	ticketTypes["Req. de Curso"] = 21;
	ticketTypes["Modificacion del SGC"] = 22;
	ticketTypes["Sugerencia de Modificacion"] = 23;
	ticketTypes["Problemas con la telefonía o con la Red"] = 24;

	return ticketTypes;
}

function saveSql(sqlLog, sql){
	sqlLog = sqlLog + sql + "\r\n" ;
	
	return sqlLog;
}

function saveLog(timestamp, sqlLog){
	// Storing Log
	var folderLog = DocsList.getFolder('Log');
	var fileName = "Log_BloomTicketMigrationScript_" + timestamp + ".txt";
	var logfile = folderLog.createFile(fileName, Logger.getLog());
	
	// Storing SQL Log
	var folderSql = DocsList.getFolder('SQL');
	var fileName = "SQL_BloomTicketMigrationScript_" + timestamp + ".txt";
	var sqlFile = folderSql.createFile(fileName, sqlLog);
}

function ticketSync(){
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando sincronizacion de requisiciones a base de datos: %s", formattedDate);
	// sqlLog
	var sqlLog = "";
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start syncing
		sqlLog = startTicketSyncJob(conn, sqlLog);
		closeDbConnection(conn);
		
		// Log out
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Sincronizacion de requisiciones finalizada correctamente", formattedDate);
	}
	catch(err) {
		// Log out with failure
		formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
		Logger.log("Error al sincronizar requisiciones en la base de datos");
		Logger.log(err);
		Logger.log("Sincronizacion de requisiciones finalizada con errores", formattedDate);
	}
	
	saveLog(formattedDate, sqlLog);

}

function startTicketSyncJob(conn, sqlLog){

	// Load the equipment type Ids
	var ticketTypes = loadTicketTypes(conn);
	
	// start point at the spreadsheet
	const offset = 2; // Ajustar de acuerdo al numero de requisiciones cargadas en el sistema
	var startRec = offset;
	
	// iterate looking for new policies
	var range = "A" + startRec.toString() + ":S" + startRec.toString();
	var ss = SpreadsheetApp.getActiveSpreadsheet();
	var sheet = ss.getSheets()[0];
	var data = sheet.getRange(range).getValues();
	var currTicket = data[0];
	var seed = currTicket[18];
	var update = 0;

	while(currTicket != null && currTicket[11] != null && currTicket[11].toString() != ""){
		try{
			if(seed == 1){
				sqlLog = sendTicketToDatabase(currTicket, conn, ticketTypes, sqlLog, sheet.getRange("S" + startRec.toString()));		
				update = 1;		
			}
		}
		catch(err){
			Logger.log("Error al sincronizar ticket # " + startRec);
			Logger.log(err);
		}
		startRec++;
		seedRange = "S" + startRec.toString();
		seed = sheet.getRange(seedRange).getValues()[0];
		range = "A" + startRec.toString() + ":S" + startRec.toString();
		data = SpreadsheetApp.getActiveSpreadsheet().getRange(range).getValues();
		currTicket = data[0];
	}	

	if(update == 1){
		sqlLog = executeTransfer(conn, sqlLog);
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
		    var seedCell = actSht.getRange(index,18);
		    var ticketNumber = actSht.getRange(index,11).getValue();
		    if(ticketNumber != ""){
			    seedCell.setValue(1);
		    }
		}
	}
	catch(err){
		Logger.log(err);
	}
}
