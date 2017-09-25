<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>KCPQ_Update_Lead_Owner_ID</fullName>
        <field>OwnerId</field>
        <lookupValue>Leads_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>KCPQ Update Lead Owner ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>KCPQ Update Lead Owner ID</fullName>
        <actions>
            <name>KCPQ_Update_Lead_Owner_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Company</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
