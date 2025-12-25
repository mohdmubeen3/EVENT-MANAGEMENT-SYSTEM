package com.pms.config.servlet;

import com.pms.config.model.Booking;
import com.pms.config.model.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * Exports all bookings as CSV for Excel.
 * URL: GET /bookings/export
 */
public class ExportBookingsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/csv; charset=UTF-8");

        String filename = "bookings_export.csv";
        resp.setHeader("Content-Disposition",
                "attachment; filename=\"" + filename + "\"");

        BookingDAO dao = new BookingDAO();
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        try (PrintWriter out = resp.getWriter()) {

            // CSV header row
            out.println("ID,Event,User,Email,Seats,Booking Time");

            List<Booking> bookings = dao.getAllBookings();

            if (bookings != null) {
                for (Booking b : bookings) {
                    String time = "";
                    if (b.getBookingTime() != null) {
                        time = b.getBookingTime().format(fmt);
                    }

                    out.print(escapeCsv(b.getId()));
                    out.print(',');
                    out.print(escapeCsv(b.getEventName()));
                    out.print(',');
                    out.print(escapeCsv(b.getUserName()));
                    out.print(',');
                    out.print(escapeCsv(b.getUserEmail()));
                    out.print(',');
                    out.print(escapeCsv(b.getSeats()));
                    out.print(',');
                    out.println(escapeCsv(time));
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Error exporting bookings to CSV", e);
        }
    }

    /** Escape value for safe CSV (handles commas, quotes, newlines). */
    private String escapeCsv(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value);

        boolean needQuotes =
                s.contains(",") || s.contains("\"") || s.contains("\n") || s.contains("\r");

        s = s.replace("\"", "\"\""); // escape quotes

        if (needQuotes) {
            s = "\"" + s + "\"";
        }
        return s;
    }
}