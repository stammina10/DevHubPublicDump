public class ContactTriggerHandler {
 public static void updateContactCount(List<Contact> conLst){
		System.debug('Inside updateContactCount method');
        set<Id> accId = new set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        for(Contact c: conLst){
           accId.add(c.AccountId); 
        }
        System.debug('Accou8tn Id Set'+accId);
        for( AggregateResult ag: [SELECT count(Id)contactcount, AccountId acc from Contact where AccountId =:accId GROUP BY AccountId]){
            Account a = new Account();
            a.Id = (Id)ag.get('acc');
            a.Number_of_Contacts__c = (Integer)ag.get('contactcount');
            accMap.put(a.Id,a);
        }
        if(accMap.size() > 0)
         database.update(accMap.values());
    }
    public static void insertCaseforContact(List<Contact> conLst){
      List<Case> cseLst = new List<Case>();
        for(Contact con:conLst){
            for(integer c=0; c<2;c++){
                Case cse = new Case();
                cse.AccountId = con.AccountId;
                cse.ContactId = con.Id;
                cse.Reason = 'Other';
                cse.Origin = 'Phone';
                if(c == 0){
                   cse.Subject = system.Label.Case_New_address_Verification;
                   cse.Type = 'Address Verification';
                }
                else{
                    cse.Subject = system.Label.Case_New_Contact_Creation_Subject;   
                    cse.Type = 'New Contact';
                }
                 
                cseLst.add(cse);   
            }
        }
        if(cseLst.size()>0)
        {
            insert cseLst;
            List<Case_related_Task__mdt> caseMdtLst = Case_related_Task__mdt.getAll().values();
            List<Custom_Task__c> tsk1 = new List<Custom_Task__c>();
            for(Case c:cseLst){
               for(Case_related_Task__mdt cmdt : caseMdtLst){
                    if(cmdt.Case_Type__c == c.Type){
                        Custom_Task__c t1 = new Custom_Task__c();
                        t1.Task_Name__c = cmdt.Task_Name__c;
                        t1.Case__c = c.id;
                        t1.Status__c = cmdt.Status__c;
                        tsk1.add(t1);
                    }
                }
            }
            if(tsk1.size() > 0)
                insert tsk1;   
        }    
    }
}