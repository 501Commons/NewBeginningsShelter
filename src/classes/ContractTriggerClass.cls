/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent locked contracts from being updated
*/
public without sharing class ContractTriggerClass {
	 public static void MainEntry (List<Contract__c> newList, Map<Id, Contract__c> newMap,
                            			List<Contract__c> oldList, Map<Id, Contract__c> oldMap){
          if (trigger.isBefore) {//before
                if (trigger.isUpdate) {                	
                   //prevent updates to this contract
                   preventUpdates(oldMap, newMap);                                   
                } 
          } 	                 				
    }
    
    private static void preventUpdates(Map<Id, Contract__c> oldMap, Map<Id, Contract__c> newMap) {
    	for (Contract__c newC : newMap.values()) {
    		Contract__c oldC = oldMap.get(newC.id);
    		if (newC.Lock_Contract__c) {
    			if (otherFieldsUpdated(oldC, newC)) {
    				newC.addError('This contract has been locked, you cannot edit any fields except status.');
    			}
    		}
    	}
    }
    
    /*
    * Check if any other fields have changed
    */
    private static boolean otherFieldsUpdated(Contract__c oldC, Contract__c newC) {
    	boolean changed = false;
    	Map<String, Schema.SObjectField> fieldsMap = Schema.SObjectType.Contract__c.fields.getMap();
    	for (String key : fieldsMap.keySet()) {
    		Schema.DescribeFieldResult result = fieldsMap.get(key).getDescribe();
    		if (result.getName() <> 'Status__c' && result.getName() <> 'Lock_Contract__c' 
    				&& result.getName() <> 'IsLocked__c'){
    			if (oldC.get(result.getName()) <> newC.get(result.getName())) {
    				changed = true;
    			}
    		}
    	}
    	return changed;
    }
}