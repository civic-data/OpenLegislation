package gov.nysenate.openleg.client.view.calendar;

import gov.nysenate.openleg.client.view.bill.SimpleBillInfoView;
import gov.nysenate.openleg.model.bill.BillId;
import gov.nysenate.openleg.model.calendar.CalendarSupplementalEntry;
import gov.nysenate.openleg.service.bill.data.BillDataService;

import java.util.Comparator;

public class CalendarSupEntryView extends SimpleBillInfoView {

    protected int billCalNo;

    protected String sectionType;

    protected SimpleBillInfoView subBillInfo;

    protected boolean billHigh;

    public CalendarSupEntryView(CalendarSupplementalEntry supEntry, BillDataService billDataService) {
        super(supEntry != null ? billDataService.getBillInfo(BillId.getBaseId(supEntry.getBillId())) : null);

        if (supEntry != null) {
            this.billCalNo = supEntry.getBillCalNo();
            this.sectionType = supEntry.getSectionType().toString();
            this.subBillInfo = supEntry.getSubBillId() != null
                    ? new SimpleBillInfoView(billDataService.getBillInfo(BillId.getBaseId(supEntry.getSubBillId())))
                    : null;
            this.billHigh = supEntry.getBillHigh();
        }
    }

    public int getBillCalNo() {
        return billCalNo;
    }

    public String getSectionType() {
        return sectionType;
    }

    public SimpleBillInfoView getSubBillInfo() {
        return subBillInfo;
    }

    public boolean isBillHigh() {
        return billHigh;
    }

    public static Comparator<CalendarSupEntryView> supEntryViewComparator =
            (ent1, ent2) -> Integer.compare(ent1.billCalNo, ent2.billCalNo);

    @Override
    public String getViewType() {
        return "calendar-floor-entry";
    }
}
