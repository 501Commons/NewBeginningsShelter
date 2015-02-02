/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to update the number of children in a household everytime a new contact 
* of type Child is inserted/updated/deleted.
*/
trigger ContactTrigger on Contact (after delete, after insert, after update) {
	ContactTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);	
}