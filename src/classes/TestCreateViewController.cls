@isTest
private class TestCreateViewController {

    static testMethod void TestCreateViewNew() {
        Pagereference p = page.Create_View;
        p.getParameters().put('isEdit','false');
        p.getParameters().put('ObjName','Account');
        p.getParameters().put('viewname','null');
        test.setCurrentPage(p);     
        Account a = new Account(name= 'Test Acc');
        insert a;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(a);
        CreateViewController c = new CreateViewController(sc);
        c.viewname = 'xyz';
        c.SelectedList.add(new Selectoption('Name','Name'));
         p.getParameters().put('firstParam','1');
        c.changemade = '1';
        c.changeoperator(); 
        for(CreateViewController.wrapper w : c.lstwrapper){
        	w.fieldName = '- None -';
        	w.value = '';
        }
        system.debug('\n\n Wrapper list test :- '+c.lstwrapper + '\n Size is :- '+c.lstwrapper.size());
        c.Save();
        
        
        //c.objectname = 'Account';
       // c.isEdit = false;
        
    }
    static testMethod void TestCreateViewEdit() {
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
       
        Pagereference p = page.Create_View;
        p.getParameters().put('isEdit','true');
        p.getParameters().put('oldObjectName','Account');
        p.getParameters().put('viewname','All');
        test.setCurrentPage(p);     
        Account a = new Account(name= 'Test Acc');
        insert a;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(a);
        CreateViewController c = new CreateViewController(sc);
        c.Save();
        c.Cancel();
        //c.objectname = 'Account';
       // c.isEdit = false;
        
    }
    
    static testMethod void TestCreateViewEditChecknullFilter() {
        lstfield__c l = new lstfield__c();
        l.Name = 'All';
		l.Object__c = 'Account';		
		l.Fields__c = 'Id,Name';
		insert l;
       
        Pagereference p = page.Create_View;
        p.getParameters().put('isEdit','true');
        p.getParameters().put('oldObjectName','Account');
        p.getParameters().put('viewname','All');
        test.setCurrentPage(p);     
        Account a = new Account(name= 'Test Acc');
        insert a;
        Apexpages.Standardcontroller sc = new Apexpages.Standardcontroller(a);
        CreateViewController c = new CreateViewController(sc);
        c.getobjectList();
        c.addrow();
        for(CreateViewController.wrapper w : c.lstwrapper){
        	/*if(w.rowNumber == 1){
	        	w.fieldName = 'Name';
	        	w.operator = '=';
	        	w.value = 'a';
        	}
        	else if(w.rowNumber == 2){
        		w.fieldName = 'type';
	        	w.operator = '=';
	        	w.value = '';
        	}
        	else*/
        	 {
        		w.fieldName = 'Name';
	        	w.operator = '=';
	        	w.value = 'a';
        	}
        }
        
        c.Save();
        //c.objectname = 'Account';
       // c.isEdit = false;
        
    }
}