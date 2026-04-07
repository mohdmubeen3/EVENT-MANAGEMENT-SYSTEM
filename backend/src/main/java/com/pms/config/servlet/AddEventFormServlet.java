<<<<<<< HEAD
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
=======
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
>>>>>>> 5b7ff224ce0bf46968bb8fc5093b52ee3ee5bf81
}