import { LightningElement,wire,track } from 'lwc';
import getTravelRequests from '@salesforce/apex/TravelRequestLWCController.getTravelRequests';
import deleteTravelRequest from '@salesforce/apex/TravelRequestLWCController.deleteTravelRequest';
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class TravelRequestDataTable extends LightningElement {
  @track travelReqData;
  tRquestDataRow;
  showLoadingSpinner=false;
  showModal = false;
  travelRequestRow;
  currentRecordId;
  isEditPage=false;
  actions=[
      {label:'View Expenses',name:'view_expenses'},
      {label:'Delete',name:'delete_record'},
      {label:'Edit',name:'edit_Record'}
  ];
    column=[
    {label:'Id',fieldName:'travelRequestId'},
    {label:'Travel Request Number',fieldName:'travelRequestNumber'},
    {label:'Travel Request Name',fieldName:'travelRequestName'},
    {label:'Status',fieldName:'travelStatus'},
    {type:'action',typeAttributes:{rowActions:this.actions,menualignment:'right'}}
    ];
    @wire(getTravelRequests)travelReqData;
    handleRowActions(event){
      const actionName = event.detail.action.name;
      const row = event.detail.row;
      switch(actionName){
        case 'view_expenses':
          this.handleViewExpenses(row);
          break;
        case 'delete_record':
          console.log(actionName);
          this.handleDeleteRecord(row);
          break;
        case 'edit_Record':
          this.handleEditRecord(row);
          break;
      }
    }
    handleViewExpenses(currentRow){
      console.log('currentRow'+currentRow);
      this.tRquestDataRow = currentRow;
      this.showModal = true;
    }
    handleDeleteRecord(currentRow){
      let currentRecord=[];
      this.showLoadingSpinner = true;
      currentRecord.push(currentRow.travelRequestId);
      console.log(currentRow);
      deleteTravelRequest({travelReqIdLst:currentRecord})
      .then(result => {
        console.log(result);
        this.showLoadingSpinner=false;
        this.dispatchEvent(new ShowToastEvent({
          title:'Success!!',
          message:currentRow.travelRequestName+' deleted successfully',
          variant:'Success'
        }),);
        return refreshApex(this.travelReqData);
      })
    }
    handleEditRecord(currentRow){
      this.travelRequestRow = currentRow;
      this.currentRecordId = currentRow.travelRequestId;
      console.log('currentRecordId inside editRecord'+this.currentRecordId);
      this.isEditPage = true;
    }
    handleCloseModal(){
      console.log('inside close modal');
      this.showModal = false;
    }
    handleEditCloseModal(){
      this.isEditPage = false;
    }
    handleSubmit(event){
      console.log('inside submit');
      const fields = event.detail.fields.travelRequestName;
      event.preventDefault();
      this.isEditPage = false;
      this.template.querySelector('lightning-record-edit-form').submit(event.detail.fields);
      this.dispatchEvent(new ShowToastEvent({
        title:'Success!!',
        message:'Edited deleted successfully',
        variant:'Success'
      }),);
    }
    handleSuccess(){
      console.log('inside success');
      return refreshApex(this.travelReqData);
    }
}