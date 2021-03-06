angular.module('app').controller("AdminController", function($http, $timeout){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.page = 'admin';
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

})
.directive('validCsv', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, ctrl) {
            function myValidation(value) {
                var ext = value.substring(value.lastIndexOf('.') + 1).toLowerCase();
                if (ext.indexOf("csv") > -1) {
                    ctrl.$setValidity('charCSV', true);
                } else {
                    ctrl.$setValidity('charCSV', false);
                }
                return value;
            }
            ctrl.$parsers.push(myValidation);
        }
    };
});
