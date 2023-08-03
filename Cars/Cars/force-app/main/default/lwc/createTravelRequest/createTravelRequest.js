import ConditionCount from '@salesforce/schema/MacroUsage.ConditionCount';
import { LightningElement,track,api,wire} from 'lwc';
import createTravelRequest from '@salesforce/apex/TravelRequestLWCController.createTravelRequest';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getSpecificTravelReqDetails from '@salesforce/apex/TravelRequestLWCController.getSpecificTravelReqDetails';
export default class CreateTravelRequest extends LightningElement {
    createSection=false;
    showLoadingSpinner=false;
    displayrecord=false;
    message;
    @api savedRecordId;
    travelData;
    expenseListDisplay=false;
    displayButton=true;
    @track travelReqLst={
        Name:'',
        Status__c:'',
        Request_Name__c:'',
        End_Date__c:'',
        Start_Date__c:'',
        Out_of_State__c:'',
        Place_of_Travel__c:''
    };
    handleCreateRequest(){
        this.createSection = true;
    }
    handleChange(event){
        if(event.target.name == "travelReqName"){
            this.travelReqLst.Request_Name__c = event.target.value;
            console.log('event.target.value'+event.target.value);
        }
        if(event.target.name == "travelReqStatus"){
            this.travelReqLst.Status__c = event.target.value;
            console.log('event.target.value'+event.target.value);
        }
    }
    handleSubmit(){
        this.showLoadingSpinner = true;
        this.createSection = false;
        createTravelRequest({travelReq:this.travelReqLst})
        .then(result => {
            this.showLoadingSpinner = false;
            this.savedRecordId = result;
         //   this.createSection = false;
            console.log('dhfjhdfj');
            this.handlefetchdetails();
        /*    this.dispatchEvent(new ShowToastEvent({
                title:'Success!!',
                message:'Record created successfully',
                variant:'success'
            }),); */
         //   this.createSection = false;
         const created=true;
        this.dispatchEvent(new CustomEvent("created",{detail:{created}}));
        })
    }
    handlefetchdetails(){
        console.log('inside ftech details');
        getSpecificTravelReqDetails({travelRequestId:this.savedRecordId})
        .then(result => {
           this.travelData = result;
           console.log('travelData'+this.travelData);
           console.log('travelData.Name'+this.travelData.Name);
           this.displayrecord = true;
        })
    }
    handleCloseModal(){
        this.displayrecord = false;
    }
    handleExpenseList(){
        this.expenseListDisplay = true;
        this.displayButton = false;
    }
}