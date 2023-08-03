public class TravelRequestAuraController {
    private static Map<Id,TravelRequest> map_travelRequests = new Map<Id,TravelRequest>();
    private static Map<Id,List<Expense>> map_expenses = new Map<Id,List<Expense>>();
    public without sharing Class TravelRequest{
        @AuraEnabled public string TravelreqName;
        @AuraEnabled public string DepartmentName;
        @AuraEnabled public Date TravelStartDate;
        @AuraEnabled public Date TravelEndDate;
        @AuraEnabled public List<Expense> expenses = new List<Expense>();
    }
    public without sharing Class Expense{
        @AuraEnabled public string ExpenseNum;
        @AuraEnabled public string ExpenseType;
    }
    public without sharing Class ResponseWrapper{
        @AuraEnabled public Boolean success;
        @AuraEnabled public string message;
        @AuraEnabled public List<TravelRequest> travel_requests = new List<TravelRequest>();
        
        public Object createResponse(Boolean success, string message, List<TravelRequest> travel_requests){
            this.travel_requests = travel_requests;
            this.success = success;
            this.message =message;
            return this;
        }   
    }
    @AuraEnabled
    public static Object getTravelRequests(){
        Object responseString;
        ResponseWrapper objResponse = new ResponseWrapper();
        TravelRequest trReq = new TravelRequest();
        try{
            Map<Id,TravelRequest> travelReqMap= new Map<Id,TravelRequest>(); 
            for(Travel_Request__c treq : [SELECT Id,Name,Department__r.Name,End_Date__c,
                                          Out_of_State__c,Place_of_Travel__c,
                                          Start_Date__c,Request_Name__c from Travel_Request__c]){
                                              trReq = new TravelRequest();
                                              trReq.TravelreqName = treq.Request_Name__c;
                                              trReq.DepartmentName =treq.Department__r.Name;
                                              trReq.TravelStartDate  = treq.Start_Date__c;
                                              trReq.TravelEndDate  = treq.End_Date__c;
                                              travelReqMap.put(treq.Id,trReq);
                                          }
            Map<Id,List<Expense>> expenseMap = new Map<Id,List<Expense>>();
            List<Expense> lst_expenses = new List<Expense>();
            Expense expWrapper = new Expense();
            for(Expense_Item__c ex : [SELECT Id,Travel_Request__c,Expense_Type__c,Name from Expense_Item__c WHERE Travel_Request__c IN:travelReqMap.KeySet()])
            {
                expWrapper = new Expense();
                lst_expenses = expenseMap.get(ex.Travel_Request__c);
                if(lst_expenses == null)
                    lst_expenses = new List<Expense>();
                
                expWrapper.ExpenseNum = ex.Name;
                expWrapper.ExpenseType = ex.Expense_Type__c;
                lst_expenses.add(expWrapper);
                expenseMap.put(ex.Travel_Request__c,lst_expenses);
            }
            for(Id travelReqId : travelReqMap.keyset()){
                trReq = new TravelRequest();
                trReq = travelReqMap.get(travelReqId);
                trReq.expenses =  expenseMap.get(travelReqId);
                travelReqMap.put(travelReqId,trReq);
            }
          responseString =   objResponse.createResponse(TRUE,'success', travelReqMap.values());
        }
        catch(Exception e){
            throw e;
        }
        return responseString;  
    }
    @AuraEnabled
    public static Object findTravelRequests(string travelReq){
         Object responseString;
        ResponseWrapper objResponse = new ResponseWrapper();
         string searchStr = 'SELECT Id,Name,Department__r.Name,End_Date__c,Out_of_State__c,Place_of_Travel__c,Start_Date__c,Request_Name__c from Travel_Request__c '+
                           'WHERE Request_Name__c LIKE \'%'+travelReq+'%\'';
        system.debug('searchStr'+searchStr);
        List<Travel_Request__c> travelReqLst = database.query(searchStr);
        TravelRequest trReq = new TravelRequest();
        try{
            Map<Id,TravelRequest> travelReqMap= new Map<Id,TravelRequest>(); 
            for(Travel_Request__c treq : travelReqLst){
                                              trReq = new TravelRequest();
                                              trReq.TravelreqName = treq.Request_Name__c;
                                              trReq.DepartmentName =treq.Department__r.Name;
                                              trReq.TravelStartDate  = treq.Start_Date__c;
                                              trReq.TravelEndDate  = treq.End_Date__c;
                                              travelReqMap.put(treq.Id,trReq);
                                          }
            Map<Id,List<Expense>> expenseMap = new Map<Id,List<Expense>>();
            List<Expense> lst_expenses = new List<Expense>();
            Expense expWrapper = new Expense();
            for(Expense_Item__c ex : [SELECT Id,Travel_Request__c,Expense_Type__c,Name from Expense_Item__c WHERE Travel_Request__c IN:travelReqMap.KeySet()])
            {
                expWrapper = new Expense();
                lst_expenses = expenseMap.get(ex.Travel_Request__c);
                if(lst_expenses == null)
                    lst_expenses = new List<Expense>();
                
                expWrapper.ExpenseNum = ex.Name;
                expWrapper.ExpenseType = ex.Expense_Type__c;
                lst_expenses.add(expWrapper);
                expenseMap.put(ex.Travel_Request__c,lst_expenses);
            }
            for(Id travelReqId : travelReqMap.keyset()){
                trReq = new TravelRequest();
                trReq = travelReqMap.get(travelReqId);
                trReq.expenses =  expenseMap.get(travelReqId);
                travelReqMap.put(travelReqId,trReq);
            }
          responseString =   objResponse.createResponse(TRUE,'success', travelReqMap.values());
        }
        catch(Exception e){
            throw e;
        }
        return responseString;  
    }
}