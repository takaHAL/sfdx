import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class ScreenFlowRecordLinks extends NavigationMixin(
  LightningElement
) {
  @api records;
  viewRecord(event) {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.target.value,
        objectApiName: "Account",
        actionName: "view"
      }
    });
  }
}
