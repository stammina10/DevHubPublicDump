public class ShipmentAppController {

    public without sharing Class shipmentRequest{
        @AuraEnabled public Id shipmentId;
        @AuraEnabled public string shipmentName;
        @AuraEnabled public string senderName;
        @AuraEnabled public string shipmentAddress;
        @AuraEnabled public Date shipmentDate;
        @AuraEnabled public string shipmentPin;
        @AuraEnabled public string receiverName;  
        @AuraEnabled public string shipmentStatus;
        @AuraEnabled public List<packageDetails> packageList = new List<packageDetails>();
        @AuraEnabled public List<TrackingHistory> trackinghistoryList = new List<TrackingHistory>();
    }
    public without sharing Class packageDetails{
           @AuraEnabled public Id packageId;
        @AuraEnabled public string packagePin;
        @AuraEnabled public Decimal packageWt;
        @AuraEnabled public string packageItems;
    }
    public without sharing Class TrackingHistory{
           @AuraEnabled public Id trackingHistoryId;
        @AuraEnabled public string comments;
        @AuraEnabled public Date trackingDate;
        @AuraEnabled public string shipmentDestination;
        @AuraEnabled public string shipmentSource;
    }
    public without sharing Class responseWrapper{
        @AuraEnabled public List<shipmentRequest> shipmentRequests = new List<shipmentRequest>();
        @AuraEnabled public boolean success;
        @AuraEnabled public string message;
        public Object createResponse(Boolean success, string message,List<shipmentRequest> shipmentrequests){
            this.success = success;
            this.message = message;
            this.shipmentRequests = shipmentrequests;
            return this;
        } 
    }
    public static Object getShipmentRequests(){
        Object responseString;
        responseWrapper wrapper = new responseWrapper();
        try{
            //shipment details
           Map<Id, shipmentRequest> shipmentMap = new Map<Id,shipmentRequest>();
            shipmentRequest sh = new shipmentRequest();
            for(Shipment__c ship:[SELECT Id,Name,Receiver_s_Phone__c,Sender_s_Name__c,Shipment_Address__c,Shipment_Date__c,Shipment_Pin__c,
                                  Shipment_Receiver_s_Name__c,Shipper_Phone_Number__c,Status__c from Shipment__c]){
                                      sh = new shipmentRequest(); 
                                      sh.shipmentId = ship.Id;
                                      sh.shipmentName = ship.Name;
                                      sh.senderName = ship.Sender_s_Name__c;
                                      sh.shipmentAddress = ship.Shipment_Address__c;
                                      sh.shipmentDate = ship.Shipment_Date__c;
                                      sh.receiverName = ship.Shipment_Receiver_s_Name__c;
                                      sh.shipmentStatus = ship.Status__c;
                                      sh.shipmentPin = ship.Shipment_Pin__c;
                                      shipmentMap.put(ship.Id,sh);
                                          }
           // package details
            Map<Id,List<packageDetails>> packageMap = new Map<Id,List<packageDetails>>();
            List<packageDetails> packLst =  new List<packageDetails>();
            packageDetails pack = new packageDetails();
            for(Package__c pk : [SELECT Id,Package_Items__c,Package_Pin__c,Package_Weight__c from Package__c WHERE Shipment__c IN:shipmentMap.Keyset()])
            {
                pack = new packageDetails();
                packLst = packageMap.get(pk.Shipment__c);
                if(packLst == null){
                    packLst= new List<packageDetails>();
                }
                pack.packageId = pk.Id;
                pack.packagePin = pk.Package_Pin__c;
                pack.packageWt = pk.Package_Weight__c;
                pack.packageItems = pk.Package_Items__c;
                packLst.add(pack);
                packageMap.put(pk.Shipment__c,packLst);
            }
            for(Id shipmentId : shipmentMap.keyset()){
                
            }
         //tracking history
         Map<Id,List<TrackingHistory>> trackinghistoryMap = new Map<Id,List<TrackingHistory>>(); 
         List<TrackingHistory> trackingLst = new List<TrackingHistory>();
          TrackingHistory tHistory = new TrackingHistory();
            for(Tracking_History__c th:[SELECT Id from Tracking_History__c WHERE Shipment__c IN:shipmentMap.Keyset()]){
               tHistory = new   TrackingHistory();
               trackingLst = trackinghistoryMap.get(th.Shipment__c);
                if(trackingLst == NULL){
                   trackingLst = new List<TrackingHistory>();
                }
                tHistory.trackingHistoryId = th.Id;
                tHistory.comments = th.Comments__c;
                tHistory.trackingDate  = th.Date__c;
                tHistory.shipmentDestination = th.Destination__c;
                tHistory.shipmentSource = th.Source_Destination__c;
                trackingLst.add(tHistory);
                trackinghistoryMap.put(th.Shipment__c,trackingLst);
            }
            responseString = wrapper.createResponse(true, 'SUCCESS',shipmentMap.values());
        }catch(Exception e){
            throw(e);
        }
        return responseString;
    } 
}