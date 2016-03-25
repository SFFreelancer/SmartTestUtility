/*
Implemented By: Shrikant Bagal.
Implemented On: 13-02-2016.
Purpose: To Create a smart Test Data.
Email:- srbagal.ceo@gmail.com
*/
@isTest
public with sharing class SmartTestUtility {
    
    // Private Members
    private static final Map<String, Map<String, Schema.SObjectField>> FieldMapCache = new Map<String, Map<String, Schema.SObjectField>>();
    private static final Map<String, Schema.SObjectType> GlobalDescribe = Schema.getGlobalDescribe();
    private static final Map<String, String> DefaultPicklistValueCache = new Map<String, String>();
    private static String m_defaultCountry = 'United States';
    private static String m_defaultCountryCode = 'US';
    private static String m_defaultState = 'New York';
    private static String m_defaultStateCode = 'NY';
    private static Boolean m_fillAllFields = false;
    private static Integer m_recordDepth = 1;  
    private static Integer recordDepthCount = 0;
    private static Map<String,Integer> recordDepthCountMap = new Map<String,Integer>();
    //Public Members
    public static Integer RecordDepth { set { if(value < 5) m_recordDepth = value; } get { return m_recordDepth; } }
    public static Boolean FillAllFields { set { m_fillAllFields = value; } get { return m_fillAllFields; } }    
    
    // Admin User Profile ID
    public static final Profile ADMIN_PPROFILE = [Select Id from Profile where Name = 'System Administrator' LIMIT 1];
    
    // User
    public static final User CURRENT_USER = [SELECT Id, Alias, Email, Lastname, FirstName,ProfileId, UserName, CommunitynickName,CompanyName FROM user WHERE Id = :UserInfo.getUserId() LIMIT 1];
    public static final User ADMIN_USER = [SELECT Id, Name, Email FROM User WHERE Profile.Name ='System Administrator' AND IsActive = true LIMIT 1];
    public static final UserRole CEO_ROLE = [SELECT Id FROM UserRole WHERE Name = 'CEO' LIMIT 1];
    public static final Group ORG_GROUP = [SELECT Id FROM Group LIMIT 1];
    // Default Country and State
    // When Country and State Picklists are enabled, cannot dynamically resolve which States are within a Country
    public static String DefaultCountry { set { m_defaultCountry = value; } get { return m_defaultCountry; } }
    public static String DefaultCountryCode { set { m_defaultCountryCode = value; } get { return m_defaultCountryCode; } }
    public static String DefaultState { set { m_defaultState = value; } get { return m_defaultState; } }
    public static String DefaultStateCode { set { m_defaultStateCode = value; } get { return m_defaultStateCode; } }
    
    
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
    
    // Private Members   
    
    private static List<sObject> createTestRecordList(String sObjectType, Integer numberOfRecords, Boolean doInsert, List<Map<String,Object>> recordDefaultValueMapList,Integer depth)
    {
        List<sObject> sObjectList = new List<sObject>();        
        Map<String,Schema.DescribeFieldResult> requiredFieldMap = getNullabelRequiredFields(sObjectType);
        sObject record = null;
        system.debug('Depth: Sobject :: '+ sObjectType + ':: '+ depth);
        Schema.SObjectType sObjectTypeRequested = GlobalDescribe.get(sObjectType);
        for(integer recordCount = 0; recordCount < numberOfRecords; recordCount++){
            record = sObjectTypeRequested.newSobject();
            Map<String, Object> recordValuesMap;
            system.debug(':: recordDefaultValueMapList :: '+ recordDefaultValueMapList);
            if(recordDefaultValueMapList != null && recordCount < recordDefaultValueMapList.size()){
                recordValuesMap = recordDefaultValueMapList[recordCount];
            }
            system.debug(':: recordValuesMap :: '+ recordValuesMap);
            if(recordValuesMap != null && !recordValuesMap.isEmpty()){
                for(String strUserField : recordValuesMap.keySet()){                    
                    record.put(strUserField.trim(),recordValuesMap.get(strUserField));
                }   
            }
			system.debug(':: :: '+ record);            
            for(String strField : requiredFieldMap.keySet()){
                if(recordValuesMap == null || recordValuesMap.isEmpty() || !recordValuesMap.containsKey(strField))
                {                    
                    try{
                        if(!recordDepthCountMap.containsKey(strField))
                            recordDepthCountMap.put(strField,depth);
                        record.put(strField,getFieldValue(record, requiredFieldMap.get(strField), depth));    
                    }catch(Exception ex){
                        system.debug(':: Exception :: '+ ex);
                        system.debug(':: Exception StackTrace:: '+ ex.getStackTraceString());
                        system.debug(':: strField :: '+ strField);
                    }
                }
            }          
            sObjectList.add(record);
        }
        if(doInsert)
            InsertListWithAssert(sObjectList);  
        system.debug('sObjectList :: ' + sObjectList);
        return sObjectList;
    }
    
    static String RandomStringValue(Integer Length)
    { 
        String strValue = 'TestValue' + math.rint( math.random() * 100000 ); 
        if(Length != null && strValue.length() > Length)
        {
            strValue = strValue.substring(0, Length);
        }
        return strValue;
    }
    
    static Object getFieldValue(sObject sObjectRecord, Schema.DescribeFieldResult fieldDescribe, Integer depth)
    {        
        Object FieldValue = null;        
        if(fieldDescribe != null){
            Schema.DisplayType displayType = fieldDescribe.getType();
            if (fieldDescribe.getName().endsWith('Country')) {
                FieldValue = DefaultCountry;
            } 
            else if (fieldDescribe.getName().endsWith('State')) {
                FieldValue = DefaultState;
            } 
            else if (fieldDescribe.getName().endsWith('CountryCode')) {
                FieldValue = DefaultCountryCode;
            } 
            else if (fieldDescribe.getName().endsWith('StateCode')) {
                FieldValue = DefaultStateCode;
            }
             else if(fieldDescribe.getName() == 'EmailEncodingKey')
            {
                FieldValue = 'ISO-8859-1';
            }
            else if(fieldDescribe.getName() == 'LanguageLocaleKey' || fieldDescribe.getName() == 'LocaleSidKey')
            {
                FieldValue = 'en_US';
            }
            else if(fieldDescribe.getName() == 'TimeZoneSidKey')
            {
               FieldValue = 'America/Los_Angeles';
            }
            else if(displayType.equals(Schema.DisplayType.Email)){ 
                FieldValue = RandomStringValue(null) +'@email.com';
            }
            else if(displayType.equals(Schema.DisplayType.DATETIME)){
                FieldValue = DateTime.now();
            }            
            else if(displayType.equals(Schema.DisplayType.URL)){
                FieldValue = 'https://'+ RandomStringValue(null) +'.com';
            }
            else if(displayType.equals(Schema.DisplayType.TIME)){
                FieldValue = Time.newInstance(12, 00, 00, 00);
            }
            else if(displayType.equals(Schema.DisplayType.BASE64))
            {
                FieldValue = Blob.valueOf(RandomStringValue(null));
            }
            else if (displayType.equals(Schema.DisplayType.Currency) || displayType.equals(Schema.DisplayType.Double)) {
                FieldValue = math.rint( math.random() * fieldDescribe.getDigits() );                
            }
            else if(displayType.equals(Schema.DisplayType.INTEGER) || displayType.equals(Schema.DisplayType.Percent))
            {
                FieldValue = Integer.valueOf(math.rint( math.random() * fieldDescribe.getDigits()));  
            }            
            else if (displayType.equals(Schema.DisplayType.MULTIPICKLIST) || displayType.equals(Schema.DisplayType.PICKLIST)) {
                FieldValue = getDefaultPicklistValue(sObjectRecord, fieldDescribe);
            }            
            else if (fieldDescribe.getName() == 'CommunityNickname' && displayType.equals(Schema.DisplayType.STRING)) { 
                FieldValue = 'test'+ string.valueof(math.roundtolong(math.random()*1000000)); 
            } 
            else if (fieldDescribe.getName() == 'UserName' && displayType.equals(Schema.DisplayType.STRING)) { 
                FieldValue = 'test'+ string.valueof(Userinfo.getOrganizationId())+ string.valueof(math.roundtolong(math.random()*1000000))+ string.valueof(Datetime.now()).replace('-','').replace(':','').replace(' ','')+'@test.com';
            }  
            else if(displayType.equals(Schema.DisplayType.STRING) || displayType.equals(Schema.DisplayType.TEXTAREA) || displayType.equals(Schema.DisplayType.ENCRYPTEDSTRING)){
                FieldValue = RandomStringValue(fieldDescribe.getLength());
            }
            else if(displayType.equals(Schema.DisplayType.Date))
            {
                FieldValue = Date.today();
            }            
            else if(displayType.equals(Schema.DisplayType.Phone))
            {
                FieldValue = '987654321';
            }
            else if(displayType.equals(Schema.DisplayType.Reference))
            {   
                String referenceObjectType = fieldDescribe.getReferenceTo()[0].getDescribe().getName(); 
                if (referenceObjectType == 'RecordType') {
                    FieldValue = setRecordType(sObjectRecord);                   
                }else if (referenceObjectType == 'Profile') { 
                    FieldValue = ADMIN_PPROFILE.Id;
                }
                else if(referenceObjectType == 'UserRole')
                {
                    FieldValue = CEO_ROLE.Id;
                }
                else if(fieldDescribe.getName() == 'DelegatedApproverId' && sObjectRecord.getSObjectType().getDescribe().getName() == 'User')
                {
                    FieldValue = ADMIN_USER.Id;
                }
                else if(referenceObjectType == 'Group')
                {
                    FieldValue = ORG_GROUP.Id;
                }  
                else if((referenceObjectType == 'Contact' || referenceObjectType == 'Account') && sObjectRecord.getSObjectType().getDescribe().getName() == 'User')
                {
                    // Does not fill the contact and Account for user as its only for Portal User.
                }
                else if(sObjectRecord.getSObjectType().getDescribe().getName() != 'BusinessHours' && (RecordDepth + 1)  > depth) {                    
                    depth = recordDepthCountMap.get(fieldDescribe.getName());
                    depth = depth + 1;
                    recordDepthCountMap.put(fieldDescribe.getName(),depth);
                    sObject referenceRecord = createTestRecordList(referenceObjectType, 1, true, null, depth)[0];
                    FieldValue = referenceRecord.Id;
                }
            }
        }        
        return FieldValue;
    }
    
    static Map<String, Schema.SObjectField> fieldMapFor(String objectType) {
        Map<String, Schema.SObjectField> fieldMap = null;
        String normalizedObjectType = objectType.toLowerCase();
        if (FieldMapCache.containsKey(normalizedObjectType)) {
            fieldMap = FieldMapCache.get(normalizedObjectType);
        } else {
            fieldMap = GlobalDescribe.get(objectType).getDescribe().fields.getMap();
            // cache it for next use
            FieldMapCache.put(normalizedObjectType, fieldMap);
        }
        return fieldMap;
    }
    
    static String getDefaultPicklistValue(SObject obj, Schema.DescribeFieldResult fieldDescribe) {
        String key = obj.getSObjectType() + '.' + fieldDescribe.getName();
        
        if (!DefaultPicklistValueCache.containsKey(key)) {
            List<Schema.PicklistEntry> entries = fieldDescribe.getPicklistValues();
            String value = null;
            for(Schema.PicklistEntry entry : entries)
            {
                if(entry.isActive() && entry.isDefaultValue())
                    value = entry.getValue();
            }
            DefaultPicklistValueCache.put(key, value);
        }
        return DefaultPicklistValueCache.get(key);
    }
    
    static Id setRecordType(SObject obj) {
        List<Schema.RecordTypeInfo> recordTypes = obj.getSObjectType().getDescribe().getRecordTypeInfos();		      
        if (recordTypes.size() > 1) { // all objects have default Master type
            //System.debug('RecordTypes ' + recordTypes);
            for (Schema.RecordTypeInfo recordType : recordTypes) {
                if (recordType.isAvailable() && recordType.isDefaultRecordTypeMapping()) {
                    return recordType.getRecordTypeId();
                }
            }
        }
        return null;
    }
    
    // <summary>
    // Created By: Shrikant Bagal.
    // Created On: 13-02-2016.
    // Purpose: To Get the Required Fields from sObject.
    // Parameters:
    // 1. sObjectTypeRequested: sObject Type to get Required Fields.    
    // Return type: List Field Describe Object of required Fields.
    public static Map<String,Schema.DescribeFieldResult> getNullabelRequiredFields(String sObjectType){
        Map<String,Schema.DescribeFieldResult> describeFieldMap = new Map<String,Schema.DescribeFieldResult>();
        Map<String,Schema.SObjectField> fieldsMap = fieldMapFor(sObjectType);
        for(Schema.SObjectField field : fieldsMap.values()){
            Schema.DescribeFieldResult fieldMetadata = field.getDescribe();
            //system.debug(':: '+ fieldMetadata.getName() + '::' + fieldMetadata.IsCreateable());
            if(fieldMetadata.IsCreateable() && (!fieldMetadata.IsNillable() || FillAllFields) && !fieldMetadata.IsDefaultedOnCreate() ){
                describeFieldMap.put(fieldMetadata.getName(),fieldMetadata);
            }
        }
        return describeFieldMap;
    }
    
    
    /* Database Operations */
    // Insert Single Record and Assert.
    public static Database.SaveResult insertWithAssert( sObject dataObject)
    {
        Database.SaveResult saveResult = Database.insert( dataObject);
        System.assert( saveResult.isSuccess());
        return saveResult;
    }
    
    // Update Single Record and Assert.
    public static Database.SaveResult updateWithAssert( sObject dataObject)
    {
        Database.SaveResult saveResult = Database.update( dataObject);
        System.assert( saveResult.isSuccess());
        return saveResult;
    }
    
    // Upsert Single Record and Assert.
    public static Database.Upsertresult upsertWithAssert( sObject dataObject)
    {
        Database.Upsertresult upsertResult = Database.upsert( dataObject);
        System.assert( upsertResult.isSuccess());
        return upsertResult;
    }
    
    // Delete single Record and Assert.
    public static Database.DeleteResult deleteWithAssert( sObject dataObject)
    {
        Database.DeleteResult deleteResult = Database.delete( dataObject);
        System.assert( deleteResult.isSuccess());
        return deleteResult;
    }
    
    // Insert List of records and Assert.
    public static Database.SaveResult[] insertListWithAssert( List<sObject> sObjectsList)
    {
        system.debug(':: sObjectsList :: '+ sObjectsList);
        Database.SaveResult[] arrSaveResult;
        if(sObjectsList[0].getSObjectType() == Schema.User.sObjectType)
        {
        	System.runAs(ADMIN_USER)
            {
                arrSaveResult = Database.insert( sObjectsList);
            }
        }
        else{
            arrSaveResult = Database.insert( sObjectsList);
        }
        for(Database.SaveResult saveResult : arrSaveResult)
            System.assert( saveResult.isSuccess());
        return arrSaveResult;
    }
    
    // Update List of Records with Assert.
    public static Database.SaveResult[] updateListWithAssert( List<sObject> sObjectsList)
    {
        Database.SaveResult[] arrUpdateResult = Database.update( sObjectsList);
        for(Database.SaveResult saveResult : arrUpdateResult)
            System.assert( saveResult.isSuccess());
        return arrUpdateResult;
    }
    
    //Delete List of records with Assert.
    public static Database.DeleteResult[] deleteListWithAssert( List<sObject> sObjectsList)
    {
        Database.DeleteResult[] arrDeleteResult = Database.delete( sObjectsList);
        for(Database.DeleteResult deleteResult : arrDeleteResult)
            System.assert( deleteResult.isSuccess());
        return arrDeleteResult;
    }        
}
