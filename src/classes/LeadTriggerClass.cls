/***
 * Author: Patrick Tewson for 501 Commons, 2013
 * 
 * Update the region field on Lead based on the value of the zip code. This proved just a bit too much for 
 * formula fields to handle.
 *
 **/

public without sharing class LeadTriggerClass {
  public static Map<String, String> regionMap = new Map<String, String>{
    '98101' => 'City of Seattle',
    '98102' => 'City of Seattle',
    '98103' => 'City of Seattle',
    '98104' => 'City of Seattle',
    '98105' => 'City of Seattle',
    '98106' => 'City of Seattle',
    '98107' => 'City of Seattle',
    '98108' => 'City of Seattle',
    '98109' => 'City of Seattle',
    '98111' => 'City of Seattle',
    '98112' => 'City of Seattle',
    '98113' => 'City of Seattle',
    '98114' => 'City of Seattle',
    '98115' => 'City of Seattle',
    '98116' => 'City of Seattle',
    '98117' => 'City of Seattle',
    '98118' => 'City of Seattle',
    '98119' => 'City of Seattle',
    '98121' => 'City of Seattle',
    '98122' => 'City of Seattle',
    '98124' => 'City of Seattle',
    '98125' => 'City of Seattle',
    '98126' => 'City of Seattle',
    '98127' => 'City of Seattle',
    '98129' => 'City of Seattle',
    '98131' => 'City of Seattle',
    '98132' => 'City of Seattle',
    '98134' => 'City of Seattle',
    '98136' => 'City of Seattle',
    '98138' => 'City of Seattle',
    '98139' => 'City of Seattle',
    '98141' => 'City of Seattle',
    '98144' => 'City of Seattle',
    '98145' => 'City of Seattle',
    '98146' => 'City of Seattle',
    '98150' => 'City of Seattle',
    '98151' => 'City of Seattle',
    '98154' => 'City of Seattle',
    '98160' => 'City of Seattle',
    '98161' => 'City of Seattle',
    '98164' => 'City of Seattle',
    '98165' => 'City of Seattle',
    '98170' => 'City of Seattle',
    '98171' => 'City of Seattle',
    '98174' => 'City of Seattle',
    '98175' => 'City of Seattle',
    '98181' => 'City of Seattle',
    '98184' => 'City of Seattle',
    '98185' => 'City of Seattle',
    '98188' => 'City of Seattle',
    '98191' => 'City of Seattle',
    '98195' => 'City of Seattle',
    '98199' => 'City of Seattle',
    '98133' => 'Seattle/Shoreline',
    '98177' => 'Seattle/Shoreline',
    '98155' => 'Seattle/Shoreline',
    '98011' => 'Other North King County - Bothell, Woodinville, etc.',
    '98012' => 'Other North King County - Bothell, Woodinville, etc.',
    '98021' => 'Other North King County - Bothell, Woodinville, etc.',
    '98028' => 'Other North King County - Bothell, Woodinville, etc.',
    '98041' => 'Other North King County - Bothell, Woodinville, etc.',
    '98072' => 'Other North King County - Bothell, Woodinville, etc.',
    '98172' => 'Other North King County - Bothell, Woodinville, etc.',
    '98001' => 'South King County',
    '98002' => 'South King County',
    '98003' => 'South King County',
    '98010' => 'South King County',
    '98013' => 'South King County',
    '98022' => 'South King County',
    '98023' => 'South King County',
    '98025' => 'South King County',
    '98030' => 'South King County',
    '98031' => 'South King County',
    '98032' => 'South King County',
    '98038' => 'South King County',
    '98035' => 'South King County',
    '98042' => 'South King County',
    '98047' => 'South King County',
    '98051' => 'South King County',
    '98054' => 'South King County',
    '98055' => 'South King County',
    '98056' => 'South King County',
    '98057' => 'South King County',
    '98058' => 'South King County',
    '98062' => 'South King County',
    '98063' => 'South King County',
    '98064' => 'South King County',
    '98071' => 'South King County',
    '98092' => 'South King County',
    '98093' => 'South King County',
    '98148' => 'South King County',
    '98158' => 'South King County',
    '98166' => 'South King County',
    '98168' => 'South King County',
    '98178' => 'South King County',
    '98190' => 'South King County',
    '98198' => 'South King County',
    '98004' => 'East King County',
    '98005' => 'East King County',
    '98006' => 'East King County',
    '98007' => 'East King County',
    '98008' => 'East King County',
    '98009' => 'East King County',
    '98014' => 'East King County',
    '98015' => 'East King County',
    '98027' => 'East King County',
    '98029' => 'East King County',
    '98033' => 'East King County',
    '98034' => 'East King County',
    '98039' => 'East King County',
    '98040' => 'East King County',
    '98045' => 'East King County',
    '98050' => 'East King County',
    '98052' => 'East King County',
    '98053' => 'East King County',
    '98059' => 'East King County',
    '98065' => 'East King County',
    '98073' => 'East King County',
    '98074' => 'East King County',
    '98075' => 'East King County',
    '98083' => 'East King County',
    '98224' => 'East King County',
    '98288' => 'East King County',
    '98070' => 'Vashon Island',
    '98020' => 'Snohomish County',
    '98026' => 'Snohomish County',
    '98036' => 'Snohomish County',
    '98037' => 'Snohomish County',
    '98043' => 'Snohomish County',
    '98087' => 'Snohomish County',
    '98201' => 'Snohomish County',
    '98202' => 'Snohomish County',
    '98203' => 'Snohomish County',
    '98204' => 'Snohomish County',
    '98205' => 'Snohomish County',
    '98206' => 'Snohomish County',
    '98207' => 'Snohomish County',
    '98208' => 'Snohomish County',
    '98209' => 'Snohomish County',
    '98210' => 'Snohomish County',
    '98211' => 'Snohomish County',
    '98212' => 'Snohomish County',
    '98213' => 'Snohomish County',
    '98223' => 'Snohomish County',
    '98270' => 'Snohomish County',
    '98271' => 'Snohomish County',
    '98282' => 'Snohomish County',
    '98292' => 'Snohomish County',
    '98321' => 'Pierce County',
    '98354' => 'Pierce County',
    '98401' => 'Pierce County',
    '98402' => 'Pierce County',
    '98403' => 'Pierce County',
    '98404' => 'Pierce County',
    '98405' => 'Pierce County',
    '98406' => 'Pierce County',
    '98407' => 'Pierce County',
    '98408' => 'Pierce County',
    '98409' => 'Pierce County',
    '98410' => 'Pierce County',
    '98411' => 'Pierce County',
    '98412' => 'Pierce County',
    '98413' => 'Pierce County',
    '98414' => 'Pierce County',
    '98415' => 'Pierce County',
    '98416' => 'Pierce County',
    '98417' => 'Pierce County',
    '98418' => 'Pierce County',
    '98419' => 'Pierce County',
    '98420' => 'Pierce County',
    '98421' => 'Pierce County',
    '98422' => 'Pierce County',
    '98423' => 'Pierce County',
    '98424' => 'Pierce County',
    '98425' => 'Pierce County',
    '98426' => 'Pierce County',
    '98427' => 'Pierce County',
    '98428' => 'Pierce County',
    '98429' => 'Pierce County',
    '98430' => 'Pierce County',
    '98431' => 'Pierce County',
    '98432' => 'Pierce County',
    '98433' => 'Pierce County',
    '98434' => 'Pierce County',
    '98435' => 'Pierce County',
    '98436' => 'Pierce County',
    '98437' => 'Pierce County',
    '98438' => 'Pierce County',
    '98439' => 'Pierce County',
    '98440' => 'Pierce County',
    '98441' => 'Pierce County',
    '98442' => 'Pierce County',
    '98443' => 'Pierce County',
    '98444' => 'Pierce County',
    '98445' => 'Pierce County',
    '98446' => 'Pierce County',
    '98447' => 'Pierce County',
    '98448' => 'Pierce County',
    '98449' => 'Pierce County',
    '98450' => 'Pierce County',
    '98451' => 'Pierce County',
    '98452' => 'Pierce County',
    '98453' => 'Pierce County',
    '98454' => 'Pierce County',
    '98455' => 'Pierce County',
    '98456' => 'Pierce County',
    '98457' => 'Pierce County',
    '98458' => 'Pierce County',
    '98459' => 'Pierce County',
    '98460' => 'Pierce County',
    '98461' => 'Pierce County',
    '98462' => 'Pierce County',
    '98463' => 'Pierce County',
    '98464' => 'Pierce County',
    '98465' => 'Pierce County',
    '98466' => 'Pierce County',
    '98467' => 'Pierce County',
    '98468' => 'Pierce County',
    '98469' => 'Pierce County',
    '98470' => 'Pierce County',
    '98471' => 'Pierce County',
    '98472' => 'Pierce County',
    '98473' => 'Pierce County',
    '98474' => 'Pierce County',
    '98475' => 'Pierce County',
    '98476' => 'Pierce County',
    '98477' => 'Pierce County',
    '98478' => 'Pierce County',
    '98479' => 'Pierce County',
    '98480' => 'Pierce County',
    '98481' => 'Pierce County',
    '98482' => 'Pierce County',
    '98483' => 'Pierce County',
    '98484' => 'Pierce County',
    '98485' => 'Pierce County',
    '98486' => 'Pierce County',
    '98487' => 'Pierce County',
    '98488' => 'Pierce County',
    '98489' => 'Pierce County',
    '98490' => 'Pierce County',
    '98491' => 'Pierce County',
    '98492' => 'Pierce County',
    '98493' => 'Pierce County',
    '98494' => 'Pierce County',
    '98495' => 'Pierce County',
    '98496' => 'Pierce County',
    '98497' => 'Pierce County',
    '98498' => 'Pierce County',
    '98499' => 'Pierce County'
  };

  public static void MainEntry (List<Lead> newList, Map<Id, Lead> newMap,
                            			List<Lead> oldList, Map<Id, Lead> oldMap){
                                                  
          if (trigger.isBefore) {//Before
                if (trigger.isInsert) {                	
                    updateObject(newList);                                   
                } else if (trigger.isUpdate) {                    
                    updateObject(newMap, oldMap);
                }
          }
    }

    private static void setRegionOnLead(Lead l, List<Lead> updatedLeads) {
      String region = 'Unknown';
      if (l.Zip_Code_Calling_From__c <> null) {
        // Some special cases
        if(l.Zip_Code_Calling_From__c == 'Others in WA State') {
          region = 'Others in WA State';
        } else if(l.Zip_Code_Calling_From__c == 'Outside of WA State') {
          region = 'Outside of WA State';
        } else {
          // zip code stored in a string so some processing
          String zipString = '';
          if(l.Zip_Code_Calling_From__c.length() >= 5) {
            zipString = l.Zip_Code_Calling_From__c.substring(0,5);
            if(regionMap.containsKey(zipString)) {
              region = regionMap.get(zipString);
            }
          }
        }
      }
      l.Region__c = region;
      updatedLeads.add(l);
    }
    
    private static void updateObject(Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
    	//for all leads inserted, update the region field
        List<Lead> updatedLeads = new List<Lead>();
    	for (Lead l : newMap.values()) {
          if(l.Zip_Code_Calling_From__c != oldMap.get(l.Id).Zip_Code_Calling_From__c) {
            setRegionOnLead(l, updatedLeads);
          }
    	}
        try {
          update(updatedLeads);
        } catch (Exception e) {
          // do nothing for now, we good
        }
    }

    private static void updateObject(List<Lead> newLeads) {
    	//for all leads inserted, update the region field
        List<Lead> updatedLeads = new List<Lead>();
    	for (Lead l : newLeads) {
          setRegionOnLead(l, updatedLeads);
    	}
        try {
          update(updatedLeads);
        } catch (Exception e) {
          // do nothing for now, we good
        }
    }
}