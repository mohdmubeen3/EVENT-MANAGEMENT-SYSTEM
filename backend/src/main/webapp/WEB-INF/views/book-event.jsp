<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="com.pms.config.model.Event" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%
    Event event = (Event) request.getAttribute("event");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy");

    String idParam = (event != null) ? String.valueOf(event.getId()) : "";
    boolean soldOut = (event != null && event.getSlots() <= 0);
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Book Event</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">

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
        }

        .nav-left-title { font-size: 1.2rem; font-weight: 600; color: var(--accent); }
        .nav-right .nav-link {
            padding: 9px 16px;
            font-size: 0.9rem;
            border-radius: 999px;
            text-decoration: none;
            color: var(--muted);
            border: 1px solid rgba(148, 163, 184, 0.4);
        }

        .wrapper {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 18px 40px;
        }

        .page-title { font-size: 1.8rem; font-weight: 600; }
        .page-subtitle { font-size: 1rem; color: var(--muted); margin-top: 4px; }

        .grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 26px;
            margin-top: 28px;
        }

        .card {
            background: rgba(15, 23, 42, 0.96);
            padding: 22px 24px;
            border-radius: 20px;
            border: 1px solid rgba(148,163,184,0.35);
        }

        .event-label { font-size: 0.9rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.08em; }
        .event-name { font-size: 1.3rem; font-weight: 600; margin-top: 4px; }
        .event-meta { margin-top: 12px; font-size: 0.95rem; color: var(--muted); }
        .event-meta strong { color: var(--text); }

        .slots-pill {
            margin-top: 16px;
            font-size: 0.9rem;
            padding: 6px 12px;
            border-radius: 999px;
            background: var(--accent-soft);
            color: var(--accent);
            display: inline-block;
        }

        .slots-pill.soldout {
            background: rgba(248, 113, 113, 0.18);
            color: var(--danger);
        }

        .hint {
            margin-top: 10px;
            font-size: 0.85rem;
            color: var(--danger);
        }

        form label {
            display: block;
            margin-top: 14px;
            font-size: 0.95rem;
            font-weight: 600;
        }

        input {
            width: 100%;
            margin-top: 6px;
            padding: 10px 12px;
            border-radius: 12px;
            border: 1px solid rgba(148,163,184,0.6);
            background: rgba(15, 23, 42, 0.9);
            color: var(--text);
            font-size: 1rem;
        }

        .btn-primary {
            margin-top: 20px;
            width: 100%;
            padding: 12px;
            border-radius: 999px;
            border: none;
            font-size: 1.05rem;
            font-weight: 600;
            background: linear-gradient(to right, #0ea5e9, #22c55e);
            color: #020617;
            cursor: pointer;
        }
        .btn-primary[disabled] {
            opacity: 0.4;
            cursor: not-allowed;
        }

        .back-link {
            display: inline-block;
            margin-top: 18px;
            font-size: 0.9rem;
            color: var(--muted);
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="nav">
    <div class="nav-left-title">EVENT MANAGEMENT SYSTEM</div>
    <div class="nav-right">
        <a href="<%= request.getContextPath() %>/events" class="nav-link">← Back</a>
    </div>
</div>

<div class="wrapper">
    <div class="page-title">Book Event</div>
    <div class="page-subtitle">Reserve your seat by entering your details</div>

    <div class="grid">
        <!-- Event Info -->
        <div class="card">
            <% if (event != null) { %>
                <div class="event-label">Selected Event</div>
                <div class="event-name"><%= event.getName() %></div>

                <div class="event-meta">
                    <div><strong>Location:</strong> <%= event.getLocation() %></div>
                    <div><strong>Date:</strong>
                        <%= event.getEventDate() != null ? event.getEventDate().format(fmt) : "-" %>
                    </div>
                    <div style="margin-top: 8px;">
                        <strong>Description:</strong> <%= event.getDescription() %>
                    </div>
                </div>

                <div class="slots-pill <%= soldOut ? "soldout" : "" %>">
                    <% if (!soldOut) { %>
                        Available Slots: <%= event.getSlots() %>
                    <% } else { %>
                        This event is fully booked
                    <% } %>
                </div>
            <% } else { %>
                <div class="hint">No event details found.</div>
            <% } %>
        </div>

        <!-- Booking Form -->
        <div class="card">
            <form method="post" action="<%= request.getContextPath() %>/book-event">

                <!-- ✅ FIXED: must match servlet parameter -->
                <input type="hidden" name="id" value="<%= idParam %>">

                <label>Your Name</label>
                <input type="text" name="username" required placeholder="Enter your full name">

                <label>Your Email</label>
                <input type="email" name="email" required placeholder="Enter your email">

                <label>Number of Seats</label>
                <input type="number" name="seats" min="1" required placeholder="How many seats?">

                <button class="btn-primary" <%= soldOut ? "disabled" : "" %>>
                    <%= soldOut ? "No Slots Available" : "Confirm Booking" %>
                </button>
            </form>

            <% if (soldOut) { %>
                <div class="hint">You cannot book this event because all seats are filled.</div>
            <% } %>

            <a class="back-link" href="<%= request.getContextPath() %>/events">← Cancel and go back</a>
        </div>
    </div>
</div>

</body>
</html>
