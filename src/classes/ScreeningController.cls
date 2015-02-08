/** 
* Written by Nineta Martinov, copyright (c) 2015 501Commons
* Controller extension for the screening wizard
*/
public with sharing class ScreeningController {
	 public Screening__c screening;	 
	 public Contact participant { public get; set;}
	 private Id participantId;
	 private Id recordTypeId;
	 private Apexpages.StandardController sc;	
	 
	 public ScreeningController(ApexPages.StandardController stdController) {
	 	//add all fields to controller to create the view state
	 	Schema.DescribeSObjectResult d = Screening__c.sObjectType.getDescribe();
		Set<String> scrFields = d.fields.getMap().keySet();
		List<String> allfields = new List<String>();
		allfields.addAll(scrFields);
	 	if(!Test.isRunningTest()) {
	 		stdController.addFields(allfields);		  	 	    	
	 	}
	 	 	
	 	this.sc = stdController;
        this.screening = (Screening__c)stdController.getRecord(); 
        
        participantId = System.currentPagereference().getParameters().get('partId'); 
        recordTypeId = System.currentPagereference().getParameters().get('RecordTypeId');
        if (screening!= null && (participantId == null || recordTypeId == null))  {        	
        	screening = [select Participant__c, RecordTypeId from Screening__c where id =:screening.Id];
        	participantId = screening.Participant__c;
        	recordTypeId = screening.RecordTypeId;
        }      
        participant = [select Name, FirstName, LastName, Birthdate from Contact where id =:participantId];
    }
    
    // The next three methods control navigation through
   // the wizard. Each returns a PageReference for one of the three pages
   // in the wizard. Note that the redirect attribute does not need to
   // be set on the PageReference because the URL does not need to change
   // when users move from page to page.
   public PageReference getPhoneScreeningPage() {   	      	  
	   return getPageReference(Page.NewOrEditScreeningStep1);
   }

   public PageReference getDVHistoryScreeningPage() {   	      	   
       return getPageReference(Page.NewOrEditScreeningStep2);       
   }
   
   public PageReference getChildrenScreeningPage() {
   	   return getPageReference(Page.NewOrEditScreeningStep3);
   }

   public PageReference getMedicalAndSpecialNeedsScreeningPage() {
   	   return getPageReference(Page.NewOrEditScreeningStep4);
   }

   public PageReference getArrivalScreeningPage() {
   	   return getPageReference(Page.NewOrEditScreeningStep5);
   }
   
   public PageReference getCallInfoAndStatusScreeningPage() {
   	   return getPageReference(Page.NewOrEditScreeningStep6);
   }
   
   private PageReference getPageReference(PageReference page) {
   	   string url = page.getUrl() + '?partId=' + participantId+'&RecordTypeId=' + recordTypeId;  	   	    
	   return new PageReference(url);
   }
 
    public PageReference save() {    	
        if (screening.Participant__c==null){
        	screening.Participant__c = participantId;        
        	screening.RecordTypeId = recordTypeId;        	
    	}
	
		update participant;
	
		this.sc.save();
		//if there were any validation errors display them		
    	if (ApexPages.getMessages().size() == 0)
    	{
    		string url = '/' + participantId;
    		return new PageReference(url);
    	}
    	return null;
    }
    
    public PageReference cancel() {
    	string url = '/' + participantId;
        return new PageReference(url);
    }
}