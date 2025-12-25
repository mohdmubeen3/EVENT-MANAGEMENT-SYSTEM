package com.pms.config.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Shows the "Add Event" form.
 * URL: /add-event-form  (mapped in web.xml)
 */
public class AddEventFormServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Forward to add-event.jsp (form page)
        req.getRequestDispatcher("/WEB-INF/views/add-event.jsp")
           .forward(req, resp);
    }
}