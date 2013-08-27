
function main() {
	// Log init and timestamp
	var formattedDate = Utilities.formatDate(new Date(), "CST", "yyyy-MM-dd HH:mm:ss");
	Logger.log("Iniciando carga de polizas a base de datos: %s", formattedDate);
	
	// verify connection & load
	try{
		// get the database connection
		var conn = getDbConnection();
		
		// start loading
		startLoadJob(conn);
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
	var eqTypes = loadEquipmentTypes(conn);

	// Get the selected range in the spreadsheet that stores policy data.
	var pd = SpreadsheetApp.getActiveSpreadsheet().getRangeByName("polizasData");

	// For every row of employee data, generate an ticket object.
	var data = pd.getValues();

	for(var i = 1; i < data.length; i++){
		var currPolicy = data[i];
		sendToDatabase(currPolicy, conn, eqTypes);
	}  
}

function sendToDatabase(policy, conn, eqTypes){
	// sql string initialization
	var sql = "	INSERT INTO `blackstarDb`.`policy`	\
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
	var office = policy[0];
	var policyType = policy[1];
	var customerContract = policy[2];
	var customer = policy[3];
	var finalUser = policy[4];
	var project = policy[5];
	var cst = policy[6];
	var equipmentType = policy[7];
	var brand = policy[8];
	var model = policy[9];
	var serialNumber = policy[10];
	var capacity = policy[11];
	var equipmentAddress = policy[12];
	var equipmentLocation = policy[13];
	var contact = policy[14];
	var contactEmail = policy[15];
	var contactPhone = policy[16];
	var startDate = policy[17];
	var endDate = policy[18];
	var visitsPerYear = policy[19];
	var responseTimeHr = policy[20];
	var solutionTimeHr = policy[21];
	var penalty = policy[22];
	var service = policy[23];
	var includesParts = policy[24];
	var exceptionParts = policy[25];
	var serviceCenter = policy[26];
	var observations = policy[27];
	var created = new Date();
	var createdBy = "PolicyMigrationScript";
	var createdByUsr = "sergio.aga";

	// fetching derived values
	var equipmentTypeId = eqTypes[equipmentType];
	
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
	
	var stmt = conn.createStatement();
	stmt.execute(sql);
	
}


function loadEquipmentTypes(conn){
	var stmt = conn.createStatement();
	var rs = stmt.execute("use blackstarDb;");
	var eqTypes = { };
	
	rs = stmt.executeQuery("select * from equipmentType;");
	while(rs.next()){
		eqTypes[rs.getString(2)] = rs.getString(1);
	}
	
	rs.close();
	stmt.close();
	
	return eqTypes;
}