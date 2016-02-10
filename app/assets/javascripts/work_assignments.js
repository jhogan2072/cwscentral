angular.module('app').controller("WAController", function($http, $timeout, $location, $window){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.page = 'students';
    vm.searchInput = '';
    vm.showResultAlert = false;
    vm.time_pattern = '^([0]?[1-9]|1[0-2]):([0-5]\\d)\\s?(AM|PM|am|pm)?$';

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

    function logoutUser() {
        document.cookie = 'x_auth_token=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        $window.location.href = '/logout';

    }

});