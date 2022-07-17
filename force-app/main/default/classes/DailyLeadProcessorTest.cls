@isTest
public with sharing class DailyLeadProcessorTest {
  @TestSetup
  static void setup() {
    List<Lead> leads = new List<Lead>();
    for (Integer i = 0; i < 200; i++) {
      Lead lead = new Lead(
        LastName = 'Lead ' + i,
        Company = 'Company ' + i,
        LeadSource = null
      );
      leads.add(lead);
    }
    insert leads;
  }

  @isTest
  public static void testScheduledJob() {
    String CRON_EXP = '0 0 0 15 3 ? 2023';
    List<Lead> leads = [SELECT Id FROM Lead];
    List<Id> ids = new List<Id>(new Map<Id, Lead>(leads).keySet());
    Test.startTest();
    // Schedule the test job
    String jobId = System.schedule(
      'DailyLeadProcessor',
      CRON_EXP,
      new DailyLeadProcessor()
    );
    Test.stopTest();
    leads = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
    System.assertEquals(200, leads.size(), 'failed');
  }
}
