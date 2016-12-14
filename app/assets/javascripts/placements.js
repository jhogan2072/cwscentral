angular.module('app').controller("PlacementController", function($http, $timeout, $location, ModalFormService,
                                                                 PlacementService, ContactAssignmentService, PlusMinus,
                                                                 $anchorScroll, $q){
    var vm = this;
    vm.addNotesRow = addNotesRow;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "";
    vm.attendanceDate = null;
    vm.contactId = -1;
    vm.contactName = "";
    vm.contactAssignments = [];
    vm.contacts = [];
    vm.CONTACT_TYPE = 2;
    vm.currentOrgId = "";
    vm.deletePlacement = deletePlacement;
    vm.displayAlert = displayAlert;
    vm.getStudentPlacements = getStudentPlacements;
    vm.getContactAssignments = getContactAssignments;
    vm.getContacts = getContacts;
    vm.getEditOrgList = getEditOrgList;
    vm.getGradeData = getGradeData;
    vm.getOrganizations = getOrganizations;
    vm.getStudents = getStudents;
    vm.goToStudent = goToStudent;
    vm.isStudentListing = true;
    vm.isSuccess = true;
    vm.isStudentsPage = false;
    vm.notes_showing = [];
    vm.orgDetails = [];
    vm.orgId = -1;
    vm.orgName = "";
    vm.orgList = [];
    vm.orgs = [];
    vm.placementStartDate = "";
    vm.selectedOrg = -1;
    vm.selectedOrgEdit = -1;
    vm.ORG_TYPE = 1;
    vm.page = 'placements';
    vm.placementcontactAssignmentId = -1;
    vm.placementStartDate = '';
    vm.plusminus = PlusMinus.get_url(true);
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedAssignment = -1;
    vm.selectedClasses = {};
    vm.selectedRow = null;
    vm.selectedContact = -1;
    vm.selectedStudent = -1;
    vm.setClickedContact = setClickedContact;
    vm.setClickedOrg = setClickedOrg;
    vm.setClickedStudent = setClickedStudent;
    vm.showOrganizationDetails = showOrganizationDetails;
    vm.showResultAlert = false;
    vm.sortReverse = false;
    vm.sortType = 'start_date';
    vm.studentPlacements = [];
    vm.studentCount = 0;
    vm.studentId = -1;
    vm.students = [];
    vm.STUDENT_TYPE = 0;
    vm.truncateStyle = {};
    vm.time_pattern = '^([0]?[1-9]|1[0-2]):([0-5]\\d)\\s?(AM|PM|am|pm)?$';

    function matchRuleShort(str, rule) {
        return new RegExp("^" + rule.split("*").join(".*") + "$").test(str);
    }

    var absUrl = $location.absUrl();
    if (absUrl.indexOf('/placements/students') > -1) {
        vm.isStudentsPage = true;
        if (window.location.search.substring(1)) {
            getStudents(window.location.search.substring(1).split('=')[1]);
        } else {
            getStudents();
        }
    } else if (absUrl.indexOf('/placements/organizations') > -1) {
        vm.isStudentsPage = false;
        getOrganizations();
    } else if (matchRuleShort(absUrl, '*/placements/*/edit')
    || matchRuleShort(absUrl, '*/placements/add*')) {
        vm.isStudentsPage = false;
        getEditOrgList();
    } else if (absUrl.indexOf('/placements/contacts') > -1) {
        vm.isStudentsPage = false;
        if (window.location.search.substring(1)) {
            getContacts(window.location.search.substring(1).split('=')[1]);
        } else {
            getContacts();
        }
    }
    ////////////

    function addNotesRow(arrayIndex) {
        var arrayLength = vm.notes_showing.length;
        var numOpen = 0;
        for (var i = 0; i < arrayIndex; i++) {
            if (vm.notes_showing[i])
                numOpen++;
        }
        var table = document.getElementById("plcmtTable");
        if (vm.notes_showing[arrayIndex])
        {
            vm.studentPlacements[arrayIndex].plusminus = PlusMinus.get_url(true);
            var row = table.deleteRow(arrayIndex + 2 + numOpen);
            vm.notes_showing[arrayIndex] = false;
        }
        else
        {
            vm.notes_showing[arrayIndex] = true;
            vm.studentPlacements[arrayIndex].plusminus = PlusMinus.get_url(false);
            var row = table.insertRow(arrayIndex + 2 + numOpen);
            var cell1 = row.insertCell(0);
            cell1.colSpan = 11;
            cell1.innerHTML = "<span style='font-weight: bold; margin-right: 25px;margin-left: 10px;'>Notes:</span>" +
                (vm.studentPlacements[arrayIndex].notes == null ? 'No notes' : vm.studentPlacements[arrayIndex].notes);
        }
    }

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
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

    function getContactAssignments(contactAssignmentId) {
        vm.contactAssignments = [];
        ContactAssignmentService.query({organization_id: vm.selectedOrgEdit, start_date: vm.placementStartDate}
        ,function(data) {
            // success handler
            angular.forEach(data, function(ca) {
                vm.contactAssignments.push(ca);
            });
            if (contactAssignmentId)
                vm.selectedAssignment = parseInt(contactAssignmentId);
            else
                vm.selectedAssignment = vm.contactAssignments[0].id;
        }, function(response) {
            vm.displayAlert(false, "There was an error retrieving contact assignments.  The HTTP return code was " + response.status);
        });
    }

    function getContacts (contactId) {
        vm.contacts = PlacementService.contacts();
        if (contactId) {
            $q.all([
                vm.contacts.$promise
            ]).then(function() {
                //CODE AFTER RESOURCES ARE LOADED
                var i = 0;
                angular.forEach(vm.contacts, function(contact) {
                    if (window.location.search.substring(1).split('=')[1] == contact.id) {
                        setClickedContact(i, contact.name, contact.id);
                    }
                    i++;
                });
            });
        }
    }

    function getEditOrgList() {
        $http.get('/placements/organizations.json').
        success(function(data, status, headers, config) {
            // this callback will be called asynchronously
            // when the response is available
            angular.forEach(data, function(organization) {
                vm.orgList.push(organization);
            });
            if (vm.currentOrgId != "")
                vm.selectedOrgEdit = parseInt(vm.currentOrgId);
            else
                vm.selectedOrgEdit = vm.orgList[0].id;
            vm.getContactAssignments(vm.placementcontactAssignmentId);
        }).
        error(function(data, status, headers, config) {
            vm.displayAlert(false,"There was an unexpected error.  Could not retrieve organizations.");
        });
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
            vm.displayAlert(false,"There was an unexpected error.  Could not retrieve organizations.");
        });
    }

    function getStudentPlacements(listingId, listingType){
        // Retrieve the work history for this student.
        var detailsURL = '';
        if (listingType == vm.STUDENT_TYPE) {
            detailsURL = '/students/' + listingId + '/placements';
        } else if (listingType == vm.ORG_TYPE) {
            detailsURL = '/organizations/' + listingId + '/placements';
        } else if (listingType == vm.CONTACT_TYPE) {
            detailsURL = '/contacts/' + listingId + '/placements';
        }
        $http.get(detailsURL).
        success(function(data){
            vm.studentPlacements = [];
            angular.forEach(data, function(stud_detail) {
                stud_detail.plusminus = PlusMinus.get_url(true);
                vm.studentPlacements.push(stud_detail);
            });
        }).
        error( function(data, status) {
            if (status == 404) {
                if (listingType == vm.STUDENT_TYPE) {
                    vm.displayAlert(false, "This student has no work placements.");
                } else if (listingType == vm.ORG_TYPE) {
                    vm.displayAlert(false, "This organization has no student work placements.");
                } else {
                    vm.displayAlert(false, "This contact has no student work placements.");
                }
                vm.studentPlacements = [];
            } else {
                //put up a failure message
                vm.displayAlert(false,"There was an retrieving student details. The HTTP return code was "+status);
            }
        });
    }

    function getStudents(studentId) {
        vm.students = PlacementService.students(function(data) {
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
        vm.getStudentPlacements(contact_id, vm.CONTACT_TYPE);
    }

    function setClickedOrg(indexSelectedOrg, org_name, org_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedOrg = indexSelectedOrg;
        vm.orgName = org_name;
        vm.orgId = org_id
        vm.getStudentPlacements(org_id, vm.ORG_TYPE);
    }

    function setClickedStudent(indexSelectedStudent, student_id) {
        vm.selectedRow = null;
        vm.truncateStyle = {};
        vm.selectedStudent = indexSelectedStudent;
        vm.studentId = student_id;
        vm.getStudentPlacements(student_id, vm.STUDENT_TYPE);
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

});