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
    		if (c.Record_Type_Name__c == 'Child' 
    				&& c.npo02__Household__c <> null) {
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
    	Map<Id, npo02__Household__c> householdsToUpdate = new Map<Id, npo02__Household__c> 
    														([select id, Number_of_Children__c from npo02__Household__c 
    															where id in :households]);    	
    	AggregateResult[] children = [select npo02__Household__c, count(id) 
    								from Contact where Record_Type_Name__c='Child' 
    								and npo02__Household__c in :households group by npo02__Household__c];
        
        Map<Id, Integer> householdChildrenMap = new Map<Id, Integer>();
        
		for (AggregateResult ar : children)  {	
		   Id hhId = (Id)ar.get('npo02__Household__c');	
		   npo02__Household__c hh = householdsToUpdate.get(hhId); 				    
		   householdChildrenMap.put(hhId,(Integer)ar.get('expr0'));
		}
        for (npo02__Household__c household : householdsToUpdate.values()){           
            if (householdChildrenMap.get(household.Id)==null) {
                household.Number_of_Children__c = 0;
            } else {
                household.Number_of_Children__c = householdChildrenMap.get(household.Id);
            }
        }
		update householdsToUpdate.values(); 								
    }
}