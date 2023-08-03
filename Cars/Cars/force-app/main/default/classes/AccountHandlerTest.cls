@isTest
private class AccountHandlerTest {
   @isTest static void testAccountHandler(){
        List<Account> acclt= new List<Account>();
        for(Integer i =0; i<= 100;i++){
            Account a = new Account(Name ='Test Account '+i);
            acclt.add(a);
        }
        insert acclt;
        
           List<Account> b= AccountHandler.getAccounts(); 
        
    } 
}