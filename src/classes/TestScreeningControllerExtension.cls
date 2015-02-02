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
private class TestScreeningControllerExtension {
	// get the 'Shelter' record id
    private static final Id shelterRecordTypeID = Schema.SObjectType.Screening__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
    private static final Id advocateTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Staff').getRecordTypeId();
    
    
	static testMethod void testController() {
		Contact c = new Contact(LastName = 'test');
		insert c;
		
		Contact advocate = new Contact(LastName = 'advocate', Title = 'Advocate', RecordTypeId = advocateTypeID);
		insert advocate;
		
        test.startTest();
        
        ApexPages.StandardController stdContr = new ApexPages.StandardController(new Screening__c()); 
    	ApexPages.currentPage().getParameters().put('partId', c.Id);
    	ApexPages.currentPage().getParameters().put('RecordTypeId', shelterRecordTypeID);
    	ScreeningController contrExt = new ScreeningController(stdContr);
    	
    	//test step 1
    	String step1 = contrExt.getPhoneScreeningPage().getUrl().toLowerCase();
    	System.assert(step1.contains('neworeditscreeningstep1'));

		//test step 2
    	String step2 = contrExt.getDVHistoryScreeningPage().getUrl().toLowerCase();
    	System.assert(step2.contains('neworeditscreeningstep2'));
    	
    	//test step 3
    	String step3 = contrExt.getChildrenScreeningPage().getUrl().toLowerCase();
    	System.assert(step3.contains('neworeditscreeningstep3'));
    	
    	//test step 4
    	String step4 = contrExt.getMedicalAndSpecialNeedsScreeningPage().getUrl().toLowerCase();
    	System.assert(step4.contains('neworeditscreeningstep4'));
    	
    	//test step 5
    	String step5 = contrExt.getArrivalScreeningPage().getUrl().toLowerCase();
    	System.assert(step5.contains('neworeditscreeningstep5'));
    	
    	//test step 6
    	String step6 = contrExt.getCallInfoAndStatusScreeningPage().getUrl().toLowerCase();
    	System.assert(step6.contains('neworeditscreeningstep6'));

		// test cancel method
		String url = contrExt.cancel().getUrl();
		System.assert(url.contains(c.Id));
    
		//test save
		contrExt.screening.Screening_Call_Origin__c = 'Direct to Shelter';
		contrExt.screening.Screening_Date__c = Date.today();
		contrExt.screening.Screening_Advocate__c = advocate.Id;
		PageReference pg = contrExt.save();
		System.assert(pg != null);
		List<Screening__c> screenings = [select id from Screening__c];
		System.assert(screenings.size() == 1);
    	
    	Test.stopTest();

    }

}