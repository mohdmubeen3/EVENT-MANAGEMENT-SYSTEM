<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pms.config.model.Booking" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    java.util.Set<String> eventNames = new java.util.HashSet<>();
    if (bookings != null) {
        for (Booking b : bookings) {
            if (b.getEventName() != null) {
                eventNames.add(b.getEventName());
            }
        }
    }

    Integer totalBookings = (Integer) request.getAttribute("totalBookings");
    Integer totalSeatsBooked = (Integer) request.getAttribute("totalSeatsBooked");
    if (totalBookings == null) totalBookings = 0;
    if (totalSeatsBooked == null) totalSeatsBooked = 0;

    String success = request.getParameter("success");
    String error = request.getParameter("error");
    String flashText = null;
    String flashType = null;

    if (success != null) {
        if ("cancelled".equals(success)) {
            flashText = "Booking cancelled and slots restored.";
        }
        flashType = "success";
    } else if (error != null) {
        if ("cancel_invalid".equals(error)) {
            flashText = "Invalid booking id.";
        } else if ("cancel_not_found".equals(error)) {
            flashText = "Booking not found. It may have already been deleted.";
        } else if ("cancel_server".equals(error)) {
            flashText = "Server error while cancelling booking.";
        } else {
            flashText = "Unable to cancel booking.";
        }
        flashType = "error";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Management System – Bookings</title>
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
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: system-ui, sans-serif;
            background: radial-gradient(circle at top, #1f2937 0, #020617 55%);
            color: var(--text);
            min-height: 100vh;
        }

        .nav {
            display: flex; justify-content: space-between; align-items: center;
            padding: 14px 30px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.25);
            background: rgba(15, 23, 42, 0.9);
            position: sticky; top: 0; z-index: 20;
        }
        .nav-left-title { font-size: 1.1rem; font-weight: 600; color: var(--accent); }
        .nav-left-sub { font-size: 0.75rem; color: var(--muted); }
        .nav-right { display: flex; gap: 12px; align-items: center; }
        .nav-links { display: flex; gap: 10px; }
        .nav-link {
            padding: 8px 14px; font-size: 0.85rem;
            border-radius: 999px; text-decoration: none;
            color: var(--muted); background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(148, 163, 184, 0.4);
            transition: 0.2s;
        }
        .nav-link:hover { color: #fff; border-color: var(--accent); }
        .nav-link-active {
            background: linear-gradient(to right, var(--accent), var(--accent2));
            color: #020617;
        }

        .wrapper { max-width: 1040px; margin: 30px auto; padding: 0 18px 32px; }
        .page-title { font-size: 1.8rem; font-weight: 600; }
        .page-subtitle { font-size: 0.9rem; color: var(--muted); margin-top: 4px; }

        .stats-bar {
            margin-top: 10px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        .stat-pill {
            font-size: 0.78rem;
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.45);
            background: rgba(15,23,42,0.9);
            color: var(--muted);
        }
        .stat-pill span {
            color: var(--accent2);
            font-weight: 600;
        }

        .export-row {
            margin-top: 10px;
            display: flex;
            justify-content: flex-end;
        }
        .btn-export {
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 0.82rem;
            border: 1px solid rgba(56,189,248,0.8);
            background: rgba(15,23,42,0.9);
            color: var(--accent);
            text-decoration: none;
            cursor: pointer;
            transition: 0.15s;
        }
        .btn-export:hover {
            background: rgba(56,189,248,0.15);
            box-shadow: 0 0 12px rgba(56,189,248,0.7);
        }

        .card {
            background: rgba(15, 23, 42, 0.9);
            padding: 18px 20px; border-radius: 18px;
            border: 1px solid rgba(148,163,184,0.35);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 6px;
            border-radius: 12px;
            overflow: hidden;
        }
        th, td { padding: 8px 10px; border-bottom: 1px solid rgba(30, 64, 175, 0.55); }
        th { color: #cbd5f5; text-transform: uppercase; font-size: 0.8rem; }
        tbody tr:nth-child(even) { background: rgba(15, 23, 42, 0.80); }
        tbody tr:nth-child(odd) { background: rgba(15, 23, 42, 0.60); }

        .seats-pill {
            display: inline-block;
            padding: 2px 9px;
            border-radius: 999px;
            background: rgba(34,197,94,0.15);
            color: #bbf7d0;
            font-size: 0.78rem;
        }
        .time-text {
            font-size: 0.8rem;
            color: var(--muted);
        }

        .filters {
            margin: 16px 0 10px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        .filter-label {
            font-size: 0.8rem;
            color: var(--muted);
        }
        .filter-select,
        .filter-input {
            padding: 6px 10px;
            border-radius: 999px;
            border: 1px solid rgba(148,163,184,0.55);
            background: rgba(15,23,42,0.9);
            color: var(--text);
            font-size: 0.85rem;
            outline: none;
        }
        .filter-input {
            min-width: 200px;
        }
        .filter-select:focus,
        .filter-input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 1px rgba(56,189,248,0.4);
        }

        .flash {
            margin-top: 14px;
            margin-bottom: 10px;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 0.9rem;
        }
        .flash-success {
            background: rgba(34, 197, 94, 0.12);
            border: 1px solid rgba(34, 197, 94, 0.6);
            color: #bbf7d0;
        }
        .flash-error {
            background: rgba(248, 113, 113, 0.12);
            border: 1px solid rgba(248, 113, 113, 0.7);
            color: #fecaca;
        }

        .action-cell {
            display: flex;
            gap: 8px;
            justify-content: center;
            flex-wrap: nowrap;
        }
        .btn-danger {
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid rgba(248,113,113,0.8);
            text-decoration: none;
            font-size: 0.78rem;
            color: var(--danger);
        }
    </style>
</head>
<body>

<div class="nav">
    <div class="nav-left">
        <div class="nav-left-title">EVENT MANAGEMENT SYSTEM</div>
        <div class="nav-left-sub">Admin View · All Bookings</div>
    </div>
    <div class="nav-right">
        <div class="nav-links">
            <a href="<%= request.getContextPath() %>/events" class="nav-link">Events</a>
            <a href="<%= request.getContextPath() %>/add-event-form" class="nav-link">Add Event</a>
            <a href="<%= request.getContextPath() %>/bookings" class="nav-link nav-link-active">Bookings</a>
        </div>
    </div>
</div>

<div class="wrapper">
    <div class="page-title">All Bookings</div>
    <div class="page-subtitle">View every booking made for your events.</div>

    <div class="stats-bar">
        <div class="stat-pill">Total Bookings: <span><%= totalBookings %></span></div>
        <div class="stat-pill">Total Seats Booked: <span><%= totalSeatsBooked %></span></div>
    </div>

    <% if (flashText != null && flashType != null) { %>
        <div class="flash <%= "success".equals(flashType) ? "flash-success" : "flash-error" %>">
            <%= flashText %>
        </div>
    <% } %>

    <div class="export-row">
        <a href="<%= request.getContextPath() %>/bookings/export" class="btn-export">
            ⬇ Export Bookings (CSV)
        </a>
    </div>

    <!-- Filters -->
    <div class="filters">
        <span class="filter-label">Filter by event:</span>
        <select id="eventFilter" class="filter-select" onchange="applyFilters()">
            <option value="ALL">All events</option>
            <% for (String ev : eventNames) { %>
                <option value="<%= ev %>"><%= ev %></option>
            <% } %>
        </select>

        <span class="filter-label">Search user / email:</span>
        <input id="userFilter"
               class="filter-input"
               type="text"
               placeholder="Type name or email..."
               onkeyup="applyFilters()" />
    </div>

    <div class="card">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Event</th>
                <th>User</th>
                <th>Email</th>
                <th>Seats</th>
                <th>Time</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (bookings == null || bookings.isEmpty()) {
            %>
            <tr>
                <td colspan="7" style="text-align:center; padding:20px;">No bookings found yet.</td>
            </tr>
            <%
                } else {
                    for (Booking b : bookings) {
            %>
            <tr class="data-row"
                data-event="<%= b.getEventName() %>"
                data-user="<%= b.getUserName() %>"
                data-email="<%= b.getUserEmail() %>">
                <td><%= b.getId() %></td>
                <td><%= b.getEventName() %></td>
                <td><%= b.getUserName() %></td>
                <td><%= b.getUserEmail() %></td>
                <td><span class="seats-pill"><%= b.getSeats() %> seat(s)</span></td>
                <td class="time-text">
                    <%
                        if (b.getBookingTime() != null) {
                            out.print(b.getBookingTime().format(fmt));
                        }
                    %>
                </td>
                <td class="action-cell">
                    <a href="<%= request.getContextPath() %>/bookings/cancel?id=<%= b.getId() %>"
                       class="btn-danger"
                       onclick="return confirm('Cancel this booking and restore slots?');">
                        Cancel
                    </a>
                </td>
            </tr>
            <%  } } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function applyFilters() {
        const eventSelect = document.getElementById('eventFilter').value.toLowerCase();
        const term = document.getElementById('userFilter').value.toLowerCase().trim();

        const rows = document.querySelectorAll('tbody tr.data-row');

        rows.forEach(function (row) {
            const eventName = (row.getAttribute('data-event') || '').toLowerCase();
            const user = (row.getAttribute('data-user') || '').toLowerCase();
            const email = (row.getAttribute('data-email') || '').toLowerCase();

            const matchEvent = (eventSelect === 'all') || (eventSelect === eventName);
            const matchUser = !term || user.includes(term) || email.includes(term);

            row.style.display = (matchEvent && matchUser) ? '' : 'none';
        });
    }
</script>

</body>
</html>