angular.module('app').controller("StudentController", function($http, $timeout){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.page = 'students';
    vm.showResultAlert = false;

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

});
