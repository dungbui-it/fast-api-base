from fastapi import FastAPI
from mangum import Mangum

app = FastAPI()

@app.get("/", response_model=str)
def read_root():
    return "Hello, World!"

@app.get("/health-check", response_model=str)
def health_check():
    return "OK"

handler = Mangum(app)
