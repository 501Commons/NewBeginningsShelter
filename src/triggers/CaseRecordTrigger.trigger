/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Trigger to create and set a unique participant id based on first case record.
* On case record update - prevent exiting of case record is children's case records are not exited.
*/
trigger CaseRecordTrigger on Case_Record__c (after delete, after insert, after update, 
												before delete, before insert, before update) {
	CaseRecordTriggerClass.MainEntry(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}