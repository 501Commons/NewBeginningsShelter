/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestAccountTriggerClass {

	static testMethod void testBeforeDeleteTrigger(){		
		//create the individual account
		Account indAccount = new Account(Name='Individual');
		insert indAccount;
		
		//get the individual account id 
		Id indAcctId = [select id from Account where Name='Individual'].id;
		
		//create custom settings		
		TriggerControlSettings__c settings = new TriggerControlSettings__c();
		settings.Default_Account_ID__c = indAcctId;
		insert settings;
		
		//try to delete the individual account
		indAccount = [select id, name from Account where id = :indAcctId];
		try {
			delete indAccount;
		} catch (Exception e) {
			
		}
		//check that the account is still there
		Account indAccountPostDelete = [select id, name from Account where id= :indAcctId];
		System.assertNotEquals(indAccountPostDelete, null);
		
		//try to edit the individual account
		indAccount.Name = 'Change the name account';
		try{
			update indAccount;
		} catch(Exception e) {
			
		}
		Account indAccountPostUpdate = [select name from Account where id =:indAcctId];
		System.assertEquals(indAccountPostUpdate.name, 'Individual');
		
		//try to change one of the other fields that silently fails
		Account indAccount2 = [select id, name, Type, description, phone, shippingStreet, website 
									from Account where id=:indAcctId];
		
		String initialDesc = indAccount2.Description;
		String initialType = indAccount2.Type;
		String initialPhone = indAccount2.Phone;
		String initialShipStreet = indAccount2.ShippingStreet;
		String initialWebsite = indAccount2.Website;
		
		indAccount2.Type = 'Prospect';
		indAccount2.Description = 'Try to change description';
		
		indAccount2.BillingStreet = '123 Street';
		indAccount2.BillingCity = 'Seattle';
		indAccount2.BillingCountry = 'USA';
		indAccount2.BillingPostalCode = '98004';
		indAccount2.BillingState = 'WA';
		
		indAccount2.Phone = '123-4567';
		
		indAccount2.ShippingStreet = '123 Test Shipping';
		indAccount2.ShippingCity = 'bellevue';
		indAccount2.ShippingCountry = 'USA';
		indAccount2.ShippingState = 'WA';
		indAccount2.ShippingPostalCode = '98004';
		
		indAccount2.Website = 'www.google.com';
		
		update indAccount2;
		
		indAccountPostUpdate = [select name, Type, description, phone, billingstreet, billingcity, billingstate,
								billingpostalcode, billingcountry, shippingstreet, shippingcity, shippingpostalcode, 
								shippingstate, shippingcountry, website from Account where id =: indAccount2.Id];
		
		System.assertEquals(indAccountPostUpdate.Type, initialType);						
		System.assertEquals(indAccountPostUpdate.Description, initialDesc);
		System.assertEquals(indAccountPostUpdate.Phone, initialPhone);
		System.assertEquals(indAccountPostUpdate.ShippingStreet, initialShipStreet);
		System.assertEquals(indAccountPostUpdate.Website, initialWebsite);
		
	}    
}