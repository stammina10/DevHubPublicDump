public class DisplayStudentController {
    
    public class studentWrapperclass{
        @AuraEnabled
        public string studentName;
        @AuraEnabled
        public string studentEmail;
        @AuraEnabled
        public string studentNum;
        @AuraEnabled
        public string regNum;
        @AuraEnabled
        public string courseName;
        @AuraEnabled
        public date regDate;
        
        public studentWrapperclass(string studentName,string studentEmail,string studentNum,string regNum,string courseName,Date regDate){
            this.studentName = studentName;
            this.studentEmail = studentEmail;
            this.studentNum = studentNum;
            this.regNum= regNum;
            this.courseName = courseName;
            this.regDate = regDate;
        }
    }
    @AuraEnabled
    public static List<studentWrapperclass> getStudentDetails(){
        List<studentWrapperclass> newStudentWrap = new List<studentWrapperclass>();
        List<Student__c> studentWrap = new List<Student__c>();
        List<Reservation__c> regWrap = new List<Reservation__c>();
        studentWrap = [SELECT Id,Name,Email_Address__c,Date_of_Birth__c,Roll_Number__c,(SELECT Id,Name,Registered_Course__c,Registered_Date__c From Reservations__r)From Student__c];
        for(Student__c st: studentWrap){
            for(Reservation__c rc:st.Reservations__r){
                newStudentWrap.add(new studentWrapperclass(st.Name,st.Email_Address__c,st.Roll_Number__c,rc.Name, rc.Registered_Course__c,rc.Registered_Date__c));
            }
        }
        system.debug('newStudentWrap'+newStudentWrap);
        return newStudentWrap;
    }
}