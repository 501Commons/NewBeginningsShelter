/** 
* Written by Nineta Martinov and Patrick Tewson, copyright (c) 2013 501Commons
* Utility class to perform various functionaliy on Service Participation operations.
*/
public without sharing class ServiceParticipationTriggerClass {
	  	
	public static void MainEntry (List<ServiceParticipation__c> newList, Map<Id, ServiceParticipation__c> newMap,
                            			List<ServiceParticipation__c> oldList, Map<Id, ServiceParticipation__c> oldMap){
                  
         if (trigger.isAfter) {//after
            if (trigger.isInsert) {                	
               //attach contracts
               attachContracts(newMap);                                                       
            } 
         } else { //Before
         	if (trigger.isInsert) {
         		setFieldOnServiceParticipation(newList);
         	} else if (trigger.isDelete) {          		
          		deleteContractParticipations(oldList);
          	}
         }                     		          	
    }
    
    /*
    * Sets the child lookup field on the service participation by looking for it on the
    * enrollment.
    */
    private static void setFieldOnServiceParticipation(List<ServiceParticipation__c> newList) {
    	//get the enrollments for the service participations being inserted
    	List<Id> enrollments = new List<Id>();
    	for (ServiceParticipation__c sp : newList) {
    		if(sp.Program_Enrollment__c <> null)
    			enrollments.add(sp.Program_Enrollment__c);
    	}
    	Map<Id, Enrollment__c> enrolls = new Map<Id, Enrollment__c>([select id, Child__c from Enrollment__c 
    												where id in: enrollments]);    											
    	for (ServiceParticipation__c sp : newList) {
    		if(sp.Program_Enrollment__c <> null && enrolls.get(sp.Program_Enrollment__c) <> null){
    			sp.Child__c = enrolls.get(sp.Program_Enrollment__c).Child__c;	
    		}    			
    	}
    }
    
    /*
    * Delete the contract participations for the service participaions being deleted
    */
    private static void deleteContractParticipations(List<ServiceParticipation__c> oldList) {    	
    	//get all contract participations for all service participations being deleted
    	List<ContractParticipation__c> cPartList = [select id, Service_Participation__c, Contract__c 
    													from ContractParticipation__c 
    													where Service_Participation__c in :oldList];		   												
    	delete cPartList;	
    	deleteOutcomesWithNoMilestone(oldList, cPartList);											
    }
    
    /*
    * Some outcomes might not have milestones at all so we'll have to locate the via the 
    * case record and delete them. Traverse from Service Participation -> Case Record
    * and look for Outcomes that should be deleted
    */
    private static void deleteOutcomesWithNoMilestone(List<ServiceParticipation__c> oldList, 
    														List<ContractParticipation__c> cpList) {
    	//for each Service Participation get the case record
    	Map<Id, Id> spToCaseRecordsMap = new Map<Id, Id>();
    	//map of service participation with contracts
    	Map<Id, Set<Id>> spWithContracts = new Map<Id, Set<Id>>(); 
    	
    	for (ServiceParticipation__c sp : oldList) {
    		spToCaseRecordsMap.put(sp.id, sp.Case_Record__c);
    		for (ContractParticipation__c cp : cpList) {
    			if (sp.id  == cp.Service_Participation__c) {
    				if (spWithContracts.get(sp.id) == null)
    					spWithContracts.put(sp.id, new Set<Id>());
    				spWithContracts.get(sp.id).add(cp.Contract__c);		
    			}
    		}
    	}
    	//for each Case Record get the Outcomes that have no milestones
    	List<Outcome__c> outcomesToDelete = new List<Outcome__c>();
    	for (Outcome__c oc : [select id, Total_Number_of_Milestones__c, Parent_Case_Record__c, Contract__c 
    							from Outcome__c 
    							where Parent_Case_Record__c in :spToCaseRecordsMap.values()
    							and Total_Number_of_Milestones__c = 0]){
    		//check if the contract on the service participation matches the one on the outcome
    		//then we can safely assume that the outcome was created by the service participation
    		for (Id spId : spToCaseRecordsMap.keySet()) {
    			if (spToCaseRecordsMap.get(spId) == oc.Parent_Case_Record__c) {
    				//if their case record matches then this is the service participation
    				if ((spWithContracts.get(spId) <> null) && 
    						(spWithContracts.get(spId).contains(oc.Contract__c))) {
    					//put in list to delete
    					outcomesToDelete.add(oc);
    				}
    			}	
    		}
    		    		    											
   		}
		delete outcomesToDelete;    										
    }
    
    /*
    * For each ServiceParticipation, get all Program Distributions, get all Contracts (Renewed and Locked)
    * and insert Contract Participations.
    */
    private static void attachContracts(Map<Id, ServiceParticipation__c> newMap) {
    	List<Id> progs = new List<Id>();
    	List<Id> spList = new List<Id>(); //list of serv part needing contract participations
    	for (ServiceParticipation__c sp : newMap.values()) {
    		if (sp.Program__c != null) {
    			progs.add(sp.Program__c);
    			spList.add(sp.Id);
    		}
    	}    	
    	if (progs.size() > 0) {
    		List<ContractParticipation__c> cpList = new List<ContractParticipation__c>();
	    	for (Contract_Program_Distribution__c cpd : [select id, Program__c, Contract__c, 
	    													Contract__r.IsLocked__c, Contract__r.Status__c 
	    													from Contract_Program_Distribution__c    													
	    													where Program__c in :progs and 
	    													(Contract__r.Status__c = 'Renewed' or Contract__r.Status__c = 'New') and
	    													Contract__r.IsLocked__c = true]){
				for (Id spId : spList) {	    														
	    			ContractParticipation__c cp = new ContractParticipation__c(Service_Participation__c=spId,
	    												Contract__c=cpd.Contract__c);
	    			cpList.add(cp);									
				}												
	    	}	    	
	    	insert cpList;	    	
    	}    	    
    }
    public static void buildUnmetGoalsString(List<ServiceParticipation__c> newList, Map<Id, ServiceParticipation__c> newMap,
                            			List<ServiceParticipation__c> oldList, Map<Id, ServiceParticipation__c> oldMap) {
                                            
      List<ServiceParticipation__c> incomingSp = new List<ServiceParticipation__c>();
      if (Trigger.isInsert) {
          incomingSp = newList;
      } else if (Trigger.isDelete) {
          incomingSp = oldList;
      } else if (Trigger.isUpdate) {
         for ( Id id : newMap.keySet()) {
            if (oldMap.get(id).Goals__c != newMap.get(id).Goals__c) {
                // value of Goals__c changed so the ServiceParticipation__c needs to be take into consideration
                incomingSp.add(newMap.get(id));
            }
        } 
      }
                                           
      Set<id> crs = new Set<id>();       
      // build set with parent Case_Record__c                                      
      for (ServiceParticipation__c sp : incomingSp) {
          crs.add(sp.Case_Record__c);
      }                                         
      updateCaseRecords(crs);       
    }
    
    private static void updateCaseRecords(Set<id> crs) {
        // get the 'Shelter' record id
        Id shelterRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
        
        // build a map with Case_Record__c of 'Shelter' type and for which some ServiceParticipation__c where affected
        Map<Id, Case_Record__c> mapCr = new Map<Id, Case_Record__c>(
        [SELECT Id, Goals_Not_Met__c FROM Case_Record__c WHERE RecordTypeId=:shelterRecordTypeID and Id in :crs]);
        
        Map<String, String> allGoals = allGoalsMap();
        
        // build map with unMetGoals
        Map<Id, Map<String, String>> crUnmetGoals = new Map<Id, Map<String, String>>();
        for (Id i : mapCr.keySet()) {
            // initially all goals are unmet
            crUnmetGoals.put(i, allGoals);
        }
        
        if (mapCr.size() > 0) {
            // retrieve all ServiceParticipation__c from the selected Case_Record__c
            List<ServiceParticipation__c> spListFiltered = [SELECT Id, Case_Record__c, Goals__c FROM ServiceParticipation__c WHERE Case_Record__c in :mapCr.keySet()];
            for (ServiceParticipation__c s : spListFiltered) {
                // remove found goals from 
                if (s.Goals__c != null) {
                    List<String> goals = s.Goals__c.split(';');
                    // get the corresponding Case_Record__c
                    Map<String,String> crGoals = crUnmetGoals.get(s.Case_Record__c);
                    for (String g : goals) {
                        crGoals.remove(g);                        
                    }
                }
            }
            
            // update the Goals_Not__c field
            for (Id i : mapCr.keySet()) {
                Map<String, String> unmet = crUnmetGoals.get(i);
                List<String> unmetGoalsList = unmet.values(); 
                unmetGoalsList.sort();
                mapCr.get(i).Goals_Not_Met__c = String.join(unmetGoalsList, ';');
            }          
            update mapCr.values();
        }      
        
        
    }
    
    /**
     * returns a map with all goals possible values 
     */
    public static Map<String, String> allGoalsMap() {
        Schema.DescribeFieldResult goalFieldResult = ServiceParticipation__c.Goals__c.getDescribe();
        List <Schema.PicklistEntry> goals = goalFieldResult.getPicklistValues();
		
        Map<String, String> allGoals = new Map<String,String>();
        for (Schema.PicklistEntry goal : goals) {
            allGoals.put(goal.getLabel(), goal.getValue());
        }
        
        return allGoals;        
    }
    
}