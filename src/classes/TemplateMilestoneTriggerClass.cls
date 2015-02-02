/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent template milestones linked to locked contracts from being updated
*/
public without sharing class TemplateMilestoneTriggerClass {
	 public static void MainEntry (List<Template_Milestone__c> newList, Map<Id, Template_Milestone__c> newMap,
                            			List<Template_Milestone__c> oldList, Map<Id, Template_Milestone__c> oldMap){
          if (trigger.isBefore) {//before
                if (trigger.isUpdate) {                	
                   //prevent updates to this template outcome
                   preventUpdates(oldMap, newMap);                                   
                } else if (trigger.isDelete) {
                   	preventUpdates(oldMap);	
                }
          }	                 				
    }
    
     private static void preventUpdates(Map<Id, Template_Milestone__c> oldMap) {
    	for (Template_Milestone__c oldMs : oldMap.values()) {    		
    		if (oldMs.IsParentContractLocked__c){
    			oldMs.addError('The parent contract has been locked, you cannot delete this template milestone.');
    		}
    	}
    }
    
     private static void preventUpdates(Map<Id, Template_Milestone__c> oldMap, Map<Id, Template_Milestone__c> newMap) {
    	for (Template_Milestone__c newC : newMap.values()) {
    		Template_Milestone__c oldC = oldMap.get(newC.id);
    		if (oldC.IsParentContractLocked__c){
    			newC.addError('The parent contract has been locked, you cannot edit this template milestone.');
    		}
    	}
    }
}