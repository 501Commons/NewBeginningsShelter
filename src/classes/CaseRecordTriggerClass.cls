/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to create and set the participant id based on the 1st case record
*/
public without sharing class CaseRecordTriggerClass {	 
	 private static final Id recTypeIdChild = [select id from RecordType where Name='Child'].id;
	 
	 public static void MainEntry (List<Case_Record__c> newList, Map<Id, Case_Record__c> newMap,
                            			List<Case_Record__c> oldList, Map<Id, Case_Record__c> oldMap){
          if (trigger.isBefore) {    
          	List<Case_Record__c> toUpdateCr = new List<Case_Record__c>();
            if (trigger.isUpdate) {
          	   checkChildrenCaseRecordStatus(newMap, oldMap);

          	   for (Case_Record__c newcr : newMap.values()) {
          	   		if (newcr.Monthly_Gross_Income_at_Intake__c <> oldMap.get(newcr.id).Monthly_Gross_Income_at_Intake__c) {
          	   			toUpdateCr.add(newcr);
          	   		}
          	   }
          	   updateMonthlyGrossIncomeAtIntake(toUpdateCr);          	      	
          	} else if (trigger.isInsert) {
  				 for (Case_Record__c newcr : newList) {
  				 	if (newcr.Monthly_Gross_Income_at_Intake__c != null) {
  				 		toUpdateCr.add(newcr);
  				 	}		
  				 }
  				 updateMonthlyGrossIncomeAtIntake(toUpdateCr);
          	}
          	
          }          				
     }
     
    private static void updateMonthlyGrossIncomeAtIntake(List<Case_Record__c> toUpdateCr){
    	Map<Id, Id> crToHouseholdMap = new Map<Id, Id>();
    	
    	for (Case_Record__c cr : toUpdateCr) {
			crToHouseholdMap.put(cr.id, cr.Household__c);
    	}
    	
    	List<Income_Level_Setting__c> levelList = [SELECT Id, Number_of_People__c, Low_End__c, High_End__c, Household_Category__c, Name 
    										FROM Income_Level_Setting__c ORDER BY Number_of_People__c];
    				
    	if (levelList == null || levelList.size() == 0) 
    		return;						
    	// construct a map with key the number of people and value a list of Income_Level_Setting__c
    	// having the same number of people 									
    	Map<Double, List<Income_Level_Setting__c>> incomeLevelMap = new Map<Double, List<Income_Level_Setting__c>>();
    	for (Income_Level_Setting__c level : levelList) {
    		List<Income_Level_Setting__c> samePeopleNoList = incomeLevelMap.get(level.Number_of_People__c); 
    		if (samePeopleNoList == null) {
    			samePeopleNoList = new List<Income_Level_Setting__c>();
    			samePeopleNoList.add(level);
    			incomeLevelMap.put(level.Number_of_People__c, samePeopleNoList);
    			
    		} else {
    			samePeopleNoList.add(level);
    		}
    	}
    	Double highestPeopleNo = levelList.get(levelList.size()-1).Number_of_People__c;
    	
    	
    	// create a map for HouseHold
    	Map<Id, npo02__Household__c> houseHoldMap = new Map<Id, npo02__Household__c>([SELECT Id,Number_of_Household_Members__c 
    				FROM npo02__Household__c where Id in :crToHouseholdMap.values()]);
    	
    	for (Case_Record__c cr : toUpdateCr) {
    		double numberOfHouseHoldMembers = houseHoldMap.get(cr.Household__c).Number_of_Household_Members__c;
    		if (cr.Monthly_Gross_Income_at_Intake__c == 0 || 
    			cr.Monthly_Gross_Income_at_Intake__c == null) {
    			cr.Income_Level__c = null;
    			continue;
    		}
    		
    		List<Income_Level_Setting__c> listIncomeLevel = null;
    		if (numberOfHouseHoldMembers > highestPeopleNo) {
    			listIncomeLevel = incomeLevelMap.get(highestPeopleNo);
    		} else {
    			listIncomeLevel = incomeLevelMap.get(numberOfHouseHoldMembers);	
    		}

    		if (listIncomeLevel != null) {
    			// we have a match for number of people
    			boolean match = false;
    			for (Income_Level_Setting__c incomeLevel : listIncomeLevel) {
    				if ((cr.Monthly_Gross_Income_at_Intake__c * 12 >= incomeLevel.Low_End__c) && 
    					((cr.Monthly_Gross_Income_at_Intake__c * 12 < incomeLevel.High_End__c) || incomeLevel.High_End__c == null )) {
    						// we found the income level category
    						cr.Income_Level__c = incomeLevel.Household_Category__c;
    						match = true;
    						break;
    					}
    			}
    			if (!match) {
    				cr.Income_Level__c = null;
    			}
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