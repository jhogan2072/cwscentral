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
    vm.sortReverse = false;
    vm.sortType = 'last_name';

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

});
