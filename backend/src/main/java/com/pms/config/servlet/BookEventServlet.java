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
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int eventId = Integer.parseInt(req.getParameter("id"));
        String username = req.getParameter("username");
        String email = req.getParameter("email");      // make sure book form has email field
        int seats = Integer.parseInt(req.getParameter("seats"));

        try {
            boolean ok = bookingDAO.bookEvent(eventId, username, email, seats);

            if (ok) {
                // success — you can optionally trigger email sending here (async ideally)
                resp.sendRedirect(req.getContextPath() + "/events?success=booked");
            } else {
                // failure due to insufficient slots or event missing
                resp.sendRedirect(req.getContextPath() + "/events?error=noslots");
            }

        } catch (Exception e) {
            // log exception server-side
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/events?error=server");
        }
    }
}