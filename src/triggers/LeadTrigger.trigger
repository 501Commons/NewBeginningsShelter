/** 
* Written by Patrick Tewson, copyright (c) 2013 501Commons
* Trigger to manage Lead behavior. Further functionality is documented in the helper class.
*/
trigger LeadTrigger on Lead (after delete, before insert, before update) {
	LeadTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);	
}