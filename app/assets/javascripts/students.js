angular.module('app').controller("StudentController", function($http, $timeout, $location, StudentService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.getStudents = getStudents;
    vm.isSuccess = true;
    vm.page = 'students';
    vm.showResultAlert = false;
    vm.students = [];

    var absUrl = $location.absUrl();
    if (absUrl.indexOf('/students/active') > -1) {
        getActiveStudents();
    } else if (window.location.pathname == '/students') {
        getStudents();
    }
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

    function getStudents() {
        vm.students = StudentService.query();
    }

    function getActiveStudents() {
        vm.students = StudentService.active();
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
