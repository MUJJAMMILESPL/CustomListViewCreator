@isTest
private class TestViewDisplayController {

    static testMethod void TestViewDisplay() {
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
		lstfield__c l1 = new lstfield__c();
        l1.Name = 'All1';
		l1.Object__c = 'Account';
		l1.Filter_Values__c = '- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID'+'\n'+
								'- None -!- None -!BLANK!unknown!NoRecordID';
		l1.Fields__c = 'Id,Name';
		insert l1;
		List<Account> lstAcc = new List<Account>();
		for(integer i= 0; i<101;i++){
			Account a = new Account();
			a.Name = 'ESPL';
			lstAcc.add(a);
		}
		insert lstAcc;
		Pagereference p = Page.ViewDisplay;		
		Test.setCurrentPage(p);
		ViewDisplayController v = new ViewDisplayController();
		v.objectname = 'Account';
		v.name = 'All1';				
		v.getRecord();
		v.newview();		
		v.del();
		v.name = 'All1';
		v.del();
		v.editview();
		v.next();
		v.lastR();
		v.previous();
		v.firstR();
		v.objectname = null;
		v.name = null;
		v.getRecord();
    }
}