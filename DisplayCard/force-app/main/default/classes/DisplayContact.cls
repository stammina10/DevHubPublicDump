public class DisplayContact {

    public List<Contact> contactLst{get;set;}
    public string SearchStrng{get;set;}
    private integer counter=0;
    private integer list_size=5;
    public integer total_size;
    public Id AccountId{get;set;}
    public DisplayContact(){ 
        contactLst = [SELECT Id, FirstName, LastName, Department,Fax,Phone,AccountId,Account.Id from Contact limit:list_size offset:counter];
        total_size = [SELECT Count() from Contact];
    }
    public void searchContact(){
        system.debug('insigde');
       string str='SELECT Id, FirstName, LastName, Department,Fax,Phone from Contact WHERE FirstName LIKE \'%'+SearchStrng+'%\' LIMIT '+list_size+' OFFSET '+counter+''; 
        contactLst = database.query(str);
    }
    public PageReference next(){
        counter =  counter+list_size;
        searchContact();
        return null;
    }
    public PageReference Prev(){
         counter =  counter-list_size;
        searchContact();
        return null;
    }
    public Boolean getdisablePrev(){
        if(counter > 0)
            return false;
        else
        return true;
    }
    public Boolean getdisableNext(){
        if(counter+list_size < total_size )
            return false;
        else 
            return true;
    }
    public PageReference fetchAccountInfo(){
        System.debug('AccountId'+AccountId);
        PageReference pg = new PageReference('/apex/DisplayAccount?AccountId='+AccountId);
        pg.setRedirect(true);
        return pg;
    }
    
}