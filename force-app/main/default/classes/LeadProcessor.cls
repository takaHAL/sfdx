public with sharing class LeadProcessor implements Database.Batchable<sObject>, Database.Stateful {
  // instance member to retain state across transactions
  public Integer recordsProcessed = 0;
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT Id FROM Lead');
  }
  public void execute(Database.BatchableContext bc, List<Lead> scope) {
    for (Lead lead : scope) {
      lead.LeadSource = 'Dreamforce';
    }

    if (!scope.isEmpty()) {
      update scope;
    }
  }
  public void finish(Database.BatchableContext bc) {
    System.debug(recordsProcessed + ' records processed.');
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];
  }
}
