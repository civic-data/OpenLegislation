<%@ page language="java" import="gov.nysenate.openleg.util.JSPHelper, org.apache.commons.lang3.StringUtils, java.util.Iterator,java.util.ArrayList, java.util.Collection,java.util.List,java.text.DateFormat,java.text.SimpleDateFormat,gov.nysenate.openleg.*,gov.nysenate.openleg.model.*" contentType="text/html" pageEncoding="utf-8"%>
<%
String appPath = request.getContextPath();
SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, MMM d, yyyy");
SimpleDateFormat datetimeFormat = new SimpleDateFormat("MM/d/yyyy hh:mm:ss aa");

Calendar activeList = (Calendar) request.getAttribute("calendar");
List<Supplemental> supplementals = activeList.getSupplementals();
if (supplementals == null) {
    supplementals = new ArrayList<Supplemental>();
}

String activeListTitle = "Active List #"+activeList.getNo();
if (activeList.getDate() != null) {
    activeListTitle += " - "+dateFormat.format(activeList.getDate());
}
%>
<div id="content">
    <h2 class="page-title"><%=activeListTitle%></h2>
    <div class="content-bg">
        <div class='item-actions' style="float:right">
            <ul>
                <li><a href="#" onclick="window.print(); return false;">Print Page</a></li>
                <li><script type="text/javascript" src="http://w.sharethis.com/button/sharethis.js#publisher=51a57fb0-3a12-4a9e-8dd0-2caebc74d677&amp;type=website"></script></li>
            </ul>
        </div>
        <%
        for (Supplemental supplemental : activeList.getSupplementals()) {
            // Just to be safe, shouldn't ever happen.
            if (supplemental == null || supplemental.getSequences() == null) continue;

            String itemTitle;
            if (supplemental.getSupplementalId() == null || supplemental.getSupplementalId().equals("null")) {
                itemTitle = "Original Active List";
                if (supplemental.getReleaseDateTime() != null) {
                    itemTitle += " - Released "+datetimeFormat.format(supplemental.getReleaseDateTime());
                }
            }
            else {
                itemTitle = "Supplemental "+supplemental.getSupplementalId();
            }
            %>
            <div class="title-block">
                <h3 class='item-title'><%=itemTitle%></h3>
            </div>
            <%
            for(Sequence sequence : supplemental.getSequences()) {
                // Just to be safe, shouldn't ever happen.
                if (sequence.getCalendarEntries() == null) continue;

                %>
                <div class="sequence">
                <% if (sequence.getNotes() != null && !sequence.getNotes().equals("null")) { %>
                    <%=sequence.getNotes()%>
                <% } %>
                </div>
                <div id="sequence-<%=sequence.getNo()%>-bills" class="billSummary">
                <% for (CalendarEntry entry : sequence.getCalendarEntries()) {
                    Bill bill = entry.getBill();
                    Bill subBill = entry.getSubBill();

                    // Just to be safe, this shouldn't ever happen
                    if (bill == null) continue;
                    %>
                    <div class="row">
                        <div style="margin-bottom:3px">
                        <a id="cal<%=entry.getNo()%>" href="#cal<%=entry.getNo()%>" class="anchor-link">#<%=entry.getNo()%></a>
                        <%
                        if (bill.isResolution()) {
                            %> - Resolution <a href="<%=JSPHelper.getLink(request, bill)%>"><%=bill.getSenateBillNo()%></a><%
                        } else {
                            %> - Bill <a href="<%=JSPHelper.getLink(request, bill)%>"><%=bill.getSenateBillNo()%></a><%
                        }

                        if (bill.getSponsor() != null) {
                            if (bill.getOtherSponsors().isEmpty()) {
                                %> - Sponsor: <%=JSPHelper.getSponsorLinks(bill, appPath)%> <%
                            } else {
                                %> - Sponsors: <%=JSPHelper.getSponsorLinks(bill, appPath)%> <%
                            }
                        }

                        if (subBill != null) {
                            if (subBill.getOtherSponsors().isEmpty()) {
                                %> (Substituted-bill Sponsor: <%=JSPHelper.getSponsorLinks(subBill, appPath)%>) <%
                            } else {
                                %> (Substituted-bill Sponsors: <%=JSPHelper.getSponsorLinks(subBill, appPath)%>) <%
                            }
                        } %>
                        </div>
                        <%=bill.getActClause()%>
                    </div>
                    <%
                } %>
                </div>
                <%
            }
        }
        %>
    </div>
</div>