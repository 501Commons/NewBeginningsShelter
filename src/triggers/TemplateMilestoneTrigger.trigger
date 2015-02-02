/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent template milestones linked to locked contracts from being changed
*/
trigger TemplateMilestoneTrigger on Template_Milestone__c (after delete, after insert, after update, 
							before delete, before insert, before update) {
	TemplateMilestoneTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}