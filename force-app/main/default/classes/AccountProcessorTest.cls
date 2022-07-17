@isTest
public with sharing class AccountProcessorTest {
  @TestSetup
  static void setup() {
    Account account = new Account(Name = 'Test');
    insert account;

    Contact contact = new Contact(LastName = 'Test', AccountId = account.Id);
    insert contact;
  }

  @isTest
  public static void countContactsTest() {
    List<Account> accounts = [SELECT Id FROM Account];
    List<Id> ids = new List<Id>(new Map<Id, Account>(accounts).keySet());

    Test.startTest();
    AccountProcessor.countContacts(ids);
    Test.stopTest();

    Account account = [
      SELECT Number_of_Contacts__c
      FROM Account
      WHERE Id IN :ids
      LIMIT 1
    ];

    System.assertEquals(
      account.Number_of_Contacts__c,
      1,
      'Number_of_Contacts__c not count'
    );
  }
}
