({
    doFieldSetInit: function(cmp, event, helper) {
        helper.createForm(cmp);
    },

    handleValueChange: function(cmp, event, helper) {
        var inputToField = cmp.get('v.inputToField');
        var field = inputToField[event.getSource().getGlobalId()];
        var obj = cmp.get('v.record');
        if (!obj[field]) {
            // Have to make a copy of the object to set a new property - thanks LockerService!
            obj = JSON.parse(JSON.stringify(obj));
        }
        //alert('====' + event.getSource().get('v.value'));
        var getFieldVal = event.getSource().get('v.value');
        if(getFieldVal == '--Select--'){
            getFieldVal = null;
        }
        obj[field] = getFieldVal;
        cmp.set('v.record', obj);
    }
})