/**
* Author: Nineta Martinov - 501Commons -2014
* Batchable, Schedulable job to create bed nights for Case Records that needs them
* Criteria for case records to be processed:
* 	Case Status = Intake to be completed, Intake Completed
* 	First bednight date = Date of creation, unless bed nights already exist in which case continue where left off
* 	Record type = Shelter / Shelter Children
*/
global class BedNightsBatchJob implements Database.Batchable<sObject>, Schedulable {
	private static Id shelterRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter').getRecordTypeId();
	private static Id shelterChildrenRecordTypeID = Schema.SObjectType.Case_Record__c.getRecordTypeInfosByName().get('Shelter Child').getRecordTypeId();
	private static final List<String> statusList = new List<String>{'\'Intake to be completed\'', '\'Intake Completed\''};	
	
	private static String query = 'select id, CreatedDate, Most_Recent_Bed_Night__c from Case_Record__c where Status__c in '+statusList+
									' and RecordTypeId in (\'' + shelterRecordTypeID + '\', \'' + shelterChildrenRecordTypeID + '\')';		
			
	webservice static void createBedNights() {
		BedNightsBatchJob b = new BedNightsBatchJob();
		Database.executeBatch(b);
	}
	
	global void execute(SchedulableContext sc){
    	BedNightsBatchJob batch = new BedNightsBatchJob();
      	Database.executeBatch(batch);
  	}
  	
  	global database.Querylocator start(Database.BatchableContext bc) {
  		System.debug('DEBUG >>> query is '+query);
		return Database.getQueryLocator(query);		 
	}
	
	global void execute(Database.BatchableContext bc, List<Case_Record__c> scope) {
		Map<Id, Case_Record__c> newCRs = new Map<Id, Case_Record__c>();			
 		for (Case_Record__c o : scope) {
 			newCRs.put(o.Id, o);
 		} 	 
 		createBedNights(newCRs);					
	}

	global void finish(Database.BatchableContext bc) {
	}
	
	public static void createBedNights(Map<Id, Case_Record__c> caseRecs) {
		//map of CR Id to list of bed nights
		Map<Id, List<Bed_Night__c>> crBedNights = new Map<Id, List<Bed_Night__c>>();
		for (Bed_Night__c bn : [select id, Bednight_Date__c, Case_Record__c
									from Bed_Night__c where Case_Record__c in :caseRecs.keySet() 
									order by Bednight_Date__c asc]) {
			if (crBedNights.get(bn.Case_Record__c) == null) {
				crBedNights.put(bn.Case_Record__c, new List<Bed_Night__c>());
			}
			crBedNights.get(bn.Case_Record__c).add(bn);													
		}
						
		List<Bed_Night__c> bedNightsToInsert = new List<Bed_Night__c>();
		//iterate over the bednights for each case record we're processing, if no bed nights 
		//create them starting with creation date of CR, otherwise create from the most recent onwards. 
		for (Id crId : caseRecs.keySet()) {
			List<Bed_Night__c> bnights = crBedNights.get(crId);
			Date mostRecentBN = caseRecs.get(crId).CreatedDate.date();
			if (bnights != null && !bnights.isEmpty()) {		//cr already has some bednights												
				mostRecentBN = caseRecs.get(crId).Most_Recent_Bed_Night__c.addDays(1);					
			}	
			for (Date d=mostRecentBN; d<=date.today(); d=d.addDays(1)) {
				Bed_Night__c bn = new Bed_Night__c(Case_Record__c=crId, Present__c=true, Bednight_Date__c=d);
				bedNightsToInsert.add(bn);
			}
		}
		if (!bedNightsToInsert.isEmpty())
			insert bedNightsToInsert;
	}
}