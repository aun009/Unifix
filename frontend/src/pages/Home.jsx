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
      <div className="home-card">
        <h1 className="home-title">UniFix</h1>
        <p className="home-subtitle">
          The one-stop solution for all your Linux-Issues
        </p>
      </div>
    </div>
  );
}

