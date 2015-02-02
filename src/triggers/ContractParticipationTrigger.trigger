/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to auto create outcomes and milestones and attach them to the service participation
*/
trigger ContractParticipationTrigger on ContractParticipation__c (after delete, after insert, after update, 
														before delete, before insert, before update) {
		ContractParticipationTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}