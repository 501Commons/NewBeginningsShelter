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
private class TestCaseRecordIncomeLevelTriggerClass {

    static testMethod void testInsertIncomeLevel() {
        ClassSetup setup = new ClassSetup();
        System.assertEquals(setup.aboveModerateCategory, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    }
    
    static testMethod void testUpdateIncomeLevel() {
    	ClassSetup setup = new ClassSetup();
    	setup.cr.Monthly_Gross_Income_At_Intake__c = 3733.375;
    	update setup.cr;
    	
	 	System.assertEquals(setup.aboveModerateCategory, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    	
    }
    
    static testMethod void testDoNotSetIncomeLevel() {
    	ClassSetup setup = new ClassSetup();
    	setup.cr.Monthly_Gross_Income_At_Intake__c = 1000;
    	update setup.cr;
    	
	 	System.assertEquals(setup.noIncome, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    	
    }
    
    static testMethod void testBlankIncomeLevel() {
    	ClassSetup setup = new ClassSetup();
    	setup.cr.Monthly_Gross_Income_At_Intake__c = 0;
    	update setup.cr;
    	
	 	System.assertEquals(setup.noIncome, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    	
    }
    
    static testMethod void testNullIncomeLevel() {
    	ClassSetup setup = new ClassSetup();
    	setup.cr.Monthly_Gross_Income_At_Intake__c = null;
    	update setup.cr;
    	
	 	System.assertEquals(setup.noIncome, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    	
    }
    
     static testMethod void testLargePeopleNumberIncomeLevel() {
    	ClassSetup setup = new ClassSetup();
    	setup.cr.Monthly_Gross_Income_At_Intake__c = 8000;
    	setup.cr.Num_of_People_in_HH_at_Intake__c = 6;
    	update setup.cr;
    	
	 	System.assertEquals(setup.aboveModerateCategory4, 
        		[select Income_Level__c from Case_Record__c where id =:setup.cr.Id].Income_Level__c);
    	
    }
    
    
    private class ClassSetup {
    	
    	Case_Record__c cr;
    	npo02__Household__c household6;
    	String aboveModerateCategory = 'Above Moderate (>80% of Median)';
    	String aboveModerateCategory4 = 'Above Moderate 4 (>80% of Median)';
    	String moderate = 'Moderate (<80% of Median)';
    	String noIncome = 'No Income';
    	ClassSetup() {
    		
    		Id parentRecTypeId = [select id from RecordType where name='Participant'].id;
    		
    		// insert Income_Level_Setting__c
    		insert new Income_Level_Setting__c(Name = 'Above_moderate1', Low_End__c = 44800,
    		           Number_of_People__c = 1, Household_Category__c = aboveModerateCategory);
    		           
    		insert new Income_Level_Setting__c(Name = 'Moderate1', Low_End__c = 30901, High_End__c = 44800,
    		           Number_of_People__c = 1, Household_Category__c = moderate);
    		
    		insert new Income_Level_Setting__c(Name = 'Above_moderate1', Low_End__c = 88801,
    		           Number_of_People__c = 4, Household_Category__c = aboveModerateCategory4);
    		
    		
    		// insert household
    		npo02__Household__c household = new npo02__Household__c(Name='Test Household');
    		insert household;
    		
    		//insert contact
    		Contact contact = new Contact(Lastname='Lastname', Firstname='Firstname', RecordTypeId=parentRecTypeId, npo02__Household__c=household.Id);
    		insert contact;
    		
    		//insert case records
    		cr = new Case_Record__c(Name='Test Case Record 1', Household__c=household.id,
    						Contact__c = contact.id, Monthly_Gross_Income_At_Intake__c = 4000,
    						Num_of_People_in_HH_at_Intake__c = 1);
    		insert cr;
    		           
    	}
    }
}