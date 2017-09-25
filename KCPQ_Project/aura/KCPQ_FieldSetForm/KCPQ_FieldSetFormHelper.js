({
    createForm: function(cmp) {
        var fields = cmp.get('v.fields');
        var obj = cmp.get('v.record');
        var inputDesc = [];
        var fieldPaths = [];
        for (var i = 0; i < fields.length; i++) {
            var field = fields[i];
            var fldType = field.type.toLowerCase();
            var config;
            if(fldType == 'anytype' || fldType == 'base64' || fldType == 'combobox' 
               || fldType == 'currency' || fldType == 'datacategorygroupreference' 
               || fldType == 'encryptedstring' || fldType == 'id'
               || fldType == 'reference' || fldType == 'string'
               || fldType == 'textarea' || fldType == 'url'){
            	config = { componentDef: 'ui:inputText', attributes: {} };
            }else if(fldType == 'multipicklist' || fldType == 'picklist'){
                config = { componentDef: 'ui:inputSelect', attributes: {} };
                var opts = [];
                opts.push({ class: "optionClass", label: "", value: "--Select--"});
                for (var j = 0; j < field.picklistValues.length; j++) {
                    opts.push({ class: "optionClass", label: field.picklistValues[j], value: field.picklistValues[j]});
                }
                config.attributes.options = opts;
                if(fldType == 'multipicklist'){
                    config.attributes.multiple = true;
                }
            }else if(fldType == 'boolean'){
                config = { componentDef: 'ui:inputCheckbox', attributes: {} };
            }else if(fldType == 'date'){
                config = { componentDef: 'ui:inputDate',
                    attributes: {
                        displayDatePicker: true
                    } };
            }else if(fldType == 'datetime' || fldType == 'time'){
                config = { componentDef: 'ui:inputDateTime', attributes: {} };
            }else if(fldType == 'double' || fldType == 'integer' || fldType == 'percent'){
                config = { componentDef: 'ui:inputNumber', attributes: {} };
            }else if(fldType == 'email'){
                config = { componentDef: 'ui:inputEmail', attributes: {} };
            }else if(fldType == 'phone'){
                config = { componentDef: 'ui:inputPhone', attributes: {} };
            }
            if (config) {
                if(field.required == true || field.dbrequired == true){
                    config.attributes.required = true;
                }
                config.attributes.value = obj[field.fieldPath];
                config.attributes.label = field.label;
                config.attributes.fieldPath = field.fieldPath;
                config.attributes.disabled = cmp.get("v.isReadOnlyFields");
                inputDesc.push([
                    config.componentDef,
                    config.attributes
                ]);
                fieldPaths.push(field.fieldPath);
            } else {
                console.log('type ' + field.type.toLowerCase() + ' not supported');
            }
        }

        $A.createComponents(inputDesc, function(cmps) {
            var inputToField = {};
            for (var i = 0; i < fieldPaths.length; i++) {
                cmps[i].addHandler('change', cmp, 'c.handleValueChange');
                inputToField[cmps[i].getGlobalId()] = fieldPaths[i];
            }
            cmp.set('v.form', cmps);
            cmp.set('v.inputToField', inputToField);
        });
    }
})