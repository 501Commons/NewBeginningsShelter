<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Birthday_Email</fullName>
        <description>Birthday Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SupportCaseResponse</template>
    </alerts>
    <alerts>
        <fullName>Notify_HL_Coordinator_of_Completed_Screening</fullName>
        <description>Notify HL Coordinator of Completed Screening</description>
        <protected>false</protected>
        <recipients>
            <recipient>hlcoordinator@newbegin.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lsmith@newbegin.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/Client_Record_Screening_Complete_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_children_advocate</fullName>
        <ccEmails>rtaylor@newbegin.org</ccEmails>
        <description>Notify children advocate.</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/New_Child_Record</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Age_on_Contact</fullName>
        <field>Age__c</field>
        <formula>FLOOR((TODAY() - Birthdate)/365.2425)</formula>
        <name>Set Age on Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactAlternateEmailUpdate</fullName>
        <field>npe01__AlternateEmail__c</field>
        <formula>Email</formula>
        <name>Contact.AlternateEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactHomePhoneUpdate</fullName>
        <field>HomePhone</field>
        <formula>Phone</formula>
        <name>Contact.HomePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactMobilePhoneUpdate</fullName>
        <field>MobilePhone</field>
        <formula>Phone</formula>
        <name>Contact.MobilePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactOtherEmailUpdate</fullName>
        <field>OtherPhone</field>
        <formula>Phone</formula>
        <name>Contact.OtherEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPersonalEmailUpdate</fullName>
        <field>npe01__HomeEmail__c</field>
        <formula>Email</formula>
        <name>Contact.PersonalEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredEmail</fullName>
        <field>Email</field>
        <formula>CASE( 
npe01__Preferred_Email__c , 

&quot;Work&quot;, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Personal&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Home&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Alternate&quot;, 
if(len(npe01__AlternateEmail__c)&gt;0, npe01__AlternateEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__HomeEmail__c)), 

If(LEN(npe01__WorkEmail__c)&gt;0 , npe01__WorkEmail__c , 
if(LEN( npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c 
)))</formula>
        <name>Contact.PreferredEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredPhone</fullName>
        <description>Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE(
  npe01__PreferredPhone__c ,
&quot;Work&quot;,
  npe01__WorkPhone__c  ,
&quot;Home&quot;,
 HomePhone,
&quot;Mobile&quot;,
 MobilePhone,
&quot;Other&quot;,
 OtherPhone,
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c  ,
if(LEN(  HomePhone)&gt;0,  HomePhone,
if(LEN( MobilePhone)&gt;0, MobilePhone,
OtherPhone
))))</formula>
        <name>Contact.PreferredPhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkEmailUpdate</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Contact.WorkEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkPhoneUpdate</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Contact.WorkPhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__PreferredPhonetoWork</fullName>
        <field>npe01__PreferredPhone__c</field>
        <literalValue>Work</literalValue>
        <name>Preferred Phone to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetPrefEmailtoWork</fullName>
        <field>npe01__Preferred_Email__c</field>
        <literalValue>Work</literalValue>
        <name>Set Pref Email to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetWorkEmailtoEmail</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Set Work Email to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__WorkPhonetoPhone</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Work Phone to Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npo02__ContactPreferredPhone_WithHousehold</fullName>
        <description>FOR USE WITH HOUSEHOLDS. Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE( 
npe01__PreferredPhone__c , 
&quot;Work&quot;, 
npe01__WorkPhone__c , 
&quot;Household&quot;,
 npo02__Formula_HouseholdPhone__c ,
&quot;Home&quot;, 
HomePhone, 
&quot;Personal&quot;,
HomePhone,
&quot;Mobile&quot;, 
MobilePhone, 
&quot;Other&quot;, 
OtherPhone, 
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c , 
if(LEN( HomePhone)&gt;0, HomePhone, 
if(LEN( MobilePhone)&gt;0, MobilePhone, 
OtherPhone 
))))</formula>
        <name>Contact.PreferredPhone_WithHousehold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Children%27s Advocate</fullName>
        <actions>
            <name>Notify_children_advocate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Child</value>
        </criteriaItems>
        <description>Notify children&apos;s advocate of new child record created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify Helpline Coordinator of  client screening complete</fullName>
        <actions>
            <name>Notify_HL_Coordinator_of_Completed_Screening</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Status__c</field>
            <operation>equals</operation>
            <value>Pending</value>
        </criteriaItems>
        <description>Workflow will send out email to HL Coordinator when a client screening has been completed (Status = Pending).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Age on Contact</fullName>
        <actions>
            <name>Set_Age_on_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculates and sets the Age for the Contact based on Date of Birth.</description>
        <formula>ISCHANGED(Birthdate)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Alternate</fullName>
        <actions>
            <name>npe01__ContactAlternateEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Alternate&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Personal</fullName>
        <actions>
            <name>npe01__ContactPersonalEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR( ISPICKVAL( npe01__Preferred_Email__c ,&quot;Personal&quot;),ISPICKVAL( npe01__Preferred_Email__c ,&quot;Home&quot;)),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Home</fullName>
        <actions>
            <name>npe01__ContactHomePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Home&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Mobile</fullName>
        <actions>
            <name>npe01__ContactMobilePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Mobile&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Other</fullName>
        <actions>
            <name>npe01__ContactOtherEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Other&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkPhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Email%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Email field based on the Preferred Email field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR( LEN(Email)=0, ISCHANGED(npe01__Preferred_Email__c) , ISCHANGED(npe01__WorkEmail__c) , ISCHANGED(npe01__HomeEmail__c) , ISCHANGED(npe01__AlternateEmail__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Phone%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Phone field based on the Preferred Phone field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR(  LEN(Phone)=0, ISCHANGED(npe01__PreferredPhone__c) ,  ISCHANGED(npe01__WorkPhone__c) ,  ISCHANGED(HomePhone) ,  ISCHANGED(MobilePhone) , ISCHANGED(OtherPhone)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Email only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__SetPrefEmailtoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__SetWorkEmailtoEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__Preferred_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__HomeEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__AlternateEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If there is a value in Email but no values in any email fields or Preferred Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Phone only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__PreferredPhonetoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__WorkPhonetoPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Contact.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__PreferredPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HomePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OtherPhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>A new phone value is added to the Phone field and there is no preferred Phone</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npo02__Contact%2EPreferred_Phone%5F%5Fc WithHousehold</fullName>
        <active>true</active>
        <description>DEPRICATED: This workflow does not do anything yet.</description>
        <formula>1=2</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
