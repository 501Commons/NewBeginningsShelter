/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent template outcomes linked to locked contracts from being changed
*/
trigger TemplateOutcomeTrigger on Template_Outcome__c (after delete, after insert, after update, 
		before delete, before insert, before update) {
	TemplateOutcomeTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}