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
private class TestDeepCloneContractControllerExtension {

    static testMethod void testControllerExtension() {
       TestHarness th = new TestHarness();
       test.startTest();
       
       ApexPages.StandardController stdContr = new ApexPages.StandardController(th.c); 
       ApexPages.currentPage().getParameters().put('id', th.c.Id);
       DeepCloneContractControllerExtension contr = new DeepCloneContractControllerExtension(stdContr);
       
       contr.deepClone();
       
       //now verify what got cloned
       Contract__c newC = [select id, name, Total_Number_of_Templ_Milestones__c, Total_Number_of_Template_Outcomes__c
                             from Contract__c where id = :contr.getNewContractId()];
       System.assertEquals(th.c.Name+' COPY', newC.name);
       System.assertEquals(10, newC.Total_Number_of_Template_Outcomes__c);
       System.assertEquals(10, newC.Total_Number_of_Templ_Milestones__c);       
       test.stopTest();
    }
}