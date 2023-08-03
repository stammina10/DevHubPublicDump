public class DisplayAccount {
    public List<Account> accountLst{get;set;}
    public Id accountId{get;set;}
    public DisplayAccount(){
        accountId = system.currentPageReference().getParameters().get('AccountId');
       accountLst = [SELECT Id,Name from Account Where Id=:accountId]; 
    }
}