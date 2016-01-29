angular.module('app').controller("VanRouteController", function($http, $timeout, $location, $window){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, Worlde";
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.showResultAlert = false;
    vm.truncateStyle = {};
    vm.list = ["one", "two", "three", "four", "five", "six"];
    vm.routeDate = "blah";

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

    function removeElement(array, index){
        array.splice(index, 1);
    }

});