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
private class TestContractTriggerClass {

    static testMethod void testUpdateLockedContract() {
        TestHarness th = new TestHarness();
        th.c.Lock_Contract__c = true;
        update th.c;
        
        th.c.Description__c = 'TEst Test';
        try {
        	update th.c;
        } catch (System.DmlException e){
    		System.assert(e.getMessage().contains('This contract has been locked, you cannot edit any fields except status.'));
    	}    	    	
    }
    
     static testMethod void testUpdateStatusLockedContract() {
        TestHarness th = new TestHarness();
        th.c.Lock_Contract__c = true;
        update th.c;
        
        th.c.Status__c = 'Closed';
    	update th.c;
    	System.assertEquals('Closed', [select Status__c from Contract__c where id = :th.c.id].Status__c);
     }
}