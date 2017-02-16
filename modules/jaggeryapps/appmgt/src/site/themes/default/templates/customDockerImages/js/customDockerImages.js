/*
 *
 *   Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *   WSO2 Inc. licenses this file to you under the Apache License,
 *   Version 2.0 (the "License"); you may not use this file except
 *   in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 * /
 */


$(document).ready(function () {
    $('#imageUrl').on('focusout keyup blur click', function () { // fires on every keyup & blur
        if ($('#imageUrl').val()) {
            $("#addImage").prop("disabled", false);
        } else {
            $("#addImage").prop("disabled", true);
        }
    });

    fillImagesListTable();

    $(document).on('click', '.deleteImage', function (e) {
        e.preventDefault();
        var imageId = $(this).closest('tr').data('uid');
        jagg.popMessage({
                            type: 'confirm',
                            modalStatus: true,
                            title: 'Delete Image',
                            content: 'Are you sure you want to delete this image ?',
                            yesCallback: function () {
                                deleteImage(imageId);
                            },
                            noCallback: function () {
                            }
                        });

    });

    $(document).on('click','.updateImage',function(e){
        e.preventDefault();
        var imageId = $(this).closest('tr').data('uid');
        jagg.popMessage({
                            type: 'confirm',
                            modalStatus: true,
                            title: 'Delete Image',
                            content: 'Are you sure you want to update this image ?',
                            yesCallback: function () {
                                updateImage(imageId);
                            },
                            noCallback: function () {
                            }
                        });
    });

    function toggleIcon(e) {
        $(e.target)
                .prev('.panel-heading')
                .find(".more-less")
                .toggleClass('glyphicon-plus glyphicon-minus');
    }

    $(document).on('hidden.bs.collapse', function (e) {
        toggleIcon(e);
    });

    $(document).on('shown.bs.collapse', function (e) {
        toggleIcon(e);
    });
    $(document).on('click', '.viewResult', function (e) {
        e.preventDefault();
        var resultJson = $(this).data('uid');
        resultJson = decodeURI(resultJson);
        resultJson = JSON.parse(resultJson);
        console.log(testsJson);
        console.log(resultJson);

        var modalBody = '<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">';
        for (i = 0; i < testsJson.length; i++) {
            var testId = testsJson[i].testId;
            var panelColorClass;
            if(resultJson[testId] == "pass") {
                panelColorClass = "panel-success";
            } else if (resultJson[testId] == "fail") {
                panelColorClass = "panel-danger";

            }
            modalBody += '<div class="panel ' + panelColorClass + '">' +
                         '<div class="panel-heading" role="tab" id="heading' + i + '">' + '<h4 class="panel-title">' +
                         '<a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse' + i + '" aria-expanded="true" aria-controls="collapse' + i + '">' +
                         '<i class="more-less glyphicon glyphicon-plus"></i>' +
                         testsJson[i].title + ' : ' + resultJson[testId]  + '</a></h4></div>' +
                         '<div id="collapse' + i + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading' + i + '">' +
                         '<div class="panel-body result-panel">' +
                         '<p>Test :</p>' +
                         '<p class="result-description">' + testsJson[i].description + '</p>' +
                         '<p>Docker Benchmark Reference : </p>' +
                         '<p class="result-description">' + testsJson[i].dockerBenchReference + '</p>' +
                         '<p>Remedy : </p>' +
                         '<p class="result-description">' + testsJson[i].remedy + '</p>' +

                         '</div></div></div></div>';
        }
        $('#viewResultModal .modal-body').html(modalBody);
    });

});


    /**
     *  Adding new image
     */
    function addNewImage() {

        $('#imageUrl').prop("disabled", true);
        $("#addImage").loadingButton({action: 'show'});
        jagg.post("../blocks/customDockerImages//ajax/customDockerImages.jag", {
            action: "isImageAvailable",
            imageUrl: $("#imageUrl").val().trim()
        }, function (result) {
            result = $.trim(result);
            if (result == "false") { // isImageAvailable=false means image is not added currently.
                jagg.post("../blocks/customDockerImages/ajax/customDockerImages.jag", {
                    action: "addImageAndCheckSecurity",
                    imageUrl: $("#imageUrl").val().trim()
                }, function (result) {
                    fillImagesListTable();
                    jagg.message({
                                     content: 'New Image added and queued for security check. It will take some time!',
                                     type: 'info',
                                     id: 'addnewcustomdockerimage'
                                 });
                    $("#addImage").loadingButton({action: 'hide'}).prop("disabled", true);
                    $('#imageUrl').prop("disabled", false).val("");

                }, function (jqXHR, textStatus, errorThrown) {
                    jagg.message({
                                     content: jqXHR.responseText,
                                     type: 'error',
                                     id: 'addnewcustomdockerimage',
                                     timeout: 8000
                                 });
                });
            } else {
                jagg.message({
                                 content: "Cant add image. Image has been already added.",
                                 type: 'error',
                                 id: 'addnewcustomdockerimage',
                                 timeout: 8000
                             });
            }
        }, function (jqXHR, textStatus, errorThrown) {
            jagg.message({
                             content: jqXHR.responseText,
                             type: 'error',
                             id: 'isImageAlreadyAdded',
                             timeout: 8000
                         });
        });
    }

    function fillImagesListTable() {
        var pendingImagesAvailable = false;
        jagg.post("../blocks/customDockerImages/ajax/customDockerImages.jag", {
            action: "getAllImages",
            imageUrl: $("#imageUrl").val().trim()
        }, function (result) {
            var tableHtml = '<tr><th>Image URL</th><th class="col-centered">Last Updated</th><th class="col-centered">Status</th><th class="col-centered">Test Report</th><th class="col-centered">Options</th><th class="col-centered">Create Application</th></tr>';
            var resObj = JSON.parse(result);
            if (resObj.length > 0) { // panel will only be shown if there are 1 or more images
                $('#dockerImagesPanelDiv').show();
            } else {
                $('#dockerImagesPanelDiv').hide();

            }
            for (i = 0; i < resObj.length; i++) {
                var statusIcon, notActiveCreateApplication = "", notActiveModifyImage = "";
                if (resObj[i].status == "passed") {
                    statusIcon = '<i class="fw fw-success text-success"></i>';
                } else if (resObj[i].status == "failed") {
                    statusIcon = '<i class="fw fw-error text-danger"></i>';
                    notActiveCreateApplication = "not-active";
                } else {
                    statusIcon = '<i class="fw fw-loader5 fw-spin text-warning"></i>';
                    notActiveCreateApplication = "not-active";
                    notActiveModifyImage = "not-active";
                    pendingImagesAvailable = true;

                }
                tableHtml += '<tr data-uid="'+ resObj[i].imageId +'"><td>' + resObj[i].remoteUrl + '</td>' +
                             '<td class="col-centered">' + resObj[i].lastUpdated.split(".")[0] + '</td>' +
                             '<td class="col-centered">' + statusIcon + '</td>' +
                             '<td class="col-centered">' + '<a href="#viewResultModal" data-uid="' + encodeURI(resObj[i].results) + '" data-toggle="modal" class="' + notActiveModifyImage + ' viewResult" title="View test report"><i class="fw fw-checklist "></i></a>' + '</td>' +
                             '<td class="col-centered">' +
                             '<a href="" class="imagePanelOptionIcon ' + notActiveModifyImage + ' updateImage" title="Update image"><i class="fw fw-refresh  "></i></a>' +
                             '<a href="" class="imagePanelOptionIcon ' + notActiveModifyImage + ' deleteImage" title="Delete image"><i class="fw fw-delete  "></i></a>' +
                             '<td class="col-centered"> ' +
                             '<a href="application.jag?appTypeName=custom&selectedImageId=bla" class=" ' + notActiveCreateApplication + '" title="Create application using this image" ><i class="fw fw-application"></i></a>' +
                             '</td>' +

                             '</td></tr>';
            }
            $('#customImagesTable').html(tableHtml);
            if(pendingImagesAvailable) {
                setTimeout(fillImagesListTable,5000); // this will poll while pendig images are available
            }

        }, function (jqXHR, textStatus, errorThrown) {

        });


    }

    function deleteImage(imageId) {
        jagg.post("../blocks/customDockerImages/ajax/customDockerImages.jag", {
            action: "deleteImage",
            imageId: imageId
        }, function (result) {
                if(result == "true") {
                    jagg.message({
                                     content: imageId + ' deleted successfully',
                                     type: 'success',
                                     id: 'deleteimage'
                                 });
                }
            fillImagesListTable();
        }, function (jqXHR, textStatus, errorThrown) {

        });

    }

    function updateImage(imageId) {
        jagg.post("../blocks/customDockerImages/ajax/customDockerImages.jag", {
            action: "updateImage",
            imageId: imageId
        }, function (result) {
            if(result == "true") {
                jagg.message({
                                 content: imageId + ' updated successfully',
                                 type: 'success',
                                 id: 'deleteimage'
                             });
            }
            fillImagesListTable();
        }, function (jqXHR, textStatus, errorThrown) {

        });
    }


