trigger BedNightTrigger on Bed_Night__c (before delete, before insert) {
	
	BedNightTriggerClass.MainEntry(trigger.new, trigger.old);
}