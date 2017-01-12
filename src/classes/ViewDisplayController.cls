public with sharing class ViewDisplayController {
	
	public String name {get;set;}
	public String objectname {get;set;}
	public List<Selectoption> setval {get;set;}
	public Boolean show {get;set;}
	public String[] fldnames {get;set;}
	public Custom_Controller sc {get;set;}
	public List<Sobject> lstQuote {get;set;}
	//public boolean show {get;set;}
	public List<Selectoption> view {get;set;}
	private Set<String> OrderbyField ;
	public boolean showEditdelete {get;set;}
	private Set<String> accessibleObjects;
	public List<Selectoption> op {get;set;}
	public String Message {get;set;}
	public  ViewDisplayController( ){
		setval = new List<Selectoption>();
		
		lstQuote = new List<Sobject>();	
		show = false;
		view = new List<Selectoption>();
		OrderbyField = new Set<String>();
		accessibleObjects = new Set<String>();
		op = new List<Selectoption>();
		//name = 'All';
		//objectname = 'Quote';
		getobjectList();
		system.debug('\n\n Hello');
		List<lstfield__c> lstviewOne = [select Name,Object__c from lstfield__c order by LastModifiedDate desc];
		if(lstviewOne.size() > 0){
			for(lstfield__c viewOne : lstviewOne){
				if(accessibleObjects.contains(viewOne.Object__c)){					
					objectname = viewOne.Object__c;
					name = viewOne.Name;
					showEditdelete = true;
					break;
				}
			}
			if(objectname == null && name == null){
				Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Error,'You do not have any List view... Create New List view for Objects'));
				view.add(new Selectoption('None','None'));
			}
		}
		getViews();
		getRecord();				
	}
	
	public void getViews(){
		if(objectname != null){
			List<lstfield__c> views = [select Name from lstfield__c where Object__c = :objectname];	
			view = new List<Selectoption>();					
			for(lstfield__c v :views){
				view.add(new Selectoption(v.Name,v.Name));			
			}	
		}	
	} 
	
	public Pagereference newview(){
		Pagereference p = new Pagereference('/apex/Create_View');
		p.getParameters().put('isEdit','false');
		p.getParameters().put('viewname','null');
		p.getParameters().put('ObjName',objectname);
		p.setRedirect(true);
		return p;
	}	
	public void getobjectList(){
		op = new List<Selectoption>();     
    	Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
      	Schema.DescribeSObjectResult objInfo = null;
      	for (Schema.SObjectType obj : objects.values()) {
       		objInfo = obj.getDescribe();
       		if(objInfo.isQueryable() && objInfo.isAccessible()){
          		op.add(new Selectoption(objInfo.getName(),objInfo.getLabel())) ;
          		accessibleObjects.add(objInfo.getName());
       		}
      	}    
    	op.sort();    	
	}
	
	public void getRecord(){			
		
		if(name != null && name != '--Select View --'){
			system.debug('\n\n\n\n\n New Object Selected is '+objectname);
			system.debug('\n\n accessibleObjects.contains(objectname) '+accessibleObjects.contains(objectname)+' and objectname is :- '+objectname);
			if(accessibleObjects.contains(objectname)){
				lstfield__c fld = [select Fields__c,Object__c,Filter_Condition__c   from lstfield__c where Name = :name limit 1];
							
				fldnames = fld.Fields__c.split(',');			
				String feld = fld.Fields__c;
				
				system.debug('*** \n\n\n field list is '+feld);
				String filter = fld.Filter_Condition__c;
				if(filter == '' || filter == null){
					filter = '';
				}
				
				String ordrBy = OrderQuery();				
				system.debug('\n\n\n Order by :- '+ordrBy);
				String query = 'select '+feld+' from '+ objectname +' '+ filter +' Order by '+ ordrBy+' desc';				
				system.debug('** \n\n Query is :- '+query);				
				if(objectname.equalsIgnoreCase('ApexClass') && feld.contains('Body') && filter == '' && !filter.contains('Name')){
						Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Warning,'You are not supposed to view body of ApexClass Object'));
						return;					
				}
				List<Sobject> l;
				try{
					l = Database.query(query);	
				}catch(DMLException e){
					//Apexpages.addMessages(e);
					Apexpages.addMessage(new Apexpages.Message(Apexpages.severity.ERROR,'You Selected Invalid Filter Criteria !!!'));
					return;
				}			
				system.debug('*** \n\n\n  Query result is '+l);
				if(l.size() > 0){
					sc = new Custom_Controller(l);
					if(objectname.equalsIgnoreCase('ApexClass') && feld.contains('Body'))
						sc.setPageSize(1);					
					else 
						sc.setPageSize(10);						
					lstQuote.clear();						
					lstQuote =  sc.getRecords();
					if(lstQuote.size() > 0){
						show = true;
						system.debug('\n\n Now Showing ... :- '+ show);
					}
				}
				else {
					show = false;
					Message = 'No Records Available for this View. Please Select another view.';
					//Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO,'No Records are Available for this Object'));
				}
			}else {
				//Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.Error,'You are not allowed to view this object'));
				Message = 'You are not allowed to view this object. Please contact your System Administrator to enable access for this object.';
				show = false;
			}
		}	
		else {
			show = false;			
		}	
		system.debug('\n\n\n\n\n\n\n show--------------------------'+show);	
		system.debug('\n\n lstQuote :- '+lstQuote+'\n size :- '+lstQuote.size());
		system.debug('\n\n Exiting from getRecords :- '+show);
	}
	public void del(){
		List<lstfield__c> ls = new List<lstfield__c>();
		if(name.equalsIgnoreCase('All') || name.equalsIgnoreCase('None')){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You can not delete this view'));
		}
		else {		
			ls = [select id from lstfield__c where Name = :name];
			system.debug('\n\n\n Delete List is :- '+ls);		
		}
		if(ls.size() > 0){
			delete ls;
		}	
		
		/*Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;*/
				
	}
	/*public Pagereference newp(){
		Pagereference p = new Pagereference('/0Q0/e');
		p.setRedirect(true);
		return p;
	}*/
	public Pagereference editview(){			
		Pagereference p = new Pagereference('/apex/Create_View');
		p.setRedirect(true);
		p.getParameters().put('isEdit','true');
		p.getParameters().put('viewname',name);
		p.getParameters().put('oldObjectName',objectname);
		return p;
	}
	public void next(){
		if(sc.getHasNext()){
			sc.next();
			lstQuote = sc.getRecords();
		}
	}
	public void previous(){
		if(sc.getHasPrevious()){
			sc.previous();
			lstQuote = sc.getRecords();
		}
	}
	public void firstR(){		
			sc.first();
			lstQuote = sc.getRecords();
		
	}
	public void lastR(){		
			sc.last();
			lstQuote = sc.getRecords();		
	}
	
	private String OrderQuery(){
		String o;
		
		SobjectType Sobj = Schema.getGlobalDescribe().get(objectname);
		Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
		for(String s : objfields.keyset()){
			OrderbyField.add(s);
		}
		system.debug('\n\n objfields CreatedDate :- '+objfields.get('CreatedDate'));
		system.debug('\n\n objectname from Order by :- '+objectname);
		
		if(objfields.containsKey('CreatedDate')){
			o = 'CreatedDate';
			return o;
		}
		if(objfields.containsKey('LastModifiedDate')){
			o = 'LastModifiedDate';
			return o;
		}
		return 'Id';
	}
	
	public void showrec(){
		setval = new List<Selectoption>();			
		system.debug('\n\n\n\n\n New Object Selected is  from action'+objectname);
		getViews();
		if(view.size()>0){
			name = view[0].getValue();
			getRecord();
			showEditdelete = true;
		}
		else {
			view.add(new Selectoption('None','None'));
			show = false;
			showEditdelete = false;
		}
						
	}
}