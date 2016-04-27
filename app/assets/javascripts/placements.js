angular.module('app').controller("PlacementController", function($http, $timeout, $location, ModalFormService, ModalDetailsService, PlacementService){
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
    vm.isStudentListing = true;
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

    var absUrl = $location.absUrl();
    if (absUrl.indexOf('/placements/students') > -1) {
        getStudents();
    } else if (absUrl.indexOf('/placements/organizations') > -1) {
        getOrganizations();
    }
    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
    }

    function createOrganization(container_name) {
        safe_name = container_name.replace(/['. ]/g, "_");
        var containerURL = '/new_container?account='+vm.account.name+'&container='+safe_name;
        $http.get(containerURL).success(function(status){
            //Alert that the container was successfully created
            vm.displayAlert(true, "The student was successfully created.");
            vm.selectedRow = null;
            vm.truncateStyle = {};
            vm.getOrganizations();
        }).
        error(function(data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            if (status == 403) {
                vm.displayAlert(false,"The student cannot be created.  Does this user have the correct permissions?");
            } else {
                vm.displayAlert(false,"There was an unexpected error.  The student was not created.");
            }
        });
    }

    function createStudent(container_name) {
        safe_name = container_name.replace(/['. ]/g, "_");
        var containerURL = '/new_container?account='+vm.account.name+'&container='+safe_name;
        $http.get(containerURL).success(function(status){
            //Alert that the container was successfully created
            vm.displayAlert(true, "The student was successfully created.");
            vm.selectedRow = null;
            vm.truncateStyle = {};
            vm.getStudents();
        }).
        error(function(data, status, headers, config) {
            // called asynchronously if an error occurs
            // or server returns response with an error status.
            if (status == 403) {
                vm.displayAlert(false,"The student cannot be created.  Does this user have the correct permissions?");
            } else {
                vm.displayAlert(false,"There was an unexpected error.  The student was not created.");
            }
        });
    }

    function deletePlacement(indexObjToDelete, placementId) {
        PlacementService.delete({id: placementId},function(data) {
            // success handler
            //Alert that the object was successfully deleted and delete the row
            vm.removeElement(vm.studentPlacements, indexObjToDelete);
            vm.displayAlert(true,"The placement was successfully deleted.");
        }, function(response) {
            vm.displayAlert(false, "There was an error deleting the placement.  The HTTP return code was " + response.status);
        });
    }

    function displayAlert (isSuccess, message) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getGradeData(){
        var gradesURL = '/students'
    }

    function getOrganizations() {
        $http.get('/placements/organizations.json').
        success(function(data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            angular.forEach(data, function(organization) {
                vm.orgs.push(organization);
            });
        }).
        error(function(data, status, headers, config) {
            vm.displayAlert(false,"There was an unexpected error.  Could not retrieve students.");
        });
    }

    function getStudentPlacements(studentOrOrgId, isStudentListing){
        // Retrieve the work history for this student.
        var detailsURL = '';
        if (isStudentListing) {
            detailsURL = '/students/' + studentOrOrgId + '/placements';
        } else {
            detailsURL = '/organizations/' + studentOrOrgId + '/placements';
        }
        $http.get(detailsURL).
        success(function(data){
            vm.studentPlacements = [];
            angular.forEach(data, function(stud_detail) {
                vm.studentPlacements.push(stud_detail);
            });
        }).
        error( function(data, status) {
            if (status == 404) {
                vm.displayAlert(false,"This organization has no student work placements.");
                vm.studentPlacements = [];
            } else {
                //put up a failure message
                vm.displayAlert(false,"There was an retrieving student details. The HTTP return code was "+status);
            }
        });
    }

    function getStudents() {
        $http.get('/placements/students.json').
        success(function(data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            angular.forEach(data, function(student) {
                vm.students.push(student);
            });
        }).
        error(function(data, status, headers, config) {
            vm.displayAlert(false,"There was an unexpected error.  Could not retrieve students.");
        });
    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

    function setClickedOrg(indexSelectedOrg, org_name, org_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedOrg = indexSelectedOrg;
        vm.orgName = org_name;
        vm.orgId = org_id
        vm.searchInput = '';
        vm.isOrgSearch = false;
        vm.getStudentPlacements(org_id, false);
        vm.orgSearchInput = '';
    }

    function setClickedStudent(indexSelectedStudent, student_name, student_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedStudent = indexSelectedStudent;
        vm.studentFullName = student_name;
        vm.studentId = student_id
        vm.searchInput = '';
        vm.isStudentSearch = false;
        vm.getStudentPlacements(student_id, true);
        vm.studentSearchInput = '';
    }

    function showOrganizationDetails(indexSelectedObject, placement_id) {
        vm.truncateStyle = {height: '200px', 'overflow-y': 'scroll'};
        vm.selectedRow = indexSelectedObject;
        var orgDetailsURL = '/placements/' + placement_id + '/org';
        $http.get(orgDetailsURL).
        success(function(data){
            vm.orgDetails = [];
            angular.forEach(data, function(org_det) {
                vm.orgDetails.push(org_det);
            });
        }).
        error( function(data, status) {
            //put up a failure message
            vm.displayAlert(false,"There was an retrieving object details. The HTTP return code was "+status);
            vm.orgDetails = [];
        });
    }

    function showGradesModal(organization_name, placement_id) {
        var grade_data = getGradeData(vm.studentId, placement_id);
        var modalOptions    = {
            closeButtonText: 'Close',
            headerText: 'Student Grades',
            bodyText: 'Following are the PowerSchool grades for ' + organization_name,
            tableData: grade_data
        };
        ModalDetailsService.showModal({}, modalOptions).then(function () {
        });
    }

    function showOrgModal() {
        var modalOptions    = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Create',
            headerText: 'Create New Organization'
        };
        ModalFormService.showModal({}, modalOptions).then(function (result) {
            vm.createOrganization(result.name);
        });
    }

    function showStudentModal() {
        var modalOptions    = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Create',
            headerText: 'Create New Student'
        };
        ModalFormService.showModal({}, modalOptions).then(function (result) {
            vm.createStudent(result.name);
        });
    }


});