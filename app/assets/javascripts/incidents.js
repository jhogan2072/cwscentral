angular.module('app').controller("IncidentController", function($http, $timeout, $location, IncidentService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.contacts = [];
    vm.CONTACT_TYPE = 2;
    vm.deleteIncident = deleteIncident;
    vm.displayAlert = displayAlert;
    vm.getContacts = getContacts;
    vm.getIncidents = getIncidents;
    vm.getOrganizations = getOrganizations;
    vm.getStudents = getStudents;
    vm.isSuccess = true;
    vm.organizations = [];
    vm.ORG_TYPE = 1;
    vm.page = 'students';
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.selectedContact = -1;
    vm.selectedOrg = -1;
    vm.selectedStudent = -1;
    vm.setClickedContact = setClickedContact;
    vm.setClickedOrg = setClickedOrg;
    vm.setClickedStudent = setClickedStudent;
    vm.showResultAlert = false;
    vm.students = [];
    vm.STUDENT_TYPE = 0;


    var absUrl = $location.absUrl();
    if (absUrl.indexOf('/incidents/students') > -1) {
        getStudents();
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
            vm.displayAlert(true,"The incident was successfully deleted.");
        }, function(response) {
            vm.displayAlert(false, "There was an error deleting the incident.  The HTTP return code was " + response.status);
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
                    vm.displayAlert(false, "This student has no incidents.");
                } else if (listingType == vm.ORG_TYPE) {
                    vm.displayAlert(false, "This organization has no student incidents.");
                } else {
                    vm.displayAlert(false, "This contact has no student incidents.");
                }
                vm.incidents = [];
            } else {
                //put up a failure message
                vm.displayAlert(false,"There was an retrieving student incidents. The HTTP return code was "+status);
            }
        });
    }

    function getOrganizations () {
        vm.organizations = IncidentService.organizations();
    }
    function getStudents() {
        vm.students = IncidentService.students();
    }

    function setClickedContact(indexSelectedContact, contact_name, contact_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedContact = indexSelectedContact;
        vm.contactName = contact_name;
        vm.contactId = contact_id
        vm.searchInput = '';
        vm.getIncidents(contact_id, vm.CONTACT_TYPE);
    }

    function setClickedOrg(indexSelectedOrg, org_name, org_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedOrg = indexSelectedOrg;
        vm.orgName = org_name;
        vm.orgId = org_id;
        vm.searchInput = '';
        vm.getIncidents(org_id, vm.ORG_TYPE);
    }

    function setClickedStudent(indexSelectedStudent, student_name, student_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedStudent = indexSelectedStudent;
        vm.studentFullName = student_name;
        vm.studentId = student_id;
        vm.searchInput = '';
        vm.getIncidents(student_id, vm.STUDENT_TYPE);
    }

});

