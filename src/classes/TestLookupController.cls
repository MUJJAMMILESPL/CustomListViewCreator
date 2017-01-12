@isTest
private class TestLookupController {

    static testMethod void myUnitTest1() {
        Account a = new Account();
        a.Name = 'ASD';
        a.Type = 'Other';
        insert a;
        Pagereference p = Page.Lookup;
        p.getParameters().put('objectname','Account');
        p.getParameters().put('fieldname','CreatedById');
        p.getParameters().put('datatype','REFERENCE');
        p.getParameters().put('namefield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetName');
        p.getParameters().put('idfield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetId');
        test.setCurrentPage(p);
        LookupController l = new LookupController();
        
    }
    static testMethod void myUnitTest2() {
        Account a = new Account();
        a.Name = 'ASD';
        a.Type = 'Other';
        insert a;
        Pagereference p = Page.Lookup;
        p.getParameters().put('objectname','Account');
        p.getParameters().put('fieldname','Type');
        p.getParameters().put('datatype','PICKLIST');
        p.getParameters().put('namefield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetName');
        p.getParameters().put('idfield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetId');
        test.setCurrentPage(p);
        LookupController l = new LookupController();
        l.lstwrap[0].isChecked = true;
        l.processSelected();
        
    }
    static testMethod void myUnitTest3() {
        Account a = new Account();
        a.Name = 'ASD';
        a.Type = 'Other';
        insert a;
        Pagereference p = Page.Lookup;
        p.getParameters().put('objectname','Account');
        p.getParameters().put('fieldname','IsDeleted');
        p.getParameters().put('datatype','BOOLEAN');
        p.getParameters().put('namefield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetName');
        p.getParameters().put('idfield','j_id0:formId:j_id34:filterid:wrapperListid:0:targetId');
        test.setCurrentPage(p);
        LookupController l = new LookupController();
        l.booleanDisplay();
        l.BooleanSelected();
        l.processSelected();
    }
}