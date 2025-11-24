<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.config.model.Event" %>
<%
    // No cache – always load fresh UI
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    List<Event> events = (List<Event>) request.getAttribute("events");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Management System – Events</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        :root {
            --bg: #020617;
            --card: #020617;
            --accent: #38bdf8;
            --accent2: #22c55e;
            --accent-soft: rgba(56, 189, 248, 0.14);
            --text: #e5e7eb;
            --muted: #9ca3af;
            --danger: #f97373;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: radial-gradient(circle at top, #1f2937 0, #020617 55%);
            color: var(--text);
            min-height: 100vh;
        }

        .nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 30px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
            background: linear-gradient(to right, rgba(15, 23, 42, 0.96), rgba(15, 23, 42, 0.9));
            backdrop-filter: blur(14px);
            position: sticky;
            top: 0;
            z-index: 20;
        }

        .nav-left-title {
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 0.07em;
            text-transform: uppercase;
            color: var(--accent);
        }

        .nav-left-sub {
            font-size: 0.75rem;
            color: var(--muted);
        }

        .nav-left {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }

        .nav-right {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .nav-pill {
            font-size: 0.78rem;
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(56, 189, 248, 0.45);
            background: rgba(15, 23, 42, 0.85);
            color: var(--muted);
        }

        .nav-pill span {
            color: var(--accent2);
            font-weight: 600;
        }

        .nav-links {
            display: flex;
            gap: 10px;
        }

        .nav-link {
            padding: 8px 14px;
            font-size: 0.85rem;
            border-radius: 999px;
            border: 1px solid rgba(148, 163, 184, 0.4);
            color: var(--muted);
            text-decoration: none;
            background: rgba(15, 23, 42, 0.6);
            transition: all 0.2s ease;
        }

        .nav-link:hover {
            color: #ffffff;
            border-color: rgba(56, 189, 248, 0.6);
            box-shadow: 0 0 14px rgba(56, 189, 248, 0.7);
            transform: translateY(-2px);
        }

        .nav-link-active {
            background: linear-gradient(to right, var(--accent), var(--accent2));
            color: #020617;
            border-color: transparent;
            box-shadow: 0 0 18px rgba(56, 189, 248, 0.9);
            font-weight: 600;
        }

        .wrapper {
            max-width: 1040px;
            margin: 30px auto 40px;
            padding: 0 18px 32px;
        }

        .header {
            margin-bottom: 18px;
        }

        .title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 10px;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 600;
        }

        .page-subtitle {
            font-size: 0.9rem;
            color: var(--muted);
            margin-top: 4px;
        }

        .page-pill {
            font-size: 0.8rem;
            color: var(--accent);
            background: var(--accent-soft);
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(56, 189, 248, 0.4);
        }

        .card {
            background: radial-gradient(circle at top left, rgba(56, 189, 248, 0.16), transparent 60%),
            radial-gradient(circle at bottom, rgba(15, 23, 42, 0.96), #020617 75%);
            border-radius: 18px;
            padding: 18px 20px 20px;
            border: 1px solid rgba(148, 163, 184, 0.35);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.9);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-bottom: 14px;
        }

        .toolbar-left {
            font-size: 0.85rem;
            color: var(--muted);
        }

        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            padding: 8px 16px;
            font-size: 0.9rem;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            background: linear-gradient(to right, #0ea5e9, #22c55e);
            color: #0b1120;
            font-weight: 600;
            box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.25);
            transition: all 0.18s ease;
        }

        .btn-primary:hover {
            filter: brightness(1.05);
            transform: translateY(-1px);
            box-shadow: 0 12px 30px rgba(8, 47, 73, 0.85);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            margin-top: 6px;
            overflow: hidden;
            border-radius: 12px;
        }

        thead {
            background: rgba(15, 23, 42, 0.96);
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid rgba(30, 64, 175, 0.55);
            text-align: left;
        }

        th {
            font-weight: 500;
            color: #cbd5f5;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            border-bottom-width: 2px;
        }

        tbody tr:nth-child(even) {
            background: rgba(15, 23, 42, 0.80);
        }

        tbody tr:nth-child(odd) {
            background: rgba(15, 23, 42, 0.60);
        }

        tbody tr:hover {
            background: rgba(6, 95, 70, 0.35);
        }

        td {
            color: #e5e7eb;
        }

        td:nth-child(1) {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .btn-danger {
            display: inline-flex;
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(248, 113, 113, 0.8);
            font-size: 0.78rem;
            color: var(--danger);
            background: transparent;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.16s ease;
        }

        .btn-danger:hover {
            background: rgba(248, 113, 113, 0.08);
            box-shadow: 0 0 12px rgba(248, 113, 113, 0.7);
        }

        .empty-state {
            text-align: center;
            padding: 18px 8px 12px;
            color: var(--muted);
            font-size: 0.9rem;
        }

        @media (max-width: 720px) {
            .nav {
                padding: 10px 16px;
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
            }

            .wrapper {
                margin-top: 20px;
            }

            .title-row {
                flex-direction: column;
                align-items: flex-start;
            }

            .toolbar {
                flex-direction: column;
                align-items: flex-start;
            }

            table {
                font-size: 0.8rem;
            }

            th, td {
                padding: 6px;
            }
        }
    </style>
</head>
<body>

<div class="nav">
    <div class="nav-left">
        <div class="nav-left-title">EVENT MANAGEMENT SYSTEM</div>
        <div class="nav-left-sub">Java · JSP · Servlets · MariaDB</div>
    </div>
    <div class="nav-right">
        <div class="nav-pill">
            Review-1 Backend: <span>Completed ✅</span>
        </div>
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/events"
               class="nav-link nav-link-active">Events</a>
            <a href="<%= request.getContextPath() %>/add-event-form"
               class="nav-link">Add Event</a>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="header">
        <div class="title-row">
            <div>
                <div class="page-title">All Events</div>
                <div class="page-subtitle">
                    View, manage and track all scheduled events stored in your database.
                </div>
            </div>
            <div class="page-pill">
                Simple CRUD · College Project
            </div>
        </div>
    </div>

    <div class="card">
        <div class="toolbar">
            <div class="toolbar-left">
                Events are fetched from MariaDB using DAO + Servlets and rendered on this JSP.
            </div>

            <a class="btn-primary"
               href="<%= request.getContextPath() %>/add-event-form">
                + Add New Event
            </a>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Event Name</th>
                <th>Location</th>
                <th>Date</th>
                <th>Description</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (events == null || events.isEmpty()) {
            %>
            <tr>
                <td colspan="6" class="empty-state">
                    No events found. Click <strong>Add New Event</strong> to create your first event.
                </td>
            </tr>
            <%
                } else {
                    for (Event e : events) {
            %>
            <tr>
                <td><%= e.getId() %></td>
                <td><%= e.getName() %></td>
                <td><%= e.getLocation() %></td>
                <td><%= e.getEventDate() %></td>
                <td><%= e.getDescription() %></td>
                <td>
                    <a class="btn-danger"
                       href="<%= request.getContextPath() %>/events/delete?id=<%= e.getId() %>"
                       onclick="return confirm('Delete this event?');">
                        Delete
                    </a>
                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>