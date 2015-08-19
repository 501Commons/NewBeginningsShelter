/** 
* Written by N Martinov , copyright (c) 2015 501Commons
* Controller extension for page used to inline edit bed nights
*/
public without sharing class EditBedNightsControllerExtension {
    private Id crId; 
    private Case_Record__c cr;
    private List<Bed_Night__c> bedNights{get; private set;}   
    private boolean saveComplete = false;
    public static Integer PAGE_SIZE = 15;
        
    public EditBedNightsControllerExtension (ApexPages.StandardSetController stdController) {
      crId= ApexPages.currentPage().getParameters().get('id');
      cr = [select name from Case_Record__c where id=:crId];
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, Name, Bednight_Date__c, Bednight_Notes__c, Present__c 
                            FROM Bed_Night__c 
                            where Case_Record__c=:crId order by Bednight_Date__c desc limit 200]));
                setCon.setPageSize(PAGE_SIZE);          
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Bed_Night__c> getBedNights() {
        return (List<Bed_Night__c>) setCon.getRecords();
    }
    
    public Case_Record__c getCaseRecord() {
        return cr;
    }
    
    public String getCaseRecordName() {
        return cr.Name;
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
        saveComplete = true;    
    }    
    
    public Boolean getSaveComplete() {
        return saveComplete;
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
        saveComplete = false;
        setCon.previous();
    }
  
    public void next() {
        saveComplete = false;
        setCon.next();
    }
    
    public PageReference clearMsg() {       
        saveComplete = false;
        return null;        
    }
           
}