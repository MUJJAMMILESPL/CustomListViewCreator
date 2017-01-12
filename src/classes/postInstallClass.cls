global with sharing class postInstallClass implements InstallHandler {
	global void onInstall(InstallContext context) {
		lstfield__c l = new lstfield__c();
		l.Name = 'All';
		l.Object__c = 'Account';
		l.Filter_Values__c = '- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID';
		l.Fields__c = 'Id,Name';
		insert l;
	}
}