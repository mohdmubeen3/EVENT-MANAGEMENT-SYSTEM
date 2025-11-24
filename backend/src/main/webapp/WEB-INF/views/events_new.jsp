<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Management System – Events</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        :root {
            --bg: #0f172a;
            --card: #111827;
            --accent: #38bdf8;
            --accent-soft: rgba(56, 189, 248, 0.15);
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
            padding: 14px 34px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
            backdrop-filter: blur(14px);
            background: linear-gradient(to right, rgba(15, 23, 42, 0.96), rgba(15, 23, 42, 0.9));
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .nav-title {
            font-size: 1.1rem;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--accent);
        }

        .nav-sub {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .nav-right {
            font-size: 0.85rem;
            color: var(--muted);
        }

        .nav-right span {
            color: var(--accent);
            font-weight: 500;
        }

        .wrapper {
            max-width: 1000px;
            margin: 26px auto 40px;
            padding: 0 16px 32px;
        }

        .header {
            margin-bottom: 16px;
        }

        .title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            gap: 10px;
        }

        .page-title {
            font-size: 1.7rem;
            font-weight: 600;
        }

        .page-subtitle {
            font-size: 0.9rem;
            color: var(--muted);
            margin-top: 4px;
        }

        .pill {
            font-size: 0.8rem;
            color: var(--accent);
            background: var(--accent-soft);
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(56, 189, 248, 0.4);
        }

        .card {
            background: radial-gradient(circle at top left, rgba(56, 189, 248, 0.18), transparent 55%),
                        radial-gradient(circle at bottom, rgba(15, 23, 42, 0.95), #020617 72%);
            border-radius: 16px;
            padding: 18px 20px 20px;
            border: 1px solid rgba(148, 163, 184, 0.3);
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

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            padding: 7px 14px;
            font-size: 0.9rem;
            border: 1px solid transparent;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.16s ease;
        }

        .btn-primary {
            background: linear-gradient(to right, #0ea5e9, #22c55e);
            color: #0b1120;
            font-weight: 600;
            box-shadow: 0 0 0 1px rgba(34, 197, 94, 0.2);
        }

        .btn-primary:hover {
            filter: brightness(1.05);
            transform: translateY(-1px);
            box-shadow: 0 12px 24px rgba(8, 47, 73, 0.7);
        }

        .btn-danger {
            background: transparent;
            color: var(--danger);
            border-color: rgba(248, 113, 113, 0.7);
            font-size: 0.78rem;
            padding: 4px 10px;
        }

        .btn-danger:hover {
            background: rgba(248, 113, 113, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
            margin-top: 6px;
        }

        thead {
            background: rgba(15, 23, 42, 0.9);
        }

        th, td {
            padding: 8px 10px;
            border-bottom: 1px solid rgba(30, 64, 175, 0.6);
            text-align: left;
        }

        th {
            font-weight: 500;
            color: #cbd5f5;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            border-bottom-width: 2px;
        }

        tbody tr:nth-child(even) {
            background: rgba(15, 23, 42, 0.7);
        }

        tbody tr:nth-child(odd) {
            background: rgba(15, 23, 42, 0.45);
        }

        tbody tr:hover {
            background: rgba(15, 118, 110, 0.25);
        }

        td {
            color: #e5e7eb;
        }

        td:nth-child(1) {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .empty-state {
            text-align: center;
            padding: 18px 8px 8px;
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
                margin-top: 18px;
            }

            .title-row {
                flex-direction: column;
                align-items: flex-start;
            }

            table {
                font-size: 0.8rem;
            }

            th, td {
                padding: 6px;
            }

            .toolbar {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>

<div class="nav">
    <div>
        <div class="nav-title">Event Management System</div>
        <div class="nav-sub">Java · JSP · Servlets · MariaDB</div>
    </div>
    <div class="nav-right">
        Review-1 Backend: <span>Completed ✅</span>
    </div>
</div>

<div class="wrapper">
    <div class="header">
        <div class="title-row">
            <div>
                <div class="page-title">All Events</div>
                <div class="page-subtitle">
                    View, manage, and track all scheduled events from one place.
                </div>
            </div>
            <div class="pill">
                Simple CRUD · College Project
            </div>
        </div>
    </div>

    <div class="card">
        <div class="toolbar">
            <div class="toolbar-left">
                Events stored in database and loaded via DAO & Servlets.
            </div>

            <a class="btn btn-primary"
               href="${pageContext.request.contextPath}/add-event-form">
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
            <c:if test="${empty events}">
                <tr>
                    <td colspan="6" class="empty-state">
                        No events found. Click <strong>Add New Event</strong> to create your first one.
                    </td>
                </tr>
            </c:if>

            <c:forEach var="e" items="${events}">
                <tr>
                    <td>${e.id}</td>
                    <td>${e.name}</td>
                    <td>${e.location}</td>
                    <td>${e.eventDate}</td>
                    <td>${e.description}</td>
                    <td>
                        <a class="btn btn-danger"
                           href="${pageContext.request.contextPath}/events/delete?id=${e.id}"
                           onclick="return confirm('Are you sure you want to delete this event?');">
                            Delete
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>