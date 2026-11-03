import uvicorn
import os
import sys

try:
    if getattr(sys.stdout, "encoding", None) and sys.stdout.encoding.lower() != "utf-8":
        sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    print(f"🚀 Starting Rakshan AI Core Backend Server on http://0.0.0.0:{port}")
    print(f"📖 Swagger Interactive API Docs available at http://localhost:{port}/docs")
    uvicorn.run("app.main:app", host="0.0.0.0", port=port, reload=True)
