<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_HL_Coordinator_on_Incomplete_Intake</fullName>
        <description>Notify HL Coordinator on Incomplete Intake</description>
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
        <template>New_Beginnings_Email_Folder/Intake_Could_NOT_be_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_HL_Coordinator_on_Intake_Complete</fullName>
        <description>Notify HL Coordinator on Intake Completed</description>
        <protected>false</protected>
        <recipients>
            <recipient>hlcoordinator@newbegin.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sf_administrator@newbegin.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/Intake_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_advocate_of_case_record_having_been_transferred_to_them</fullName>
        <description>Notify advocate of case record having been transferred to them</description>
        <protected>false</protected>
        <recipients>
            <field>Advocate__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/Case_Record_Has_Been_Assigned</template>
    </alerts>
    <alerts>
        <fullName>Notify_data_coordinator_that_a_case_record_has_been_exited</fullName>
        <description>Notify data coordinator that a case record has been exited.</description>
        <protected>false</protected>
        <recipients>
            <recipient>sf_administrator@newbegin.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>New_Beginnings_Email_Folder/Case_Record_Exited_Email_Template</template>
    </alerts>
    <rules>
        <fullName>Notify Advocate when Case is Assigned</fullName>
        <actions>
            <name>Notify_advocate_of_case_record_having_been_transferred_to_them</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This rule will fire when the Advocate field on the case record changes. An email will be sent out to them to indicate that a case record has been assigned to them.</description>
        <formula>IF( ISNEW(), NOT(ISNULL( Advocate__c )) , ISCHANGED( Advocate__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify HL Coordinator of Completed Intake</fullName>
        <actions>
            <name>Notify_HL_Coordinator_on_Intake_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Record__c.Status__c</field>
            <operation>equals</operation>
            <value>Intake completed</value>
        </criteriaItems>
        <description>Workflow to notify the HL Coordinator that an intake has been completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify HL Coordinator of Incomplete Intake</fullName>
        <actions>
            <name>Notify_HL_Coordinator_on_Incomplete_Intake</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Record__c.Status__c</field>
            <operation>equals</operation>
            <value>Intake could not be completed</value>
        </criteriaItems>
        <description>Workflow to notify the HL Coordinator that an intake could not be completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify of Case Record Exited</fullName>
        <actions>
            <name>Notify_data_coordinator_that_a_case_record_has_been_exited</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case_Record__c.Status__c</field>
            <operation>equals</operation>
            <value>Exited</value>
        </criteriaItems>
        <description>Notifies Administrator of an exited case record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
