@isTest
public with sharing class LeadProcessorTest {
  @testSetup
  static void setup() {
    List<Lead> leads = new List<Lead>();

    for (Integer i = 0; i < 200; i++) {
      leads.add(new Lead(LastName = 'LastName ' + i, Company = 'Company ' + i));
    }
    insert leads;
  }
  @isTest
  public static void test() {
    Test.startTest();
    LeadProcessor leadProcessor = new LeadProcessor();
    Id batchId = Database.executeBatch(leadProcessor);
    Test.stopTest();

    System.assertEquals(
      200,
      [SELECT COUNT() FROM Lead WHERE LeadSource = 'Dreamforce']
    );
  }
}
