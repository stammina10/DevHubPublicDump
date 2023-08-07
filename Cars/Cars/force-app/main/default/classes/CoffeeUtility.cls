public with sharing Class CoffeeUtility{
    public List<Coffee__c> getCoffeeDetails(){
        List<Coffee__c> cfeLst = [SELECT Id from Coffee__c LIMIT 50000];
        return cfeLst;
    }
}