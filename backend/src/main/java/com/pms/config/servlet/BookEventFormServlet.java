package com.pms.config.servlet;

import com.pms.config.model.Event;
import com.pms.config.model.dao.EventDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class BookEventFormServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/events?error=invalid_event");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/events?error=invalid_event");
            return;
        }

        try {
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                resp.sendRedirect(req.getContextPath() + "/events?error=event_not_found");
                return;
            }

            req.setAttribute("event", event);
            req.getRequestDispatcher("/WEB-INF/views/book-event.jsp")
               .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Error loading event for booking", e);
        }
    }
}