import re
from typing import Dict, Any, List
from app.agents.base_agent import BaseSafetyAgent
from app.models.schemas import AgentScoreDetail

class BullyingAgent(BaseSafetyAgent):
    def __init__(self):
        super().__init__(name="Bullying & Harassment Agent")

        # Direct violent & lethal physical threats
        self.violent_threats = [
            "killing you", "kill you", "will kill you", "gonna kill you", "going to kill you",
            "murder you", "beat you", "beat the shit", "break your face", "cut you", "stab you",
            "shoot you", "destroy you", "hurt you", "hunt you down", "watch your back",
            "mar dalunga", "jaan se mar", "thok dunga", "marunga", "chhodunga nahi", "pitunga",
            "blood", "slit", "dead", "i will kill", "i am killing"
        ]

        # High impact bullying & self-harm cues
        self.severe_keywords = [
            "kill yourself", "die", "go die", "nobody likes you", "loser",
            "ugly", "worthless", "freak", "stupid idiot", "delete your account",
            "everyone hates you", "fat pig", "disgusting", "kill urself", "suicide"
        ]

        # Moderate bullying & harassment patterns
        self.moderate_keywords = [
            "shut up", "idiot", "dumb", "clown", "fake", "get lost",
            "stop talking", "embarrassing", "annoying", "pathetic", "creep", "fool"
        ]

    def analyze(self, text: str, context: Dict[str, Any] = None) -> AgentScoreDetail:
        lower_text = text.lower()
        matched_indicators: List[str] = []
        score = 0.0

        # Check violent physical/death threats first (Highest Severity!)
        for pattern in self.violent_threats:
            if re.search(r"\b" + re.escape(pattern) + r"\b", lower_text) or pattern in lower_text:
                matched_indicators.append(f"Direct violent physical/death threat: '{pattern}'")
                score += 90.0
                break

        # Check severe patterns
        for pattern in self.severe_keywords:
            if re.search(r"\b" + re.escape(pattern) + r"\b", lower_text):
                matched_indicators.append(f"Severe harassment/harm cue: '{pattern}'")
                score += 45.0

        # Check moderate patterns
        for pattern in self.moderate_keywords:
            if re.search(r"\b" + re.escape(pattern) + r"\b", lower_text):
                matched_indicators.append(f"Degrading insult: '{pattern}'")
                score += 18.0

        # Check aggressive typography (ALL CAPS and exclamation flood)
        if len(text) > 8 and text.isupper():
            score += 15.0
            matched_indicators.append("Aggressive tone: ALL CAPS speech")

        if "!!!" in text or "????" in text:
            score += 10.0
            matched_indicators.append("Hostile punctuation repetition")

        final_score = min(100.0, score)
        confidence = 0.95 if any("violent" in i for i in matched_indicators) else (0.90 if matched_indicators else 0.40)

        return AgentScoreDetail(
            agent_name=self.name,
            score=round(final_score, 1),
            confidence=confidence,
            indicators=matched_indicators
        )
