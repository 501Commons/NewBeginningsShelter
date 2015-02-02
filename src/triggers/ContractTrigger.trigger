/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent locked contracts from being updated
*/
trigger ContractTrigger on Contract__c (after delete, after insert, after update, 
											before delete, before insert, before update) {
	ContractTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}