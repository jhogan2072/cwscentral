angular.module('app').controller("OrgController", function($http, $timeout, OrganizationService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, World";
    vm.displayAlert = displayAlert;
    vm.getOrganizations = getOrganizations;
    vm.isSuccess = true;
    vm.organizations = [];
    vm.page = 'organizations';
    vm.showResultAlert = false;
    vm.sortReverse = false;
    vm.sortType = 'name';

    if (window.location.pathname == '/organizations') {
        getOrganizations();
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

    function getOrganizations() {
        vm.organizations = OrganizationService.query();
    }

});
