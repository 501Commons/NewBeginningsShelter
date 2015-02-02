@isTest
private class TestServiceParticipationGoalsTrigger {
    static testMethod void updateServiceParticipation(){
        // get the case record for Marge Simpson
        Case_Record__c c = [SELECT Id, Name, (SELECT Id from Participations__r) from Case_Record__c WHERE Name like '%SH PART-01888 11/2014 Case Record%'];
        system.debug('test:' + c);
        // retrieve the first ServiceParticipation__c
        /*
        ServiceParticipation__c sp = c.Participations__r.get(0); 
        system.debug('[rpop] sp:' + sp.Goals__c);
		*/
    }
}