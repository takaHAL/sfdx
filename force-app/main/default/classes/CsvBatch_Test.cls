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

    // 検証
  }
}
