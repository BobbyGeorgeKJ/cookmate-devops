import React from "react";
import { useParams, useNavigate } from "react-router-dom";
import dishes from "../data/dishes";
import "./RecipePage.css";

export default function RecipePage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const dish = dishes.find((d) => d.id === Number(id));

  if (!dish) return <div>Recipe not found</div>;

  return (
    <div className="recipe">
      <button className="back-btn" onClick={() => navigate(-1)}>← Back</button>
      <img src={dish.image} alt={dish.name} className="recipe-image" />
      <h2>{dish.name}</h2>
      <p className="tagline">{dish.tagline}</p>

      <h3>Ingredients</h3>
      <ul>
        {dish.ingredients.map((ing, i) => (
          <li key={i}>{ing}</li>
        ))}
      </ul>

      <h3>Steps</h3>
      <ol>
        {dish.steps.map((s, i) => (
          <li key={i}>{s}</li>
        ))}
      </ol>
    </div>
  );
}
