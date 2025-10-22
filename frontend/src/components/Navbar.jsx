import React from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";

const Navbar = () => {
  return (
    <nav className="navbar">
      <ul className="navbar-list">
        <li>
          <Link to="/" className="navbar-link">
            Home
          </Link>
        </li>
        <li>
          <Link to="/domains" className="navbar-link">
            Domains
          </Link>
        </li>
        <li>
          <Link to="/feedback" className="navbar-link">
            Feedback
          </Link>
        </li>
        {/* <li>
          <Link to="/view-feedback" className="navbar-link">
            View Feedback
          </Link>
        </li> */}
        <li>
          <Link to="/contribute" className="navbar-link">
            Contribute
          </Link>
        </li>
      </ul>
    </nav>
  );
};

export default Navbar;
