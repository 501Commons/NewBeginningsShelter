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
private class TestContractParticipationTriggerClass {
 
    private static final Integer batchSize = 10;
    private static Id advocateRecTypeId = [select id from RecordType where Name='Staff'].Id;

    static testMethod void testInsertOfContractParticipation() {
        TestHarness th = new TestHarness();
        
        test.startTest();
        //number of milestones for the service participation
        List<Milestone__c> milestones = [select id, Outcome__c, Outcome__r.Outcome_NameFormula__c, Milestone_NameFormula__c 
                                            from Milestone__c];
        System.assertEquals(batchSize*2, milestones.size());
        //now check the milestones
        for (Milestone__c m : milestones) {
            if (m.Outcome__r.Outcome_NameFormula__c == 'Outcome 1') { //created from outcome 1 template milestones
                System.assertEquals('TM OUTCOME 1', m.Milestone_NameFormula__c);
            } else if (m.Outcome__r.Outcome_NameFormula__c == 'Outcome 2') {
                System.assertEquals('TM OUTCOME 2', m.Milestone_NameFormula__c);
            }
        }
        
        try {
        	th.insertDuplicateContractParticipation();
        } catch(System.DmlException e) {
        	System.assert(e.getMessage().contains('This Service Participation is already linked to the Contract. Please choose a different contract.'));
        }
        test.stopTest();
    }
    
    static testMethod void testDeleteOfContractParticipation() {
    	 TestHarness th = new TestHarness();
    	 test.startTest();
    	 //number of milestones for the service participation
         List<Milestone__c> milestones = [select id, Outcome__c, Outcome__r.Outcome_NameFormula__c, Milestone_NameFormula__c 
                                            from Milestone__c];
         System.assertEquals(batchSize*2, milestones.size());
         
         //delete the contract participation
         List<ContractParticipation__c> cpList = [select id from ContractParticipation__c];
         delete cpList;
         
         //now check that all milestones have been deleted
         //number of milestones for the service participation             
         milestones = [select id from Milestone__c];
         System.assertEquals(0, milestones.size());
         
    	 test.stopTest();
    }
    
    //set up the test environment
    private class TestHarness {
        List<Template_Milestone__c> tmlist = new List<Template_Milestone__c>();
        Contact c, adv;
        Case_Record__c cr;
        Program__c prog; 
        Enrollment__c enr;
        Contract__c contract; 
        Template_Outcome__c o1, o2;
        ServiceParticipation__c sp; 
        ContractParticipation__c cp;
        
        TestHarness() {
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
            
            //set up a contract with multiple outcomes
            contract = new Contract__c(Name='TEst Contract', Status__c='Renewed');
            insert contract;
            
            //distribute the contract to a program
            Contract_Program_Distribution__c cpd = new Contract_Program_Distribution__c(Contract__c=contract.Id, Program__c=prog.id);
            insert cpd;
            
            o1 = new Template_Outcome__c(Template_Outcome_Name__c='Outcome 1', Contract__c=contract.id);
            insert o1;
            
            o2 = new Template_Outcome__c(Template_Outcome_Name__c='Outcome 2', Contract__c=contract.id);
            insert o2;
                        
            //for each outcome create 10 template milestones
            for (Integer i=0; i<batchSize; i++) {       
                Template_Milestone__c tm1 = new Template_Milestone__c(  Milestone_Name__c='TM OUTCOME 1', Template_Outcome__c = o1.id);
                Template_Milestone__c tm2 = new Template_Milestone__c(  Milestone_Name__c='TM OUTCOME 2', Template_Outcome__c = o2.id);
                tmlist.add(tm1);
                tmlist.add(tm2);
            }
            insert tmlist;
            
            contract.Lock_Contract__c=true;
            update contract;
            
            sp = new ServiceParticipation__c(Type__c='Phone Consultation', 
                                                                     Case_Record__c=cr.id,
                                                                     Program__c=prog.id, 
                                                                     Program_Enrollment__c=enr.id,                                                                      
                                                                     Advocate__c=adv.id);
            insert sp;                        
        }        
        
        private void insertDuplicateContractParticipation() {
        	cp = new ContractParticipation__c(Contract__c=contract.id, Service_Participation__c=sp.id);
        	insert cp;                                                                    
        }
    }
}