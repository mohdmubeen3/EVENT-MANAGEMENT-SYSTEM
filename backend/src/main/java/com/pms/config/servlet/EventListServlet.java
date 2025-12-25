package com.pms.config.servlet;

import com.pms.config.model.Event;
import com.pms.config.model.dao.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class EventListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            EventDAO dao = new EventDAO();
            List<Event> events = dao.getAllEvents();

            // 📊 Dashboard stats
            int totalEvents = events != null ? events.size() : 0;
            int totalSlots = 0;
            int soldOutEvents = 0;

            if (events != null) {
                for (Event e : events) {
                    int slots = e.getSlots();
                    totalSlots += slots;
                    if (slots <= 0) {
                        soldOutEvents++;
                    }
                }
            }

            req.setAttribute("events", events);
            req.setAttribute("totalEvents", totalEvents);
            req.setAttribute("totalSlots", totalSlots);
            req.setAttribute("soldOutEvents", soldOutEvents);

            req.getRequestDispatcher("/WEB-INF/views/events.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error loading events list", e);
        }
    }
}