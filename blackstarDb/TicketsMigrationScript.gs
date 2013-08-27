
function main() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de tickets a base de datos: %s", formattedDate);
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start loading
		startLoadJob(conn);
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
}

function getDbConnection(){
	var conn = Jdbc.getCloudSqlConnection("jdbc:google:rdbms://salej1-blackstar-dev:salej1-blackstar-dev/blackstarDb");
	return conn;
}

function closeDbConnection(conn){
	if(!conn.isClosed()){
		conn.close();
	}
}

function startLoadJob(conn) {

	// Load the equipment type Ids
	var policies = loadPolicies(conn);

	// Get the selected range in the spreadsheet that stores tickets data.
	var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName("ticketsData");

	// For every row of employee data, generate an ticket object.
	var data = pd.getValues();

	for(var i = 1; i < data.length; i++){
		var currTicket = data[i];
		sendToDatabase(currTicket, conn, policies);
	}  
}

function sendToDatabase(ticket, conn, policies){
	// sql string initialization
	var sql = "INSERT INTO `blackstardb`.`ticket` \
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
			 `responseTimeDeviation`, \
			 `followUp`, \
			 `closed`, \
			 `arrival`, \
			 `serviceOrderNumber`, \
			 `employee`, \
			 `solutionTime`, \
			 `solutionTimeDeviationHr`, \
			 `ticketStatusId`)\
			VALUES(";
				
	// reading the values
	var created = ticket[ 0 ];
	var user = ticket[ 1 ];
	var contact = ticket[ 2 ];
	var contactPhone = ticket[ 3 ];
	var contactEmail = ticket[ 4 ];
	var serialNumber = ticket[ 5 ];
	var observations = ticket[ 6 ];
	var ticketNumber = ticket[ 21 ];
	var rawPhoneResolved = ticket[ 22 ];
	var phoneResolved = 0;
	if(rawPhoneResolved == "SI"){
		phoneResolved = 1;
	}
	var followUp = ticket[ 24 ];
	var closed = ticket[ 25 ];
	var arrival = ticket[ 26 ];
	var serviceOrderNumber = ticket[ 27 ];
	var employee = ticket[ 28 ];
	var solutionTime = ticket[ 29 ];
	var solutionTimeDeviationHr = ticket[ 30 ];
	var createdBy = "TicketMigrationScript";
	var createdByUsr = "sergio.aga";

	// fetching derived values
	var policyId = policies[serialNumber];
	
	if(policyId == null){
		throw Utilities.formatString("serialNumber %s could not be found", serialNumber);
	}
	
	var rawTicketStatusId = ticket[ 31 ];
	var ticketStatusId = ticketStatus[rawTicketStatusId];

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
	sql = sql + Utilities.formatString("'%s',",responseTimeDeviation);
	sql = sql + Utilities.formatString("'%s',",followUp);
	sql = sql + Utilities.formatString("'%s',",Utilities.formatDate(closed, "CST", "yyyy-MM-dd HH:mm:ss"));
	sql = sql + Utilities.formatString("'%s',",arrival);
	sql = sql + Utilities.formatString("'%s',",serviceOrderNumber);
	sql = sql + Utilities.formatString("'%s',",employee);
	sql = sql + Utilities.formatString("'%s',",solutionTime);
	sql = sql + Utilities.formatString("'%s',",solutionTimeDeviationHr);
	sql = sql + Utilities.formatString("'%s',",ticketStatusId);
	sql = sql + Utilities.formatString("'%s',",createdBy);
	sql = sql + Utilities.formatString("'%s');",createdByUsr);
	
	Logger.log(Utilities.formatString("Inserting Ticket %s", serialNumber));
	
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
}


function loadPolicies(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDb;");
	var policies = { };
	
	rs = stmt.executeQuery("select policyId, serialNumber from policy");
	while(rs.next()){
		policies[rs.getString(2)] = rs.getInt(1);
	}
	
	rs.close();
	stmt.close();
	
	return policies;
}


function loadTicketStatus(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDb;");
	var ticketStatus = { };
	
	rs = stmt.executeQuery("select ticketStatusId, ticketStatus from ticketStatus");
	while(rs.next()){
		ticketStatus[rs.getString(2)] = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return ticketStatus;
}