/*
* Copyright (c) 2014 501Commons
* Utility class to handle insert and delete of Bed Nights
* Prevent insert of bed night with the same date. 
* Prevent deleting of bed night that is not the oldest or most recent bed night.
*/
public without sharing class BedNightTriggerClass {
	
	public static void MainEntry(List<Bed_Night__c> newList, List<Bed_Night__c> oldList) {
		if (trigger.isBefore) {
			if (trigger.isInsert) {
				Map<Id, List<Bed_Night__c>> crBedNights = createCrBedNightMap(newList);
				validateInsert(newList, crBedNights);			
			} else if (trigger.isDelete) { 
				Map<Id, List<Bed_Night__c>> crBedNights = createCrBedNightMap(oldList);
				validateDelete(oldList, crBedNights);
			}
		}
	}
	
	private static void validateDelete(List<Bed_Night__c> bnList, 
									   Map<Id, List<Bed_Night__c>> crBedNightsMap) 
    {
    	for (Bed_Night__c bn : bnList) {
    		Date d = bn.Bednight_Date__c;
    		List<Bed_Night__c> fullBnList = crBedNightsMap.get(bn.Case_Record__c);
    		// get the first and last because the list is sorted
    		Date oldest = fullBnList.get(0).Bednight_Date__c;
    		Date newest = fullBnList.get(fullBnList.size()-1).Bednight_Date__c;
    		if ((d != oldest) && (d != newest)) {
    			bn.addError('You are not allowed to delete this bed night. Only the oldest or the most recent bed night can be deleted.');    			
    		}
    	}
    }
    
	private static void validateInsert(List<Bed_Night__c> bnList, 
									   Map<Id, List<Bed_Night__c>> crBedNightsMap)
	{
		for (Bed_Night__c bn : bnList) {
			List<Bed_Night__c> fullBnList = crBedNightsMap.get(bn.Case_Record__c);
			if (dateAlreadyExists(bn, fullBnList)) {				
				bn.addError('Bed night with this date already exists');
			}
		}
									   	
	}
	
	private static Boolean dateAlreadyExists(Bed_Night__c bn, List<Bed_Night__c> bnList) {
		if ( bnList != null ) {
			for (Bed_Night__c crbn : bnList) {
				if (crbn.Bednight_Date__c == bn.Bednight_Date__c) {
					return true;
				}
			}	
		}
		return false;
	}
	
	private static Map<Id, List<Bed_Night__c>> createCrBedNightMap(List<Bed_Night__c> bnList) {
		Set<Id> crSet = new Set<Id>();
		for (Bed_Night__c bn : bnList) {
			crSet.add(bn.Case_Record__c);
		}
		
		// create a Cr BedNight Map
		Map<Id, List<Bed_Night__c>> crBedNights = new Map<Id, List<Bed_Night__c>>();
		for (Bed_Night__c bn : [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c in :crSet 
									order by Bednight_Date__c asc]) {
			if (crBedNights.get(bn.Case_Record__c) == null) {
				crBedNights.put(bn.Case_Record__c, new List<Bed_Night__c>());
			}
			crBedNights.get(bn.Case_Record__c).add(bn);													
		}
		return crBedNights;
	}

}