public class CampingListController {
    @AuraEnabled
    public static List<Camping_Item__c> getCampingList(){
        List<Camping_Item__c> campingLst = [SELECT Id, Name, Quantity__c, Packed__c, Price__c, Camping_Site__r.Name, Camping_Site__r.Start_Date__c, Camping_Site__r.End_Date__c from 
                                       Camping_Item__c];
        return campingLst;
    }
    @AuraEnabled
    public static void updateCampingItemStatus(Id campingListItemId,string status){
        System.debug('campingListItemId'+campingListItemId);
        system.debug('status'+status);
        List<Camping_Item__c> campingLst = [SELECT Id, Packed__c from Camping_Item__c WHERE Id=:campingListItemId];
        Camping_Item__c c = new Camping_Item__c();
        c.Id = campingLst[0].Id;
        if(status == 'true')
      	  c.Packed__c = true;
        if(status == 'false')
            c.Packed__c = false;
        update c;
    }
    @AuraEnabled
    public static void createCampingListItem (Camping_Item__c item){
        Camping_Item__c ct = new Camping_Item__c(Name = item.Name,
                                                Packed__c = item.Packed__c,
                                                Price__c = item.Price__c,
                                                Quantity__c = item.Quantity__c);
        insert ct;
    }
    @AuraEnabled
    public static void updateStatusToPacked(List<Camping_Item__c> campitemLst){
        List<Camping_Item__c> cLst = new List<Camping_Item__c>();
        System.debug(campitemLst);
        for(Camping_Item__c c:campitemLst ){
            System.debug('c '+c.Name);
            Camping_Item__c it = new Camping_Item__c();
            it.Id = c.Id;
            it.Packed__c = true;
            cLst.add(it);
        }
        if(cLst.size() > 0)
            update cLst;
    }
      @AuraEnabled
    public static void deleteCampingItem(Camping_Item__c item){
        System.debug('item'+item);
        List<Camping_Item__c> campingLst = [SELECT Id, Packed__c from Camping_Item__c WHERE Id=:item.Id];
        if(campingLst.size() > 0)
            delete campingLst;
    }
    public class wrapper{
        public List<Camping_Item__c> campingListItems;
        public string campingSiteName;
        public datetime campingsiteStartDate;
        public datetime campingsiteEndDate; 
    }
    public static wrapper getSites(){
        wrapper wr = new wrapper();
       List<Camping_Item__c> campLst = [SELECT Id, Name, Quantity__c, Packed__c, Price__c, Camping_Site__r.Name, Camping_Site__r.Start_Date__c, Camping_Site__r.End_Date__c from 
                                       Camping_Item__c];
        return wr;
    }
}