/** 
* Written by Patrick Tewson, copyright (c) 2013 501Commons
* Trigger to manage Service Participation behavior. Further functionality is documented in the helper class.
*/
trigger LabelSPTrigger on ServiceParticipation__c (after delete, after insert, after update) {
	LabelSPTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);	
}