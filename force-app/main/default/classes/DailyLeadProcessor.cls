public with sharing class DailyLeadProcessor implements Schedulable {
  public void execute(SchedulableContext ctx) {
    List<Lead> leads = [
      SELECT Id, LeadSource
      FROM Lead
      WHERE LeadSource = NULL
      ORDER BY CreatedDate ASC
      LIMIT 200
    ];
    for (Lead lead : leads) {
      lead.LeadSource = 'Dreamforce';
    }

    if (!leads.isEmpty()) {
      update leads;
    }
  }
}
