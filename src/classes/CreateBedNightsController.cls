public with sharing class CreateBedNightsController {
	private string startDate;
	private string endDate;
	private Id caseRecordId;
	
	public String errorMessage = 'There is already a bed night with a date that falls within ' + 
				'this date range. Please change the date range or delete the existing bed night ' +
			    'before proceeding.';
	public String dateRangeError = 'Start date cannot be greater than end date.';		    
	
	public string getCustomStartDate() {
		return startDate;
	}
	
	public string getCustomEndDate() {
		return endDate;
	}
	
	public void setCustomStartDate(string d) {
		this.startDate = d;
	}
	
	public void setCustomEndDate(string d) {
		this.endDate = d;
	}
	
	
	public PageReference create() {
		this.caseRecordId = System.currentPagereference().getParameters().get('caseRecordId');
		if (Date.parse(startDate) > Date.parse(endDate)) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,this.dateRangeError));
			return null;
		}
		if ( caseRecordId != null) {
			// check if there are created bed nights in the select interval
			List<Bed_Night__c> bednights = [SELECT b.Id FROM Bed_Night__c b
						where b.Case_Record__c = :this.caseRecordId 
							and b.IsDeleted = false
							and b.Bednight_Date__c >= :Date.parse(this.startDate)
							and b.Bednight_Date__c <= :Date.parse(this.endDate)];
			if ( bednights.size() > 0) {
				//  there is a bed overlap
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,this.errorMessage));
				return null;
			} else {
				// the bed night records are created
				List<Bed_Night__c> bedNightsToCreate = new List<Bed_Night__c>();
				for (Date d = Date.parse(this.startDate); d <= Date.parse(this.endDate); d = d.addDays(1)) {
					Bed_Night__c bn = new Bed_Night__c(Case_Record__c = this.caseRecordId, Present__c=true, Bednight_Date__c=d);
					bedNightsToCreate.add(bn);
				}
				if (!bedNightsToCreate.isEmpty()) {
					try {
						insert bedNightsToCreate;
					} catch (Exception e) {
						ApexPages.addMessages(e);
						return null;
					}
				}
			}
		} 
		
		//if there were any validation errors display them		
    	if (ApexPages.getMessages().size() == 0)
    	{
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'You have successfully created Bed Nights for the given date range. You can now close this window.'));
    	}
		return null;
	}
	
}