angular.module('app').controller("IncidentController", function($http, $timeout, $location,
                                                                IncidentService, $anchorScroll, $q){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.contacts = [];
    vm.contactId = -1;
    vm.CONTACT_TYPE = 2;
    vm.deleteIncident = deleteIncident;
    vm.displayAlert = displayAlert;
    vm.getContacts = getContacts;
    vm.getIncidents = getIncidents;
    vm.getOrganizations = getOrganizations;
    vm.getStudents = getStudents;
    vm.goToStudent = goToStudent;
    vm.isSuccess = true;
    vm.organizations = [];
    vm.orgId = -1;
    vm.ORG_TYPE = 1;
    vm.page = 'students';
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.selectedContact = -1;
    vm.selectedOrg = -1;
    vm.selectedStudent = -1;
    vm.setClickedContact = setClickedContact;
    vm.setClickedOrg = setClickedOrg;
    vm.setClickedStudent = setClickedStudent;
    vm.showResultAlert = false;
    vm.studentId = -1;
    vm.students = [];
    vm.STUDENT_TYPE = 0;


    var absUrl = $location.absUrl();
    if (absUrl.indexOf('/incidents/students') > -1) {
        if (window.location.search.substring(1)) {
            getStudents(window.location.search.substring(1).split('=')[1]);
        } else {
            getStudents();
        }
    } else if (absUrl.indexOf('/incidents/organizations') > -1) {
        getOrganizations();
    } else if (absUrl.indexOf('/incidents/contacts') > -1) {
        getContacts();
    }
    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
    }

    function deleteIncident(indexObjToDelete, incidentId) {
        IncidentService.delete({id: incidentId},function(data) {
            // success handler
            //Alert that the object was successfully deleted and delete the row
            vm.removeElement(vm.incidents, indexObjToDelete);
            vm.displayAlert(true,"The feedback was successfully deleted.");
        }, function(response) {
            vm.displayAlert(false, "There was an error deleting the feedback.  The HTTP return code was " + response.status);
        });
    }

    function displayAlert (isSuccess, message) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getContacts () {
        vm.contacts = IncidentService.contacts();
    }
    function getIncidents(listingId, listingType){
        // Retrieve the work history for this student.
        var detailsURL = '';
        if (listingType == vm.STUDENT_TYPE) {
            detailsURL = '/students/' + listingId + '/incidents';
        } else if (listingType == vm.ORG_TYPE) {
            detailsURL = '/organizations/' + listingId + '/incidents';
        } else if (listingType == vm.CONTACT_TYPE) {
            detailsURL = '/contacts/' + listingId + '/incidents';
        }
        $http.get(detailsURL).
        success(function(data){
            vm.incidents = [];
            angular.forEach(data, function(inc_detail) {
                vm.incidents.push(inc_detail);
            });
        }).
        error( function(data, status) {
            if (status == 404) {
                if (listingType == vm.STUDENT_TYPE) {
                    vm.displayAlert(false, "This student has no feedback.");
                } else if (listingType == vm.ORG_TYPE) {
                    vm.displayAlert(false, "This organization has no student feedback.");
                } else {
                    vm.displayAlert(false, "This contact has no student feedback.");
                }
                vm.incidents = [];
            } else {
                //put up a failure message
                vm.displayAlert(false,"There was an retrieving student feedback. The HTTP return code was "+status);
            }
        });
    }

    function getOrganizations () {
        vm.organizations = IncidentService.organizations();
    }

    function getStudents(studentId) {
        vm.students = IncidentService.students(function(data) {
            // success handler
            if (studentId) {
                $q.all([
                    vm.students.$promise
                ]).then(function() {
                    //CODE AFTER RESOURCES ARE LOADED
                    var i = 0;
                    angular.forEach(vm.students, function(student) {
                        if (window.location.search.substring(1).split('=')[1] == student.id) {
                            setClickedStudent(i, student.id);
                        }
                        i++;
                    });
                    goToStudent();
                });
            }
        }, function(response) {
            vm.displayAlert(false, "There was an unexpected error.  Could not retrieve students.  The HTTP return code was " + response.status);
        });

    }

    function goToStudent() {
        // set the location.hash to the id of
        // the element you wish to scroll to.
        $location.hash('activeStudent');

        // call $anchorScroll()
        $anchorScroll();
    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

    function setClickedContact(indexSelectedContact, contact_name, contact_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedContact = indexSelectedContact;
        vm.contactName = contact_name;
        vm.contactId = contact_id
        vm.getIncidents(contact_id, vm.CONTACT_TYPE);
    }

    function setClickedOrg(indexSelectedOrg, org_name, org_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedOrg = indexSelectedOrg;
        vm.orgName = org_name;
        vm.orgId = org_id;
        vm.getIncidents(org_id, vm.ORG_TYPE);
    }

    function setClickedStudent(indexSelectedStudent, student_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedStudent = indexSelectedStudent;
        vm.studentId = student_id;
        vm.getIncidents(student_id, vm.STUDENT_TYPE);
    }

});

