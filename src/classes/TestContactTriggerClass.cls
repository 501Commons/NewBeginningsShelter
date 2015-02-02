@isTest
private class TestContactTriggerClass {
	private static final Id childRecTypeId = [select Id from RecordType where name='Child'].Id;
    private static final Id partRecTypeId = [select Id from RecordType where name='Participant'].Id;
    
    static testMethod void testContactTrigger() {
    	npo02__Household__c hh = new npo02__Household__c(name = 'TEst HH');
    	insert hh;
    	
    	System.assertEquals(null, [select Number_of_Children__c from npo02__Household__c where id =:hh.id].Number_of_Children__c);
    	
        //create a batch of Contacts        
        List<Contact> listOfContacts = new List<Contact>();
        for (Integer i=0; i<10 ; i++) {
        	Contact c = new Contact(LastName='Test', RecordTypeID=childRecTypeId, npo02__Household__c=hh.id);
        	listOfContacts.add(c);
        }
        insert listOfContacts;        
        //now test that the number of children on the household has been updated
        System.assertEquals(10, [select Number_of_Children__c from npo02__Household__c where id =:hh.id].Number_of_Children__c);
        
        //now delete one of the child contacts
        delete listOfContacts.get(0);
        listOfContacts.remove(0);
        System.assertEquals(9, [select Number_of_Children__c from npo02__Household__c where id =:hh.id].Number_of_Children__c);
        
        //create a new household
        npo02__Household__c hh2 = new npo02__Household__c(name = 'TEst HH2');
    	insert hh2;
    	
    	//update - move all remaining contacts to new household
    	for (Contact c: listOfContacts) {
    		c.npo02__Household__c = hh2.id;
    	}
    	update listOfContacts;
    	System.assertEquals(9, [select Number_of_Children__c from npo02__Household__c where id =:hh2.id].Number_of_Children__c);
        
        //update - change record type from Child to Participant
        for (Contact c: listOfContacts) {
    		c.RecordTypeId = partRecTypeId;
    	}
    	update listOfContacts;
        System.assertEquals(0, [select Number_of_Children__c from npo02__Household__c where id =:hh2.id].Number_of_Children__c);
    }    
}