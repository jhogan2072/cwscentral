angular.module('app').controller("OrgController", function($http, $timeout, $location, $window, $cookies,
                                                           ModalFormService, ModalDetailsService, PlacementService)
{
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.createOrganization = createOrganization;
    vm.deletePlacement = deletePlacement;
    vm.displayAlert = displayAlert;
    vm.getStudentPlacements = getStudentPlacements;
    vm.getGradeData = getGradeData;
    vm.getOrganizations = getOrganizations;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.orgDetails = [];
    vm.page = 'organizations';
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.selectedOrg = -1;
    vm.setClickedOrg = setClickedOrg;
    vm.showOrganizationDetails = showOrganizationDetails;
    vm.showGradesModal = showGradesModal;
    vm.showOrgModal = showOrgModal;
    vm.showResultAlert = false;
    vm.studentPlacements = [];
    vm.studentCount = 0;
    vm.orgName = "";
    vm.orgId = -1;
    vm.orgs = [];
    vm.studentSearchInput = '';
    vm.truncateStyle = {};

    getOrganizations();

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

    function getStudentPlacements(organizationId){
        // Retrieve the work history for this student.
        var detailsURL = '/organizations/' + organizationId + '/placements/';
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

    function logoutUser() {
        document.cookie = 'x_auth_token=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        $window.location.href = '/logout';

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
        vm.getStudentPlacements(org_id);
        vm.orgSearchInput = '';
    }

    function showOrganizationDetails(indexSelectedObject, placement_id) {
        vm.truncateStyle = {height: '300px', 'overflow-y': 'scroll'};
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

});