<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_HL_Coordinator_of_Lead_conversion</fullName>
        <description>Notify HL Coordinator of Lead conversion</description>
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
        <template>New_Beginnings_Email_Folder/Helpline_Lead_Conversion_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_advocate_of_DV_call_having_been_transferred_to_them</fullName>
        <description>Notify advocate of DV call having been transferred to them</description>
        <protected>false</protected>
        <recipients>
            <field>Transferred_to__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/DV_Call_Advocate_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Company_to_Individual</fullName>
        <field>Company</field>
        <formula>&apos;Individual&apos;</formula>
        <name>Set Company to Individual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Last_Name</fullName>
        <field>LastName</field>
        <formula>&apos;Caller&apos;</formula>
        <name>Set Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Time_to_Now</fullName>
        <description>Sets field to system time,</description>
        <field>Call_Time_Out__c</field>
        <formula>NOW()</formula>
        <name>Set Time to Now</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notify Helpline Coordinator of DV Call Conversion</fullName>
        <actions>
            <name>Notify_HL_Coordinator_of_Lead_conversion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.IsConverted</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Everytime a DV Call/ Lead is converted notify the HL Coordinator via email.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify advocate of transfer</fullName>
        <actions>
            <name>Notify_advocate_of_DV_call_having_been_transferred_to_them</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This rule fires when a lead is saved with the transferred field set. Notifies the advocate that a DV call was transferred to them.</description>
        <formula>AND(($RecordType.Name == &apos;DV Call&apos;), NOT(ISBLANK(Transferred_to__c)), ISCHANGED(Transferred_to__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Time Stamp Call Time Out Field</fullName>
        <actions>
            <name>Set_Time_to_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>DV Call</value>
        </criteriaItems>
        <description>When record is saved time stamp the Call Time Out field with system time.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
