import { LightningElement,api,track } from 'lwc';
import insertExpenses from '@salesforce/apex/TravelRequestLWCController.insertExpenses';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class CreateExpenseDynamicRows extends LightningElement {
    @api travelrequestid;
    keyIndex=0;
    @track expenseList=[
        {
            Expense_Type__c:'',
            Amount__c:'',
            Travel_Request__c:''
        }
    ];
    handledeleterow(event){
        if(this.expenseList.length > 1){
            --this.keyIndex;
            this.expenseList.splice(event.target.accessKey,1);
        }
    }
    handleAddRow(){
        ++this.keyIndex;
        this.expenseList.push({
            Expense_Type__c:'',
            Amount__c:''
        });
    }
    changeHandler(event){
        if(event.target.name == 'expenseType'){
            this.expenseList[event.target.accessKey].Expense_Type__c = event.target.value;
            this.expenseList[event.target.accessKey].Travel_Request__c = this.travelrequestid;
        }
        if(event.target.name == 'expenseAmount'){
            this.expenseList[event.target.accessKey].Amount__c = event.target.value;
        }
    }
    handleSubmitExpRecords(){
        console.log('travelrequestid'+this.travelrequestid);
        insertExpenses({expenseLst:this.expenseList, travelRequestId:this.travelRequestId})
        .then(result => {
            this.dispatchEvent(new ShowToastEvent({
                title:'Success',
                message:'expense records created successfully',
                variant:'success'
            }),);
        })
    }
}