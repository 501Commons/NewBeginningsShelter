@isTest
private class TestEditBedNightsControllerExtension{

    @isTest
    static void testController() {
        TestHarness th = new TestHarness();        
        th.createEnrollment();
        //create some bednights
        List<Bed_Night__c> bnights = new List<Bed_Night__c>();
        for (Integer i=0; i<10; i++) {
            Bed_Night__c b = new Bed_Night__c(Case_Record__c=th.cr.id, Bednight_Date__c=date.today()-i);
            bnights.add(b);
        }        
        insert bnights;
        test.startTest();        
        
        ApexPages.StandardSetController stdContr = new ApexPages.StandardSetController(new List<Bed_Night__c>()); 
        ApexPages.currentPage().getParameters().put('id', th.cr.Id);
        EditBedNightsControllerExtension contrExt = new EditBedNightsControllerExtension(stdContr);
        
        List<Bed_Night__c> bedNightsFromController = contrExt.getBedNights();
        System.assertEquals(10, bedNightsFromController.size()); 
        for (Bed_Night__c b : bedNightsFromController) {
            System.assertEquals(null, b.Bednight_Notes__c);
            b.Present__c = true;
        }
        contrExt.save();
        System.assert(contrExt.getSaveComplete());
        bedNightsFromController = contrExt.getBedNights();
        for (Bed_Night__c b : bedNightsFromController ) {
            System.assert(b.Present__c);            
        }
        System.assertEquals(th.cr.Name, contrExt.getCaseRecordName());
        System.assertEquals(th.cr.Id, contrExt.getCaseRecord().Id);
        
        System.assert(!contrExt.hasNext);
        System.assert(!contrExt.hasPrevious);
                        
        contrExt.previous();
        System.assertEquals(10, contrExt.getBedNights().size());
        
        contrExt.next();
        System.assertEquals(10, contrExt.getBedNights().size());
        System.assertEquals(null, contrExt.clearMsg());
    }
    
    
}