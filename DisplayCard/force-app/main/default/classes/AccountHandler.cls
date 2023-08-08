public without sharing class AccountHandler {
 @AuraEnabled
     public static List<Account> getAccounts() {
        List<Account> accLst = [SELECT Id, Name,Type,Industry,BillingStreet,BillingCity,BillingState,BillingPostalCode,NumberOfEmployees,NumberofLocations__c,TickerSymbol from Account LIMIT 50000];
        return accLst;

    }
    @AuraEnabled
    public static List<Account> fetchAccountDetails(Id AccountId){
        try {
            List<Account> accountLst = [SELECT Id,Name,Type,Industry,BillingAddress,NumberOfEmployees,NumberofLocations__c,TickerSymbol from Account where Id=:AccountId];
            return accountLst;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}