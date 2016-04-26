angular.module('app').controller("PlacementController", function($http, $timeout){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.createOrganization = createOrganization;
    vm.createStudent = createStudent;
    vm.deletePlacement = deletePlacement;
    vm.displayAlert = displayAlert;
    vm.getStudentPlacements = getStudentPlacements;
    vm.getGradeData = getGradeData;
    vm.getOrganizations = getOrganizations;
    vm.getStudents = getStudents;
    vm.isSuccess = true;
    vm.orgDetails = [];
    vm.orgId = -1;
    vm.orgName = "";
    vm.orgs = [];
    vm.page = 'placements';
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.selectedOrg = -1;
    vm.selectedStudent = -1;
    vm.setClickedOrg = setClickedOrg;
    vm.setClickedStudent = setClickedStudent;
    vm.showOrganizationDetails = showOrganizationDetails;
    vm.showGradesModal = showGradesModal;
    vm.showOrgModal = showOrgModal;
    vm.showStudentModal = showStudentModal;
    vm.showResultAlert = false;
    vm.studentPlacements = [];
    vm.studentCount = 0;
    vm.studentFullName = "";
    vm.studentId = -1;
    vm.students = [];
    vm.studentSearchInput = '';
    vm.truncateStyle = {};
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


});