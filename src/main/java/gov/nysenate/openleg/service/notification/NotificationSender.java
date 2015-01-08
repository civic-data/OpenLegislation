package gov.nysenate.openleg.service.notification;

import gov.nysenate.openleg.model.notification.RegisteredNotification;
import gov.nysenate.openleg.model.notification.NotificationSubscription;
import gov.nysenate.openleg.model.notification.NotificationTarget;

import java.util.Collection;

public interface NotificationSender {

    /**
     * @return The medium through which the sender sends notifications
    */
    public NotificationTarget getTargetType();

    /**
     * Sends a notification to all of the given addresses
     * @param registeredNotification Notification
     * @param addresses Collection<String>
     */
    public void sendNotification(RegisteredNotification registeredNotification, Collection<NotificationSubscription> addresses);
}
