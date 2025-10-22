import React, { useState, useEffect } from "react";
import axios from "axios";
import Loader from "../components/Loader";
import "./Feedback.css";

const ViewFeedback = () => {
  const [feedback, setFeedback] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    fetchFeedback();
  }, []);

  const fetchFeedback = async () => {
    try {
      // Use local Spring Boot backend
      const apiUrl = "http://localhost:8081/api/feedback";
      const response = await axios.get(apiUrl);
      
      console.log("Feedback data:", response.data);
      // Handle the Spring Boot API response structure
      if (response.data && response.data.success) {
        setFeedback(response.data.data || []);
      } else {
        setFeedback([]);
      }
      setLoading(false);
    } catch (error) {
      console.error("Error fetching feedback:", error);
      setError("Failed to load feedback. Please try again later.");
      setLoading(false);
    }
  };

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
        <div className="glass-card feedback-list-card">
          <h1 className="form-title">View Feedback</h1>
          {error && <div className="error-message">{error}</div>}
          
          {feedback.length === 0 ? (
            <div className="no-feedback">No feedback submissions found.</div>
          ) : (
            <div className="feedback-list">
              {feedback.map((item) => (
                <div key={item.id} className="feedback-item">
                  <div className="feedback-header">
                    <h3>{item.name}</h3>
                    <span>{item.email}</span>
                  </div>
                  <p className="feedback-message">{item.message}</p>
                  <div className="feedback-date">
                    {new Date(item.createdAt).toLocaleString()}
                  </div>
                </div>
              ))}
            </div>
          )}
          
          <button 
            onClick={fetchFeedback} 
            className="form-button refresh-button"
          >
            Refresh
          </button>
        </div>
      </div>
    </div>
  );
};

export default ViewFeedback;
