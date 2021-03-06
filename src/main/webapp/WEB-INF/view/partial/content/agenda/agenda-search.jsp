<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<section ng-controller="AgendaCtrl">
  <section class="content-section">
    <md-tabs md-selected="selectedView" class="md-primary">
      <md-tab>
        <md-tab-label><i class="icon-calendar prefix-icon2"></i>Browse</md-tab-label>
        <section ng-if="selectedView === 0" ng-controller="AgendaBrowseCtrl">
          <p class="text-medium margin-left-10 gray10">
            <i class="prefix-icon2 icon-info"></i>Repeated meetings typically have notes associated with them to indicate changes to the time/location.
          </p>
          <md-card class="content-card">
            <md-content layout="row">
              <div flex>
                <label>Select month/year: </label>
                <select ng-model="curr.month" ng-change="updateSelectedDate()" class="margin-left-10">
                  <option value="0">January</option>
                  <option value="1">February</option>
                  <option value="2">March</option>
                  <option value="3">Apr</option>
                  <option value="4">May</option>
                  <option value="5">June</option>
                  <option value="6">July</option>
                  <option value="7">August</option>
                  <option value="8">September</option>
                  <option value="9">October</option>
                  <option value="10">November</option>
                  <option value="11">December</option>
                </select>
                <select ng-model="curr.year" ng-change="updateSelectedDate()" class="margin-left-10">
                  <option>2015</option>
                  <option>2014</option>
                  <option>2013</option>
                  <option>2012</option>
                  <option>2011</option>
                  <option>2010</option>
                  <option>2009</option>
                </select>
              </div>
            </md-content>
          </md-card>
          <span ng-show="loading"><i class="icon-hourglass prefix-icon2"></i>Loading Meetings...</span>
          <md-card class="content-card">
            <md-card-content id="agenda-date-picker" ui-calendar="calendarConfig" ng-model="meetingEventSources"></md-card-content>
          </md-card>
        </section>
      </md-tab>
      <md-tab>
        <md-tab-label>
          <md-tab-label><i class="icon-search prefix-icon2"></i>Search</md-tab-label>
        </md-tab-label>
        <section ng-if="selectedView === 1" ng-controller="AgendaSearchCtrl">
          <section class="margin-top-10">
            <md-card class="content-card text-medium">
              <form class="agenda-search">
                <div flex>
                  <label>Search for agendas by year</label>
                  <select ng-model="searchParams.year" ng-change="selectedYearChanged()">
                    <option ng-repeat="year in years">{{year}}</option>
                  </select>
                </div>
              </form>
            </md-card>
            <md-card ng-if="agendaSearch.error" class="content-card">
              <md-subheader class="md-warn">{{agendaSearch.error.message}}</md-subheader>
            </md-card>
            <md-card class="content-card">
              <div class="subheader" layout="row" layout-sm="column" layout-align="space-between center">
                <div flex> {{pagination.totalItems}} committee agendas were matched.
                  <span ng-if="pagination.totalItems > 0">
                    Viewing page {{pagination.currPage}} of {{pagination.lastPage}}.
                  </span>
                </div>
                <div flex class="text-align-right">
                  <dir-pagination-controls pagination-id="agenda-search" boundary-links="true"></dir-pagination-controls>
                </div>
              </div>
              <md-content layout="row" style="padding:0" class="no-top-margin">
                <div class="search-refine-panel" hide-sm>
                  <h3>Refine your search</h3>
                  <md-divider></md-divider>
                  <div class="refine-controls">
                    <label for="sort_by_param">Sort By</label>
                    <select id="sort_by_param" ng-model="searchSort" ng-change="simpleSearch(false)">
                      <option value="">Relevance</option>
                      <option value="agenda.id.number:desc">Newest First</option>
                      <option value="agenda.id.number:asc">Oldest First</option>
                    </select>
                    <hr/>
                    <label for="week_of_param">Week Of</label>
                    <select id="week_of_param" ng-model="searchParams.weekOf">
                      <option value="">Any</option>
                      <option ng-repeat="weekOf in weekOfListing">{{weekOf}}</option>
                    </select>
                    <label for="agenda_no_param">Agenda No</label>
                    <select id="agenda_no_param" ng-model="searchParams.agendaNo">
                      <option value="">Any</option>
                      <option ng-repeat="agendaNo in agendaNoList">{{agendaNo}}</option>
                    </select>
                    <label for="committee_param">Committee</label>
                    <select id="committee_param" ng-model="searchParams.commName">
                      <option value="">Any</option>
                      <option ng-repeat="comm in committeeListing">{{comm.name}}</option>
                    </select>
                    <label for="bill_print_no_param">Has Bill Print No</label>
                    <input id="bill_print_no_param" type="text" ng-model="searchParams.printNo" ng-model-options="{debounce: 300}"
                           placeholder="e.g. S1234"/>
                    <md-button ng-click="resetSearchParams() && simpleSearch(true)" class="md-primary margin-top-10">Reset Filters</md-button>
                  </div>
                </div>
                <div class="padding-20" ng-if="agendaSearch.response.total === 0">
                  <p class="red1 text-medium bold">No results were found after applying your filters.</p>
                </div>
                <div flex class="padding-20">
                  <a class="result-link"
                     dir-paginate="r in agendaSearch.results | itemsPerPage: 6"
                     total-items="agendaSearch.response.total" current-page="pagination.currPage"
                     ng-init="commAgenda = r.result;" 
                     pagination-id="agenda-search"
                     ng-href="${ctxPath}/agendas/{{commAgenda.agendaId.year}}/{{commAgenda.agendaId.number}}/{{commAgenda.committeeId.name}}?view=1">
                    <md-item>
                      <md-item-content layout-sm="column" layout-align-sm="center start" style="cursor: pointer;">
                        <div class="padding-16" style="width:300px">
                          <h4 class="no-margin">
                            Agenda {{commAgenda.agendaId.number}} ({{commAgenda.agendaId.year}})
                          </h4>
                          <h5 class="no-margin">{{commAgenda.committeeId.name}}</h5>
                        </div>
                        <div class="padding-16">
                          <h5 class="no-margin">Week Of: {{commAgenda.weekOf | moment:'ll'}}</h5>
                          <h5 class="no-margin">Bills Considered: {{commAgenda.totalBillsConsidered}}</h5>
                          <h5 class="no-margin">Bills Voted On: {{commAgenda.totalBillsVotedOn}}</h5>
                        </div>
                      </md-item-content>
                      <md-divider ng-if="!$last"/>
                    </md-item>
                  </a>
                </div>
              </md-content>
              <div class="subheader" layout="row" layout-align="end center">
                <div flex style="text-align: right;">
                  <dir-pagination-controls pagination-id="agenda-search" boundary-links="true"></dir-pagination-controls>
                </div>
              </div>
            </md-card>
          </section>
        </section>
      </md-tab>
      <md-tab>
        <md-tab-label>
          <md-tab-label><i class="icon-flag prefix-icon2"></i>Updates</md-tab-label>
        </md-tab-label>
        <section ng-if="selectedView === 2" ng-controller="AgendaUpdatesCtrl">
          <md-card class="content-card">
            <md-subheader>Show agenda updates during the following date range</md-subheader>
            <div layout="row" class="padding-20 text-medium">
              <div flex>
                <label>From</label>
                <input class="margin-left-10" ng-model="curr.fromDate" type="datetime-local">
              </div>
              <div flex>
                <label>To</label>
                <input class="margin-left-10" ng-model="curr.toDate" type="datetime-local">
              </div>
            </div>
            <md-divider></md-divider>
            <div layout="row" class="padding-20 text-medium">
              <div flex>
                <label>With </label>
                <select class="margin-left-10" ng-model="curr.type">
                  <option value="processed">Processed Date</option>
                  <option value="published">Published Date</option>
                </select>
              </div>
              <div flex>
                <label>Sort </label>
                <select class="margin-left-10" ng-model="curr.sortOrder">
                  <option value="desc" selected>Newest First</option>
                  <option value="asc">Oldest First</option>
                </select>
              </div>
              <div flex>
                <md-checkbox class="md-hue-3 no-margin" ng-model="curr.detail" aria-label="detail">Show Detail</md-checkbox>
              </div>
            </div>
          </md-card>
          <div ng-if="agendaUpdates.fetching" class="text-medium text-align-center">Fetching updates, please wait.</div>
          <update-list ng-show="!agendaUpdates.fetching && agendaUpdates.response.success === true"
                       update-response="agendaUpdates.response"
                       from-date="curr.fromDate" to-date="curr.toDate"
                       pagination="pagination" show-details="curr.detail">
          </update-list>
          <md-card class="content-card" ng-if="agendaUpdates.response.success === false">
            <md-subheader class="margin-10 md-warn">
              <h4>{{agendaUpdates.errMsg}}</h4>
            </md-subheader>
          </md-card>
        </section>
      </md-tab>
    </md-tabs>
  </section>
</section>