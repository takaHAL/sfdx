@isTest
public with sharing class AddPrimaryContactTest {
  @testSetup
  static void setup() {
    List<Account> accounts = new List<Account>();

    for (Integer i = 0; i < 100; i++) {
      if (i < 50) {
        accounts.add(
          new Account(Name = 'Test Account' + i, BillingState = 'NY')
        );
      } else {
        accounts.add(
          new Account(Name = 'Test Account' + i, BillingState = 'CA')
        );
      }
    }
    insert accounts;

    Contact contact = new Contact(LastName = 'Test Contact');
    insert contact;
  }

  @isTest
  public static void stateNY_Test() {
    Contact contact = [SELECT Id FROM Contact LIMIT 1];
    String state = 'NY';

    AddPrimaryContact addPrimaryContact = new AddPrimaryContact(contact, state);
    Test.startTest();
    System.enqueueJob(addPrimaryContact);
    Test.stopTest();
    System.assertEquals(
      50,
      [SELECT COUNT() FROM Contact WHERE Account.BillingState = :state],
      'Failed'
    );
  }
  @isTest
  public static void stateCA_Test() {
    Contact contact = [SELECT Id FROM Contact LIMIT 1];
    String state = 'CA';

    AddPrimaryContact addPrimaryContact = new AddPrimaryContact(contact, state);
    Test.startTest();
    System.enqueueJob(addPrimaryContact);
    Test.stopTest();
    System.assertEquals(
      50,
      [SELECT COUNT() FROM Contact WHERE Account.BillingState = :state],
      'Failed'
    );
  }
}
