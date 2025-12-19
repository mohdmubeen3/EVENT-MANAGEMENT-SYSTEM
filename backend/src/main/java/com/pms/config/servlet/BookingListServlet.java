package com.pms.config.servlet;

import com.pms.config.model.Booking;
import com.pms.config.model.dao.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class BookingListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            BookingDAO dao = new BookingDAO();
            List<Booking> bookings = dao.getAllBookings();

            // 📊 Dashboard stats
            int totalBookings = bookings != null ? bookings.size() : 0;
            int totalSeatsBooked = 0;

            if (bookings != null) {
                for (Booking b : bookings) {
                    totalSeatsBooked += b.getSeats();
                }
            }

            req.setAttribute("bookings", bookings);
            req.setAttribute("totalBookings", totalBookings);
            req.setAttribute("totalSeatsBooked", totalSeatsBooked);

            req.getRequestDispatcher("/WEB-INF/views/bookings.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error loading bookings list", e);
        }
    }
}