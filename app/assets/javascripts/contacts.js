angular.module('app').controller("ContactController", function($http, $timeout, $window, ModalFormService,
                                                               ContactService, ContactAssignmentService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.closeAssignment = closeAssignment;
    vm.contacts = [];
    vm.displayAlert = displayAlert;
    vm.getContacts = getContacts;
    vm.isSuccess = true;
    vm.page = 'organizations';
    vm.reopenContact = reopenContact;
    vm.selectedDate = "";
    vm.showCloseoutModal = showCloseoutModal;
    vm.showResultAlert = false;
    vm.sortReverse = false;
    vm.sortType = 'organization_name';

    if (window.location.pathname == '/contacts') {
        getContacts();
    }
    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
    }

    function closeAssignment(contactAssignmentId, closeDate) {
        var ca = ContactAssignmentService.get({id:contactAssignmentId});
        ca.effective_end_date = closeDate;
        ContactAssignmentService.update({ id:contactAssignmentId }, ca, function(data) {
            //success
            vm.displayAlert(true,"The contact assignment was successfully closed.", true);
            $window.location.href = '/contacts';
        }, function(response) {
            var errorString = '';
            for (var key in response.data){
                errorString += key + ' ' + response.data[key] + ', ';
            }
            errorString = errorString.slice(0, -2);
            vm.displayAlert(false, "The contact could not be closed because of the following problems: " + errorString, false);
        });
    }

    function deletePlacement(indexObjToDelete, placementId) {
        PlacementService.delete({id: placementId},function(data) {
            // success handler
            //Alert that the object was successfully deleted and delete the row
            vm.removeElement(vm.studentPlacements, indexObjToDelete);
            vm.displayAlert(true,"The placement was successfully deleted.", true);
        }, function(response) {
            vm.displayAlert(false, "There was an error deleting the placement.  The HTTP return code was " + response.status, false);
        });
    }

    function displayAlert (isSuccess, message, hide) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        if (hide == true)
            $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getContacts () {
        if (window.location.search == '')
            vm.contacts = ContactService.query();
        else
            vm.contacts = ContactService.query({all: true})
    }

    function reopenContact(contactId) {
        var ca = ContactAssignmentService.reopen({contact_id:contactId});
        vm.displayAlert(true,"The contact assignment was successfully updated.", true);
        $window.location.href = '/contacts';
    }

    function showCloseoutModal(contactAssignmentId) {
        var modalOptions = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Save',
            headerText: 'Close out contact',
            bodyText: 'Choose a last day for the contact.',
            formLabel: 'End Date:'
        };

        ModalFormService.showModal({}, modalOptions).then(function (result) {
            vm.closeAssignment(contactAssignmentId, vm.selectedDate);
        });
    }

});


