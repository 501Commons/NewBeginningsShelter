/*
* Class used to create and return a test harness for contract, template outcomes and milestones
*/
public without sharing class TestHarness {	
		
		public Contract__c c, c2;
		public List<Template_Outcome__c> templateOutcomes = new List<Template_Outcome__c>();
		public List<Template_Outcome__c> templateOutcomes2 = new List<Template_Outcome__c>();
		public List<Template_Milestone__c> templateMilestones = new List<Template_Milestone__c>();
		public Program__c p;
		public Contact con, adv, child;
        public Case_Record__c cr;         
        public Enrollment__c enr;
        public ServiceParticipation__c sp;
        public Contact staff;
        public String initialGoal;
               
		private static Id staffRecTypeId = [select id from RecordType where Name='Staff'].Id;
		private static Id childRecTypeId = [select id from RecordType where Name='Child'].Id;
		
		//constructor
		public TestHarness() {
			p = new Program__c(Name='Test Program');
			insert p;			
			
			c = new Contract__c(Name='Test Contract', Start_Date__c=date.today(), End_Date__c=date.today()+365, Status__c='New');
			insert c;
			
			//connect the program with the contract
			Contract_Program_Distribution__c cpd = new Contract_Program_Distribution__c(Contract__c=c.id, Program__c=p.id);
			insert cpd;	
			
			//add staff
			staff = new Contact(LastName='Staff Member', RecordTypeId=staffRecTypeId);
			insert staff;		
			
			Contract_Reporting_Staff__c crs = new Contract_Reporting_Staff__c(Contract__c=c.id, Staff_Member__c=staff.id);
			insert crs;
			
			//create template outcomes
			for (Integer i=0; i<10; i++){
				Template_Outcome__c to = new Template_Outcome__c(Contract__c=c.id, Template_Outcome_Name__c='TEMP OUTCOME '+i);
				templateOutcomes.add(to);
			}			
			insert templateOutcomes;
			
			//create template milestones
			for (Integer i=0; i<10; i++){
				Template_Milestone__c tm = new Template_Milestone__c(Template_Outcome__c=templateOutcomes.get(i).id, Milestone_Name__c='TEMP MILESTONE '+i);
				templateMilestones.add(tm);
			}			
			insert templateMilestones;
		}
		
		//this will create one more contract with 2 outcomes but no milestones
		public void createAdditionalContractWithOutcomesNoMilestones() {
			c2 = new Contract__c(Name='Test Contract2', Start_Date__c=date.today(), End_Date__c=date.today()+365, Status__c='New');
			insert c2;
			
			//connect the program with the contract
			Contract_Program_Distribution__c cpd = new Contract_Program_Distribution__c(Contract__c=c2.id, Program__c=p.id);
			insert cpd;	
			
			//create template outcomes
			for (Integer i=0; i<2; i++){
				Template_Outcome__c to = new Template_Outcome__c(Contract__c=c2.id, Template_Outcome_Name__c='SECOND TEMP OUTCOME '+i);
				templateOutcomes2.add(to);
			}			
			insert templateOutcomes2;
		}
		
		public void createEnrollment() {
			 //create Client
            con = new Contact(Lastname='Simpson');
            insert con;
            
            //create Advocate 
            adv = new Contact(Lastname='Advocate', RecordTypeId=staffRecTypeId);
            insert adv;
            
            cr = new Case_Record__c(Name='Test Case Record', Contact__c=con.id,
            						RecordTypeId=Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId());                                                  
            insert cr;
                                    
            enr = new Enrollment__c(Program__c=p.id, Case_Record__c=cr.id);
            insert enr;	
		}
		
		public void createChildEnrollment() {
			 //create Client
            con = new Contact(Lastname='Simpson', Firstname='Homer');
            insert con;
            
            //create Child record
            child = new Contact(Lastname='Simpson', Firstname='Bart', RecordTypeId=childRecTypeId);
            insert child;
            
            //create Advocate 
            adv = new Contact(Lastname='Advocate', RecordTypeId=staffRecTypeId);
            insert adv;
            
            cr = new Case_Record__c(Name='Test Case Record', Contact__c=con.id);                                                  
            insert cr;
            
            //insert enrollment with child field set                        
            enr = new Enrollment__c(Program__c=p.id, Case_Record__c=cr.id, Child__c=child.id);
            insert enr;
		}
		
		public void insertServiceParticipation(){
			
			initialGoal = ServiceParticipationTriggerClass.allGoalsMap().values().get(0);
			sp = new ServiceParticipation__c(Type__c='Phone Consultation', 
                                               Case_Record__c=cr.id,
                                               Program__c=p.id, 
                                               Program_Enrollment__c=enr.id,                                                                      
                                               Advocate__c=adv.id,
                                               Goals__c = initialGoal);
            insert sp;    	
		}
}