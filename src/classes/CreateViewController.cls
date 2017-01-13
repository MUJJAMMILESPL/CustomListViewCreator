// Added Class level comment
// added new one
public with sharing class CreateViewController {   

	public String viewname {get;set;}
	//public List<Selectoption> available {get;set;}
	public List<String> availselected {get;set;}
	public List<String> optselected {get;set;}
	public List<Selectoption> SelectedList {get;set;}
	public Boolean isEdit {get;set;}
	public String msg {get;set;}
	public List<Selectoption> LeftFieldList {get;set;}
	public String objectname {get;set;}
	public String oldObjectName;
	public Map<String,String> mapeditfieldname ;
	String[] lst;
	lstfield__c listviewforEdit;
	public Integer Count {get;set;}
	public List<wrapper> lstwrapper {get;set;}
	public List<Selectoption> lstfeld {get;set;}
	public List<Selectoption> lstoperatorUnknown {get;set;}
	public List<Selectoption> lstoperatorNumber {get;set;}
	public List<Selectoption> lstoperatorString {get;set;}
	public List<Selectoption> lstoperatorApexClassName {get;set;}
	private String InvalidFilterCriteriaName ;
	
	public boolean shownumber {get;set;}
	public String changemade {get;set;}
	private Map<String,String> mapNameToType;
	public String recordId {get;set;}
	public List<Selectoption> lstoperatorlookup {get;set;} 
	private boolean isValidFilterCriteria;
	
	public class wrapper{
		public Integer rowNumber {get;set;}
		public String fieldName {get;set;}
		public String operator {get;set;}
		public String value {get;set;}
		public String datatype {get;set;}
		public String recordId {get;set;}
		public wrapper(Integer rowNumber, String fieldName, String operator, String value){
			this.rowNumber = rowNumber;
			this.operator = operator;
			this.fieldName = fieldName;
			this.value = value;
			datatype = 'unknown';
			recordId = '';
		}
		public wrapper(Integer rowNumber, String fieldName, String operator, String value, String datatype, String Rid){
			this.rowNumber = rowNumber;
			this.operator = operator;
			this.fieldName = fieldName;
			this.value = value;
			this.datatype = datatype;
			recordId = Rid;
		}
	}
	public CreateViewController(ApexPages.StandardController controller) {
		//available = new List<Selectoption>();
		Count = 0;
		availselected = new List<String>();
		SelectedList = new List<Selectoption>();
		optselected = new List<String>();
		lstwrapper = new List<wrapper>();
		lstfeld = new List<Selectoption>();
		lstoperatorUnknown = new List<Selectoption>();
		lstoperatorNumber = new List<Selectoption>();
		lstoperatorString = new List<Selectoption>();
		lstoperatorlookup = new List<Selectoption>();
		lstoperatorApexClassName = new List<Selectoption>();
		
		
		mapeditfieldname = new Map<String,String>();
		boolean ed = Boolean.valueOf(Apexpages.currentPage().getParameters().get('isEdit'));
		if(ed == true){
			String viewnamefromedit = Apexpages.currentPage().getParameters().get('viewname');
			if(viewnamefromedit != 'None' && viewnamefromedit != null){
				oldObjectName = Apexpages.currentPage().getParameters().get('oldObjectName');
				if(viewnamefromedit != null || viewnamefromedit != ''){
					viewname = viewnamefromedit;
					listviewforEdit = [select id,Name, Fields__c,Object__c,Filter_Values__c from lstfield__c where name = :viewname limit 1];
					objectname = listviewforEdit.Object__c;
					lst = listviewforEdit.Fields__c.split(',');
					if(lst.size()>0){
						for(String s : lst){
							SelectedList.add(new Selectoption(s,s));
							mapeditfieldname.put(s,s);
						}
					}
					if(listviewforEdit.Filter_Values__c != null && listviewforEdit.Filter_Values__c != '')	{
						String[] filters = 	listviewforEdit.Filter_Values__c.split('\n');
						system.debug('\n\n filters :- '+filters+' \n\n filters size :- '+filters.size());
						for(String f : filters){
							String[] vals = f.split('!');
							if(vals[2] == 'BLANK'){
								vals[2] = '';
							}
							if(vals[4] == 'NoRecordID'){
								vals[4] = '';
							}
							lstwrapper.add(new wrapper(++Count,vals[0],vals[1],vals[2],vals[3],vals[4]));							
						}	
					}
					else {
						lstwrapper.add(new wrapper(++Count,'','',''));
						lstwrapper.add(new wrapper(++Count,'','',''));
						lstwrapper.add(new wrapper(++Count,'','',''));
						lstwrapper.add(new wrapper(++Count,'','',''));
						lstwrapper.add(new wrapper(++Count,'','',''));
					}	
				}
				else {
					viewname = null;				
				}			
				isEdit = ed;
				msg = 'Update Existing View';
			}
			system.debug('\n\n lstwrapper last isEdit :- '+lstwrapper);
			system.debug('\n\n lstwrapper size :- '+lstwrapper.size());
		}
		else {
			isEdit = false;
			msg = 'Create New View';
			objectname = Apexpages.currentPage().getParameters().get('ObjName');
			lstwrapper.add(new wrapper(++Count,'','',''));
			lstwrapper.add(new wrapper(++Count,'','',''));
			lstwrapper.add(new wrapper(++Count,'','',''));
			lstwrapper.add(new wrapper(++Count,'','',''));
			lstwrapper.add(new wrapper(++Count,'','',''));
		}
				
		getFieldList();
		filloperator();
		if(lstwrapper.size() > 5){
			shownumber = true;
		}
		system.debug('\n\n last cons lstwrapper :- '+lstwrapper);
		system.debug('\n\n lstwrapper size :- '+lstwrapper.size());
    }    
    
	public void getFieldList(){
		system.debug('\n\n\n objectname '+objectname);
		LeftFieldList = new List<Selectoption>();
		lstfeld = new List<Selectoption>();
		mapNameToType = new Map<String,String>();
		lstfeld.add(new Selectoption('- None -','- None -'));
		if(objectname != null && objectname != '-- Select Object --'){
			if(isEdit == false){
				SobjectType Sobj = Schema.getGlobalDescribe().get(objectname);
				Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
				Schema.Describefieldresult Descfield ;
				for(Schema.Sobjectfield feld : objfields.values() ){
					Descfield = feld.getDescribe();	
					if(!Descfield.isDeprecatedAndHidden())						
						LeftFieldList.add(new Selectoption(Descfield.getName(),Descfield.getName()));							
						Schema.Displaytype disp = Descfield.getType();							
						lstfeld.add(new Selectoption(Descfield.getName(),Descfield.getName()));						
						mapNameToType.put(Descfield.getName(),disp.name());
				}	
			}
			if(isEdit == true){
				SobjectType Sobj = Schema.getGlobalDescribe().get(objectname);
				Map<String,Schema.Sobjectfield> objfields = Sobj.getDescribe().fields.getMap();
				Schema.Describefieldresult Descfield ;
				for(Schema.Sobjectfield feld : objfields.values() ){
					Descfield = feld.getDescribe();
					if(!Descfield.isDeprecatedAndHidden()){
						Schema.Displaytype disp = Descfield.getType();							
						lstfeld.add(new Selectoption(Descfield.getName(),Descfield.getName()));						
						mapNameToType.put(Descfield.getName(),disp.name());
						if(!mapeditfieldname.containskey(Descfield.getName()))											
							LeftFieldList.add(new Selectoption(Descfield.getName(),Descfield.getName()));
					}
				}	
			}
		}
		system.debug('\n\n objectname :- '+objectname + '\n\n old object name :- '+oldObjectName);
		
		if(objectname != oldObjectName){
			SelectedList = new List<Selectoption>();
			clearFilter();
		}
		/*lstwrapper = new LIst<wrapper>();
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','',''));
		lstwrapper.add(new wrapper(++Count,'','','')); 
		*/
		
		lstfeld.sort();	
		LeftFieldList.sort();
					
	}
	
	public void clearFilter(){
		system.debug('\n\n\n In clearFilter Methode');		
		List<wrapper> lstwrapper1 = new List<wrapper>();
		for(wrapper w : lstwrapper){
			w.fieldName = '';
			w.operator = '';
			w.value = '';
			w.datatype = 'unknown';
			w.recordId = '';
			lstwrapper1.add(w);
		}
		lstwrapper = new List<wrapper>();
		for(wrapper wr : lstwrapper1){
			lstwrapper.add(wr);
		}
		system.debug('\n\n lstwrapper1 '+lstwrapper1);
		system.debug('\n\n lstwrapper '+lstwrapper);
		
	}
	
	
	public List<Selectoption> getobjectList(){
		List<Selectoption> op = new List<Selectoption>();    	        
    
    	Map<String, Schema.SObjectType> objects = Schema.getGlobalDescribe();
      	Schema.DescribeSObjectResult objInfo = null;
      	for (Schema.SObjectType obj : objects.values()) {
       		objInfo = obj.getDescribe();
       		if(objInfo.isQueryable() && objInfo.isAccessible())
          		op.add(new Selectoption(objInfo.getName(),objInfo.getLabel())) ;
      	}    
      	op.sort();
    	return op;
	}
	
	public Pagereference Save(){
		if(isEdit == false){
			if(SelectedList.size() == 0){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least one field'));
				return null;
			}
			if(objectname.equals('-- Select Object --') || objectname == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Object'));
				return null;
			}	
			if(viewname == null || viewname == ''){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Name Field Can not be Empty'));
				return null;
			}
			if(validateName()){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'View Name Already Exist, Please select another Name'));
				return null;
			}
			else {	
				
				String fieldnm = '';
				Integer lastelement = SelectedList.size() - 1;
				for(Integer i = 0; i<SelectedList.size();i++){
					if(i == lastelement)
						fieldnm += SelectedList[i].getValue();
					else
						fieldnm += SelectedList[i].getValue() + ',';
				}
				String filterValue = saveFilter();
				String filter_Condition = getFilter();
				
				if(isValidFilterCriteria == false){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Filter Criteria'+InvalidFilterCriteriaName));
					return null;
				}
				
				system.debug('\n\n filter_Condition is :- '+filter_Condition);
				
				lstfield__c ListView = new lstfield__c();
				ListView.Name = viewname;
				ListView.Fields__c = fieldnm;
				ListView.Object__c = objectname;
				ListView.Filter_Condition__c = filter_Condition;
				ListView.Filter_Values__c = filterValue;
				insert ListView;
			}
		}
		else {
				if(SelectedList.size() == 0){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select at least one field'));
				return null;
				}	
				if(viewname == null || viewname == ''){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Name Field Can not be Empty'));
					return null;
				}
				if(objectname.equals('-- Select Object --') || objectname == null){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Object'));
				return null;
				}
				String fieldnm = '';
				Integer lastelement = SelectedList.size() - 1;
				for(Integer i = 0; i<SelectedList.size();i++){
					if(i == lastelement)
						fieldnm += SelectedList[i].getValue();
					else
						fieldnm += SelectedList[i].getValue() + ',';
				}
				lstfield__c ListView = listviewforEdit;
				//
				String filterValue = saveFilter();
				String filter_Condition = getFilter();
				
				if(isValidFilterCriteria == false){
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please select valid Filter Criteria'+InvalidFilterCriteriaName));
					return null;
				}
				ListView.Name = viewname;
				ListView.Fields__c = fieldnm;
				ListView.Object__c = objectname;
				// ----------------
				ListView.Filter_Condition__c = filter_Condition;
				ListView.Filter_Values__c = filterValue;
				update ListView;
		}
		Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;
	}
	
	public boolean validateName(){
		List<lstfield__c> ListView = [select Id,Name from lstfield__c where Name = :viewname];
		if(ListView.size() != 0){
			system.debug('*** \n\n\n Already exist name is '+ListView);
			return true;
		}
		return false;
	}
	
	public Pagereference Cancel(){
		Pagereference p = new Pagereference('/apex/ViewDisplay');
		p.setRedirect(true);
		return p;
	}
	
	public void addrow(){
		lstwrapper.add(new wrapper(++Count,'','',''));
		if(Count > 5){
			showNumber = true;
		}
		system.debug('\n\n\n wrapper list is :- '+lstwrapper);
	}
	public void deleterow(){
		if(Count > 5){
			lstwrapper.remove(Count-1);
			Count --;			
		}
		if(Count <= 5 ){
			showNumber = false;
		}
		system.debug('\n\n\n wrapper list is :- '+lstwrapper);
	}
	public void changeoperator(){		
		system.debug('\n\n Wrapper List is :- '+lstwrapper);
		system.debug('\n\n Size is :- '+lstwrapper.size());
		//integer i = Integer.valueOf(changemade);
		
		integer i = Integer.valueOf(ApexPages.currentPage().getParameters().get('firstParam'));
		system.debug('\n\n I = '+i);
		if(lstwrapper.get(i-1).fieldName != '- None -')	{			
			lstwrapper.get(i-1).operator = '=';
			String dtype = mapNameToType.get(lstwrapper.get(i-1).fieldName);
			if(dtype != null){
				if(dtype.equalsIgnoreCase('STRING')  || dtype.equalsIgnoreCase('DOUBLE') || dtype.equalsIgnoreCase('INTEGER') || dtype.equalsIgnoreCase('BOOLEAN')
										 || dtype.equalsIgnoreCase('PHONE')
										  || dtype.equalsIgnoreCase('EMAIL') || dtype.equalsIgnoreCase('REFERENCE') || dtype.equalsIgnoreCase('PICKLIST')){
					lstwrapper.get(i-1).datatype = dtype;
				}
			}
		}	
		else {
			lstwrapper.get(i-1).operator = '- None -';
			lstwrapper.get(i-1).datatype = 'unknown';
		}
		lstwrapper.get(i-1).value = '';
	}
	public void filloperator(){
    	
    	lstoperatorUnknown = new List<Selectoption>();    	
    	lstoperatorUnknown.add(new Selectoption('- None -','- None -'));  	    	
    	//lstoperatorUnknown.add(new Selectoption('=','equals'));
    	//lstoperatorUnknown.add(new Selectoption('<>','not equal to'));
    	
    	
	    	//lstoperator.add(new Selectoption('=','equals'));
    		//lstoperator.add(new Selectoption('<>','not equal to'));
    		lstoperatorNumber = new List<Selectoption>();
    		lstoperatorNumber.add(new Selectoption('- None -','- None -'));
    		lstoperatorNumber.add(new Selectoption('=','equals'));
    		lstoperatorNumber.add(new Selectoption('<>','not equal to'));
	    	lstoperatorNumber.add(new Selectoption(' < ','less than'));
	    	lstoperatorNumber.add(new Selectoption(' <= ','less than or equal to'));   
	    	lstoperatorNumber.add(new Selectoption(' > ','greater than'));
	    	lstoperatorNumber.add(new Selectoption(' >= ','greater than or equal to')); 
    	
    		lstoperatorString = new List<Selectoption>();
    		lstoperatorString.add(new Selectoption('- None -','- None -'));
    		lstoperatorString.add(new Selectoption('=','equals'));
    		lstoperatorString.add(new Selectoption('<>','not equal to'));
    		lstoperatorString.add(new Selectoption('start','starts with'));    
    		lstoperatorString.add(new Selectoption('end','ends with'));	
    		lstoperatorString.add(new Selectoption('contains','contains'));	
    		
    		    		
    		
    		lstoperatorlookup = new List<Selectoption>();
    		lstoperatorlookup.add(new Selectoption('- None -','- None -'));
    		lstoperatorlookup.add(new Selectoption('=','equals'));
    		lstoperatorlookup.add(new Selectoption('<>','not equal to'));
    		
    		lstoperatorApexClassName = new List<Selectoption>();
    		lstoperatorApexClassName.add(new Selectoption('- None -','- None -'));
    		lstoperatorApexClassName.add(new Selectoption('=','equals'));
    		lstoperatorApexClassName.add(new Selectoption('<>','not equal to'));
    		lstoperatorApexClassName.add(new Selectoption('start','starts with'));    
    		lstoperatorApexClassName.add(new Selectoption('end','ends with'));	
    		
    }
	public String getFilter(){		
		String filter = ' where ';	
		String ALPHABETS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
		String DIGIT = '1234567890';	
		InvalidFilterCriteriaName = '';
		isValidFilterCriteria = true;
		for(Integer i = 0;i<lstwrapper.size();i++){
			Integer j = i+1;
			wrapper w = lstwrapper[i];	
			system.debug('\n\n w wrapper is :- '+w);		
			if(w.fieldName != '- None -' && w.operator != '- None -'){
				String datatype = mapNameToType.get(w.fieldName);
				String val = w.value;
				String[] vals;
				if(val == ''){
					val = null;
				}
				if(dataType.equalsIgnoreCase('STRING')  || datatype.equalsIgnoreCase('EMAIL') ){
					if(val != null ){
						
						String op = w.operator;
						if(op == 'start'){
							filter += w.fieldName +' '+ 'Like' + ' \'' + val+'%\' ';
						}	
						else if(op == 'end'){
							filter += w.fieldName +' '+ 'Like' + ' \'%' + val+'\' ';
						}
						else if(op == 'contains'){
							filter += w.fieldName +' '+ 'Like' + ' \'%' + val+'%\' ';
						}
						else {
							String newval = '\''+val + '\'';
							filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';    // for equal and not equal 
						}					
						
					}else {
						//filter += '';
						//isValidFilterCriteria = false;
						//InvalidFilterCriteriaName += ' At row '+j+', ';
					}
				}
				else if(datatype.equalsIgnoreCase('REFERENCE')){
					String id = w.recordId;
					system.debug('\n\n Reference id :- '+id);
					if(id=='')
						id = null;
					else
						system.debug('\n\n  id Length :- '+id.length());
					if(id != null && id.length()== 18){
						String newval = '\''+id + '\'';
						filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';    // for equal and not equal
					}
					else {
						filter += '';
					}
				}
				else if(datatype.equalsIgnoreCase('PICKLIST') ){
					if(val.contains(',')){
						vals = val.split(',');
						filter += ' ( ';
						for(String s : vals){
							String newval = '\''+s + '\'';
							filter += w.fieldName +' '+ w.operator + ' ' + newval+'  or ';
							/*if(newval.containsOnly(ALPHABETS+DIGIT+','))							
								filter += w.fieldName +' '+ w.operator + ' ' + newval+'  or ';
							else {
								filter += '';
								isValidFilterCriteria = false;
								InvalidFilterCriteriaName += ' At row '+j+', ';
							}*/
						}
						filter = filter.substring(0, filter.length()-3);
						filter += ' ) ';
						system.debug('\n\n\n\n ****** Picklist Filter is :- '+filter);						
					}					
					else {
						String newval = '\''+val + '\'';
						filter += w.fieldName +' '+ w.operator + ' ' + newval+' ';
						/*if(newval.containsOnly(ALPHABETS+DIGIT))
							
						else {
							filter += '';
							isValidFilterCriteria = false;
							InvalidFilterCriteriaName += ' At row '+j+', ';
						}	*/
					}
				}
				else if(datatype.equalsIgnoreCase('PHONE')){
					if (val.containsOnly(DIGIT) && val != null){
						String fstr = '({0}) {1}-{2}';										
						String VV =String.format(fstr,new List<String>{val.substring(0, 3), val.substring(3, 6), val.substring(6, 10)});
						filter += w.fieldName +' '+ w.operator + ' \'' + VV+'\' ';
					}else {
						filter += '';
						isValidFilterCriteria = false;
						InvalidFilterCriteriaName += ' At row '+j+', ';
					}
				}
				else if(datatype.equalsIgnoreCase('BOOLEAN') && val != null){
					
					
					if (val.containsOnly('TRUEFALSEtruefalse'))
						filter += w.fieldName +' '+ w.operator + ' ' + val+' ';
					else {						
						filter += '';
						isValidFilterCriteria = false;
						InvalidFilterCriteriaName += ' At row '+j+', ';
					}
				}
				else {	
					// for double data type and boolean 
					if (val.containsOnly(DIGIT) && val != null)
						filter += w.fieldName +' '+ w.operator + ' ' + val+' ';
					else {
						filter += '';
						isValidFilterCriteria = false;
						InvalidFilterCriteriaName += ' At row '+j+', ';
					}
				}
				if(i+1 <= lstwrapper.size()-1 ){
					if(lstwrapper[i+1].fieldName != '- None -' && lstwrapper[i+1].operator != '- None -'){
						system.debug('\n\n\n Appending and to :- '+filter);
						filter += ' and ';
						system.debug('\n After Appending and filter is :- '+filter);
					}
				}
			}	
			else {
				if(i+1 <= lstwrapper.size()-1 && filter.length() > 7){
					if(lstwrapper[i+1].fieldName != '- None -' && lstwrapper[i+1].operator != '- None -'){
						system.debug('\n\n\n Appending and to :- '+filter);
						filter += ' and ';
						system.debug('\n After Appending and filter is :- '+filter);
					}
				}
			}		
		}
		
		if(filter.length() <= 7){
			filter = '';
		}
		if(InvalidFilterCriteriaName.length() > 2)
		InvalidFilterCriteriaName = InvalidFilterCriteriaName.substring(0, InvalidFilterCriteriaName.length()-2);
		system.debug(' \n\n\n Filter condition is :- '+filter);
		
		return filter;
	}
	private String saveFilter(){
		String con = '';
		String temp='';
		for(wrapper w : lstwrapper){
			temp = w.value;
			if(w.value == ''){
				temp = 'BLANK';
			}
			if(w.recordId == ''){
				w.recordId = 'NoRecordID';
			}
			con += w.fieldName+'!'+w.operator+'!'+temp+'!'+w.datatype+'!'+w.recordId+'\n' ;		
		}
		return con;
	}
}
