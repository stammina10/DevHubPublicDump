// Below opportunity trigger will insert similar opportunities based for the account based on amount.
// also throw error when closed won opportunity is deleted
public without sharing class OpportunityHelper {
    public static void getOppty(List<Opportunity> OpptLst) {
        List<Opportunity> opLst = new List<Opportunity>();
        //get existing opportunities that matches amount
        List<Opportunity> exstOppLst = new List<Opportunity>();
        List<Similar_Opportunities__c> simiLst = new List<Similar_Opportunities__c>();
        Set<Id> accId = new set<Id>();
  
        for(Opportunity o: OpptLst){
           for(Opportunity op: [SELECT Id,Name,AccountId from Opportunity WHERE Amount =: o.Amount AND StageName = 'Closed Won'AND AccountId=:o.AccountId]){
            //exstOppLst.add(op);
            Similar_Opportunities__c sop = new Similar_Opportunities__c();
               sop.Opportunity__c = op.Id;
               sop.Name = op.Name;
               sop.Account__c = op.AccountId;
               simiLst.add(sop);
           } 
       }
        system.debug('simiLst'+simiLst);
       if(simiLst.size() > 0)
       insert simiLst;
       
    }
    public static void checkState(List<Opportunity> OptLst){
        for(Opportunity o:OptLst ){
            if(o.StageName == 'Closed Won')
              o.addError('Cannot delete Closed Won Opportunities');  
        }
    }
    
}