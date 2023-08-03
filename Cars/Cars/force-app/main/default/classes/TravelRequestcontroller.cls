public class TravelRequestcontroller {
    public List<Travel_Request__c> travelreqs{get;set;}
    public string TravelReqId{get;set;}
    Travel_Request__c tr= new Travel_Request__c();
    public List<Travel_Request__c> insertTravelReq{get;set;}
    public string searchString{get;set;}
    public string onKeySearchStr{get;set;}
    private integer counter=0;
    private integer list_size=5;
    public integer total_size;
    public TravelRequestcontroller(){
        insertTravelReq = new list<Travel_Request__c>();
        insertTravelReq.add(tr);
        travelreqs =[SELECT Id,Name,Department__r.Department_Name__c,Place_of_Travel__c,Out_of_State__c,
                     Request_Name__c,Start_Date__c,End_Date__c,Status__c,
                     Total_Expense__c 
                     FROM Travel_Request__c
                     limit:list_size
                     offset:counter
                    ];
        total_size =[SELECT count() FROM Travel_Request__c];
        System.debug('total_size'+total_size);
             System.debug('list_size'+list_size);
             System.debug('counter'+counter);
    } 
    public PageReference viewExpenses(){
       PageReference pg = new PageReference('/apex/TravelRequestDetail?travelReqId='+TravelReqId);
        pg.setRedirect(true);
        return pg; 
    }
    public PageReference createNewReq(){
        PageReference pref = new PageReference('/apex/CreateTravelRequest');
        pref.setRedirect(true);
        return pref;
    }
    public PageReference createExpenses(){
        PageReference pref1 = new PageReference('/apex/CreateTravelRequest?createExpense=true&trReqId='+TravelReqId);
        pref1.setRedirect(true);
        return pref1;
    }
    public void searchRequests(){
        string searchStr = 'SELECT Id,Name,Department__r.Department_Name__c,Place_of_Travel__c,Out_of_State__c,Request_Name__c,'+
                            'Start_Date__c,End_Date__c,Status__c,Total_Expense__c FROM Travel_Request__c '+
                           'WHERE Request_Name__c LIKE \'%'+searchString+'%\'';
        System.debug(searchStr);
     //   if((!isBlank(searchString))){
               travelreqs = Database.query(searchStr);
         
      //  }
    }
    public void clearSearch(){
      travelreqs  = [SELECT Id,Name,Department__r.Department_Name__c,Place_of_Travel__c,Out_of_State__c,Request_Name__c,Start_Date__c,End_Date__c,Status__c,Total_Expense__c FROM Travel_Request__c];  
    }
    public pagereference start(){
        counter=0;
        getRecords();
        return null;
    }
    public pagereference end(){
        counter= total_size-math.mod(total_size,list_size);
        return null;
    }
    public pagereference next(){
        counter = counter+list_size;
        getRecords();
        system.debug('inside next'+list_size);
        system.debug('counter'+counter);
        return null;
    }
    public pagereference prev(){
        counter = counter-list_size;
         getRecords();
        return null;
    }
    public void getRecords(){
         travelreqs =[SELECT Id,Name,Department__r.Department_Name__c,Place_of_Travel__c,Out_of_State__c,
                     Request_Name__c,Start_Date__c,End_Date__c,Status__c,
                     Total_Expense__c 
                     FROM Travel_Request__c
                     limit:list_size
                     offset:counter
                    ];
    }

}