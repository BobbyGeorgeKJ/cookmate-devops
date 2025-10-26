import React from "react";
import { useNavigate } from "react-router-dom";
import "./DishCard.css";

export default function DishCard({ dish }) {
  const navigate = useNavigate();

  return (
    <div className="dish-card" onClick={() => navigate(`/recipe/${dish.id}`)}>
      <img src={dish.image} alt={dish.name} className="dish-image" />
      <div className="dish-info">
        <h3>{dish.name}</h3>
        <p>{dish.tagline}</p>
      </div>
    </div>
  );
}
