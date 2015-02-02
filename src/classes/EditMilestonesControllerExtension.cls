/** 
* Written by Nineta Martinov , copyright (c) 2013 501Commons
* Controller extension for page used to inline edit milestones 
*/
public without sharing class EditMilestonesControllerExtension {
	private Id servPartId; 
	private ServiceParticipation__c sp;
	private List<Milestone__c> milestones {get; private set;} 	
        
    public EditMilestonesControllerExtension(ApexPages.StandardSetController stdController) {
      servPartId = ApexPages.currentPage().getParameters().get('id');
      sp = [select name from ServiceParticipation__c where id=:servPartId];
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, Name, Status__c, Milestone_NameFormula__c, Service_Participation__c, Outcome__c,
                    		DescriptionFormula__c, Contract_Name__c 
                    		FROM Milestone__c 
                    		where Service_Participation__c=:servPartId limit 200]));
                setCon.setPageSize(10);    		
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Milestone__c> getMilestones() {
        return (List<Milestone__c>) setCon.getRecords();
    }
    
    public ServiceParticipation__c getServiceParticipation() {
    	return sp;
    }
    
    public String getServiceParticipationName() {
    	return sp.Name;
    }
     
    public void save() {
    	Integer pageNumber = setCon.getPageNumber();
    	update setCon.getRecords();    	
    	//clear previous and next
    	setCon.reset();    	
    	if(pageNumber!= 1) {
			setCon.setPageNumber(pageNumber - 1);
			setCon.next();
		}    	   	
    }    
    
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }     
  
    public void previous() {
        setCon.previous();
    }
  
    public void next() {
        setCon.next();
    }
           
}