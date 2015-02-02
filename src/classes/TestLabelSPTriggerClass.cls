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
private class TestLabelSPTriggerClass {

  private static final Integer batchSize = 10;
  private static Id advocateRecTypeId = [select id from RecordType where Name='Staff'].Id;    

  static testmethod void TestLabelSPTrigger() {
    Contact c, adv;
    Case_Record__c cr;
    Program__c prog; 
    Enrollment__c enr;
    ServiceParticipation__c sp1; 
    ServiceParticipation__c sp2; 
    ServiceParticipation__c sp3; 
    ServiceParticipation__c sp4;
     
    //set up the custom settings values
    insert new Group_Services_Types__c(Name = 'Support Group');    
    insert new Group_Services_Types__c(Name = 'Parenting Group');   
    insert new Group_Services_Types__c(Name = 'Childcare');
    
    //create Client
    c = new Contact(Lastname='Simpson');
    insert c;
    
    //create Advocate 
    adv = new Contact(Lastname='Advocate', RecordTypeId=advocateRecTypeId);
    insert adv;
    
    cr = new Case_Record__c(Name='Test Case Record', Contact__c=c.id);                                                  
    insert cr;
    
    prog = new Program__c(Name='Unit Test Program');
    insert prog;
    
    enr = new Enrollment__c(Program__c=prog.id, Case_Record__c=cr.id);
    insert enr;
    
    
    Date aDate = Date.Today();
    sp1 = new ServiceParticipation__c(Type__c='Support Group', 
    Case_Record__c=cr.id,
    Program__c=prog.id, 
    Program_Enrollment__c=enr.id,                                                                      
    Date_of_Service__c = aDate,
    Advocate__c=adv.id);
    insert sp1;

    sp1 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp1.Id][0];
    System.Assert(sp1.First_Of_Type__c);

    aDate.addDays(-1);
    sp2 = new ServiceParticipation__c(Type__c='Support Group', 
    Case_Record__c=cr.id,
    Program__c=prog.id, 
    Program_Enrollment__c=enr.id,                                                                      
    Date_of_Service__c = aDate.addDays(-1),
    Advocate__c=adv.id);
    insert sp2;                        

    sp1 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp1.Id][0];
    sp2 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp2.Id][0];
    System.Assert(sp2.First_Of_Type__c);
    System.Assert(!sp1.First_Of_Type__c);

    sp1.Date_Of_Service__c = aDate.addDays(-10);
    update sp1;

    sp1 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp1.Id][0];
    sp2 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp2.Id][0];
    System.Assert(!sp2.First_Of_Type__c);
    System.Assert(sp1.First_Of_Type__c);


    sp3 = new ServiceParticipation__c(Type__c='Parenting Group', 
    Case_Record__c=cr.id,
    Program__c=prog.id, 
    Program_Enrollment__c=enr.id,                                                                      
    Date_of_Service__c = aDate,
    Advocate__c=adv.id);
    insert sp3;                         
    sp3 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp3.Id][0];
    System.Assert(sp3.First_Of_Type__c);  
    
    sp4 = new ServiceParticipation__c(Type__c='Childcare',     
    Case_Record__c=cr.id,
    Program__c=prog.id, 
    Program_Enrollment__c=enr.id,                                                                      
    Date_of_Service__c = aDate,
    Advocate__c=adv.id);
    insert sp4;                         
    sp4 = [SELECT First_Of_Type__c from ServiceParticipation__c WHERE Id =: sp4.Id][0];
    System.Assert(sp4.First_Of_Type__c);                       

  }
}