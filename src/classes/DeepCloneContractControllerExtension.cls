/** 
* Written by Nineta Martinov , copyright (c) 2013 501Commons
* Controller extension for deep cloning of contracts. It clones a contract with 
* it programs, staff, template outcomes and template milestones.
*/
public without sharing class DeepCloneContractControllerExtension {
	public Contract__c contract {get; set;} 	
	private ApexPages.StandardController controller {get; set;}
	private Id newContractId {get; private set;}
	
	public DeepCloneContractControllerExtension(ApexPages.StandardController stdController) {	
		//initialize the stanrdard controller
        this.controller = stdController;
        // load the current record
        contract = (Contract__c)controller.getRecord();
	}
	
	public PageReference deepClone() {
		 // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Contract__c newContract;
 
         try {
              //copy the Contract fields
             contract = [select Id, Name, Contract_Amount__c, Contract_Number__c, Description__c, End_Date__c, Fund_Source__c,
             				Internal_Account_Number__c, Point_of_Contact__c, Reporting_Requirements__c, Start_Date__c
             				from Contract__c where id = :contract.id];
             newContract = contract.clone(false);
             newContract.Name = contract.Name+' COPY';
             insert newContract;
             
             newContractId = newContract.Id;
 
             // set the id of the new record created for testing
             Id newRecordId = newContract.id;
 
             // create the contract program distributions for the new contract 
             List<Contract_Program_Distribution__c> cpdList = [select id, Contract__c, Program__c 
             													from Contract_Program_Distribution__c where Contract__c = :contract.Id];
			 List<Contract_Program_Distribution__c> newcpdList = new List<Contract_Program_Distribution__c>();
			 for (Contract_Program_Distribution__c cpd : cpdList) {
			 	Contract_Program_Distribution__c newCPD = new Contract_Program_Distribution__c(Contract__c=newContract.id, 
			 													Program__c=cpd.Program__c);
				newcpdList.add(newCPD);			 													
			 }             			
			 insert newcpdList;
			 										
             // copy the Staff the members
             List<Contract_Reporting_Staff__c> newStaffList = new List<Contract_Reporting_Staff__c>();
             List<Contract_Reporting_Staff__c> staffList = [select id, Contract__c, Staff_Member__c from Contract_Reporting_Staff__c 
             													where Contract__c = :contract.Id];
			 for (Contract_Reporting_Staff__c s: staffList) {
			 	Contract_Reporting_Staff__c newStaff = new Contract_Reporting_Staff__c(Contract__c=newContract.id, 
			 													Staff_Member__c=s.Staff_Member__c);
				newStaffList.add(newStaff);			 													
			 }             													
             insert newStaffList;
             
             // copy template outcomes
             Map<Id, Template_Outcome__c> oldIdToNewTOutcomeMap = new Map<Id, Template_Outcome__c>();
                          
             List<Template_Outcome__c> newTemplateOutcomeList = new List<Template_Outcome__c>();
             List<Template_Outcome__c> templateOutcomeList = [select id, Contract__c, Performance_commitment__c, Template_Outcome_Detail__c,
             													Template_Outcome_Name__c
             													from Template_Outcome__c 
             													where Contract__c = :contract.Id];
			 for (Template_Outcome__c to: templateOutcomeList) {
			 	Template_Outcome__c newTO = new Template_Outcome__c(Contract__c=newContract.id, 
			 															Performance_commitment__c=to.Performance_commitment__c,
			 															Template_Outcome_Detail__c=to.Template_Outcome_Detail__c,
			 															Template_Outcome_Name__c=to.Template_Outcome_Name__c);
				newTemplateOutcomeList.add(newTO);			
				oldIdToNewTOutcomeMap.put(to.Id, newTO); 													
			 }             													
             insert newTemplateOutcomeList;
             
             // copy template milestones
             List<Template_Milestone__c> templateMilesList = [select id, Performance_commitment__c, Description__c,
             														Template_Outcome__c, Milestone_Name__c
             													from Template_Milestone__c 
             													where Template_Outcome__c in :templateOutcomeList];
             													 
			 List<Template_Milestone__c> newTemplMilesList = new List<Template_Milestone__c>();
			 for (Template_Milestone__c tm : templateMilesList) {
			 	Template_Milestone__c newTm = new Template_Milestone__c(Milestone_Name__c=tm.Milestone_Name__c, 
			 															Description__c=tm.Description__c,
			 															Performance_commitment__c=tm.Performance_commitment__c,
			 															Template_Outcome__c=oldIdToNewTOutcomeMap.get(tm.Template_Outcome__c).Id);
				newTemplMilesList.add(newTm);			 															
			 }            					
			 insert newTemplMilesList;								
 			  
         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }
         
         return new PageReference('/'+newContract.id+'/e?retURL=%2F'+newContract.id);
	}	
	
	public Id getNewContractId() {
		return newContractId;
	}
		
}