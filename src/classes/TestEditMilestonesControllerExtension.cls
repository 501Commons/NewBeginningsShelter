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
private class TestEditMilestonesControllerExtension {

    static testMethod void testController() {
        TestHarness th = new TestHarness();
        th.c.Lock_Contract__c = true;
        update th.c;
        th.createEnrollment();
        th.insertServiceParticipation();
        
        test.startTest();
        ServiceParticipation__c servPart = [select Name from ServiceParticipation__c].get(0);
        List<Milestone__c> milestones = [select id from Milestone__c];
        System.assertEquals(10, milestones.size());
        
        ApexPages.StandardSetController stdContr = new ApexPages.StandardSetController(new List<Milestone__c>()); 
    	ApexPages.currentPage().getParameters().put('id', th.sp.Id);
    	EditMilestonesControllerExtension contrExt = new EditMilestonesControllerExtension(stdContr);
    	
    	List<Milestone__c> milestonesFromController = contrExt.getMilestones();
    	System.assertEquals(10, milestonesFromController.size()); 
    	for (Milestone__c m : milestonesFromController) {
    		System.assertEquals(null, m.Status__c);
    		m.Status__c = 'Met';
    	}
    	contrExt.save();
    	milestonesFromController = contrExt.getMilestones();
    	for (Milestone__c m : milestonesFromController) {
    		System.assertEquals('Met', m.Status__c);    		
    	}
    	System.assertEquals(servPart.Name, contrExt.getServiceParticipationName());
    	System.assertEquals(servPart, contrExt.getServiceParticipation());
    	
    	System.assert(!contrExt.hasNext);
    	System.assert(!contrExt.hasPrevious);
    	    	    	
    	contrExt.previous();
    	System.assertEquals(10, contrExt.getMilestones().size());
    	
    	contrExt.next();
    	System.assertEquals(10, contrExt.getMilestones().size());
    }
    
    
}