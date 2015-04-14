use blackstarDb;

DELIMITER $$


-- -----------------------------------------------------------------------------
  -- blackstarDb.DeleteOldProjects
-- -----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS blackstarDb.DeleteOldProjects$$
CREATE PROCEDURE blackstarDb.DeleteOldProjects()
BEGIN
   
    DELETE FROM workTeam WHERE codexProjectId IN (
        13);
    DELETE FROM codexEntryItem WHERE entryId IN (
        SELECT _id FROM codexProjectEntry WHERE projectId IN (
            13));
    DELETE FROM codexProjectEntry WHERE projectId IN (
        13);
    DELETE FROM codexPriceProposalItem WHERE priceProposalEntryId IN (
        SELECT _id FROM codexPriceProposalEntry WHERE priceProposalId IN(
            SELECT _id FROM codexPriceProposal WHERE projectId IN (
                13)));
    DELETE FROM codexPriceProposalEntry WHERE priceProposalId IN (
        SELECT _id FROM codexPriceProposal WHERE projectId IN (
            13));
    DELETE FROM codexPriceProposal WHERE projectId IN (
        13); 
    DELETE FROM followUp WHERE codexProjectId IN (
        13); 
    DELETE FROM codexDeliverableTrace WHERE codexProjectId IN (
        13); 
    DELETE FROM codexProject WHERE _id IN (
        13); 
   

END$$

CALL DeleteOldProjects()$$

DROP PROCEDURE IF EXISTS blackstarDb.DeleteOldProjects$$

DELIMITER ;