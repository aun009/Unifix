import React, { useState, useEffect } from "react";
import "./Home.css";
import Loader from "../components/Loader";

export default function Home() {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Simulate a loading delay
    const timer = setTimeout(() => setLoading(false), 3000); // Adjust the time as needed
    return () => clearTimeout(timer);
  }, []);

  if (loading) {
    return <Loader />;
  }

  return (
    <div className="container">
      {/* Animated blobs */}
      <div className="blobs">
        <div className="blob a">a</div>
        <div className="blob b">b</div>
        <div className="blob c">c</div>
      </div>

      {/* Glass morphism card (centered on top of blobs) */}
      <div
        style={{
          position: "absolute",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          width: "90%",
          maxWidth: "800px",
          minHeight: "400px",
          background: "rgba(255, 255, 255, 0.15)",
          borderRadius: "15px",
          boxShadow: "0 8px 32px 0 rgba(31, 38, 135, 0.37)",
          backdropFilter: "blur(4px)",
          WebkitBackdropFilter: "blur(4px)",
          border: "1px solid rgba(255, 255, 255, 0.18)",
          padding: "2rem",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        <h1 style={{ fontSize: "8rem", color: "#fff", fontFamily: "'Poppins', sans-serif" }}>
          UniFix
        </h1>
        <p style={{ fontSize: "1.5rem", color: "#fff", fontFamily: "'Roboto', sans-serif", marginTop: "1rem" }}>
          The one-stop solution for all your Linux-Issues
        </p>
      </div>
    </div>
  );
}
