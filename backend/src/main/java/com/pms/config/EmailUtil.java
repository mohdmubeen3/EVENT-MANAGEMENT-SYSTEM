package com.pms.config;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Properties;

/**
 * Sends booking confirmation emails using Gmail SMTP.
 */
public class EmailUtil {

    // Your Gmail (system sender email)
    private static final String FROM_EMAIL = "sheikhmubeen502@gmail.com";

    // ⚠️ Keep your 16-char app password ONLY HERE, do not share it.
    private static final String FROM_PASSWORD = "oxwl xjlv jgia kkst";

    /**
     * Send a booking confirmation email with full event details.
     */
    public static void sendBookingConfirmation(String toEmail,
                                               String userName,
                                               String eventName,
                                               String eventLocation,
                                               LocalDate eventDate,
                                               int seats) throws MessagingException {

        if (toEmail == null || toEmail.trim().isEmpty()) {
            return; // nothing to send
        }

        String dateText = "Not specified";
        if (eventDate != null) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy");
            dateText = eventDate.format(fmt);
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(toEmail));

        String subject = "Your Booking is Confirmed – " +
                (eventName != null ? eventName : "Event");

        StringBuilder body = new StringBuilder();
        body.append("Hello ").append(userName).append(",\n\n");
        body.append("Your booking has been confirmed.\n\n");
        body.append("Event Details:\n");
        if (eventName != null) {
            body.append("  • Name: ").append(eventName).append("\n");
        }
        if (eventLocation != null) {
            body.append("  • Location: ").append(eventLocation).append("\n");
        }
        body.append("  • Date: ").append(dateText).append("\n");
        body.append("  • Seats: ").append(seats).append("\n\n");
        body.append("Thank you for using the Event Management System.\n");

        message.setSubject(subject);
        message.setText(body.toString());

        Transport.send(message);
    }
}