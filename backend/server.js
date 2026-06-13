const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 8081;

// Database Connection
const connectionString = process.env.DATABASE_URL || 'postgresql://neondb_owner:npg_wzrm1cWXitC3@ep-falling-bread-adpoy9ql.c-2.us-east-1.aws.neon.tech/neondb?sslmode=require';

const pool = new Pool({
  connectionString: connectionString,
  ssl: {
    rejectUnauthorized: false
  }
});

// Middleware
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept']
}));
app.use(express.json());

// Request logger middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Email transporter configuration
let transporter = null;
const gmailUser = process.env.GMAIL_USERNAME;
const gmailPass = process.env.GMAIL_APP_PASSWORD;

if (gmailUser && gmailPass) {
  transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: gmailUser,
      pass: gmailPass
    }
  });
  console.log('Nodemailer SMTP transporter initialized with Gmail credentials.');
} else {
  console.log('Gmail credentials not fully configured. Email notifications will be skipped.');
}

// Map database row to Frontend-compatible JSON
const mapFeedback = (row) => ({
  id: row.id,
  name: row.name,
  email: row.email,
  message: row.message,
  createdAt: row.created_at,
  updatedAt: row.updated_at
});

// Helper for email regex validation
const validateEmail = (email) => {
  const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return re.test(String(email).toLowerCase());
};

// --- REST Endpoints ---

// 1. Health Check
app.get('/api/feedback/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: "Backend is healthy",
    data: "OK"
  });
});

// 2. Submit Feedback
app.post('/api/feedback', async (req, res) => {
  console.log('=== FEEDBACK SUBMISSION START ===');
  const { name, email, message } = req.body;
  
  console.log(`Received feedback submission for: ${email}`);
  console.log(`Request details - Name: ${name}, Email: ${email}, Message length: ${message ? message.length : 0}`);

  // Validation
  if (!name || name.trim().length < 2 || name.length > 100) {
    console.log('=== FEEDBACK SUBMISSION FAILED (Validation error: Name) ===');
    return res.status(400).json({
      success: false,
      message: "Name is required and must be between 2 and 100 characters"
    });
  }

  if (!email || !validateEmail(email)) {
    console.log('=== FEEDBACK SUBMISSION FAILED (Validation error: Email) ===');
    return res.status(400).json({
      success: false,
      message: "Invalid email format"
    });
  }

  if (!message || message.trim().length < 3 || message.length > 1000) {
    console.log('=== FEEDBACK SUBMISSION FAILED (Validation error: Message) ===');
    return res.status(400).json({
      success: false,
      message: "Message is required and must be between 3 and 1000 characters"
    });
  }

  try {
    const id = crypto.randomUUID();
    const now = new Date();

    const insertQuery = `
      INSERT INTO feedbacks (id, name, email, message, created_at, updated_at)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;

    const result = await pool.query(insertQuery, [id, name, email, message, now, now]);
    const savedFeedback = mapFeedback(result.rows[0]);
    console.log(`Feedback saved successfully to Neon DB with ID: ${savedFeedback.id}`);

    // Send email notification (async so it doesn't block response)
    const emailRecipient = process.env.EMAIL_RECIPIENT || 'arunmahajan9240@gmail.com';
    const emailFrom = process.env.EMAIL_FROM || 'noreply@unifix.com';

    if (transporter) {
      console.log('Attempting to send email notification...');
      const mailOptions = {
        from: emailFrom,
        to: emailRecipient,
        subject: `New Feedback from UniFix - ${savedFeedback.name}`,
        text: `New feedback received from UniFix website:

Name: ${savedFeedback.name}
Email: ${savedFeedback.email}
Message: ${savedFeedback.message}

Submitted at: ${savedFeedback.createdAt.toISOString()}

---
This is an automated message from UniFix feedback system.`
      };

      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.error('Failed to send feedback email:', error.message);
        } else {
          console.log(`Feedback email sent successfully to: ${emailRecipient}`);
        }
      });
    } else {
      console.log('Email service not configured, skipping email notification');
    }

    console.log('=== FEEDBACK SUBMISSION SUCCESS ===');
    return res.status(201).json({
      success: true,
      message: "Feedback submitted successfully!",
      data: savedFeedback
    });

  } catch (err) {
    console.error('=== FEEDBACK SUBMISSION FAILED ===');
    console.error('Error processing feedback submission:', err.message);
    console.error(err.stack);
    return res.status(500).json({
      success: false,
      message: "Failed to submit feedback. Please try again later.",
      data: null
    });
  }
});

// 3. Get All Feedback
app.get('/api/feedback', async (req, res) => {
  try {
    console.log('Fetching all feedback');
    const selectQuery = 'SELECT * FROM feedbacks ORDER BY created_at DESC';
    const result = await pool.query(selectQuery);
    
    const feedbackList = result.rows.map(mapFeedback);
    return res.status(200).json({
      success: true,
      message: "Feedback retrieved successfully",
      data: feedbackList
    });
  } catch (err) {
    console.error('Error fetching feedback:', err.message);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch feedback. Please try again later.",
      data: null
    });
  }
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Unhandled Application Error:', err);
  res.status(500).json({
    success: false,
    message: 'An unexpected error occurred.'
  });
});

// Start Server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
