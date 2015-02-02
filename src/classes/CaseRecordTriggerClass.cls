/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to create and set the participant id based on the 1st case record
*/
public without sharing class CaseRecordTriggerClass {	 
	 private static final Id recTypeIdChild = [select id from RecordType where Name='Child'].id;
	 
	 public static void MainEntry (List<Case_Record__c> newList, Map<Id, Case_Record__c> newMap,
                            			List<Case_Record__c> oldList, Map<Id, Case_Record__c> oldMap){
          if (trigger.isBefore) {          	
            if (trigger.isUpdate) {
          	   checkChildrenCaseRecordStatus(newMap, oldMap);
          	}
          }          				
     }
         
    /*
    * Check the status of children's case records before allowing the parent case record to exit
    */
    private static void checkChildrenCaseRecordStatus(Map<Id, Case_Record__c> newMap, Map<Id, Case_Record__c> oldMap){    	
    	Map<Id, Id> crTOHouseholdMap = new Map<Id, Id>();
    	    	
    	for (Case_Record__c newcr : newMap.values()) {
    		Case_Record__c oldcr = oldMap.get(newcr.id);  						 		
    		if ((newcr.Status__c <> oldcr.Status__c) && (newcr.Status__c == 'Exited') && 
    				(newcr.Contact_Record_Type__c=='Client')) {
    			crTOHouseholdMap.put(newcr.Household__c, newcr.id);    			
    		}
    	}
    	
    	//map with household, list of case records
    	Map<Id, List<Case_Record__c>> householdToRelatedCrs = new Map<Id, List<Case_Record__c>>();
    	//find all child case records for each household
    	for (Case_Record__c cr :[select id, Status__c, Household__c, Contact__c, 
    								Contact__r.RecordTypeId, Contact__r.Role_in_Household__c 
    	                            from Case_Record__c 
    								where Household__c in :crTOHouseholdMap.keySet() 
    								and Contact__r.RecordTypeId = :recTypeIdChild]){
    									
    		if (householdToRelatedCrs.get(cr.Household__c) == null) {
    			householdToRelatedCrs.put(cr.Household__c, new List<Case_Record__c>());
    		}
    		householdToRelatedCrs.get(cr.Household__c).add(cr);
    	}    	
    	//for each household check the status of all case records that are linked to children
    	for (Id hhId : householdToRelatedCrs.keySet()) {
    		//make sure the cr id is not in initial set
    		List<Case_Record__c> crList =  householdToRelatedCrs.get(hhId);
    		for (Case_Record__c cr : crList) {
	    		Id crId = cr.id;
	    		if ((newMap.get(crId) == null) && (cr.Status__c <> 'Exited') 
	    				&& (cr.Contact__r.Role_in_Household__c =='Child' || cr.Contact__r.RecordTypeId == recTypeIdChild)){
	    			Case_Record__c originalCR = newMap.get(crTOHouseholdMap.get(hhId));
	    			originalCR.addError('You cannot exit this case record while the participant\'s children have Active case records.');
	    		}
    		}
    	}
    }
}