from typing import Dict, Any, List, Optional
from app.agents.bullying_agent import BullyingAgent
from app.agents.grooming_agent import GroomingAgent
from app.agents.emotion_agent import EmotionAgent
from app.agents.indic_agent import IndicAgent
from app.models.schemas import RiskAssessmentResult, AgentScoreDetail
from app.services.gemini_service import gemini_service
from app.config import settings

class SupervisorAgent:
    def __init__(self):
        self.bullying_agent = BullyingAgent()
        self.grooming_agent = GroomingAgent()
        self.emotion_agent = EmotionAgent()
        self.indic_agent = IndicAgent()

    def evaluate(self, text: str, context: Optional[Dict[str, Any]] = None) -> RiskAssessmentResult:
        """
        Executes parallel micro-agent evaluation or Google Gemini LLM reasoning,
        aggregates signals using supervisory logic, and produces an explainable 0-100 risk assessment.
        """
        # 1. Try Gemini LLM deep evaluation if GEMINI_API_KEY is configured
        gemini_result = gemini_service.evaluate(text, context)
        if gemini_result:
            breakdown_raw = gemini_result.get("agent_breakdown", {})
            converted_breakdown: Dict[str, AgentScoreDetail] = {}
            for k in ["bullying", "grooming", "emotion", "indic"]:
                detail = breakdown_raw.get(k, {})
                converted_breakdown[k] = AgentScoreDetail(
                    agent_name=detail.get("agent_name", f"{k.capitalize()} Agent"),
                    score=float(detail.get("score", 0.0)),
                    confidence=float(detail.get("confidence", 0.95)),
                    indicators=detail.get("indicators", [])
                )

            score = float(gemini_result.get("overall_risk_score", 0.0))
            return RiskAssessmentResult(
                overall_risk_score=score,
                severity=gemini_result.get("severity", "LOW"),
                category=gemini_result.get("category", "Benign Communication"),
                detected_reason=gemini_result.get("detected_reason", "No harmful linguistic or behavioral indicators detected."),
                recommended_action=gemini_result.get("recommended_action", "Normal: Safe digital environment."),
                agent_breakdown=converted_breakdown,
                alert_triggered=score >= settings.RISK_THRESHOLD_HIGH
            )

        # 2. Local Multi-Agent Evaluation (Fast, Deterministic, Offline-ready)
        res_bullying = self.bullying_agent.analyze(text, context)
        res_grooming = self.grooming_agent.analyze(text, context)
        res_emotion = self.emotion_agent.analyze(text, context)
        res_indic = self.indic_agent.analyze(text, context)

        agent_breakdown: Dict[str, AgentScoreDetail] = {
            "bullying": res_bullying,
            "grooming": res_grooming,
            "emotion": res_emotion,
            "indic": res_indic
        }

        # Weighted calculation
        weighted_score = (
            (res_grooming.score * 0.40) +
            (res_indic.score * 0.25) +
            (res_bullying.score * 0.20) +
            (res_emotion.score * 0.15)
        )

        # Peak hazard escalation: If any individual agent flags >= 70, overall risk must NOT be diluted!
        max_single_score = max(res_bullying.score, res_grooming.score, res_emotion.score, res_indic.score)
        if max_single_score >= 70.0:
            final_risk_score = max(weighted_score, max_single_score)
        else:
            final_risk_score = weighted_score

        final_risk_score = min(100.0, max(0.0, round(final_risk_score, 1)))

        # Determine Severity
        if final_risk_score >= settings.RISK_THRESHOLD_CRITICAL:
            severity = "CRITICAL"
        elif final_risk_score >= settings.RISK_THRESHOLD_HIGH:
            severity = "HIGH"
        elif final_risk_score >= settings.RISK_THRESHOLD_MEDIUM:
            severity = "MEDIUM"
        else:
            severity = "LOW"

        # Check specifically for direct violent physical/death threat
        is_violent_threat = any("violent physical/death threat" in ind for ind in res_bullying.indicators)

        # Determine Primary Category
        if is_violent_threat:
            primary_category = "Violent Threat & Intimidation"
        else:
            scores_by_cat = {
                "Grooming & Coercion": res_grooming.score,
                "Vernacular Extortion": res_indic.score,
                "Cyberbullying": res_bullying.score,
                "Emotional Distress": res_emotion.score,
            }
            primary_category = max(scores_by_cat, key=scores_by_cat.get)
            if final_risk_score == 0:
                primary_category = "Benign Communication"

        # Collect Explainable Reason Indicators
        all_indicators: List[str] = []
        for ag in agent_breakdown.values():
            all_indicators.extend(ag.indicators)

        if all_indicators:
            detected_reason = "; ".join(all_indicators[:4])
        else:
            detected_reason = "No harmful linguistic or behavioral indicators detected."

        # Recommended Action based on XAI
        if is_violent_threat:
            recommended_action = "CRITICAL SAFETY ALERT: Direct physical threat detected. Ensure child's physical safety immediately and report to authorities."
        elif severity in ["CRITICAL", "HIGH"]:
            if primary_category in ["Grooming & Coercion", "Vernacular Extortion"]:
                recommended_action = "Immediate Action: Check child's state gently. Do not delete messages—preserve digital evidence under POCSO/DPDP compliance."
            else:
                recommended_action = "Parent Review Advised: Have an empathetic talk with your child regarding online peer interactions."
        elif severity == "MEDIUM":
            recommended_action = "Monitor Trend: Mild risk indicators detected. Review activity logs in the dashboard."
        else:
            recommended_action = "Normal: Safe digital environment."

        alert_triggered = final_risk_score >= settings.RISK_THRESHOLD_HIGH

        return RiskAssessmentResult(
            overall_risk_score=final_risk_score,
            severity=severity,
            category=primary_category,
            detected_reason=detected_reason,
            recommended_action=recommended_action,
            agent_breakdown=agent_breakdown,
            alert_triggered=alert_triggered
        )
