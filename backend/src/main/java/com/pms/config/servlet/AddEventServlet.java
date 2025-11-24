package com.pms.config.servlet;

import com.pms.config.model.Event;
import com.pms.config.model.dao.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/add-event")
public class AddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String location = req.getParameter("location");
        String dateStr = req.getParameter("eventDate");
        String description = req.getParameter("description");

        try {
            LocalDate date = LocalDate.parse(dateStr);

            Event event = new Event(0, name, location, date, description);

            EventDAO dao = new EventDAO();
            dao.addEvent(event);

            // 🔹 Success message on events page
            resp.sendRedirect(req.getContextPath() + "/events?success=added");

        } catch (Exception e) {
            throw new ServletException("Error while adding event", e);
        }
    }
}