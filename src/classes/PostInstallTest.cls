@isTest
public with sharing class PostInstallTest {
	public static testmethod void testPostinstall(){
		postInstallClass p = new postInstallClass();		
		test.testinstall(p,new version(1,0),true);
		List<lstfield__c> l = [select id, Name from lstfield__c limit 1];
		system.assertEquals(l[0].Name, 'All');
	}
}