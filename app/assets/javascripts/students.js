angular.module('app').controller("StudentController", function($http, $timeout, $location, $window, $cookies, ModalFormService, ModalDetailsService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.assignment_student_class = "";
    vm.createStudent = createStudent;
    vm.displayAlert = displayAlert;
    vm.getStudentAssignments = getStudentAssignments;
    vm.getGradeData = getGradeData;
    vm.getStudents = getStudents;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.orgDetails = [];
    vm.page = 'students';
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.selectedStudent = -1;
    vm.setClickedStudent = setClickedStudent;
    vm.showOrganizationDetails = showOrganizationDetails;
    vm.showGradesModal = showGradesModal;
    vm.showStudentModal = showStudentModal;
    vm.showResultAlert = false;
    vm.studentAssignments = [];
    vm.studentCount = 0;
    vm.studentFullName = "";
    vm.studentId = -1;
    vm.students = [];
    vm.studentSearchInput = '';
    vm.truncateStyle = {};

    getStudents();

    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
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

    function displayAlert (isSuccess, message) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getGradeData(){
        var gradesURL = '/students'
    }

    function getStudentAssignments(studentId){
	// Retrieve the work history for this student.
		var detailsURL = '/students/' + studentId + '/work/';
		$http.get(detailsURL).
            success(function(data){
                vm.studentAssignments = [];
                angular.forEach(data, function(stud_detail) {
                    vm.studentAssignments.push(stud_detail);
                });
		    }).
            error( function(data, status) {
                if (status == 404) {
                    vm.displayAlert(false,"This student has no work assignments.");
                    vm.studentAssignments = [];
                } else {
                    //put up a failure message
                    vm.displayAlert(false,"There was an retrieving student details. The HTTP return code was "+status);
                }
        });
	}

    function getStudents() {
        $http.get('/students.json').
        success(function(data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            angular.forEach(data, function(student) {
                vm.students.push(student);
            });
            vm.student = vm.students[0];
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

    function setClickedStudent(indexSelectedStudent, student_name, student_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedStudent = indexSelectedStudent;
        vm.studentFullName = student_name;
        vm.studentId = student_id
        vm.searchInput = '';
        vm.isStudentSearch = false;
        vm.getStudentAssignments(student_id);
        vm.studentSearchInput = '';
    }

    function showOrganizationDetails(indexSelectedObject, assignment_id) {
        vm.truncateStyle = {height: '400px', 'overflow-y': 'scroll'};
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