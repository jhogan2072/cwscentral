angular.module('app').controller("ContactController", function($http, $timeout, ContactService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.contacts = [];
    vm.displayAlert = displayAlert;
    vm.getContacts = getContacts;
    vm.isSuccess = true;
    vm.page = 'placements';
    vm.showResultAlert = false;

    getContacts();
    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
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

});

