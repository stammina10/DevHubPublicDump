public class TravelRequestDetailController {
    public List<Travel_Request__c> travelReqDetail{get;set;}
    public List<Expense_Item__c> expenseItemLst{get;set;}
    public TravelRequestDetailController(){
         Id traReqId = System.currentPageReference().getParameters().get('travelReqId');
        travelReqDetail = [SELECT Id,Name,Department__r.Department_Name__c,Place_of_Travel__c,Out_of_State__c,Request_Name__c,
                           Start_Date__c,End_Date__c,Status__c,Total_Expense__c FROM Travel_Request__c
                           WHERE Id=:traReqId ];
        expenseItemLst = [SELECT Id,Name,Amount__c,Expense_Type__c from Expense_Item__c	WHERE Travel_Request__c=:traReqId];
    }
    public PageReference goback(){
        PageReference pr = new PageReference('/apex/TravelRequestPage');
        pr.setRedirect(true);
        return pr;
    }
}