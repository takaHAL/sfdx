public with sharing class AccountTriggerHandler {
  public static void CreateAccounts(List<Account> accounts) {
    List<Account> newAccounts = new List<Account>();

    for (Account a : accounts) {
      a.ShippingState = a.BillingState;
    }
  }
}
