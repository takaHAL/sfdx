@isTest
public with sharing class CsvBatch_Test {
  @testSetup
  static void setup() {
    // テスト用のレコードを生成
    Contact contact = new Contact(LastName = 'Test Contact');
    insert contact;
  }

  @isTest
  static void CsvBatch_Test() {
    Test.startTest();
    CsvBatch batch = new CsvBatch('Contact');
    Database.executeBatch(batch);
    Test.stopTest();

    List<ContentWorkspace> libraries = [
      SELECT Id, Name
      FROM ContentWorkspace
      WHERE Name = 'ApexResults'
      LIMIT 1
    ];
    System.assert(!libraries.isEmpty(), 'library not found');

    List<ContentVersion> documents = [
      SELECT Title
      FROM ContentVersion
      WHERE Title LIKE '%Contact%'
    ];
    System.assertEquals(2, documents.size(), 'csv not found');
  }
}
