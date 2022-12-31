({
  /* eslint-disable */
  clickCreateItem: function (component, event, helper) {
    var validCamping = component
      .find("CampingItem")
      .reduce(function (validsoFar, inputCmp) {
        inputCmp.showHelpMessageIfInvalid();
        return validsoFar && inputCmp.get("v.validity").valid;
      }, true);
    if (validCamping) {
      var newCamping = component.get("v.newItem");
      var theCamping = component.get("v.items");
      var addCamping = JSON.parse(JSON.stringify(newCamping));

      theCamping.push(addCamping);
      component.set("v.items", theCamping);
      component.set("v.newItem", {
        sobjectType: "Camping_Item__c",
        Name: "",
        Quantity__c: 0,
        Price__c: 0,
        Packed__c: false
      });
    }
  }
});
