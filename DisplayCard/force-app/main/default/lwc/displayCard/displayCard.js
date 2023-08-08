import { LightningElement,track } from 'lwc';
import getCoffeeDetails from '@salesforce/apex/CoffeeUtility.getCoffeeDetails';
export default class DisplayCard extends LightningElement {
@track coffeeData;
    actions=[
    {label:'View Details',name:'view_details'},
    {label:'Add to Cart',name:'add_to_cart'},
    {label:'Compare',name:'compare_details'}
];
column=[
    {label:'Id',fieldName:'coffeeRowId'},
    {label:'Name',fieldName:'coffeeName'},
    {label:'Origin',fieldName:'coffeeOrigin'},
    {label:'Roast',fieldName:'coffeeRoastType'},
    {label:'Description',fieldName:'coffeeDescription'},
    {type:'action',typeAttributes:{rowActions:this.actions,menualignment:'right'}}
    ];
}