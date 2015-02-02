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
private class TestLeadTriggerClass {
   static testmethod void TestLeadTrigger() {
       Lead l1 = new Lead(RecordTypeId='012i000000073u5AAA',LastName='Test', Company='TestCo', 
           Status='Open - Not Contacted', Zip_Code_Calling_From__c='98101 Seattle/Downtown');
       insert l1;

       Lead l2 = new Lead(RecordTypeId='012i000000073u5AAA',LastName='Test', Company='TestCo', 
           Status='Open - Not Contacted', Zip_Code_Calling_From__c='98028 N King County');
       insert l2;

       List<Lead> tLeads = [SELECT Region__c FROM Lead WHERE Id =: l1.Id];
       System.assert(tLeads.size() > 0);
       Lead t1 = tLeads.get(0);
       System.assert(t1.Region__c == 'City of Seattle');

       tLeads = [SELECT Region__c FROM Lead WHERE Id =: l2.Id];
       System.assert(tLeads.size() > 0);
       Lead t2 = tLeads.get(0);
       System.assert(t2.Region__c == 'Other North King County - Bothell, Woodinville, etc.');
   }
}