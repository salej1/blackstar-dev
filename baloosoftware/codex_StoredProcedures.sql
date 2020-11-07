use blackstarDb;

DELIMITER $$

-- SP to create projectfollowup 
DROP PROCEDURE IF EXISTS blackstarDb.AddProjectFollowUp$$
PROCEDURE `AddProjectFollowUp`(
        IN project_id VARCHAR(20),
        IN followup_date DATE,
        IN user_assigner INTEGER(11),
        IN user_assingned INTEGER(11),
        IN comment TEXT
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

DECLARE id INT DEFAULT 0;
DECLARE count_rows INT DEFAULT 0;
SELECT COUNT(proyectfollowup_id) INTO count_rows from blackstardb.projectfollowup;
IF count_rows > 0 THEN
	SELECT MAX(proyectfollowup_id) INTO id from blackstardb.projectfollowup;
END IF;
SET id = id + 1;

INSERT INTO blackstardb.projectfollowup 
(
proyectfollowup_id, project_id, followup_date, user_assigner, user_assingned, comment
) 
VALUES 
(
id, project_id, followup_date, user_assigner, user_assingned, comment
);
select LAST_INSERT_ID();
END$$

-- SP to get all projectfollowup by project id
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectFollowUpByProjectId$$
PROCEDURE `GetProjectFollowUpByProjectId`(
        IN project_id VARCHAR(20)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

SELECT * FROM blackstardb.projectfollowup 
	where project_id=project_id 
	order by followup_date asc;

END$$

-- SP to add new project tracking
DROP PROCEDURE IF EXISTS blackstarDb.AddProjectTracking$$
PROCEDURE `AddProjectTracking`(
        IN project_id VARCHAR(20),
        IN file_type VARCHAR(20),
        IN user VARCHAR(20),
        IN file_path VARCHAR(100),
        IN tracking_date VARCHAR(20)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

DECLARE id INT DEFAULT 0;
DECLARE count_rows INT DEFAULT 0;
SELECT COUNT(project_tracking_id) INTO count_rows from blackstardb.project_tracking;
IF count_rows > 0 THEN
	SELECT MAX(project_tracking_id) INTO id from blackstardb.project_tracking;
END IF;
SET id = id + 1;

INSERT INTO blackstardb.project_tracking 
(project_tracking_id, project_id, project_tracking_file_type, user, file_path, tracking_date) 
VALUES (id, project_id, file_type, user, file_path, tracking_date);

END$$

-- SP to get project status by project status id
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectStatusById$$
PROCEDURE `GetProjectStatusById`(
        IN status_id VARCHAR(3)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

SELECT * FROM blackstardb.projectstatus WHERE projectstatus_id=status_id;

END$$



-- SP for get all project_tracking records by project_id
DROP PROCEDURE IF EXISTS blackstarDb.GetProjectTrakingByProjectId$$
PROCEDURE `GetProjectTrakingByProjectId`(
        IN project_id vaRCHAR(20)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN


SELECT * FROM blackstardb.project_tracking 
	where project_id=project_id 
	order by tracking_date asc;

END$$

-- SP for get all warrant projects by status
DROP PROCEDURE IF EXISTS blackstarDb.GetAllWarrantProjectsByStatus$$
PROCEDURE `GetAllWarrantProjectsByStatus`(
        IN status_id VARCHAR(5)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	SELECT * FROM blackstardb.warrantProject wp 
	WHERE wp.status=status_id
	order by wp.updateDate asc;
END$$

-- SP for add new CostCenter into costcenter table
DROP PROCEDURE IF EXISTS blackstarDb.AddCostCenter$$
PROCEDURE `AddCostCenter`(
        IN costcenter_id vARCHAR(20),
        IN office_id CHAR(1)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

    INSERT INTO blackstardb.costcenter (costcenter_id, office_id) VALUES (costcenter_id, office_id); 

END$$

-- SP for find all CostCenter by officeId
DROP PROCEDURE IF EXISTS blackstarDb.GetAllCostCenterByOfficeId$$
PROCEDURE `GetAllCostCenterByOfficeId`(
        IN office_id CHAR(1)
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	SELECT costcenter.costcenter_id, costcenter.office_id 
    FROM blackstardb.costcenter
    WHERE costcenter.office_id = office_id;
END$$

DELIMITER ;

