/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent template outcomes linked to locked contracts from being updated
*/
public without sharing class TemplateOutcomeTriggerClass {
	 public static void MainEntry (List<Template_Outcome__c> newList, Map<Id, Template_Outcome__c> newMap,
                            			List<Template_Outcome__c> oldList, Map<Id, Template_Outcome__c> oldMap){
          if (trigger.isBefore) {//before
                if (trigger.isUpdate) {                	
                   	//prevent updates to this template outcome
                   	preventUpdates(oldMap, newMap);                                   
                } else if (trigger.isDelete) {
                   	preventUpdates(oldMap);	
                }
          }	                 				
    }
    
    private static void preventUpdates(Map<Id, Template_Outcome__c> oldMap) {
    	for (Template_Outcome__c oldOutcome : oldMap.values()) {    		
    		if (oldOutcome.IsParentContractLocked__c){
    			oldOutcome.addError('The parent contract has been locked, you cannot delete this template outcome.');
    		}
    	}
    }
    
    private static void preventUpdates(Map<Id, Template_Outcome__c> oldMap, Map<Id, Template_Outcome__c> newMap) {
    	for (Template_Outcome__c newC : newMap.values()) {
    		Template_Outcome__c oldC = oldMap.get(newC.id);
    		if (oldC.IsParentContractLocked__c){
    			newC.addError('The parent contract has been locked, you cannot edit this template outcome.');
    		}
    	}
    }
}