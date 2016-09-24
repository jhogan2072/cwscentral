angular.module('app').controller("StudentController", function($http, $timeout, $location, ModalImportService, StudentService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.getStudents = getStudents;
    vm.isSuccess = true;
    vm.page = 'students';
    vm.showImportModal = showImportModal;
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

    function showImportModal() {
        var modalOptions = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Save',
            headerText: 'Import Students',
            bodyText: 'Select a file to import students from'
        };

        ModalImportService.showModal({}, modalOptions).then(function (result) {
            vm.importStudent(result.filename);
        });
    }
});
