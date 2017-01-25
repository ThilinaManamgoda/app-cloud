/*
 * Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *   WSO2 Inc. licenses this file to you under the Apache License,
 *   Version 2.0 (the "License"); you may not use this file except
 *   in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing,
 *   software distributed under the License is distributed on an
 *   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *   KIND, either express or implied.  See the License for the
 *   specific language governing permissions and limitations
 *   under the License.
 */
// Beginning of functions functions for add, edit, cancel save save actions for Evn variables and Labels
$(document).on('click', '.panel-heading a', function(e){
    var $this = $(this);
    if($this.hasClass('collapsed')) {
        $this.find('i').removeClass('glyphicon-chevron-up').addClass('glyphicon-chevron-down');
    } else  {
        $this.find('i').removeClass('glyphicon-chevron-down').addClass('glyphicon-chevron-up');
    }
});

$(document).on("click",".fw-cancel", function(e){ //user click on remove text
    var propBlock = $(this).parent('span').parent('div').parent('div');
    jagg.popMessage({type:'confirm', modalStatus: true, title:'Delete Tag',content:'Are you sure you want to delete this?',
        yesCallback:function(){
            propBlock.remove();
        }, noCallback:function(){}
    });

});

$(document).on('click', '.fw-edit', function () {
    var propBlock = $(this).parent('span').parent('div').parent('div');
    propBlock.find('.element-key-holder')[0].readOnly = false;
    propBlock.find('.element-value-holder')[0].readOnly = false;
    $(this).hide();
    $(this).parent().find('.fw-save').show();
});


$(document).on('click', '.fw-save', function () {
    var propBlock = $(this).parent('span').parent('div').parent('div');
    propBlock.find('.element-key-holder')[0].readOnly = true;
    propBlock.find('.element-value-holder')[0].readOnly = true;
    $(this).hide();
    $(this).parent().find('.fw-edit').show();
});

$(document).on('change focusout keyup', '.element-add-value', function () {
    var value = $(this).val();
    var propHolder = $(this).parent('div').parent('div');
    var key = propHolder.find('.element-add-key').val();
    var addBtn = propHolder.find('.btn-primary-add-val');
    if(propHolder.parent('div').attr("id") == "env-pane") {
        var addBtn = propHolder.find('.btn-primary-add-val-env');
    }
    if(!value || !key){
        addBtn.prop("disabled" , true);
    } else {
        addBtn.prop("disabled" , false);
    }
});

$(document).on('change focusout keyup', '.element-add-key', function () {
    var key = $(this).val();
    var propHolder = $(this).parent('div').parent('div');
    var value = propHolder.find('.element-add-value').val();
    var addBtn = propHolder.find('.btn-primary-add-val');

    if(propHolder.parent('div').attr("id") == "env-pane"){
        var addBtn = propHolder.find('.btn-primary-add-val-env');
        if(validateEnvironmentVariable(key)){
            addBtn.prop("disabled" , false);
            propHolder.find('.element-add-value').prop("disabled" , false);
        } else {
            addBtn.prop("disabled" , true);
            propHolder.find('.element-add-value').prop("disabled" , true);
        }
    }

    if(!value || !key){
        addBtn.prop("disabled" , true);
    } else {
        addBtn.prop("disabled" , false);
    }
});

$(document).on('click', '.btn-primary-add-val, .btn-primary-add-val-env', function() {
    activateCreateApplication();
    var addBlock = $(this).parent().parent();
    var key = addBlock.find('.element-add-key')[0].value;
    var value = addBlock.find('.element-add-value')[0].value;
    var paneId = addBlock.parent().attr('id');
    var initialValueElement = '<input type="text" class="form-control element-add-value" placeholder="Value">\n';
    var initialAddElement = '<button class="btn btn-primary btn-primary-add btn-primary-add-val" disabled>Add</button>\n';
    if (paneId === "env-pane") {
        if(noOfDbs == 0){
            initialValueElement = '<input type="text" class="form-control element-add-value" id="value">\n';
        } else {
            initialValueElement = '<select id="value" name="value" class="form-control select2 element-add-value"></select>\n';
        }
        initialAddElement = '<button class="btn btn-primary btn-primary-add btn-primary-add-val-env" disabled>Add</button>\n';
        addBlock.attr('name');
    }
    drawInitialEnvTagPane(addBlock, key, value, initialValueElement, initialAddElement);
});

function addEnvFromFile(key, val) {
    activateCreateApplication();
    var addBlock = $('.btn-primary-add-val-env').parent().parent();
    var key = key;
    var value = val;
    var initialValueElement;
    if(noOfDbs == 0){
        initialValueElement = '<input type="text" class="form-control element-add-value" id="value">\n';
    } else {
        initialValueElement = '<select id="value" name="value" class="form-control select2 element-add-value"></select>\n';
    }
    var initialAddElement = '<button class="btn btn-primary btn-primary-add btn-primary-add-val-env" disabled>Add</button>\n';
    drawInitialEnvTagPane(addBlock, key, value, initialValueElement, initialAddElement);
}

function drawInitialEnvTagPane(addBlock, key, value, initialValueElement, initialAddElement){
    var panelBody = addBlock.parent();
    panelBody.append(
        '<div class="form-inline  property-seperator prop-key-vals-holder">\n'+
        '<div class="form-group">\n'+
        '<label class="sr-only" for="key">Key</label>\n'+
        '<input type="text" class="form-control element-key-holder" id="key" placeholder="Key" value="' + key + '" disabled>\n'+
        '</div>\n'+
        '<div class="form-group">\n'+
        '<label class="sr-only" for="value">Value</label>\n'+
        '<input type="text" class="form-control element-value-holder" id="value" placeholder="Value" value="' + value + '" disabled>\n'+
        '</div>\n'+
        '<div class="form-group edit-key-values">\n'+
        '<span class="fw-stack fw-lg">\n'+
        '<i class="fw fw-ring fw-stack-2x"></i>\n'+
        '<i class="fw fw-cancel fw-stack-1x"></i>\n'+
        '</span>\n'+
        '</div>\n'+
        '</div>\n'
    );
    addBlock.remove();
    panelBody.prepend(
        '<div class="form-inline property-seperator"  id="env-body">\n'+
        '<div class="form-group">\n'+
        '<label class="sr-only" for="key">Key</label>\n'+
        '<input type="text" class="form-control element-add-key" name="envKey" placeholder="Key">\n'+
        '</div>\n'+
        '<div class="form-group custom-env-class-for-demo">\n'+
        '<label class="sr-only" for="value">Value</label>\n'+
        initialValueElement +
        '</div>\n'+
        '<div class="form-group">\n'+
        initialAddElement +
        '</div>\n'+
        '</div>\n'
    );

    var valueElem = document.getElementById("value");
    if (noOfDbs != 0){
        initSelect2(null, valueElem, "", allDBInfo);
    }
}

function drawEnvTagPane(panelBody, key, value){
    panelBody.append(
        '<div class="form-inline  property-seperator prop-key-vals-holder">\n'+
        '<div class="form-group">\n'+
        '<label class="sr-only" for="key">Key</label>\n'+
        '<input type="text" class="form-control element-key-holder" id="key" placeholder="Key" value="' + key + '">\n'+
        '</div>\n'+
        '<div class="form-group">\n'+
        '<label class="sr-only" for="value">Value</label>\n'+
        '<input type="text" class="form-control element-value-holder" id="value" placeholder="Value" value="' + value + '">\n'+
        '</div>\n'+
        '<div class="form-group edit-key-values">\n'+
        '<span class="fw-stack fw-lg">\n'+
        '<i class="fw fw-ring fw-stack-2x"></i>\n'+
        '<i class="fw fw-cancel fw-stack-1x"></i>\n'+
        '</span>\n'+
        '</div>\n'+
        '</div>\n'
    );
}

/**
 * Get a json object array with key-val pair for given pane repsented by {@code elementId}
 * @param elementId
 * @returns {Array}
 */
function getProperties(elementId){
    var propArray =[];
    var panelBody = document.getElementById(elementId);
    $(panelBody).children('.prop-key-vals-holder').each(function(){
        var property = {};
        property["key"] = $(this).find('.element-key-holder')[0].value;
        property["value"] = $(this).find('.element-value-holder')[0].value;
        propArray.push(property);
    });
    return propArray;
}

function getLambdaProperties(){
    var propArray = [];
    var classProperty = {};
    classProperty["key"] = "LAMBDA_CLASS";
    classProperty["value"] = $('#lambdaClass').val();
    propArray.push(classProperty);
    if($('#functionName').val()){
        var functionProperty = {};
        functionProperty["key"] = "LAMBDA_FUNCTION_NAME";
        functionProperty["value"] =  $('#functionName').val();
        propArray.push(functionProperty);
    }
    console.log(propArray);
    return propArray;
}
