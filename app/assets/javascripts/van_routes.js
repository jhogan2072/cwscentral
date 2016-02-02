angular.module('app').controller("VanRouteController", function($http, $timeout, $location, $window, $resource){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "Hello, Worlde";
    vm.dailyRoutes = {};
    vm.deleteRoute = deleteRoute;
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.showResultAlert = false;
    vm.truncateStyle = {};
    vm.routeDate = "";
    vm.VanRoute = $resource("/van_routes.json");
    vm.getRoutes = getRoutes;

    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
    }

    function deleteRoute(indexObjToDelete, routeId) {
        var deleteAction = $resource("/van_routes/:id.json", {id: routeId});
        deleteAction.delete();
        //Alert that the object was successfully deleted and delete the row
        vm.removeElement(vm.dailyRoutes, indexObjToDelete);
        vm.displayAlert(true,"The object was successfully deleted.");
    }


    function displayAlert (isSuccess, message) {
        vm.isSuccess = isSuccess;
        vm.alertText = message;
        vm.showResultAlert = true;
        $timeout(function(){vm.showResultAlert = false}, 5000);
    }

    function getRoutes () {
        vm.dailyRoutes = vm.VanRoute.query({route_date: vm.routeDate});
    }

    function logoutUser() {
        document.cookie = 'x_auth_token=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        $window.location.href = '/logout';

    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

});