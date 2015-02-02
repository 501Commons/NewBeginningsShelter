/***
 * Author: Patrick Tewson for 501 Commons, 2013
 * 
 * For purposes of reporting, we need to know when a Service Participation in certain groups 
 * (support groups) is the first time the individual has attended. This trigger labels the service
 * participations as 'First of Type' if it is the first time the connected individual attends
 * a support group of that type.
 **/

public without sharing class LabelSPTriggerClass {

  // avoid recursion
  public static Boolean inHereAlready = False;
  //private static Set<String> IncludedTypes = new Set<String> {'Support Group', 'Chemical Dependency Group', 'Parenting Group'};
  private static Set<String> IncludedTypes = new Set<String>();
  private static Map<String, Group_Services_Types__c> expSettings = Group_Services_Types__c.getAll();

  public static void MainEntry (List<ServiceParticipation__c> newList, Map<Id, ServiceParticipation__c> newMap,
                            			List<ServiceParticipation__c> oldList, Map<Id, ServiceParticipation__c> oldMap){
                                                  
          //System.debug(' ***** Trigger executing');
          //read the types from Group Services Custom Settings          
		  if (expSettings <> null) {    
   			IncludedTypes.addAll(expSettings.keySet());   			
		  }
		                                           
          if(inHereAlready) {
            return;
          } else {
            inHereAlready = true;
          }
          if(trigger.isAfter) {//After
            if(!trigger.isDelete) {
              updateRelatedObjects(newMap);
            } else {
              updateRelatedObjects(oldMap);
            }
          }
 	  inHereAlready = false;
    }      
    
    private static void updateRelatedObjects(Map<Id, ServiceParticipation__c> newMap) {
      // We want to build a list of all the contacts and types in the affected objects
      System.debug(' ***** Trigger update method');
      Set<String> types = new Set<String>();
      Set<Id> caseRecordIds = new Set<Id>();
      // if the deleted service participation wasn't a 'first', it can't affect the status of others
      for(Id spid: newMap.keySet()) {
        types.add(newMap.get(spid).Type__c);
        caseRecordIds.add(newMap.get(spid).Case_Record__c);
      }

      // Maps are our friends!
      Map<Id,Case_Record__c> caseRecords = 
          new Map<Id, Case_Record__c>([SELECT Name, Id, Contact__c FROM Case_Record__c where Id =: caseRecordIds]);
      
      System.debug('DEBUG >>> what are the case records '+caseRecords);
          
      Set<Id> contacts = new Set<Id>();
      for(Case_Record__c cr: caseRecords.values()) {
        contacts.add(cr.Contact__c);
      }
      List<ServiceParticipation__c> services = 
         [SELECT Id, Name, Type__c, First_Of_Type__c, Case_Record__r.Contact__c, Date_Of_Service__c FROM ServiceParticipation__c 
           WHERE Case_Record__r.Contact__c =: contacts AND Type__c =: types];      

      List<ServiceParticipation__c> updated = new List<ServiceParticipation__c>();
         
      // get earliest participation in the trigger group by Contact and type - MAPS ARE OUR FRIENDS
      Map<Id, Map<String,List<ServiceParticipation__c>>> serviceParticipationMap = new Map<ID, Map<String, List<ServiceParticipation__c>>>();
      for(ServiceParticipation__c service: services) {
        //System.debug('    ***** Within first for loop ' + service.Type__c);
        if(!IncludedTypes.contains(service.Type__c)) {
          continue; 
        }
        System.debug('    ***** Type passed the test! ' + service.Type__c +' Case Record ID: '+service.Case_Record__c);
        if (service.Case_Record__c <> null && caseRecords.get(service.Case_Record__c) <> null) {
        	Id contactId = caseRecords.get(service.Case_Record__c).Contact__c;

	        if(!serviceParticipationMap.containsKey(contactId)) {
	          serviceParticipationMap.put(contactId, new Map<String, List<ServiceParticipation__c>> {service.Type__c => new List<ServiceParticipation__c>()});
	          serviceParticipationMap.get(contactId).get(service.Type__c).add(service);
	          System.debug('    ***** Adding a new map for Contact: '+contactId);
	        } else {
	          Map<String, List<ServiceParticipation__c>> firstByType = serviceParticipationMap.get(contactId);
	          if(!firstByType.containsKey(service.Type__c)) {
	            firstByType.put(service.Type__c, new List<ServiceParticipation__c>());
	            firstByType.get(service.Type__c).add(service);
	            System.debug('    ***** Adding a FIRST new entry for Contact '+contactId + ' and Type: '+service.Type__c);
	          } else {
	            firstByType.get(service.Type__c).add(service);
	            System.debug('    ***** Adding an EXISTING new entry for Contact '+contactId + ' and Type: '+service.Type__c);
	          }
	        }
        }
      }
      for(Id spid: serviceParticipationMap.keySet()) {
        for(String type: serviceParticipationMap.get(spid).keySet()) {
          ServiceParticipation__c theFirst = null;
          for(ServiceParticipation__c service: serviceParticipationMap.get(spid).get(type)) {
            if(service.Date_Of_Service__c == null) {
              continue;
            }
            if(theFirst == null) {
              theFirst = service;
            } else { 
              if(service.Date_Of_Service__c < theFirst.Date_Of_Service__c) {
                theFirst = service;
              }
            }
            service.First_Of_Type__c = False;
            updated.add(service);
          }
          if(theFirst != null) theFirst.First_Of_Type__c = True;
        }
      }
      update(updated);
    }
}