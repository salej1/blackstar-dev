use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
  -- blackstarDb.DeleteOldProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteOldProjects$$
CREATE PROCEDURE blackstarDb.DeleteOldProjects()
BEGIN
   
    DELETE FROM workTeam WHERE codexProjectId IN (
        SELECT _id FROM codexProject WHERE created < '2015-1-1');
    DELETE FROM codexEntryItem WHERE entryId IN (
        SELECT _id FROM codexProjectEntry WHERE projectId IN (
            SELECT _id FROM codexProject WHERE created < '2015-1-1'));
    DELETE FROM codexProjectEntry WHERE projectId IN (
        SELECT _id FROM codexProject WHERE created < '2015-1-1');
    DELETE FROM codexPriceProposalItem WHERE priceProposalEntryId IN (
        SELECT _id FROM codexPriceProposalEntry WHERE priceProposalId IN(
            SELECT _id FROM codexPriceProposal WHERE projectId IN (
                SELECT _id FROM codexProject WHERE created < '2015-1-1')));
    DELETE FROM codexPriceProposalEntry WHERE priceProposalId IN (
        SELECT _id FROM codexPriceProposal WHERE projectId IN (
            SELECT _id FROM codexProject WHERE created < '2015-1-1'));
    DELETE FROM codexPriceProposal WHERE projectId IN (
        SELECT _id FROM codexProject WHERE created < '2015-1-1'); 
    DELETE FROM codexProject WHERE created < '2015-1-1';
   

END$$

CALL DeleteOldProjects()$$

DROP PROCEDURE IF EXISTS blackstarDb.DeleteOldProjects$$

DELIMITER ;