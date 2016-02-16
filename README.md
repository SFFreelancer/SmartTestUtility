### Welcome to Salesforce Smart Test Utility.
>The Purpose of this repository is to save your huge time  and allow you to replace tens of lines of object creation with a mere handful ones.
This is done through Salesforce test data generator that populates the lookup, master-detail relationships and required fields.

### Why to write a smart test methods
>How often have you wasted hours reverse-engineering a new schema just to create data for a unit test?
>And as all good force.com developers know, you should not rely on existing system data for your tests to work with, but inserting records into a foreign org which could have any number of unexpected validation rules and required fields makes for a lot of extra code, or a high risk of test failure. There are many ways to include data for tests, including through static resources, but every method has its own peculiarities. 


### How the SmartTestUtility Class will be helpful:

>SmartTestUtility dynamically used to describe metadata for populating all  the required fields with valid data and creating any related objects and provide a recursion limit for lookup to the same object type upto 5 levels

#####Multiple Method Overloading to provide multiple option to access the SmartTestUtility Class methods
```javascript
public static sObject createTestRecord(String sObjectType)
    {
        return createTestRecord(sObjectType, true);
    }
    
    public static sObject createTestRecord(Schema.sObjectType sObjectType)
    {
        return createTestRecord(sObjectType, true);
    }
    
    public static sObject createTestRecord(String sObjectType, Boolean doInsert)
    {
        return createTestRecord(sObjectType, doInsert, null);    
    }
    
    public static sObject createTestRecord(Schema.sObjectType sObjectType, Boolean doInsert)
    {
        return createTestRecord(sObjectType, doInsert, null);
    }
    
    public static sObject createTestRecord(String sObjectType, Boolean doInsert, Map<String,Object> recordDefaultValueMap)
    {
        List<sObject> testRecordList = createTestRecordList(sObjectType, 1, doInsert, new List<Map<String,Object>>{ recordDefaultValueMap });
        return testRecordList[0];    
    }
    
    public static sObject createTestRecord(Schema.sObjectType sObjectType, Boolean doInsert, Map<String,Object> recordDefaultValueMap)
    {
        List<sObject> testRecordList = createTestRecordList(String.valueOf(sObjectType), 1, doInsert, new List<Map<String,Object>>{ recordDefaultValueMap });
        return testRecordList[0];
    }    
    
    public static List<sObject> createTestRecordList(String sObjectType, Integer numberOfRecords)
    {
        return createTestRecordList(sObjectType, numberOfRecords, true);
    }
    
    public static List<sObject> createTestRecordList(Schema.sObjectType sObjectType, Integer numberOfRecords)
    {
        return createTestRecordList(String.valueOf(sObjectType), numberOfRecords);
    }
    
    public static List<sObject> createTestRecordList(String sObjectType, Integer numberOfRecords, Boolean doInsert)
    {
        return createTestRecordList(sObjectType, numberOfRecords, doInsert, null);    
    }
    
    public static List<sObject> createTestRecordList(Schema.sObjectType sObjectType, Integer numberOfRecords, Boolean doInsert)
    {
        return createTestRecordList(String.valueOf(sObjectType), numberOfRecords, doInsert);
    }
    public static List<sObject> createTestRecordList(String sObjectType, Integer numberOfRecords, Boolean doInsert, List<Map<String,Object>> recordDefaultValueMap)
    {
        return createTestRecordList(sObjectType, numberOfRecords, doInsert, recordDefaultValueMap, 0);
    }    
    
    public static List<sObject> createTestRecordList(Schema.sObjectType sObjectType, Integer numberOfRecords, Boolean doInsert, List<Map<String,Object>> recordDefaultValueMap)
    {
        return createTestRecordList(String.valueOf(sObjectType), numberOfRecords, doInsert, recordDefaultValueMap, 0);
    }    
    
    public static Map<String, Schema.SObjectField> getFieldMapFor(String sObjectType)
    {
        return fieldMapFor(sObjectType);
    }
    
    public static Map<String, Schema.SObjectField> getFieldMapFor(Schema.sObjectType sObjectType)
    {
        return getFieldMapFor(String.valueOf(sObjectType));
    }   
``` 

####Line Usage

#####Simple line to create objects:
```javascript
Account account = (Account)SmartTestUtility.createTestRecord('Account');
                              OR
Account account = (Account)SmartTestUtility.createTestRecord(Schema.Account.sObjectType);
```

#####Simple line to create multiple object records (it will help you while bulk testing):

```javascript
List<Account> accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType,Integer numberOfRecords);
                              OR
List<Account> accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType,Integer numberOfRecords);
```

####Additional Options

#####To fill all fields for Test Records:
```javascript
SmartTestUtility.FillAllFields = true;
```
#####To get System Administrator Profile

```javascript
Profile adminProfile = SmartTestUtility.ADMIN_PPROFILE;
```
#####Get Current User Record:

```javascript
User currentUser = SmartTestUtility.CURRENT_USER;
```

#####Get Admin User Record:

```javascript
User adminUser = SmartTestUtility.ADMIN_USER;
```

#####To define default Country and State / CountryCode and StateCode ( CountryState Picklist Enabled Organizations)
```javascript
SmartTestUtility.DefaultCountry = 'India';
SmartTestUtility.DefaultCountryCode = 'IN';
SmartTestUtility.DefaultState = 'Maharashtra';
SmartTestUtility.DefaultStateCode = 'MH';
```
#####To perform Database operation with Assert:

```javascript

// For Single Record.
Database.SaveResult insertSaveResult = SmartTestUtility.insertWithAssert(sObjectRecord); 

Database.SaveResult updateSaveResult = SmartTestUtility.updateWithAssert(sObjectRecord);

Database.Upsertresult upsertResult = SmartTestUtility.upsertWithAssert(sObjectRecord);

Database.DeleteResult deleteResult = SmartTestUtility.deleteWithAssert(sObjectRecord);

// For List of sObject

Database.SaveResult[] insertSaveResult = SmartTestUtility.insertListWithAssert(sObjectRecord); 

Database.SaveResult[] updateSaveResult = SmartTestUtility.updateListWithAssert(sObjectRecord);

Database.DeleteResult[] deleteResult = SmartTestUtility.deleteListWithAssert(sObjectRecord);
```
##### To Get the Fields of Objects

```javascript
Map<String, Schema.SObjectField> accountFieldMap = SmartTestUtility.getFieldMapFor('Account');
```


### Support or Contact
Having trouble with Pages? Check out the [Blog](isalesforcestuff.blogspot.com/2016/02/smart-way-to-write-test-methods.html)
