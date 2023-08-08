public with sharing class TravelRequestLWCController {

    public without sharing class travelRequestWrapper{
        @AuraEnabled public string travelRequestName{get;set;}
        @AuraEnabled public Id travelRequestId{get;set;}
        @AuraEnabled public string travelRequestNumber{get;set;}    
        @AuraEnabled public Date travelStartDate;
        @AuraEnabled public Date travelEndDate;
        @AuraEnabled public string travelStatus;
        @AuraEnabled public boolean OutofState;
        @AuraEnabled public string placeOfTravel;
        @AuraEnabled public List<expenseWrapper> expenses{get;set;}
    }
    public without sharing class expenseWrapper{
        @AuraEnabled public Id expenseId;
        @AuraEnabled public decimal expAmount;
        @AuraEnabled public string expenceNum;   
        @AuraEnabled public string expenseType;
    }
    @AuraEnabled(cacheable=true)
    public static List<travelRequestWrapper> getTravelRequests(){
        try {
            Map<Id,travelRequestWrapper> travelReqMap = new Map<Id,travelRequestWrapper>();
            Map<Id,List<expenseWrapper>> finalExpWrapper = new Map<Id,List<expenseWrapper>>();
            List<travelRequestWrapper> wrapper = new List<travelRequestWrapper>();
            travelRequestWrapper wr = new travelRequestWrapper();
            for(Travel_Request__c t:[SELECT Id,Name,Request_Name__c,End_Date__c,Start_Date__c,Status__c,Out_of_State__c,Place_of_Travel__c from Travel_Request__c]){
                wr = new travelRequestWrapper();
                wr.travelRequestId = t.Id;
                wr.travelRequestNumber = t.Name;
                wr.travelRequestName = t.Request_Name__c;
                wr.travelStartDate = t.Start_Date__c;
                wr.travelEndDate = t.End_Date__c;
                wr.travelStatus = t.Status__c;
                wr.OutofState = t.Out_of_State__c;
                wr.placeOfTravel = t.Place_of_Travel__c;
                wrapper.add(wr);
                travelReqMap.put(wr.travelRequestId,wr);
            }
           List<expenseWrapper> expWrapperLst = new List<expenseWrapper>();
           expenseWrapper exWrapper = new expenseWrapper();
            for(Expense_Item__c ex:[SELECT Id,Expense_Type__c,Name,Description__c,Amount__c,Travel_Request__c from Expense_Item__c
                                    WHERE Travel_Request__c IN:travelReqMap.keySet()]){
                                        exWrapper = new expenseWrapper();
                                        if(expWrapperLst == NULL){
                                            expWrapperLst = new List<expenseWrapper>();
                                        }
                                        exWrapper.expenseId = ex.Id;
                                        exWrapper.expAmount = ex.Amount__c;
                                        exWrapper.expenceNum = ex.Name;    
                                        exWrapper.expenseType = ex.Expense_Type__c;  
                                        expWrapperLst.add(exWrapper);  
                                        wr.expenses = expWrapperLst;
                                        travelReqMap.put(ex.Travel_Request__c,wr);
                                      //  finalExpWrapper.put(ex.Travel_Request__c,expWrapperLst);                        
            }
           /* for(Id travelReqId:travelReqMap.keySet()){
              wr = new travelRequestWrapper();
              wr =   travelReqMap.get(travelReqId);
              wr.expenses =finalExpWrapper.get(travelReqId);
              travelReqMap.put(travelReqId,wr);
            }*/

            System.debug('wrapper'+wrapper);
            return travelReqMap.values();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void deleteTravelRequest(List<Id> travelReqIdLst){
        try {
            List<Travel_Request__c> travLst = new List<Travel_Request__c>();
            if(travelReqIdLst != null){
              for(Travel_Request__c tr:[SELECT Id from Travel_Request__c WHERE Id IN:travelReqIdLst]){
                travLst.add(tr);
              }
              if(travLst.size() > 0){
                  delete travLst;
              }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static Id createTravelRequest(Travel_Request__c travelReq){
        try {
            Id travelReqId;
            if(travelReq != null){
                insert travelReq;
                travelReqId = travelReq.Id;
               
            }
            return travelReqId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(Cacheable=true)
    public static Travel_Request__c getSpecificTravelReqDetails(Id travelRequestId){
            return [SELECT Id,Name,Request_Name__c,End_Date__c,Start_Date__c,Status__c,Out_of_State__c,Place_of_Travel__c from Travel_Request__c WHERE Id=:travelRequestId];           
    }
    @AuraEnabled
    public static void insertExpenses(List<Expense_Item__c> expenseLst, Id travelRequestId){
        try {
            system.debug('travelRequestId'+travelRequestId);
            List<Expense_Item__c> expLst = new List<Expense_Item__c>();
            if(expenseLst.size() > 0){
                for(Expense_Item__c exp:expenseLst){
                    Expense_Item__c ex = new Expense_Item__c();
                    ex.Amount__c = exp.Amount__c;
                    ex.Expense_Type__c = exp.Expense_Type__c;
                    ex.Travel_Request__c = exp.Travel_Request__c;
                    expLst.add(ex);
                }
                insert expLst;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}