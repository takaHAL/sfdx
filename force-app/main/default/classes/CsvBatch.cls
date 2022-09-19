public with sharing class CsvBatch implements Database.Batchable<SObject>, Database.Stateful {
  private String objectName;
  private Map<String, String> fields;

  public CsvBatch(String objectName) {
    this.objectName = objectName;
  }

  private String objectCsvColumnHeader;
  private String schemaCsvColumnHeader;
  private List<String> objectCsvRowValues = new List<String>();
  private List<String> schemaCsvRowValues = new List<String>();

  public Database.QueryLocator start(Database.BatchableContext bc) {
    fields = getFields(objectName);
    String columns = String.join(new List<String>(this.fields.keySet()), ', ');

    String query = 'SELECT ' + columns + ' FROM ' + objectName;

    return Database.getQueryLocator(query);
  }

  public void execute(Database.BatchableContext bc, List<SObject> records) {
    // 取得したレコードでCSVの行を作成
    // 例） '0015i00000KcklhAAB',false,'Sample Account for Entitlements'
    for (SObject record : records) {
      List<String> row = new List<String>();
      for (String filedName : fields.keySet()) {
        if (record.get(filedName) != null) {
          row.add(String.valueOf(record.get(filedName)).escapeCsv());
        } else {
          row.add('');
        }
      }
      objectCsvRowValues.add(String.join(row, ','));
    }

    // 項目のAPI参照名、ラベルでCSVの行を作成
    schemaCsvColumnHeader = String.join(
      new List<String>{ 'DeveloperName', 'Name' },
      ', '
    );
    List<String> fieldNames = new List<String>();
    for (String filedName : fields.keySet()) {
      List<String> row = new List<String>();
      row.add(filedName.escapeCsv());
      row.add(fields.get(filedName).escapeCsv());

      schemaCsvRowValues.add(String.join(row, ','));
      fieldNames.add(filedName.escapeCsv());
    }

    // オブジェクトの項目名でCSVのヘッダーを作成
    objectCsvColumnHeader = String.join(fieldNames, ', ');
  }

  public void finish(Database.BatchableContext bc) {
    // 保存先ライブラリの情報取得
    List<ContentWorkspace> libraries = [
      SELECT Id, Name
      FROM ContentWorkspace
      WHERE Name = 'ApexResults'
      LIMIT 1
    ];

    if (libraries.isEmpty()) {
      System.debug('保存先ライブラリーが見つかりません。');
    } else {
      List<ContentVersion> documents = new List<ContentVersion>();
      // 項目のAPI参照名、ラベルのCSVを作成
      String schemaCsvFile =
        schemaCsvColumnHeader +
        '\n' +
        String.join(schemaCsvRowValues, '\n');
      ContentVersion schemaDoc = new ContentVersion(
        Title = objectName + '-Schema',
        PathOnClient = objectName + '-Schema' + '.csv',
        VersionData = Blob.valueOf(schemaCsvFile),
        FirstPublishLocationId = libraries[0].Id
      );
      documents.add(schemaDoc);

      // レコード情報をCSVに
      String objectCsvFile =
        objectCsvColumnHeader +
        '\n' +
        String.join(objectCsvRowValues, '\n');
      ContentVersion objectDoc = new ContentVersion(
        Title = objectName,
        PathOnClient = objectName + '.csv',
        VersionData = Blob.valueOf(objectCsvFile),
        FirstPublishLocationId = libraries[0].Id
      );
      documents.add(objectDoc);

      // ContentVersionにCSVのデータを保存
      insert documents;
    }
  }

  // 指定したオブジェクトの項目のAPI参照名を返す
  // API参照名をキー、ラベルを値
  private Map<String, String> getFields(String objectName) {
    Map<String, String> fields = new Map<String, String>();

    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
    Schema.DescribeSObjectResult describeObject = objectType.getDescribe();

    Map<String, Schema.SObjectField> schemaFields = describeObject.fields.getMap();

    for (Schema.SObjectField schemaField : schemaFields.values()) {
      fields.put(
        schemaField.getDescribe().getName(),
        schemaField.getDescribe().getLabel()
      );
    }

    return fields;
  }
}
