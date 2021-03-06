/** Routing Configuration --- */

angular.module('open').config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    $routeProvider

        /** --- Bills --- */

        .when(ctxPath + '/bills', { templateUrl: ctxPath + '/partial/content/bill/bill-search', reloadOnSearch: false })
        .when(ctxPath + '/bills/:session/:printNo', { templateUrl: ctxPath + '/partial/content/bill/bill-view', reloadOnSearch: false })

        /** --- Agendas --- */

        .when(ctxPath + '/agendas', { templateUrl: ctxPath + '/partial/content/agenda/agenda-search', reloadOnSearch: false})
        .when(ctxPath + '/agendas/:year/:agendaNo', { templateUrl: ctxPath + '/partial/content/agenda/agenda-view', reloadOnSearch: false })
        .when(ctxPath + '/agendas/:year/:agendaNo/:comm', { templateUrl: ctxPath + '/partial/content/agenda/agenda-view', reloadOnSearch: false })

        /** --- Calendars --- */

        .when(ctxPath + '/calendars', { templateUrl: ctxPath + '/partial/content/calendar/calendar-search', reloadOnSearch: false })
        .when(ctxPath + '/calendars/:year/:calNo', { templateUrl: ctxPath + '/partial/content/calendar/calendar-view', reloadOnSearch: false })

        /** --- Laws --- */

        .when(ctxPath + '/laws', { templateUrl: ctxPath + '/partial/content/law/law-search' })
        .when(ctxPath + '/laws/:lawId', { templateUrl: ctxPath + '/partial/content/law/law-view', reloadOnSearch: false })

        /** --- Members --- */
        .when(ctxPath + '/members', { templateUrl: ctxPath + '/partial/content/member/member-search', reloadOnSearch: false})
        .when(ctxPath + '/members/:sessionYear/:memberId', { templateUrl: ctxPath + '/partial/content/member/member-view', reloadOnSearch: false})

    /** --- Transcripts --- */

        .when(ctxPath + '/transcripts', { templateUrl: ctxPath + '/partial/content/transcript/transcript-list', reloadOnSearch: false})
        .when(ctxPath + '/transcripts/session/:filename', { templateUrl: ctxPath + '/partial/content/transcript/session-transcript-view', reloadOnSearch: false})
        .when(ctxPath + '/transcripts/hearing/:filename', { templateUrl: ctxPath + '/partial/content/transcript/hearing-transcript-view'})

        /** --- Reports --- */

        .when(ctxPath + '/admin/report/daybreak', { templateUrl: ctxPath + '/partial/report/daybreak', reloadOnSearch: false })

        /** --- Admin --- */

        .when(ctxPath + '/admin', { template: 'Manage Page' })
        .when(ctxPath + '/admin/account', { templateUrl: ctxPath + '/partial/admin/account', reloadOnSearch: false })

        /** --- Docs --- */

        .when(ctxPath + '/docs', { redirectTo: ctxPath + '/docs'})

        /** --- Home Page --- */

        .otherwise({
            templateUrl: ctxPath + '/partial/home/landing'
        });

    $locationProvider.html5Mode(true);
    $locationProvider.hashPrefix('!');
}]);
