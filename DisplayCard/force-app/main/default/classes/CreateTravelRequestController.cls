public class CreateTravelRequestController {
    public List<Travel_Request__c> travelReqLst{get;set;}
    public List<Expense_Item__c> expenseItemLst{get;set;}
    public Id travelRequestId{get;set;}
    public string createExpense{get;set;}
    Travel_Request__c tr = new Travel_Request__c();
    Expense_Item__c expItem = new Expense_Item__c();
    public CreateTravelRequestController(){
        createExpense = System.currentPageReference().getParameters().get('createExpense');
        travelRequestId = System.currentPageReference().getParameters().get('trReqId');
        travelReqLst = new List<Travel_Request__c>();
        travelReqLst.add(tr);
        expenseItemLst = new List<Expense_Item__c>();
        expenseItemLst.add(expItem);
    }
    public void saveTravelReq(){
        insert travelReqLst;
        for(Travel_Request__c t: travelReqLst)
        travelRequestId = t.Id;
    }
    public PageReference gobacktoHome(){
        PageReference pr = new PageReference('/apex/TravelRequestPage');
        pr.setRedirect(true);
        return pr;
        
    }
    public void saveExpenses(){
        for(Expense_Item__c e: expenseItemLst){
            e.Travel_Request__c = travelRequestId;
        }
        insert expenseItemLst;
    }
    public void addExpenses(){
        Expense_Item__c ex = new Expense_Item__c();
      expenseItemLst.add(ex);
    }
}