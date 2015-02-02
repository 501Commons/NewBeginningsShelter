/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCreateBedNightController {

	private static Id shelterRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
	private static Id shelterChildrenRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter Child').getRecordTypeId();
	private static final List<Id> recTypeList = new List<Id>{shelterRecordTypeID, shelterChildrenRecordTypeID};

	private class TestModel {
		Contact c;
		Case_Record__c cr;
		Bed_Night__c bn1;

		TestModel() {
			c = new Contact(Lastname='ContactLastName', Firstname='ContactFirstName');
			insert c;
		
			cr = new Case_Record__c(Name='TestCreateBedNightController', 
										Status__c = 'Status Completed', 
										RecordTypeId = recTypeList[1],
										Contact__c = c.id);    	
			insert cr;
		
			bn1 = new Bed_Night__c(Bednight_Date__c = Date.Today().addDays(1), Case_Record__c = cr.id);	
			insert bn1;			
		}
	}
	
    static testMethod void testOverlapController() {
    	
   		TestModel tm = new TestModel();
   		
   		test.startTest();
   		
   		CreateBedNightsController bnc = new CreateBedNightsController();
   		ApexPages.currentPage().getParameters().put('caseRecordId', tm.cr.id);
   		
   		bnc.setCustomStartDate(Date.Today().format());
   		bnc.setCustomEndDate(Date.Today().addDays(7).format());
   		
   		PageReference pRef1 = bnc.create();
   		System.assert(pRef1 == null);	
   		
   		bnc.setCustomStartDate(Date.Today().addDays(3).format());
   		bnc.setCustomEndDate(Date.Today().addDays(10).format());
   		
   		PageReference pRef2 = bnc.create();
   		System.assert(pRef2 == null && ApexPages.getMessages()[0].getSummary().contains(bnc.errorMessage));	
   		test.stopTest();
        
    }
    
    static testMethod void testDatesInWrongOrderController() {
    	TestModel tm = new TestModel();
   		
   		test.startTest();
   		
   		CreateBedNightsController bnc = new CreateBedNightsController();
   		ApexPages.currentPage().getParameters().put('caseRecordId', tm.cr.id);
   		
   		string testStartDate = Date.Today().addDays(10).format();
   		string testEndDate = Date.Today().addDays(9).format();
   		if (bnc.getCustomStartDate() == null) {
   			bnc.setCustomStartDate(testStartDate);	
   		}
   		if (bnc.getCustomEndDate() == null ) {
   			bnc.setCustomEndDate(testEndDate);	
   		}
   		
   		PageReference pRef = bnc.create();
   		System.assert(pRef == null && ApexPages.getMessages()[0].getSummary().contains(bnc.dateRangeError));	
   			
   		test.stopTest();
    }
    
    static testMethod void testNonOverlapController() {
  		TestModel tm = new TestModel();
   		
   		test.startTest();
   		
   		CreateBedNightsController bnc = new CreateBedNightsController();
   		ApexPages.currentPage().getParameters().put('caseRecordId', tm.cr.id);
   		
   		string testStartDate = Date.Today().addDays(3).format();
   		string testEndDate = Date.Today().addDays(7).format();
   		if (bnc.getCustomStartDate() == null) {
   			bnc.setCustomStartDate(testStartDate);	
   		}
   		if (bnc.getCustomEndDate() == null ) {
   			bnc.setCustomEndDate(testEndDate);	
   		}
   		
   		PageReference pRef = bnc.create();
   		System.assert(pRef == null && 0 < ApexPages.getMessages().size());	
   		
   		// check that the bed_nights record were created succesfully
   		List<Bed_Night__c> bedNights = [select b.id, b.Bednight_Date__c
										from Bed_Night__c b where Case_Record__c = :tm.cr.id
										and b.Bednight_Date__c >= :Date.parse(testStartDate) 
										and b.Bednight_Date__c <= :Date.parse(testEndDate)
										order by Bednight_Date__c asc];
										
		for (Date d = Date.parse(testStartDate); d <= Date.parse(testEndDate); d = d.addDays(1)) {
			System.assertEquals(d, bedNights[Date.parse(testStartDate).daysBetween(d)].Bednight_Date__c);
		}
   		
   		test.stopTest();
        
    	
    }
    
    
}