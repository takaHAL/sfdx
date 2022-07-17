@isTest
public with sharing class AccountTriggerTest {
  @TestSetup
  static void setup() {
    List<Account> accts = new List<Account>();
    for (Integer i = 0; i < 200; i++) {
      Account acct = new Account(
        Name = 'Test Account ' + i,
        BillingState = 'CA'
      );
      accts.add(acct);
    }
    insert accts;
  }
  @isTest
  public static void createAccountsTest() {
    String checkState = 'CA';
    List<Account> verifyAccts = [
      SELECT Id
      FROM Account
      WHERE BillingState = :checkState AND ShippingState = :checkState
    ];

    System.assertEquals(
      verifyAccts.size(),
      200,
      'BillingState ShippingState not equal'
    );
  }
}
