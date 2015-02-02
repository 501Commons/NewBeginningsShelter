/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger utility class to auto create milestones and attach them to the service participation
* Will look at the template outcomes and milestones for each newly inserted contract participation 
* and create the outcomes and milestones.
*/
public without sharing class ContractParticipationTriggerClass {
	public static void MainEntry (List<ContractParticipation__c> newList, Map<Id, ContractParticipation__c> newMap,
                            			List<ContractParticipation__c> oldList, Map<Id, ContractParticipation__c> oldMap){
          if (trigger.isBefore) {//before
                if (trigger.isInsert) {                	
                   createOutcomesAndMilestones(newList);                                   
                } else if (trigger.IsDelete) {
                   deleteMilestones(oldList);	
                }
          } 	                 				
    }    
    
    /*
    * Cascade delete all milestones for the contract participations being deleted
    */
    private static void deleteMilestones(List<ContractParticipation__c> oldList) {    	
    	//from the contract participations being deleted get all the milestones
    	    	
    	//Map<Contract ParticipationId, <Service Part Id, Contract>>
    	Map<Id, Map<Id, Id>> contractPartMap = new Map<Id, Map<Id, Id>>();
    	Set<Id> serviceParticipations = new Set<Id>();
    	
    	for (ContractParticipation__c cp : oldList) {
    		Map<Id, Id> contractServicePart = new Map<Id, Id>();
    		contractServicePart.put(cp.Service_Participation__c, cp.Contract__c);    	
    		contractPartMap.put(cp.id, contractServicePart);
    		serviceParticipations.add(cp.Service_Participation__c);
    	}   
    	
    	List<Milestone__c> milestonesToDelete = new List<Milestone__c>();    	
    	
    	for (List<Milestone__c> milestones : [select id, Outcome__r.Contract__c, Service_Participation__c
    										from Milestone__c 
    										where Service_Participation__c in :serviceParticipations]) {
    		for (Milestone__c m : milestones){
    			//check if the combination contract-service part exists, then put in list to delete
    			for (Id key : contractPartMap.keySet()) {
    				if (contractPartMap.get(key).get(m.Service_Participation__c) == m.Outcome__r.Contract__c) {
    					milestonesToDelete.add(m);
    				}
    			}
    		}									
    	}    	
    	delete milestonesToDelete;
    									
    }
    
    /*
    * For each contract participation passed in, get the service participation and its list of contracts
    * then create outcomes and milestones.
    */
    private static void createOutcomesAndMilestones(List<ContractParticipation__c> newList) {    	
    	//each service participation can have 1 or more contracts
    	Map<Id, List<Id>> srvPartToContractMap = new Map<Id, List<Id>>();
    	Set<Id> allContracts = new Set<Id>();
    	
    	for (ContractParticipation__c cp : newList){
    		if (cp.Contract__c <> null && cp.Service_Participation__c <> null) {
    			if (srvPartToContractMap.get(cp.Service_Participation__c) == null){
    				srvPartToContractMap.put(cp.Service_Participation__c, new List<Id>());
    			}
    			srvPartToContractMap.get(cp.Service_Participation__c).add(cp.Contract__c);
    			allContracts.add(cp.Contract__c);
    		}
    	}
    	
    	//first make sure that this pair (service participation - contract does not already exist)
    	//throw an error if user is trying to attach the same serv part with the same contract
    	boolean createOutcomesAndMilestones = true;
    	for (List<ContractParticipation__c> listExistingPairs : [select id, Service_Participation__c, Contract__c 
    															from ContractParticipation__c 
    															where Service_Participation__c in :srvPartToContractMap.keySet()]) {
    		for (ContractParticipation__c cp : listExistingPairs) {
    			List<Id> contrIds = srvPartToContractMap.get(cp.Service_Participation__c);
    			for (Id cid : contrIds) {
    				if (cid == cp.Contract__c) {
    					createOutcomesAndMilestones = false;
    					throw new DuplicatedDataException('Service Participation','Contract', 'Please choose a different contract.');
    				}
    			}    			
    		}															
    	}
    															
    	//if (createOutcomesAndMilestones) {
	    	//for all service participations with contracts get the template outcomes
	    	Map<Id, List<Id>> contractWithTemplateOutcomesMap = new Map<Id, List<Id>>();
	    	List<Template_Outcome__c> templateOutcomes = [select id, Contract__c from Template_Outcome__c 
	    													where Contract__c in :allContracts];
			for (Template_Outcome__c o : templateOutcomes) {
				if (contractWithTemplateOutcomesMap.get(o.Contract__c) == null) {
					contractWithTemplateOutcomesMap.put(o.Contract__c, new List<Id>());
				}
				contractWithTemplateOutcomesMap.get(o.Contract__c).add(o.id);
			}    									
	    	
	    	//now get the actual template outcomes and template milestones	    	 	    		    	
	    	Map<Id, Template_Outcome__c> templOutcomeWithTemplOutcomeMap = new Map<Id, Template_Outcome__c>(
	    																	[select id, Template_Outcome_Detail__c, 
	    																	 Template_Outcome_Name__c, IsParentContractLocked__c,
	    																	 Total_Number_of_Milestones__c 	    														 
	    																	 from Template_Outcome__c 
	    															         where id in :templateOutcomes]);					    	
	    	
	    	Map<Id, List<Template_Milestone__c>> templOutcomeWithTemplMsMap = new Map<Id, List<Template_Milestone__c>>();
	    	for (List<Template_Milestone__c> templateMilestones : [select id, Template_Outcome__c, Milestone_Name__c, Description__c	    														 
	    														from Template_Milestone__c 
	    														where Template_Outcome__c in :templateOutcomes]){	
	    		for (Template_Milestone__c tm : templateMilestones) {
		    		//populate tha map with template milestones
		    		if (templOutcomeWithTemplMsMap.get(tm.Template_Outcome__c) == null) {
		    			templOutcomeWithTemplMsMap.put(tm.Template_Outcome__c, new List<Template_Milestone__c>());
		    		}
	    			templOutcomeWithTemplMsMap.get(tm.Template_Outcome__c).add(tm);	    
	    		}			    			    		
	    	}	
	    	System.debug('DEBUG >>> template outcomes '+templOutcomeWithTemplOutcomeMap);	
	    	System.debug('DEBUG >>> template milestones '+templOutcomeWithTemplMsMap);												
	    	
	    	
	    	//query for the service participations 
	    	Map<Id, ServiceParticipation__c> serviPartMap = new Map<Id, ServiceParticipation__c>(
	    														[select id, Case_Record__c from ServiceParticipation__c
	    														 	where id in :srvPartToContractMap.keySet()]);
	    	//get existing outcomes
	    	Map<Id, Outcome__c> existingOutcomes = new Map<Id, Outcome__c>(
	    												[select id, Parent_Case_Record__c, Contract__c, Template_Outcome__c
	    													from Outcome__c where Contract__c in :allContracts and 
	    													Template_Outcome__c in :templOutcomeWithTemplOutcomeMap.keySet()]);
	    														 	
	    	//using the template outcomes create the real outcomes 
	    	//for the service participations' case records, if outcome with the same
	    	// case record, contract  and template outcome id exists, don't create
	    	List<Outcome__c> outcomesToInsert = new List<Outcome__c>();
	    	
	    	for (Id sp : srvPartToContractMap.keySet()) {
	    		//what contracts does it have
	    		List<Id> contractIdList = srvPartToContractMap.get(sp);
	    		//look up the template outcomes for each contract
	    		for (Id cid : contractIdList) {
	    			List<Id> templateOutcomesForContract = contractWithTemplateOutcomesMap.get(cid);
	    			if (templateOutcomesForContract != null) {
			    		//for each template outcome create an outcome
			    		for (Id tocId : templateOutcomesForContract) {     	
				    		Template_Outcome__c to = templOutcomeWithTemplOutcomeMap.get(tocId);
				    		if (to != null) {				    			
				    			Outcome__c outcome = new Outcome__c(Contract__c = cid, Template_Outcome__c=to.Id,
				    											Total_Number_of_Milestones__c = to.Total_Number_of_Milestones__c,
				    											Parent_Case_Record__c = serviPartMap.get(sp).Case_Record__c);		    									
								outcomesToInsert.add(outcome);	 
				    		}   											
			    		}
	    			}
	    		}
	    	}	   
	    	
	    	Set<Outcome__c> finalOutcomesInsert = new Set<Outcome__c>();
	    	finalOutcomesInsert.addAll(outcomesToInsert); 	
	    	//check if the outcome already exists so we don't add twice		    
			for (Outcome__c existingOutcome : existingOutcomes.values()) {
				for (Outcome__c o : outcomesToInsert) {
					if (existingOutcome.Contract__c == o.Contract__c && 
							existingOutcome.Parent_Case_Record__c == o.Parent_Case_Record__c &&
							existingOutcome.Template_Outcome__c == o.Template_Outcome__c)	{
						finalOutcomesInsert.remove(o);		
					}		
				}
			}
			
	    	outcomesToInsert.clear();	
	    	outcomesToInsert.addAll(finalOutcomesInsert);	    	
	    	System.debug('DEBUG >>> Outcomes that will be inserted...'+outcomesToInsert);
	    	insert outcomesToInsert;     
	    	
	    	//map of template outcomes id to list of real outcomes
	    	Map<Id,List<Outcome__c>> templOutcomeIdToOutcomeIdMap = new Map<Id, List<Outcome__c>>();
	    	for (Outcome__c insertedOutcome : outcomesToInsert) {
	    		if (templOutcomeIdToOutcomeIdMap.get(insertedOutcome.Template_Outcome__c) == null)
	    			templOutcomeIdToOutcomeIdMap.put(insertedOutcome.Template_Outcome__c, new List<Outcome__c>());
	    		templOutcomeIdToOutcomeIdMap.get(insertedOutcome.Template_Outcome__c).add(insertedOutcome);
	    	}	 
	    	//add existing outcomes
	    	for (Outcome__c existingOutcome : existingOutcomes.values()) {
	    		if (templOutcomeIdToOutcomeIdMap.get(existingOutcome.Template_Outcome__c) == null)
	    			templOutcomeIdToOutcomeIdMap.put(existingOutcome.Template_Outcome__c, new List<Outcome__c>());
	    		templOutcomeIdToOutcomeIdMap.get(existingOutcome.Template_Outcome__c).add(existingOutcome);
	    	}  	
	    	    	    														
	    	//using the template milestones create the real milestones for the service participation	
	    	List<Milestone__c> milestonesToInsert = new List<Milestone__c>();
	    	for (Id sp : srvPartToContractMap.keySet()) {
	    		//what contracts does it have
	    		List<Id> contractIdList = srvPartToContractMap.get(sp);
	    		for (Id cid : contractIdList) {	    				    		
	    			//look up the template outcomes for the contract
	    			List<Id> templateOutcomesForContract = contractWithTemplateOutcomesMap.get(cid);
	    			if (templateOutcomesForContract != null) {
		    			//now get the template milestones for the template outcomes
		    			for (Id oId : templateOutcomesForContract) {   
		    				//get the real outcome for the template outcome that matches the contract and case record
		    				Id outcomeId = null;
		    				for (Outcome__c outcome : templOutcomeIdToOutcomeIdMap.get(oId)) {
		    					if (outcome.Contract__c == cid && 
		    							outcome.Parent_Case_Record__c == serviPartMap.get(sp).Case_Record__c){
		    						outcomeId = outcome.Id;			
		    					}
		    				}	    			  	
		    				if (outcomeId != null){
				    			List<Template_Milestone__c> tmpMilestones = templOutcomeWithTemplMsMap.get(oId);
				    			if (tmpMilestones != null) {		    		
					    			for (Template_Milestone__c tm : tmpMilestones) {			    				
					    				Milestone__c ms = new Milestone__c(Outcome__c=outcomeId, 
					    											Template_Milestone__c=tm.id,
					    											Service_Participation__c=sp);
										milestonesToInsert.add(ms);	    											
					    			}
		    					}
		    				}
		    			}
			    	}
	    		}
	    	}	
	    	insert milestonesToInsert;			
    	//}													
    }
}