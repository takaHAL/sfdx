public with sharing class AddPrimaryContact implements Queueable {
  private Contact contact;
  private String state;
  public AddPrimaryContact(Contact contact, String state) {
    this.contact = contact;
    this.state = state;
  }
  public void execute(QueueableContext context) {
    List<Contact> contacts = new List<Contact>();
    for (Account account : [
      SELECT Id
      FROM Account
      WHERE BillingState = :state
      LIMIT 200
    ]) {
      Contact cContact = contact.clone(false, false, false, false);
      cContact.AccountId = account.Id;
      cContact.LastName = 'Test LastName';
      contacts.add(cContact);
    }

    if (!contacts.isEmpty()) {
      insert contacts;
    }
  }
}
