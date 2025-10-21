from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse

app = FastAPI()

recipes = [
    {"id": 1, "name": "Pasta", "ingredients": ["pasta", "tomato", "garlic"]},
    {"id": 2, "name": "Fried Rice", "ingredients": ["rice", "vegetables", "soy sauce"]},
    {"id": 3, "name": "Paneer Curry", "ingredients": ["paneer", "onion", "spices"]}
]

@app.get("/")
def root():
    return {"message": "Welcome to CookMate API prototype!"}

@app.get("/recipes")
def get_recipes():
    return recipes

@app.post("/suggest")
async def suggest_dish(file: UploadFile = File(...)):
    # Mock logic – we’re not doing image analysis here yet
    return JSONResponse({
        "suggested_dish": "Pasta",
        "confidence": "0.72"
    })
