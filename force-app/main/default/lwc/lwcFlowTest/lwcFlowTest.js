import { LightningElement } from "lwc";

export default class LwcFlowTest extends LightningElement {
  // RESTART 終了後再開
  // NONE そのまま終了
  finishBehavior = "NONE";

  get inputVariables() {
    return [
      {
        name: "inputTest",
        type: "String",
        value: "テストデータ"
      }
    ];
  }

  handleStatusChange(event) {
    console.log(event.detail);
    console.log(event.detail.status);
    if (event.detail.status === "FINISHED") {
      // set behavior after a finished flow interview
    }
  }
}
