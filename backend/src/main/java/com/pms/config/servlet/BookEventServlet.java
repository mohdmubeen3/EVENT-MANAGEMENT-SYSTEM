package com.pms.config.servlet;

import com.pms.config.model.dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class BookEventServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        String seatsParam = req.getParameter("seats");
        String username = req.getParameter("username");
        String email = req.getParameter("email");

        // Basic validation
        if (idParam == null || seatsParam == null ||
            username == null || email == null ||
            username.trim().isEmpty() || email.trim().isEmpty()) {

            resp.sendRedirect(req.getContextPath() + "/events?error=invalid_booking");
            return;
        }

        int eventId;
        int seats;

        try {
            eventId = Integer.parseInt(idParam.trim());
            seats = Integer.parseInt(seatsParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events?error=invalid_booking");
            return;
        }

        try {
            boolean ok = bookingDAO.bookEvent(eventId, username, email, seats);

            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/events?success=booked");
            } else {
                resp.sendRedirect(req.getContextPath() + "/events?error=noslots");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/events?error=server");
        }
    }
}
