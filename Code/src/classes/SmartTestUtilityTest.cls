/*
Implemented By: Shrikant Bagal.
Implemented On: 13-02-2016.
Purpose: To verify the SmartTestUtility Class.
Email:- srbagal.ceo@gmail.com
*/
@isTest(SeeAllData=false)
private class SmartTestUtilityTest {
    
    /*--------- Verify for Object Name as String ---------- */
    
    // Verify only required fields are get filled.
    static testMethod void createsSingleObjectWithRequiredStringField() {
        SmartTestUtility.FillAllFields = false;
		Account account = (Account)SmartTestUtility.createTestRecord('Account');		
		System.assert(account.Id != null);
		System.assert(account.Name != null);
        System.assert(account.ParentId == null);
	}
    
    //Verify that Sibgle Depth AccountId lookup and ParentId is Filled.
    static testMethod void createsObjectWithSetsLookupWithSingleDepthField() {        
        SmartTestUtility.FillAllFields = true;
        System.Test.startTest();        
		Contact contact = (Contact)SmartTestUtility.createTestRecord('Contact');        
        Account InnerAccount = [SELECT ParentId FROM Account Where Id=:contact.AccountId];
        System.Test.stopTest();
		System.assert(contact.Id != null);
		System.assert(InnerAccount.ParentId != null);
	}
    
    //verify Dafault Country and State
    static testMethod void createsObjectWithUserDefinedCountryState() {        
        SmartTestUtility.FillAllFields = true;
        SmartTestUtility.DefaultCountry = 'India';
        SmartTestUtility.DefaultCountryCode = 'IN';
        SmartTestUtility.DefaultState = 'MAHARASHTARA';
        SmartTestUtility.DefaultStateCode = 'MH';
        System.Test.startTest();        
		Contact contact = (Contact)SmartTestUtility.createTestRecord('Contact');
        System.Test.stopTest();
		System.assert(contact.Id != null);
		System.assertEquals('India', contact.MailingCountry);
        System.assertEquals('MAHARASHTARA', contact.MailingState);
	}
    
    // Get Record without Insertion.
    static testMethod void createRecordWithoutInsertion() {
        SmartTestUtility.FillAllFields = false;
		Account account = (Account)SmartTestUtility.createTestRecord('Account',false);		
		System.assert(account.Id == null);
		System.assert(account.Name != null);       
	}
    
    /*------------- Verify sObject as Schema.sObjectType ---------------*/
    
    // Verify only required fields are get filled.
    static testMethod void createsSingleObjectWithRequiredStringFieldsObjectType() {
        SmartTestUtility.FillAllFields = false;
		Account account = (Account)SmartTestUtility.createTestRecord(Schema.Account.sObjectType);		
		System.assert(account.Id != null);
		//System.assert(account.Name != null);
        ///System.assert(account.ParentId == null);
	}
    
    //Verify that Sibgle Depth AccountId lookup and ParentId is Filled.
    static testMethod void createsObjectWithSetsLookupWithSingleDepthFieldsObjectType() {        
        SmartTestUtility.FillAllFields = true;
        System.Test.startTest();        
		Contact contact = (Contact)SmartTestUtility.createTestRecord(Schema.Contact.sObjectType);        
        Account InnerAccount = [SELECT ParentId FROM Account Where Id=:contact.AccountId];
        System.Test.stopTest();
		System.assert(contact.Id != null);
		System.assert(InnerAccount.ParentId != null);
	}
    
    //verify Dafault Country and State
    static testMethod void createsObjectWithUserDefinedCountryStatesObjectType() {        
        SmartTestUtility.FillAllFields = true;
        SmartTestUtility.DefaultCountry = 'India';
        SmartTestUtility.DefaultCountryCode = 'IN';
        SmartTestUtility.DefaultState = 'MAHARASHTARA';
        SmartTestUtility.DefaultStateCode = 'MH';
        System.Test.startTest();        
		Contact contact = (Contact)SmartTestUtility.createTestRecord(Schema.Contact.sObjectType);
        System.Test.stopTest();
		System.assert(contact.Id != null);
		System.assertEquals('India', contact.MailingCountry);
        System.assertEquals('MAHARASHTARA', contact.MailingState);
	}
    
    // Get Record without Insertion.
    static testMethod void createRecordWithoutInsertionsObjectType() {
        SmartTestUtility.FillAllFields = false;
		Account account = (Account)SmartTestUtility.createTestRecord(Schema.Account.sObjectType,false);		
		System.assert(account.Id == null);        
		System.assert(account.Name != null);       
	}
    
    // Get Record without Insertion.
    static testMethod void createRecordUsersObjectType() {
        SmartTestUtility.FillAllFields = true;
		User user = (User)SmartTestUtility.createTestRecord(Schema.User.sObjectType,true);		
		System.assert(user.Id != null);		      
	}
    
    // Test Database Operations on single record
    static testMethod void verifySingleRecordDataBaseOperation()
    {
        SmartTestUtility.FillAllFields = false;
		Account account = (Account)SmartTestUtility.createTestRecord(Schema.Account.sObjectType,false);		
		System.assert(account.Id == null);
        System.assert(account.Name != null);
        SmartTestUtility.insertWithAssert(account);
        System.assert(account.Id != null);
        account.Name = 'Changed Name';
        SmartTestUtility.upsertWithAssert(account);
        account = [SELECT Id, Name FROM Account WHERE Id =: account.Id];
        system.assertEquals('Changed Name', account.Name);
        account.Name = 'Changed2 Name';
        SmartTestUtility.updateWithAssert(account);
        account = [SELECT Id, Name FROM Account WHERE Id =: account.Id];
        system.assertEquals('Changed2 Name', account.Name);
        SmartTestUtility.deleteWithAssert(account);
        List<Account> accountList = [SELECT Id FROM Account];
        system.assertEquals(0, accountList.size());
    }
    
    static testMethod void verifyListRecordDataBaseOperation()
    {
        SmartTestUtility.FillAllFields = false;
		List<Account> accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType,3,false);		
		System.assert(accountList[0].Id == null);
        System.assert(accountList[0].Name != null);
        SmartTestUtility.insertListWithAssert(accountList);
        System.assert(accountList[0].Id != null);
        accountList[0].Name = 'Changed Name';
        SmartTestUtility.updateListWithAssert(accountList); 
        Account account = [SELECT Id, Name FROM Account WHERE Id =: accountList[0].Id];
        system.assertEquals('Changed Name', account.Name);       
               
        SmartTestUtility.deleteListWithAssert(accountList);
        accountList = [SELECT Id FROM Account];
        system.assertEquals(0, accountList.size());
    }
    
    static testMethod void verifyListRecordWithInsertion()
    {
        SmartTestUtility.FillAllFields = false;
		List<Account> accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType,3);		
		System.assert(accountList[0].Id != null);
    }
    
    static testMethod void verifyUserDefinedValues()
    {
        SmartTestUtility.FillAllFields = true;
        List<Map<String,Object>> recordValueMap = new List<Map<String,Object>>();
        Map<String,Object> firstRecordValues = new Map<String,Object>();
        firstRecordValues.put('Name', 'User Defined');
        recordValueMap.add(firstRecordValues);        
		List<Account> accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType, 3, true, recordValueMap);		
        system.assertEquals(accountList[0].Name, 'User Defined');
        Map<String,Object> secondRecordValues = new Map<String,Object>();
        secondRecordValues.put('Name', 'User Defined2');
        recordValueMap.add(secondRecordValues);
        accountList = (List<Account>)SmartTestUtility.createTestRecordList(Schema.Account.sObjectType, 3, true, recordValueMap);		
        system.assertEquals(accountList[1].Name, 'User Defined2');
        System.assert(accountList[0].Id != null);
    }
    
    static testMethod void verifyFieldDescription()
    {
        Map<String, Schema.SObjectField> FieldMap = SmartTestUtility.getFieldMapFor(Schema.Account.sObjectType);
        system.assert(FieldMap != null);
    }
}