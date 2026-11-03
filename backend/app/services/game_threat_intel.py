from typing import List, Dict, Any

# Threat Intelligence Database of Suspicious Games & Apps Based on Verified News History
THREAT_INTELLIGENCE_CATALOG: List[Dict[str, Any]] = [
    {
        "id": "game-blue-whale",
        "name": "Blue Whale Challenge / Curator APKs",
        "aliases": ["blue whale", "curator", "f57", "silent house", "sea of whales"],
        "package_signatures": ["com.bluewhale", "com.curator", "com.f57", "org.bluewhale"],
        "risk_score": 100.0,
        "severity": "CRITICAL",
        "threat_type": "Self-Harm & Minor Suicide Challenge",
        "news_headline": "Mumbai & Indore Police Cyber Advisories (2017–2021): Fatal 50-day self-harm tasks targeting minors.",
        "news_history": "Notorious social challenge responsible for multiple minor deaths across India (Mumbai, Indore, Assam) and globally. Adult curators isolate children, tasking them with escalating self-harm, sleep deprivation, and fatal final instructions under blackmail.",
        "recommended_action": "🚨 CRITICAL: Immediately remove app, seek physical guardian intervention, and contact Cyber Cell / 1930.",
        "regulatory_tags": ["POCSO Act Sec 11/12", "IPC 306 / BNS 108", "IT Act Sec 67B"]
    },
    {
        "id": "game-free-fire",
        "name": "Free Fire / Free Fire MAX",
        "aliases": ["free fire", "freefire", "free fire max"],
        "package_signatures": ["com.dts.freefireth", "com.dts.freefiremax"],
        "risk_score": 85.0,
        "severity": "CRITICAL",
        "threat_type": "Minor Financial Fraud & Lethal Addiction",
        "news_headline": "National Media & NCRB Reports: 40+ Indian minors drained parents' life savings (₹1.2L–₹40L) leading to suicides.",
        "news_history": "Extensive news cases across Madhya Pradesh, Maharashtra (Nagpur/Pune), UP, and Gujarat: Minors stole parents' credit cards/UPI to buy diamonds & weapon skins. Multiple tragic minor suicides occurred after parents discovered unauthorized bank debits. Contains aggressive predatory gambling gacha loops.",
        "recommended_action": "Enforce strict in-app purchase freeze, Google Play biometric passwords, and limit screen time to 45 mins.",
        "regulatory_tags": ["DPDP Act 2023 Sec 9 (Dark Patterns)", "NCPCR Advisory 2022"]
    },
    {
        "id": "game-roblox",
        "name": "Roblox",
        "aliases": ["roblox", "roblox mobile"],
        "package_signatures": ["com.roblox.client"],
        "risk_score": 82.0,
        "severity": "HIGH",
        "threat_type": "Online Predator Grooming & Virtual Coercion",
        "news_headline": "CERT-In & US NCMEC Advisories (2023–2025): Predators luring children into unmonitored private voice channels.",
        "news_history": "Global investigations revealed predators using user-created Roblox experiences ('condo games') to initiate contact with minors under age 13, transferring them to encrypted Discord servers to request private photos and gift card extortion.",
        "recommended_action": "Enable Account Restrictions in Roblox Settings, disable in-game chat for under-16, and monitor connected Discord accounts.",
        "regulatory_tags": ["POCSO Act Sec 11", "DPDP Act 2023 Sec 9"]
    },
    {
        "id": "game-bgmi",
        "name": "BGMI / PUBG Mobile",
        "aliases": ["bgmi", "pubg", "battlegrounds mobile india", "pubg mobile"],
        "package_signatures": ["com.pubg.imobile", "com.tencent.ig", "com.pubg.krmobile"],
        "risk_score": 75.0,
        "severity": "HIGH",
        "threat_type": "Severe Addiction, Aggression & Stranger Voice Chat",
        "news_headline": "Banned under Sec 69A IT Act (2020), reinstated under probation: Linked to violent behavioral shifts.",
        "news_history": "State police advisories in Lucknow and Mumbai documented cases of extreme psychological withdrawal, domestic conflict, and minors communicating with adult strangers over unfiltered real-time voice chat during late-night matches.",
        "recommended_action": "Set daily playtime limit of 1 hour, restrict voice chat to known school friends, and turn off night access.",
        "regulatory_tags": ["IT Act Sec 69A", "NCPCR Gaming Guidelines"]
    },
    {
        "id": "game-teen-patti-rummy",
        "name": "Underage Real-Money Gambling & Betting Apps",
        "aliases": ["teen patti", "junglee rummy", "rummy circle", "winzo", "dream11", "zupee", "mpl", "stake"],
        "package_signatures": ["com.teenpatti", "com.jungleerummy", "com.winzo", "com.dream11.app", "com.zupee", "com.rummycircle"],
        "risk_score": 92.0,
        "severity": "CRITICAL",
        "threat_type": "Illegal Underage Gambling & UPI Drainage",
        "news_headline": "ED & State Police Crackdowns: Dark pattern algorithms targeting teenagers into quick-money debt loops.",
        "news_history": "Numerous news reports across India highlighting school-going teenagers losing tens of thousands of rupees borrowed from parents' Paytm/Google Pay accounts on simulated card gambling and fantasy betting apps.",
        "recommended_action": "🚨 Uninstall immediately. Minors under 18 are legally prohibited from real-money wagering apps in India.",
        "regulatory_tags": ["Public Gambling Act", "IT Rules 2021 (Online Gaming Amendment)"]
    },
    {
        "id": "game-momo-challenge",
        "name": "Momo Challenge / Suicide Dare Clones",
        "aliases": ["momo", "momo challenge", "creepy momo"],
        "package_signatures": ["com.momo", "com.momo.challenge"],
        "risk_score": 96.0,
        "severity": "CRITICAL",
        "threat_type": "Viral Coercive Self-Harm & Extortion",
        "news_headline": "Ministry of Electronics and IT (MeitY) Advisory: Gruesome extortion game targeting young children.",
        "news_history": "MeitY and police issued national alerts warning parents against this viral phenomenon where an grotesque avatar blackmails minors with exposed personal data if they refuse to perform self-destructive acts.",
        "recommended_action": "🚨 Uninstall immediately, report sender number to National Cyber Crime Portal (cybercrime.gov.in).",
        "regulatory_tags": ["POCSO Act Sec 11", "IT Act Sec 67B"]
    },
    {
        "id": "game-happymod-sideload",
        "name": "Trojanized Modded Game APKs & Unofficial Stores",
        "aliases": ["happymod", "lucky patcher", "apkvpn", "modded minecraft", "free gems apk"],
        "package_signatures": ["com.happymod", "com.forpda", "com.chelpus.luckypatcher"],
        "risk_score": 88.0,
        "severity": "CRITICAL",
        "threat_type": "Trojanized Spyware & Camera/SMS Hijacking",
        "news_headline": "CERT-In Cyber Advisory CIAD-2024: Fake game cheat APKs bundling banking trojans and spy tools.",
        "news_history": "Children searching for 'free in-game coins' or 'hacked games' download sideloaded APKs from untrusted sites. News reports showed these apps embed RATs (Remote Access Trojans) that intercept two-factor SMS OTPs and access phone cameras.",
        "recommended_action": "Disable 'Install Unknown Apps' permission in Android Settings and run antivirus scan.",
        "regulatory_tags": ["IT Act Sec 43/66", "CERT-In Advisory 2024"]
    }
]

class GameThreatIntelService:

    def get_catalog(self) -> List[Dict[str, Any]]:
        return THREAT_INTELLIGENCE_CATALOG

    def scan_apps(self, installed_apps: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Scans a list of installed apps/packages from the child device against the threat intelligence database.
        """
        flagged_games: List[Dict[str, Any]] = []
        highest_score: float = 0.0

        for app in installed_apps:
            raw_name = str(app.get("app_name", "")).strip().lower()
            raw_pkg = str(app.get("package_name", "")).strip().lower()

            matched_threat = None

            for threat in THREAT_INTELLIGENCE_CATALOG:
                # Check package signatures
                for sig in threat["package_signatures"]:
                    if sig.lower() in raw_pkg:
                        matched_threat = threat
                        break
                if matched_threat:
                    break

                # Check aliases
                for alias in threat["aliases"]:
                    if alias.lower() in raw_name or alias.lower() in raw_pkg:
                        matched_threat = threat
                        break
                if matched_threat:
                    break

            # Keyword heuristics for gambling / dangerous apps
            if not matched_threat:
                gambling_cues = ["teen patti", "rummy", "poker", "casino", "satta", "betting", "winzo", "gambling"]
                for cue in gambling_cues:
                    if cue in raw_name or cue in raw_pkg:
                        matched_threat = {
                            "id": f"heuristic-gamble-{cue}",
                            "name": app.get("app_name", "Unknown Gambling App"),
                            "risk_score": 90.0,
                            "severity": "CRITICAL",
                            "threat_type": "Suspected Underage Gambling & Dark Pattern Betting",
                            "news_headline": "Enforcement Directorate Warning: Real-money gambling apps targeting youth with financial entrapment.",
                            "news_history": "Matches real-money betting and card gambling indicators. Indian law forbids minors from participating in online wagering activities.",
                            "recommended_action": "Uninstall immediately and check linked UPI payment histories.",
                            "regulatory_tags": ["Public Gambling Act", "IT Rules 2021"]
                        }
                        break

            if matched_threat:
                score = matched_threat["risk_score"]
                highest_score = max(highest_score, score)
                flagged_games.append({
                    "app_name": app.get("app_name", matched_threat["name"]),
                    "package_name": app.get("package_name", ""),
                    "is_installed": True,
                    "threat_info": matched_threat
                })

        overall_game_risk = highest_score if flagged_games else 0.0

        return {
            "total_scanned": len(installed_apps),
            "flagged_count": len(flagged_games),
            "overall_game_risk_score": overall_game_risk,
            "status": "CRITICAL" if overall_game_risk >= 85 else ("HIGH" if overall_game_risk >= 70 else ("WARNING" if overall_game_risk > 0 else "CLEAN")),
            "flagged_games": flagged_games,
            "threat_catalog_size": len(THREAT_INTELLIGENCE_CATALOG)
        }

game_intel_service = GameThreatIntelService()
