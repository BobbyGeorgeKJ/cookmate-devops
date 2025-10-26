import React from "react";
import { Link } from "react-router-dom";
import "./Navbar.css";

export default function Navbar() {
  return (
    <nav className="navbar">
      <div className="navbar-content">
        <div className="logo">🍳 CookMate</div>
        <div className="links">
          <Link to="/">Home</Link>
        </div>
      </div>
    </nav>
  );
}
