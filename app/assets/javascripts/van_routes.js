angular.module('app').controller("VanRouteController", function($http, $timeout, $location, $window, $resource){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "";
    vm.copyFromDate = "";
    vm.dailyRoutes = {};
    vm.deleteRoute = deleteRoute;
    vm.displayAlert = displayAlert;
    vm.isSuccess = true;
    vm.logoutUser = logoutUser;
    vm.page = 'routes';
    vm.removeElement = removeElement;
    vm.searchInput = '';
    vm.selectedRow = null;
    vm.showResultAlert = false;
    vm.truncateStyle = {};
    vm.routeDate = "";
    vm.VanRoute = $resource("/van_routes/:id.json");
    vm.getRoutes = getRoutes;

    Number.prototype.mod = function(n) {
        return ((this%n)+n)%n;
    };
    Date.prototype.addBusDays = function(dd) {
        var wks = Math.floor(dd/5);
        var dys = dd.mod(5);
        var dy = this.getDay();
        if (dy === 6 && dys > -1) {
            if (dys === 0) {dys-=2; dy+=2;}
            dys++; dy -= 6;}
        if (dy === 0 && dys < 1) {
            if (dys === 0) {dys+=2; dy-=2;}
            dys--; dy += 6;}
        if (dy + dys > 5) dys += 2;
        if (dy + dys < 1) dys -= 2;
        this.setDate(this.getDate()+wks*7+dys);
    };
    ////////////

    function alertShowHide(isShown) {
        vm[isShown] = !vm[isShown];
    }

    function deleteRoute(indexObjToDelete, routeId) {
        //var deleteAction = $resource("/van_routes/:id.json", {id: routeId});
        vm.VanRoute.delete({id: routeId});
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
        var prev_date = new Date(vm.routeDate);
        prev_date.addBusDays(-1);
        var a = moment(prev_date);
        var date_string = a.format("DD-MMM-YYYY");
        vm.copyFromDate = date_string;
        $('#dt1').val(date_string).change();
    }

    function logoutUser() {
        document.cookie = 'x_auth_token=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
        $window.location.href = '/logout';

    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

});