package com.pms.config.servlet;

import com.pms.config.model.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles admin cancelling a booking (GET /bookings/cancel?id=..)
 */
public class CancelBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/bookings?error=cancel_invalid");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/bookings?error=cancel_invalid");
            return;
        }

        try {
            BookingDAO dao = new BookingDAO();
            boolean ok = dao.cancelBooking(bookingId);

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/bookings?success=cancelled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/bookings?error=cancel_not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/bookings?error=cancel_server");
        }
    }
}