const DANGER_KEYWORDS = {
  high: [
    "Chest pain", 
    "unconscious", 
    "heavy bleeding", 
    "cannot breathe", 
    "emergency", 
    "accident", 
    "head injury", 
    "severe injury", 
    "breathing problem",
    "chest tightness"
  ],
  medium: [
    "High fever", 
    "persistent cough", 
    "vomiting", 
    "dizziness", 
    "fever", 
    "stomach ache", 
    "diarrhea", 
    "joint pain", 
    "cough", 
    "rash", 
    "allergy", 
    "shivering", 
    "body pain"
  ]
};

const WEIGHTS = {
  high: 10,
  medium: 5
};

const THRESHOLD = 10; // If total weight >= 10, it's an Emergency. 5-9 is Moderate. < 5 is Mild.

function calculateSeverity(symptoms) {
  let score = 0;
  const lowerSymptoms = symptoms.toLowerCase();
  
  DANGER_KEYWORDS.high.forEach(kw => {
    if (lowerSymptoms.includes(kw.toLowerCase())) {
      score += WEIGHTS.high;
    }
  });

  DANGER_KEYWORDS.medium.forEach(kw => {
    if (lowerSymptoms.includes(kw.toLowerCase())) {
      score += WEIGHTS.medium;
    }
  });

  if (score >= THRESHOLD) {
    return 'Emergency';
  } else if (score >= 5) {
    return 'Moderate';
  } else {
    return 'Mild';
  }
}

module.exports = { calculateSeverity };
