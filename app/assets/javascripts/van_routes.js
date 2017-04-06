angular.module('app').controller("VanRouteController", function($http, $timeout, $location, $window, ModalFormService, VanRouteService){
    var vm = this;
    vm.alertShowHide = alertShowHide;
    vm.alertText = "";
    vm.copyFromDate = "";
    vm.copyRoutes = copyRoutes;
    vm.dailyRoutes = {};
    vm.datesWithRoutes = [];
    vm.deleteRoute = deleteRoute;
    vm.deletesChecked = 0;
    vm.displayAlert = displayAlert;
    vm.exportAll = exportAll;
    vm.getRoutes = getRoutes;
    vm.getUrlParameter = getUrlParameter;
    vm.isSuccess = true;
    vm.page = 'routes';
    vm.prev_school_day = '';
    vm.removeElement = removeElement;
    vm.routeDate = '';
    vm.searchInput = '';
    vm.showResultAlert = false;
    vm.saveDelete = 'Save';
    vm.selectedDate = '';
    vm.showRouteModal = showRouteModal;
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
    var dtCopyFrom = new Date();
    var dtToday = new Date();
    var defaultDateParam = getUrlParameter('route_date');

    if (typeof(defaultDateParam) != 'undefined' && defaultDateParam != '') {
        dtCopyFrom = new Date(defaultDateParam);
        dtCopyFrom.setTime( dtCopyFrom.getTime() + dtCopyFrom.getTimezoneOffset()*60*1000 );
        dtToday = new Date(defaultDateParam);
        dtToday.setTime( dtToday.getTime() + dtToday.getTimezoneOffset()*60*1000 );
    }
    else {
        dtCopyFrom.setHours(0,0,0,0);
        dtToday.setHours(0,0,0,0);
    }
    vm.options = {
        inline: true,
        format: 'DD-MMM-YYYY',
        defaultDate: moment(dtToday)
    };
    dtCopyFrom.addBusDays(-1);
    vm.copy_options = {
        allowInputToggle: true,
        defaultDate: moment(dtCopyFrom),
        inline: false,
        format: 'DD-MMM-YYYY'
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
        vm.dailyRoutes = VanRouteService.query({route_date: vm.routeDate.toString()});
        if (vm.dailyRoutes.length == 0)
        {
            var prev_date = new Date(vm.routeDate);
            prev_date.addBusDays(-1);
            var a = moment(prev_date);
            var date_string = a.format("DD-MMM-YYYY");
            vm.copyFromDate = date_string;
            vm.copy_options.defaultDate = a;
            $('#dt1').val(date_string).change();
        }
    }

    function getUrlParameter(param, dummyPath) {
        var sPageURL = dummyPath || window.location.search.substring(1),
            sURLVariables = sPageURL.split(/[&||?]/),
            res;

        for (var i = 0; i < sURLVariables.length; i += 1) {
            var paramName = sURLVariables[i],
                sParameterName = (paramName || '').split('=');

            if (sParameterName[0] === param) {
                res = sParameterName[1];
            }
        }

        return res;
    }

    function removeElement(array, index){
        array.splice(index, 1);
    }

    function showRouteModal() {
        vm.datesWithRoutes.push('04/05/2017');
        vm.datesWithRoutes.push('04/06/2017');
        vm.datesWithRoutes.push('04/08/2017');

        var my_string = "";
        for (var i=0; i < vm.datesWithRoutes.length; i++) {
            my_string = my_string + 'SelectedDates[new Date(\'' + vm.datesWithRoutes[i] + '\')] = new Date(\'' + vm.datesWithRoutes[i] + '\').toString();\n';
        }
        var modalOptions = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Save',
            headerText: 'Select a prior route date',
            bodyText: 'Choose from the blue numbered days with prior routes.',
            formLabel: 'Route Date:',
            dateArray: my_string,
            modalType: 'routes_dates'
        };

        ModalFormService.showModal({}, modalOptions).then(function (result) {
            vm.copyFromDate = vm.selectedDate;
        });
    }


});