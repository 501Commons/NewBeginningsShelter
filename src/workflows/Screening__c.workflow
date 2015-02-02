<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_screening_name</fullName>
        <description>Sets screening name (Shelter)(Participant ID)(Screening Date)(&quot;Screening&quot;)</description>
        <field>Name</field>
        <formula>&quot;SH &quot; &amp; Participant__r.Participant_Id__c &amp; &quot; &quot; &amp; TEXT(MONTH(TODAY())) &amp; &quot;/&quot; &amp; TEXT(DAY(TODAY())) &amp; &quot;/&quot; &amp; TEXT(YEAR(TODAY())) &amp; &quot; Screening&quot;</formula>
        <name>Set screening name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Screening Name</fullName>
        <actions>
            <name>Set_screening_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the screening name to (Shelter)(Participant ID)(Screening Date)(&quot;Screening&quot;)</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
