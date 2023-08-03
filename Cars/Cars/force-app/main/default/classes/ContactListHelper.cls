public without sharing class ContactListHelper {
    @AuraEnabled
public static List<Contact> getContacts() {
List<Contact> conLst = [SELECT Id,Name,Title from Contact LIMIT 50000];
        return conLst;
    }
}