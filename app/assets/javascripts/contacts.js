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
        ContactAssignmentService.update({ id:contactAssignmentId }, ca);
        vm.displayAlert(true,"The contact assignment was successfully closed.");
        $window.location.href = '/contacts';
    }

    function displayAlert (isSuccess, message) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getContacts () {
        vm.contacts = ContactService.query();
    }

    function reopenContact(contactId) {
        var ca = ContactAssignmentService.reopen({contact_id:contactId});
        vm.displayAlert(true,"The contact assignment was successfully updated.");
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


