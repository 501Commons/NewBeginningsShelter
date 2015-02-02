/** 
* Written by Nineta Martinov, copyright (c) 2013 501Commons
* Utility for trigger to prevent the deletion or modification of the individual/bucket account.
* The ID of the bucket account is defined in custom settings.
*/
public without sharing class AccountTriggerClass {
	public static void MainEntry (List<Account> newList, Map<Id, Account> newMap,
                            			List<Account> oldList, Map<Id, Account> oldMap){
           if (trigger.isBefore) {                 				
	           TriggerControlSettings__c settings = TriggerControlSettings__c.getInstance();                				
	           if (settings != null) {
	           		Id DefaultAcctId = settings.Default_Account_ID__c;
	           		if (trigger.isDelete && oldMap.get(DefaultAcctId) != null) {		
	           			oldMap.get(DefaultAcctId).addError ('You cannot delete the default account.');
	            	} else if (trigger.isUpdate) {
	            		//get the old version of the individual account and the new version of the individual account
            			Account indacc = newMap.get(DefaultAcctId);
            			Account oldacc = oldMap.get(DefaultAcctId);                       
                        if (indacc != null && oldacc != null) {
	            			//If we're trying to change the name do not allow throw error
	            			if (indacc.Name != oldacc.Name) {            		
	            				newMap.get(DefaultAcctId).addError ('You cannot rename or edit the default account.');
	            			//if we're trying to change anything else fail silently/do not modify anything
	            			} else if (indacc.Type != oldacc.Type || indacc.Description != oldacc.Description ||
				            	indacc.ShippingStreet != oldacc.ShippingStreet || indacc.ShippingCity != oldacc.ShippingCity || 
				            	indacc.ShippingState != oldacc.ShippingState || indacc.ShippingPostalCode != oldacc.ShippingPostalCode ||
				            	indacc.ShippingCountry != oldacc.ShippingCountry || indacc.Phone != oldacc.Phone || 
				                indacc.BillingStreet != oldacc.BillingStreet || indacc.BillingCity != oldacc.BillingCity ||
				                indacc.BillingState != oldacc.BillingState || indacc.BillingPostalCode != oldacc.BillingPostalCode ||
				                indacc.BillingCountry != oldacc.BillingCountry ||
				                indacc.Fax != oldacc.Fax || indacc.Website != oldacc.Website) {
	                  	
			                  	 indacc.Type = oldacc.Type;
			                  	 indacc.Description = oldacc.Description;
			                  	 
			                  	 indacc.ShippingStreet = oldacc.ShippingStreet;
			                  	 indacc.ShippingCity = oldacc.ShippingCity; 
			            		 indacc.ShippingState = oldacc.ShippingState; 
			            		 indacc.ShippingPostalCode = oldacc.ShippingPostalCode;
			            		 indacc.ShippingCountry = oldacc.ShippingCountry;
			                  	 
			                  	 indacc.Phone = oldacc.Phone;            	
			            		 
			            		 indacc.BillingStreet = oldacc.BillingStreet;
			            		 indacc.BillingCity = oldacc.BillingCity;
			            		 indacc.BillingState = oldacc.BillingState;
			            		 indacc.BillingPostalCode = oldacc.BillingPostalCode;
			            		 indacc.BillingCountry = oldacc.BillingCountry;  
			            		 
			            		 indacc.Fax = oldacc.Fax;  
			            		 indacc.Website = oldacc.Website;        		             		 
				                }
                        }
	           		}           
	         
	           }                 				
           }
    }
}