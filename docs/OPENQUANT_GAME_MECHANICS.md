# OpenQuant game mechanics — discovery inventory

Observation date: 2026-10-30. Source for every entry: [OpenQuant Game Room](https://openquant.co/math-game), visited in an unsigned-in browser. This is an inventory, not a complete mechanics specification. The evidence label VERIFIED — DIRECT OBSERVATION below means the screen or instruction was observed; it does **not** mean the described behavior has been experimentally verified. No original code or artwork is copied into MindSprint.

## Shared navigation and access

- **VERIFIED — DIRECT OBSERVATION:** The page lists eight selectable game modes. Each selection shown below opened an in-page game screen without signing in; the URL remained `/math-game`. A Back control returns to the menu and Play Again is visible in each game screen.
- **VERIFIED — DIRECT OBSERVATION:** The site says sign-in is needed for leaderboard ranking and keeping high scores. We did not test whether any other feature requires an account. MindSprint's records will be local by requirement.
- **UNVERIFIED:** Complete gameplay, questions, inputs, transitions, edge cases, result screens and scoring behavior for all eight. Initial visible labels/instructions below are not proof of implementation behavior.

## Arithmetic

- **VERIFIED — DIRECT OBSERVATION:** Menu label “Arithmetic Game”; selection opens a screen showing 0 points, a timer initially displaying 120 seconds, a visible 3 during entry, Back and Play Again. No rules text was visible in the initial screen.
- **UNVERIFIED:** Objective details, operation and number distributions, answer input, timing semantics, scoring, progression, penalties and end conditions. Investigate in milestone 3.

## Arithmetic Pro

- **VERIFIED — DIRECT OBSERVATION:** Menu label “Arithmetic Pro”; selection shows 0 points, initially 120 seconds, a visible 3 during entry, Back and Play Again. No initial rules text was visible.
- **UNVERIFIED:** Game-specific generation, answer formats, timer semantics, scoring, penalties and progression. Do not assume it is only harder Arithmetic. Investigate in milestone 3.

## Sequence

- **VERIFIED — DIRECT OBSERVATION:** Menu label “Sequence Game”; selection shows 0 points, initially 120 seconds, a visible 3 during entry, Back and Play Again. No initial rules text was visible.
- **UNVERIFIED:** Patterns, answer format, timing semantics, scoring, ambiguity and progression. Investigate in milestone 4.

## Optiver 80 in 8

- **VERIFIED — DIRECT OBSERVATION:** Selection shows 0 points, initially 480 seconds, a visible 3 during entry, Back and Play Again. No initial rules text was visible.
- **UNVERIFIED:** Question count and types, input, timing semantics, scoring, stopping rules and progression. Do not infer these from the name. Investigate in milestone 4.

## Memory

- **VERIFIED — DIRECT OBSERVATION:** Initial screen shows Round 1 / 3, 0 points and Start Round. Its instruction says to enter presented digits in sequence and offers one additional attempt after an incorrect answer.
- **UNVERIFIED:** The instruction's actual implementation, stimulus timings, later rounds, input controls, scoring and end conditions. Investigate in milestone 5.

## Risk

- **VERIFIED — DIRECT OBSERVATION:** Initial screen shows Round 1 of 20 and Start Round. Its rules describe colored balloons with different pop probabilities; pumping earns one point per pump, collecting banks round earnings, and a pop forfeits that round's earnings.
- **UNVERIFIED:** Actual controls, probabilities, distributions, transition behavior, timing and total scoring. Investigate in milestone 5.

## Flexibility

- **VERIFIED — DIRECT OBSERVATION:** Initial screen displays 60 seconds and Start Game. Its rules ask whether the left card's meaning matches the right card's text color, with right/left arrows for equal/not equal and stated +1/−1 scoring.
- **UNVERIFIED:** Actual stimulus generation, display colors, touch input, timer behavior, scoring and progression. Investigate in milestone 6.

## Letter Speed

- **VERIFIED — DIRECT OBSERVATION:** Initial screen shows Round 1 of 10 and Start Game. Its rules describe choosing the highest- or lowest-valued option among four within 30 seconds. Row values are described as absolute differences of alphabet positions for paired letters or the position of a single letter; correct answers are said to earn remaining seconds as points.
- **UNVERIFIED:** Actual letter distributions, tie handling, prompt selection, incorrect and timeout behavior, rounding and progression. Investigate in milestone 6.

## Repeatable investigation method

For each assigned pair in milestones 3–6: start unsigned-in; record date, URL, screen state, on-screen instructions and whether access is restricted. Play multiple sessions when possible, recording prompts, inputs, correct and incorrect feedback, score changes, clock readings, and end conditions; compare repeated samples rather than generalizing from one example. Note backgrounding, invalid inputs and edge cases when feasible. Distinguish displayed rules from behavior observed in play and from public implementation evidence. Record source references and exact uncertainty, not unsupported claims. Where publicly delivered implementation can be inspected legitimately, use it as evidence without copying proprietary code or bypassing access controls. Stop if authentication or anti-bot restrictions prevent access; request user-provided recordings or sources only if necessary. Generate independent code later.
