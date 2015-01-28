<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="open-component" tagdir="/WEB-INF/tags/component" %>

<section ng-controller="BillCtrl">
  <section ng-controller="BillViewCtrl">
    <md-toolbar class="md-toolbar-tools auto-height">
      <h6 class="margin-top-10 margin-bottom-10">{{bill.title}}</h6>
    </md-toolbar>
    <md-toolbar class="md-hue-2 md-toolbar-tools auto-height">
      <section layout="row" layout-sm="column"
               layout-align="start center" layout-align-sm="start start">
        <div class="margin-bottom-10 margin-top-20" layout="row" layout-align="start center" style="margin-right:60px;">
          <img class="margin-right-10" src="http://lorempixel.com/50/50/food/5"
               style="height: 60px;min-width:60px;"/>
          <div layout="column">
            <div class="text-medium">Sponsored By</div>
            <div class="bold">{{bill.sponsor.member.fullName}}</div>
            <%--<div class="text-small">District {{bill.sponsor.member.districtCode}}</div>--%>
          </div>
        </div>
        <div class="margin-bottom-10 margin-top-20" layout="column" style="margin-right:60px;">
          <div class="text-medium">Status as of {{bill.status.actionDate | moment:'MMMM D, YYYY'}}</div>
          <div class="bold"><span>{{getStatusDesc(bill.status)}}</span></div>
        </div>
        <div class="margin-bottom-10 margin-top-20" layout="column" ng-if="bill.programInfo">
          <div class="text-medium">Bill #{{bill.programInfo.sequenceNo + 1}} on the program for </div>
          <div class="bold">{{bill.programInfo.name}}</div>
        </div>
      </section>
    </md-toolbar>
    <md-toolbar ng-if="bill.amendments.size > 1" class="md-toolbar-tools auto-height">
      <label style="margin-right:40px;">Viewing </label>
      <md-radio-group layout="row" layout-sm="column" ng-model="curr.amdVersion">
        <md-radio-button ng-repeat="(version, amd) in bill.amendments.items" class="md-accent md-hue-1"
                         value="{{version}}">
          <span ng-if="$first">Initial</span>
          <span ng-if="!$first">Revision {{version}}</span>
          <span ng-if="$last"> (Latest)</span>
        </md-radio-button>
      </md-radio-group>
    </md-toolbar>
    <md-tabs md-selected="selectedView" class="md-hue-2">
      <md-tab md-on-select="backToSearch()">
        <md-tab-label><span><i class="icon-search prefix-icon2"></i>Back to Search</span></md-tab-label>
      </md-tab>
      <md-tab label="Details">
        <%-- Status --%>
        <md-card class="content-card" hide>
          <md-subheader>Status - {{bill.milestones.size}} of 8 milestones met</md-subheader>
          <md-content style="margin-left:16px;">
            <p class="text-medium capitalize">
              {{bill.status.actionDate | moment:'MMMM D, YYYY'}} - {{getStatusDesc(bill.status) | lowercase}}
            </p>
            <section layout="row">
              <md-button ng-if="bill.committeeAgendas.size > 0" class="text-medium md-primary md-hue-2 margin-right-20"
                         ng-init="lastAgenda = bill.committeeAgendas.items[bill.committeeAgendas.size - 1]"
                         ng-href="${ctxPath}/agendas/{{lastAgenda.agendaId.year}}/{{lastAgenda.agendaId.number}}/{{lastAgenda.committeeId.name}}">
                {{lastAgenda.committeeId.name}} Committee Agenda #{{lastAgenda.agendaId.number}} ({{lastAgenda.agendaId.year}})
              </md-button>
              <md-button ng-if="bill.calendars.size > 0" class="text-medium md-primary md-hue-2 "
                         ng-href="${ctxPath}/calendars/{{lastCalendar.year}}/{{lastCalendar.calendarNumber}}"
                         ng-init="lastCalendar = bill.calendars.items[bill.calendars.size -1]">
                Senate Floor Calendar {{lastCalendar.calendarNumber}} ({{lastCalendar.year}})
              </md-button>
            </section>
          </md-content>
        </md-card>
        <%-- Enacting Clause --%>
        <md-card class="content-card">
          <md-subheader>Enacting Clause</md-subheader>
          <md-content style="margin-left:16px;">
            <p class="text-medium">{{bill.amendments.items[curr.amdVersion].actClause}}</p>
          </md-content>
        </md-card>
        <%-- Bill Summary --%>
        <md-card class="md-whiteframe-z0 white-bg padding-10">
          <md-subheader>Summary of Bill</md-subheader>
          <md-content style="margin-left:16px;">
            <p class="text-medium">{{bill.summary}}</p>
          </md-content>
        </md-card>
        <%-- Co/Multi --%>
        <md-card layout="row" layout-sm="column" layout-align="start start" class="content-card"
                 ng-if="bill.amendments.items[curr.amdVersion].coSponsors.size > 0 ||
                        bill.amendments.items[curr.amdVersion].multiSponsors.size > 0">
          <%-- Co Sponsor --%>
          <section flex style="width:100%" ng-if="bill.amendments.items[curr.amdVersion].coSponsors.size > 0">
            <md-subheader>{{bill.amendments.items[curr.amdVersion].coSponsors.size}} Co Sponsor(s)</md-subheader>
            <md-divider/>
            <md-content style="margin-left:16px;max-height: 200px;" class="padding-10">
              <md-list>
                <md-item ng-repeat="coSponsor in bill.amendments.items[curr.amdVersion].coSponsors.items">
                  <md-item-content>
                    <div class="md-tile-left">
                      <img class="margin-right-10" ng-src="http://lorempixel.com/50/50/food/{{$index}}"
                           style="height: 50px;width:50px;"/>
                    </div>
                    <div class="md-tile-content">
                      <span class="text-medium">{{coSponsor.fullName}} (D)</span>
                    </div>
                  </md-item-content>
                </md-item>
              </md-list>
            </md-content>
          </section>
          <%-- Multi Sponsor --%>
          <section flex style="width:100%" ng-if="bill.amendments.items[curr.amdVersion].multiSponsors.size > 0">
            <md-subheader>{{bill.amendments.items[curr.amdVersion].multiSponsors.size}} Multi Sponsor(s)</md-subheader>
            <md-divider/>
            <md-content style="margin-left:16px;max-height: 200px;" class="padding-10">
              <md-list>
                <md-item ng-repeat="multiSponsor in bill.amendments.items[curr.amdVersion].multiSponsors.items">
                  <md-item-content>
                    <div class="md-tile-left">
                      <img class="margin-right-10" ng-src="http://lorempixel.com/50/50/food/{{$index}}"
                           style="height: 50px;width:50px;"/>
                    </div>
                    <div class="md-tile-content">
                      <span class="text-medium">{{multiSponsor.fullName}} (D)</span>
                    </div>
                  </md-item-content>
                </md-item>
              </md-list>
            </md-content>
          </section>
        </md-card>
        <%-- Law Section --%>
        <md-card class="content-card">
          <md-subheader>Affected Law</md-subheader>
          <md-content style="margin-left:16px;">
            <span class="text-medium">Primary Law Section - {{bill.amendments.items[curr.amdVersion].lawSection}}</span>
            <p class="text-medium">Law Code - {{bill.amendments.items[curr.amdVersion].lawCode}}</p>
          </md-content>
        </md-card>
      </md-tab>
      <%-- Sponsor Memo --%>
      <md-tab label="Sponsor Memo">
        <md-card class="content-card">
          <md-content ng-if="bill.amendments.items[curr.amdVersion].memo">
            <pre class="bill-full-text margin-20" style=""
               ng-bind-html="bill.amendments.items[curr.amdVersion].memo | prettySponsorMemo"></pre>
          </md-content>
          <md-content ng-if="bill.billType.chamber == 'ASSEMBLY'">
            <div class="text-medium padding-20">Sponsor memos are not available for Assembly bills.</div>
          </md-content>
          <md-content ng-if="!bill.amendments.items[curr.amdVersion].memo && bill.billType.chamber == 'SENATE'">
            <div class="text-medium padding-20">Sponsor memo is not available yet for this version of the bill.</div>
          </md-content>
        </md-card>
      </md-tab>
      <%-- Bill Actions --%>
      <md-tab label="Actions">
        <md-card class="content-card">
          <md-content>
            <md-list>
              <md-item hide-sm>
                <md-item-content>
                  <div style="width:140px" class="md-tile-left margin-10"><span class="text-medium">Date</span></div>
                  <div style="width:100px" class="md-tile-left margin-10"><span class="text-medium">Chamber</span></div>
                  <div style="width:60px" class="md-tile-left margin-10"><span class="text-medium">Bill</span></div>
                  <div class="md-tile-content"><span class="text-medium">Action Text</span></div>
                </md-item-content>
                <md-divider/>
              </md-item>
              <md-item ng-repeat="action in bill.actions.items">
                <md-item-content>
                  <div style="width:140px" hide-sm class="margin-10">
                    <span class="text-medium">{{action.date | moment:'MMMM D, YYYY'}}</span>
                  </div>
                  <div style="width:100px" hide-sm class="margin-10">
                    <span class="text-medium capitalize">{{action.chamber | lowercase}}</span>
                  </div>
                  <div style="width:60px" hide-sm class="margin-10">
                    <span class="text-medium">{{action.billId.printNo}}</span>
                  </div>
                  <div class="md-tile-content">
                    <h4 ng-class="{'bold': action.chamber == 'SENATE'}"
                        class="text-medium margin-10 capitalize">{{action.text | lowercase}}</h4>
                    <h4 hide-gt-sm>{{action.date | moment:'MMMM D, YYYY'}}</h4>
                    <p hide-gt-sm>{{action.billId.printNo}} - {{action.chamber}}</p>
                  </div>
                </md-item-content>
                <md-divider ng-if="!$last"/>
              </md-item>
            </md-list>
          </md-content>
        </md-card>
      </md-tab>
      <%-- Bill Text --%>
      <md-tab label="Bill Text">
        <md-content class="margin-10 padding-20">
          <span ng-if="!bill.amendments.items[curr.amdVersion].fullText">Bill Text is not available yet. New bills or revisions
          may not have full text available right away.</span>
          <pre  ng-if="bill.amendments.items[curr.amdVersion].fullText" class="bill-full-text">
             {{bill.amendments.items[curr.amdVersion].fullText}}
          </pre>
        </md-content>
      </md-tab>
      <%-- Updates --%>
      <md-tab label="Update History">
        <md-button>What</md-button>

      </md-tab>
  </section>
</section>