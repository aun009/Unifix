import React, { useState } from "react";
import axios from "axios";
import Loader from "../components/Loader";
import "./Feedback.css";

const Feedback = () => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    message: "",
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [success, setSuccess] = useState(false);

  // API URL for Spring Boot backend
  const apiUrl = `${import.meta.env.VITE_API_URL || 'http://localhost:8081/api'}/feedback`;

  const handleChange = (e) => {
    const { name, value } = e.target;
    console.log("hiiiiiiiiiiiiiiiiiiiiiiiiii", e.target)

    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
    
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(false);

    try {
      console.log("Submitting feedback to:", apiUrl);
      const response = await axios.post(apiUrl, formData, {
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      });
      console.log("Response:", response.data);
      
      if (response.data.success) {
        setSuccess(true);
        setFormData({ name: "", email: "", message: "" });
      }
    } catch (error) {
      console.error("Error submitting feedback:", error);
      console.error("Error details:", {
        message: error.message,
        status: error.response?.status,
        data: error.response?.data,
        config: error.config,
      });
      
      setError(
        error.response?.data?.message ||
        "Failed to submit feedback. Please try again later."
      );
    } finally {
      setLoading(false);
    }
  };

  // Show loader if loading is true
  if (loading) {
    return <Loader />;
  }

  return (
    <div className="feedback-page">
      <div className="feedback-container">
        <div className="blob">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 310 350">
            <path d="M156.4,339.5c31.8-2.5,59.4-26.8,80.2-48.5c28.3-29.5,40.5-47,56.1-85.1c14-34.3,20.7-75.6,2.3-111  c-18.1-34.8-55.7-58-90.4-72.3c-11.7-4.8-24.1-8.8-36.8-11.5l-0.9-0.9l-0.6,0.6c-27.7-5.8-56.6-6-82.4,3c-38.8,13.6-64,48.8-66.8,90.3c-3,43.9,17.8,88.3,33.7,128.8c5.3,13.5,10.4,27.1,14.9,40.9C77.5,309.9,111,343,156.4,339.5z" />
          </svg>
        </div>
        <div className="glass-card">
          <h1 className="form-title">FEEDBACK</h1>
          {success && <div className="success-message">Feedback submitted successfully. Thank you!</div>}
          {error && <div className="error-message">{error}</div>}
          
          <form onSubmit={handleSubmit}>
            <input
              type="text"
              placeholder="Name"
              className="form-input"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
            />
            <input
              type="email"
              placeholder="Email"
              className="form-input"
              name="email"
              value={formData.email}
              onChange={handleChange}
              required
            />
            <textarea
              placeholder="Message"
              className="form-textarea"
              name="message"
              value={formData.message}
              onChange={handleChange}
              required
            />
            <button type="submit" className="form-button">
              Submit
            </button>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Feedback;
