angular.module('app').controller("OrgController", function($http, $timeout, $location, $window, $cookies, ModalFormService, ModalDetailsService){
        var vm = this;
        vm.alertShowHide = alertShowHide;
        vm.alertText = "Hello, World";
        vm.assignment_student_class = "";
        vm.createOrganization = createOrganization;
        vm.displayAlert = displayAlert;
        vm.getStudentAssignments = getStudentAssignments;
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
        vm.studentAssignments = [];
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

        function displayAlert (isSuccess, message) {
            vm.isSuccess = isSuccess;
            vm.alertText = message;
            vm.showResultAlert = true;
            $timeout(function(){vm.showResultAlert = false}, 5000);
        }

        function getGradeData(){
            var gradesURL = '/students'
        }

        function getStudentAssignments(organizationId){
            // Retrieve the work history for this student.
            var detailsURL = '/organizations/' + organizationId + '/work/';
            $http.get(detailsURL).
            success(function(data){
                vm.studentAssignments = [];
                angular.forEach(data, function(stud_detail) {
                    vm.studentAssignments.push(stud_detail);
                });
            }).
            error( function(data, status) {
                if (status == 404) {
                    vm.displayAlert(false,"This organization has no student work assignments.");
                    vm.studentAssignments = [];
                } else {
                    //put up a failure message
                    vm.displayAlert(false,"There was an retrieving student details. The HTTP return code was "+status);
                }
            });
        }

        function getOrganizations() {
            $http.get('/organizations.json').
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
            vm.getStudentAssignments(org_id);
            vm.orgSearchInput = '';
        }

        function showOrganizationDetails(indexSelectedObject, assignment_id) {
            vm.truncateStyle = {height: '300px', 'overflow-y': 'scroll'};
            vm.selectedRow = indexSelectedObject;
            var orgDetailsURL = '/work_assignments/' + assignment_id + '/org';
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

        function showGradesModal(organization_name, assignment_id) {
            var grade_data = getGradeData(vm.studentId, assignment_id);
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

    })
    .directive('ngReallyClick', [function() {
        return {
            restrict: 'A',
            link: function(scope, element, attrs) {
                element.bind('click', function() {
                    var message = attrs.ngReallyMessage;
                    if (message && confirm(message)) {
                        scope.$apply(attrs.ngReallyClick);
                    }
                });
            }
        }
    }]);