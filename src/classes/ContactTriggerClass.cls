public without sharing class ContactTriggerClass {
	public static void MainEntry (List<Contact> newList, Map<Id, Contact> newMap,
                            			List<Contact> oldList, Map<Id, Contact> oldMap){
          
          if (trigger.isBefore) {
          	if (trigger.isUpdate) {
          		List<Contact> toUpdate = new List<Contact>();
          		for (Contact c : newMap.values()) {
          			if (c.MailingPostalCode != oldMap.get(c.Id).MailingPostalCode ) {
          				toUpdate.add(c);
          			}
          		}
          		updateRegion(toUpdate);
          	} else if (trigger.isInsert) {
	  			updateRegion(newList);
  			}
          }
          
          if (trigger.isAfter) {//After
                if (trigger.isInsert) {                	
                    updateRelatedObjects(newMap);                                   
                } else if (trigger.isDelete) {
                    updateRelatedObjects(oldMap);
                } else if (trigger.isUpdate) {                    
                    updateRelatedObjects(oldMap, newMap);
                }
          } 	                 				
    }
    
    private static String getRegion(String postalCode) {
    	 Zip_Code_Mapping_Setting__c mapping = Zip_Code_Mapping_Setting__c.getValues(postalCode);
    	 if (mapping != null) {
    	 	return mapping.Region__c;
    	 }
    	 return null;
    }
    
    private static void updateRegion(List<Contact> contacts) {
    	for (Contact c : contacts) {
    		if (!String.isBlank(c.MailingPostalCode)) {
    			String region = getRegion(c.MailingPostalCode);
    			if (region != null) {
    				c.Region__c = region;
    			}
    		} else {
    			System.debug('else branch setting to blank');
    			c.Region__c = '';
    		}
    	}
    }
    
    private static void updateRelatedObjects(Map<Id, Contact> newMap) {
    	//for all contacts inserted check their record type and get their household
    	Set<Id> householdSet = new Set<Id>();
    	for (Contact c : newMap.values()) {
    		if (c.npo02__Household__c <> null) {
    			householdSet.add(c.npo02__Household__c);
    		}
    	}
    	updateHouseholds(householdSet);
    }
    
    private static void updateRelatedObjects(Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
    	//for all contacts updated check their record type and get their household
    	Set<Id> householdSet = new Set<Id>();
    	for (Contact newC : newMap.values()) {
    		Contact oldC = oldMap.get(newC.id);
    		if (newC.RecordTypeId <> oldC.RecordTypeId || 
    				newC.npo02__Household__c <> oldC.npo02__Household__c) {
    					if (newC.npo02__Household__c <> null) {
    						householdSet.add(newC.npo02__Household__c);
    					}
    		}
    	}
    	updateHouseholds(householdSet);
    }
    
    /*
    * Update households with the number of children
    */
    private static void updateHouseholds(Set<Id> households) {
    	List<npo02__Household__c> householdsToUpdate = [select id, Number_of_Children__c, Number_of_Household_Members__c
    													from npo02__Household__c 
    													where id in :households];    	
    	List<Contact> contacts = [select id, npo02__Household__c, Record_Type_Name__c
    								from Contact where npo02__Household__c in :households];
        
        Map<Id, Integer> householdChildrenMap = new Map<Id, Integer>();
        Map<Id, Integer> householdMembersMap = new Map<Id, Integer>();
        
		for (Contact c : contacts)  {	
		   Id hhId = c.npo02__Household__c;	
		   String record_type = c.Record_Type_Name__c;
		   
		   if (householdChildrenMap.containsKey(hhId)) {
		   	// the houseHold is already included in map
		   	householdMembersMap.put(hhId, householdMembersMap.get(hhId) + 1);
		   	if (record_type.equals('Child')) {
		   		householdChildrenMap.put(hhId, householdChildrenMap.get(hhId) + 1);
		   	}
		   		
		   } else {
		   	// the houseHold is newly found
		   	householdMembersMap.put(hhId, 1);
		   	if (record_type.equals('Child')) {
		   		householdChildrenMap.put(hhId, 1);
		   	} else {
		   		householdChildrenMap.put(hhId, 0);
		   	}
		   }
		}
        for (npo02__Household__c household : householdsToUpdate){           
            if (householdChildrenMap.get(household.Id)==null) {
                household.Number_of_Children__c = 0;
                household.Number_of_Household_Members__c = 0;
            } else {
                household.Number_of_Children__c = householdChildrenMap.get(household.Id);
                household.Number_of_Household_Members__c = householdMembersMap.get(household.Id);
            }
        }
		update householdsToUpdate; 								
    }
}