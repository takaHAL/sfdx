({
  /* eslint-disable */
  packItem: function (component, event, helper) {
    component.set("v.Item.Packed__c", true);
    var btnClicked = event.getSource();
    btnClicked.set("v.disabled", true);
  }
});
