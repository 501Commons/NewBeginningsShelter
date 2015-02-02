/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to update the metrics on parent outcome when the status of a milestone changes.
*/
trigger MilestoneTrigger on Milestone__c (after delete, after insert, after update, 
												before delete, before insert, before update) {
	 MilestoneTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}