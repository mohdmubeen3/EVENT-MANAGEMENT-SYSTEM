package com.pms.config.servlet;

import com.pms.config.model.dao.EventDAO;
import jakarta.servlet.ServletException;
 
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// 👉 Handles BOTH /delete-event and /events/delete
 
public class DeleteEventServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        try {
            int id = Integer.parseInt(idParam);
            EventDAO dao = new EventDAO();
            dao.deleteEvent(id);
        } catch (Exception ignored) {
            // for now we just ignore parse/DB errors
        }

        resp.sendRedirect(req.getContextPath() + "/events");
    }
}