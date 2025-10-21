import React, { useState, useEffect } from "react";
import axios from "axios";

function App() {
  const [recipes, setRecipes] = useState([]);
  const [file, setFile] = useState(null);
  const [suggestion, setSuggestion] = useState(null);

  // Fetch recipes when page loads
  useEffect(() => {
    axios.get("/api/recipes")
      .then(res => setRecipes(res.data))
      .catch(() => setRecipes([]));
  }, []);

  const handleUpload = async (e) => {
    e.preventDefault();
    if (!file) return;
    const fd = new FormData();
    fd.append("file", file);
    const res = await axios.post("/api/suggest", fd, {
      headers: { "Content-Type": "multipart/form-data" }
    });
    setSuggestion(res.data);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>CookMate (Prototype)</h1>
      <h2>Recipes</h2>
      <ul>
        {recipes.map(r => <li key={r.id}>{r.name}</li>)}
      </ul>

      <h2>Suggest Dish (Upload an image)</h2>
      <form onSubmit={handleUpload}>
        <input type="file" onChange={e => setFile(e.target.files[0])} />
        <button type="submit">Suggest</button>
      </form>

      {suggestion && (
        <pre>{JSON.stringify(suggestion, null, 2)}</pre>
      )}
    </div>
  );
}

export default App;
