import React from "react";
import dishes from "../data/dishes";
import DishCard from "../components/DishCard";
import "./Dashboard.css";

export default function Dashboard() {
  return (
    <div className="dashboard">
      <h1>What’s Cooking Today?</h1>
      <p className="subtitle">Click on a dish to view its recipe</p>

      <div className="dish-grid">
        {dishes.map((dish) => (
          <DishCard key={dish.id} dish={dish} />
        ))}
      </div>
    </div>
  );
}
