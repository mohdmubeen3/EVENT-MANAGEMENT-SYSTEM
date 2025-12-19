package com.pms.config.servlet;

import com.pms.config.model.Event;
import com.pms.config.model.dao.EventDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

public class AddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String location = req.getParameter("location");
        String dateStr = req.getParameter("eventDate");
        String description = req.getParameter("description");
        String slotsStr = req.getParameter("slots");   // ✅ NEW

        try {
            LocalDate date = LocalDate.parse(dateStr);
            int slots = Integer.parseInt(slotsStr);     // ✅ NEW

            // ✅ UPDATED CONSTRUCTOR (with slots)
            Event event = new Event(0, name, location, date, description, slots);

            EventDAO dao = new EventDAO();
            dao.addEvent(event);

            resp.sendRedirect(req.getContextPath() + "/events?success=added");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/events?error=add_failed");
        }
    }
}