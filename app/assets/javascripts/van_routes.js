angular.module('app').controller("VanRouteController", function($http, $timeout, $location, $window, VanRouteService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "";
    vm.copyFromDate = "";
    vm.copyRoutes = copyRoutes;
    vm.dailyRoutes = {};
    vm.deleteRoute = deleteRoute;
    vm.deletesChecked = 0;
    vm.displayAlert = displayAlert;
    vm.exportAll = exportAll;
    vm.getRoutes = getRoutes;
    vm.incrementDeletes = incrementDeletes;
    vm.isSuccess = true;
    vm.page = 'routes';
    vm.removeElement = removeElement;
    vm.routeDate = "";
    vm.searchInput = '';
    vm.showResultAlert = false;
    vm.saveDelete = 'Save';
    vm.time_pattern = '^([0]?[1-9]|1[0-2]):([0-5]\\d)\\s?(AM|PM|am|pm)?$';

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

    function copyRoutes() {
        VanRouteService.copy({
            copy_from: vm.copyFromDate, copy_to: vm.routeDate
        },function(data) {
            // success handler
            angular.forEach(data, function(route) {
                vm.dailyRoutes.push(route);
            });
            vm.displayAlert(true, "Routes copied.")
        }, function(response) {
            vm.displayAlert(false, "There was an error copying routes.  The HTTP return code was " + response.status);
        });
    }

    function deleteRoute(indexObjToDelete, routeId) {
        //var deleteAction = $resource("/van_routes/:id.json", {id: routeId});
        VanRouteService.delete({id: routeId});
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

    function exportAll() {
        $window.location.href = '/van_routes/export_all?route_date=' + vm.routeDate;
    }

    function getRoutes () {
        vm.dailyRoutes = VanRouteService.query({route_date: vm.routeDate});
        if (vm.dailyRoutes.length == 0)
        {
            var prev_date = new Date(vm.routeDate);
            prev_date.addBusDays(-1);
            var a = moment(prev_date);
            var date_string = a.format("DD-MMM-YYYY");
            vm.copyFromDate = date_string;
            $('#dt1').val(date_string).change();
        }
    }

    function incrementDeletes(object_id) {
        if (vm.chk[object_id])
            vm.deletesChecked += 1;
        else
            vm.deletesChecked -= 1;
    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

});