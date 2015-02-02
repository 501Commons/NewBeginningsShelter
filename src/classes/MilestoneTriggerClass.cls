/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Utility class to perform milestone calculations.
*/
public without sharing class MilestoneTriggerClass {
	
	private static boolean updateMilestones = true; //flag to make sure we don't fire the trigger more than once
	
	public static void MainEntry (List<Milestone__c> newList, Map<Id, Milestone__c> newMap,
                            			List<Milestone__c> oldList, Map<Id, Milestone__c> oldMap){
          if (trigger.isAfter && updateMilestones) {
              if (trigger.isUpdate) {
              	updateRelatedObjects(oldMap, newMap);
              } else if (trigger.isDelete){
              	updateRelatedObjects(oldMap);
              } else if (trigger.isInsert) { 
              	updateRelatedObjects(newMap);
              }
              //do not set the flag if unit tests are running
              if (!Test.isRunningTest())
              	updateMilestones = false;
          } 	                 				
    }
    
    //when milestones are inserted or deleted re-count and update outcome
    private static void updateRelatedObjects(Map<Id, Milestone__c> mMap) {
    	List<Id> outcomesToUpdate = new List<Id>();
    	for (Milestone__c m : mMap.values()) {    		
    		outcomesToUpdate.add(m.Outcome__c);    		
    	}
    	if (outcomesToUpdate.size() > 0)
    		updateCounts(outcomesToUpdate);
    }
    
    //if the status of the milestone has changed re-count and update outcome
    private static void updateRelatedObjects(Map<Id, Milestone__c> oldMap, Map<Id, Milestone__c> newMap) {
    	List<Id> outcomesToUpdate = new List<Id>();
    	for (Id k : newMap.keySet()) {
    		Milestone__c newMilestone = newMap.get(k);
    		Milestone__c oldMilestone = oldMap.get(k);
    		if (newMilestone.Status__c <> oldMilestone.Status__c) {
    			outcomesToUpdate.add(newMilestone.Outcome__c);
    		}
    	}
    	if (outcomesToUpdate.size() > 0)
    		updateCounts(outcomesToUpdate);
    }
    
    
   //update counts   
   private static void updateCounts(List<Id> outcomesToUpdate) {      	
    	//get all outcomes
    	List<Outcome__c> outcomes = [select id, Number_of_Milestones_Met__c 
    									 from Outcome__c where id in: outcomesToUpdate];
    	//now get all milestones for the outcomes
    	List<Milestone__c> allMilestones = [select id, Status__c, Outcome__c, Template_Milestone__c, Count__c, Date_Milestone_Met__c 
    											from Milestone__c 
    											where Outcome__c in :outcomesToUpdate 
    											order by Outcome__c, Template_Milestone__c, Date_Milestone_Met__c asc];
		
		//list of outcomes with their actual milestone count, 
		//we want to delete the ones that don't have any milestones left 
		Map<Id, Integer> outcomesWithMilestoneCount = new Map<Id, Integer>();		 
		List<Outcome__c> outcomesToDelete = new List<Outcome__c>();
				
		//<outcome id, map<templ milestone id, met/not met>>
		Map<Id, Map<Id, boolean>> outcomeWithMilestonesMet = new Map<Id, Map<Id, boolean>>();
		
		//Map<templ_milestone id, milestone> map of milestones that need an update to count milestone or not?		  											
		Map<Id, Milestone__c> milestonesCountTrueMap = new Map<Id, Milestone__c>();				
				
		for (Milestone__c m : allMilestones) {
			//keep track of how many milestones each outcome has				
			if (outcomesWithMilestoneCount.get(m.Outcome__c) == null) {//no count yet
				outcomesWithMilestoneCount.put(m.Outcome__c, 0);//initialize		
			}	
			Integer mlCount = outcomesWithMilestoneCount.get(m.Outcome__c);						
			outcomesWithMilestoneCount.put(m.Outcome__c, mlCount++);
			//*******************************************************
			
			if (outcomeWithMilestonesMet.get(m.Outcome__c) == null) {
				Map<Id, boolean> tmMap = new Map<Id, boolean>();				
				outcomeWithMilestonesMet.put(m.Outcome__c, tmMap);
			}	
						
			Map<Id, boolean> tmMap = outcomeWithMilestonesMet.get(m.Outcome__c);
			if (tmMap.get(m.Template_Milestone__c) ==  null) {				
				tmMap.put(m.Template_Milestone__c, false);
			} 			
			
			if (m.Status__c == 'Met') {
				tmMap.put(m.Template_Milestone__c, true);
			}
			
			//now mantain the map for the milestone count flag, if it's the first met milestone
			//then Count? will be true, else it will be false
			if (milestonesCountTrueMap.get(m.Template_Milestone__c) == null && (m.Status__c == 'Met')) { //nothing has been set for this milestone yet
				m.Count__c = true;				
				milestonesCountTrueMap.put(m.Template_Milestone__c, m);
			} else {
				m.Count__c = false;				
			}				
		}	
		
		for (Outcome__c o : outcomes) {
			//get stats for the outcome
			Map<Id, boolean> tmMap = outcomeWithMilestonesMet.get(o.id);
			//now count how many met			
			Integer count = 0;
			if (tmMap != null) {
				for (Id i : tmMap.keySet()) {
					if (tmMap.get(i))
						count++;
				}
			}
			o.Number_of_Milestones_Met__c = count;		
			//********************************************************************
			//some outcomes will have no milestones left attached, so delete them
			if (outcomesWithMilestoneCount.get(o.id)==null){ //can't find outcome in the map of outcomes that have some milestones
				outcomesToDelete.add(o);
			}	
		}	 						
		update outcomes;  
		delete outcomesToDelete;
		update allMilestones; 											
   }
    
}