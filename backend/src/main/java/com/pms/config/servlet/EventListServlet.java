package com.pms.config.servlet;

import com.pms.config.model.Event;
import com.pms.config.model.dao.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/events")
public class EventListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            EventDAO dao = new EventDAO();
            List<Event> events = dao.getAllEvents();

            req.setAttribute("events", events);

            req.getRequestDispatcher("/WEB-INF/views/events.jsp")
               .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException("Error loading events list", e);
        }
    }
}