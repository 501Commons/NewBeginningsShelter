/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to prevent the deletion or modification of the individual/bucket account.
* The ID of the bucket account is defined in custom settings.
*/
trigger AccountTrigger on Account (before delete, before update) {
	 AccountTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);	
}