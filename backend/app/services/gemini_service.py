import os
import json
import logging
from typing import Dict, Any, Optional
import httpx
from app.config import settings

logger = logging.getLogger("gemini_service")

class GeminiThreatEvaluationService:
    def __init__(self):
        self.api_key = settings.GEMINI_API_KEY or os.getenv("GEMINI_API_KEY", "")
        self.model = settings.GEMINI_MODEL or "gemini-2.0-flash"

    def set_api_key(self, key: str):
        self.api_key = key.strip()
        settings.GEMINI_API_KEY = self.api_key

    def has_api_key(self) -> bool:
        return bool(self.api_key and len(self.api_key) > 10)

    def evaluate(self, text: str, context: Optional[Dict[str, Any]] = None) -> Optional[Dict[str, Any]]:
        """
        Uses Google Gemini LLM to semantically evaluate any complex, disguised, or violent text for child harm.
        Returns a structured RiskAssessmentResult dict, or None if key is missing or request fails.
        """
        if not self.has_api_key():
            return None

        prompt = f"""You are the Multi-Agent Safety Engine of Rakshan AI (Child Cyber Safety Platform for Indian Minors).
Evaluate the following incoming message/notification sent to a minor:

Text: "{text}"
Context: {json.dumps(context or {})}

Analyze for:
1. Violent physical/death threats (e.g. "I am killing you", "mar dalunga", "beat you up") -> 90-100 CRITICAL
2. Predatory grooming & coercion (secrecy "don't tell mom", requesting private selfies/nudes) -> 90-100 CRITICAL
3. Vernacular/Hinglish blackmail & extortion ("viral kar dunga", demanding UPI money) -> 90-100 CRITICAL
4. Cyberbullying & slurs ("loser", "nobody likes you", "go die") -> 70-85 HIGH
5. Benign/safe everyday communication -> 0-15 LOW

Return ONLY a raw JSON object (no markdown, no backticks, no extra text) with exact schema:
{{
  "overall_risk_score": <float 0 to 100>,
  "severity": "<CRITICAL|HIGH|MEDIUM|LOW>",
  "category": "<Grooming & Coercion|Cyberbullying|Violent Threat|Vernacular Extortion|Benign Communication>",
  "detected_reason": "<1-2 concise sentence explanation of the specific cue detected>",
  "recommended_action": "<actionable parental/statutory advice under POCSO or DPDP>",
  "agent_breakdown": {{
    "bullying": {{"score": <float 0-100>, "confidence": <float 0-1>, "indicators": ["<string>"]}},
    "grooming": {{"score": <float 0-100>, "confidence": <float 0-1>, "indicators": ["<string>"]}},
    "indic": {{"score": <float 0-100>, "confidence": <float 0-1>, "indicators": ["<string>"]}},
    "emotion": {{"score": <float 0-100>, "confidence": <float 0-1>, "indicators": ["<string>"]}}
  }}
}}"""

        url = f"https://generativelanguage.googleapis.com/v1beta/models/{self.model}:generateContent?key={self.api_key}"

        try:
            with httpx.Client(timeout=6.0) as client:
                resp = client.post(
                    url,
                    headers={"Content-Type": "application/json"},
                    json={
                        "contents": [{"parts": [{"text": prompt}]}],
                        "generationConfig": {"temperature": 0.1, "maxOutputTokens": 600}
                    }
                )

                if resp.status_code == 200:
                    data = resp.json()
                    candidates = data.get("candidates", [])
                    if candidates:
                        raw_text = candidates[0].get("content", {}).get("parts", [{}])[0].get("text", "").strip()
                        # Clean markdown json formatting if any
                        if raw_text.startswith("```json"):
                            raw_text = raw_text[7:]
                        if raw_text.startswith("```"):
                            raw_text = raw_text[3:]
                        if raw_text.endswith("```"):
                            raw_text = raw_text[:-3]
                        raw_text = raw_text.strip()

                        parsed = json.loads(raw_text)
                        logger.info(f"Gemini successfully scored '{text[:30]}...' -> {parsed.get('overall_risk_score')}")
                        return parsed
                else:
                    logger.warning(f"Gemini API returned status {resp.status_code}: {resp.text}")
        except Exception as e:
            logger.warning(f"Gemini evaluation failed: {e}")

        return None

gemini_service = GeminiThreatEvaluationService()

