public with sharing class Custom_Controller {
	
	public integer PageSize {get;set;}
	public integer PageNumber{get;set;}
	private Integer Counter;
	public Integer TotalPages {get;set;}
	public List<Sobject> lst;
	public Integer TotalRecords {get;set;}
	private Integer newPageIndex = 1;
	public Custom_Controller(List<Sobject> lst){
		this.lst = lst;
		PageNumber = 0;	
		Counter = 0;	
		TotalPages =0;
		TotalRecords = this.lst.size();
		
	}
	
	public void SetPageSize(integer PageSize){
		this.PageSize = PageSize;
		setDetails();
	}
	private void setDetails(){
		if (TotalPages == 0 && lst !=null){
		TotalPages = lst.size() / PageSize;
		Integer mod = lst.size() - (TotalPages * PageSize);
		if (mod > 0)
			TotalPages++;
		}
		
	}
	public List<Sobject> getRecords(){
		List<Sobject> record = new List<Sobject>();		
		try
		{
			if (lst == null)
				return null;
			
			transient Integer counter = 0;
			transient Integer min = 0;
			transient Integer max = 0;
			if (newPageIndex > pageNumber){
				min = pageNumber * pageSize;
				max = newPageIndex * pageSize;
			}
			else
			{
				max = newPageIndex * pageSize;
				min = max - pageSize;			
			}
			for(Sobject a : lst)
			{
				counter++;
				if (counter > min && counter <= max)
					record.add(a);
			}
			
			pageNumber = newPageIndex;						
			if (record == null || record.size() <= 0)
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
			}
			catch(Exception ex)
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
			}
			system.debug('\n\n Records are :- '+record);
			system.debug('\n\n Size is :- '+record.size());
			system.debug('\n\n Page Number is :- '+pageNumber);
		return record;
	}
	
	public void next(){
		system.debug('\n\n before next index is :- '+newPageIndex);
		newPageIndex ++;
		pageNumber++;
		system.debug('\n\n after next index is :- '+newPageIndex);
	}
	public void previous(){
		newPageIndex --;
		pageNumber--;
	}
	
	public void Last(){
		newPageIndex = TotalPages;
		pageNumber = TotalPages;
	}
	public void First(){
		newPageIndex = 1;
		pageNumber = 1;
	}
	public Boolean getPreviousButtonEnabled()
	{
		return !(pageNumber > 1);
	}
	
	public Boolean getNextButtonDisabled()
	{
		if (lst == null) 
			return true;
		else
			return ((pageNumber * pageSize) >= lst.size());
	}
	public boolean gethasNext(){
		system.debug('\n\n Total page :- '+TotalPages);
		system.debug('\n\n PageNumber = '+PageNumber);
		if(PageNumber < TotalPages){
			return true;
		}
		return false;
	}
	public boolean gethasPrevious(){
		system.debug('\n\n previous Total page :- '+TotalPages);
		system.debug('\n\n previous PageNumber = '+PageNumber);
		if(PageNumber >1 && PageNumber <= TotalPages){
			return true;
		}
		return false;
	}
}