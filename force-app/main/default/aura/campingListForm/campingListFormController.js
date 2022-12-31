({
  clickCreateItem: function (component, event, helper) {
    var validCamping = component
      .find("campingform")
      .reduce(function (validSoFar, inputCmp) {
        // Displays error messages for invalid fields
        inputCmp.showHelpMessageIfInvalid();
        return validSoFar && inputCmp.get("v.validity").valid;
      }, true);
    if (validCamping) {
      var addItm = event.getParam("v.newItem");
      helper.createItem(component, addItm);
    }
  },
  submitForm: function (component, helper) {
    if (helper.validateItemForm(component)) {
      // Create the new item
      var newItem = component.get("v.newItem");
      helper.createItem(component, newItem);
    }
  }
});
