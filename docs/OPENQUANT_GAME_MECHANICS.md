# OpenQuant game mechanics — discovery inventory

Observation date: 2026-10-30. Source for every entry: [OpenQuant Game Room](https://openquant.co/math-game), visited in an unsigned-in browser. This is an inventory, not a complete mechanics specification. The evidence label VERIFIED — DIRECT OBSERVATION below means the screen or instruction was observed; it does **not** mean the described behavior has been experimentally verified. No original code or artwork is copied into MindSprint.

## Shared navigation and access

- **VERIFIED — DIRECT OBSERVATION:** The page lists eight selectable game modes. Each selection shown below opened an in-page game screen without signing in; the URL remained `/math-game`. A Back control returns to the menu and Play Again is visible in each game screen.
- **VERIFIED — DIRECT OBSERVATION:** The site says sign-in is needed for leaderboard ranking and keeping high scores. We did not test whether any other feature requires an account. MindSprint's records will be local by requirement.
- **UNVERIFIED:** Complete gameplay, questions, inputs, transitions, edge cases, result screens and scoring behavior for all eight. Initial visible labels/instructions below are not proof of implementation behavior.

## Arithmetic

Observations on 2026-10-30, unsigned-in at the shared source above. Two sessions sampled; first was allowed to expire. These are examples, not established generation bounds.

- **VERIFIED — DIRECT OBSERVATION:** Starting/replaying shows a countdown including 3, then a question and focused numeric input; timer starts at 120 seconds and counts down. Play Again resets the observed score to 0 and timer to 120.
- **VERIFIED — DIRECT OBSERVATION:** Sampled `230 / 5 = 46`, `96 + 98 = 194`, `9 * 92 = 828`, `67 + 7 = 74`, `10 - 4 = 6`, `539 / 7 = 77`, `78 - 97 = -19`, `30 - 43 = -13`. Answers were accepted, score increased by one per answer, input cleared and a new question appeared without Enter. Thus addition, subtraction, multiplication, exact division and negative answers occur in these samples; this does not establish distributions or limits.
- **VERIFIED — DIRECT OBSERVATION:** With `96 + 98` active, typing `999` and pressing Enter did not change the question or score. Replacing it with `194` immediately advanced and increased score. No separate incorrect count or penalty was visible in that case. Do not infer behavior for all malformed entries.
- **VERIFIED — DIRECT OBSERVATION:** At 0 seconds, the first run displayed “You Scored” with 5 points and “Your Last Question” showing the unsolved `16 + 96 = 112`, together with Play Again and Back. The timer display offers a hide control; its behavior was not tested.
- **UNVERIFIED:** Exact random generator, operator weights, complete number and answer ranges, adaptive difficulty, leading zeros, decimals, zero, overflow, exact matching rules, timer accuracy or background handling, rapid input/expiry races, skips, and whether incorrect entries have hidden consequences. No complete rule has been established from the limited samples.

## Arithmetic Pro

Observations on 2026-10-30, unsigned-in at the shared source above. Two sessions sampled; first was allowed to expire.

- **VERIFIED — DIRECT OBSERVATION:** Selection and Play Again start with score 0, a visible countdown, and a timer initially showing 120 seconds; a focused numeric input is provided. Correct answers immediately advance and add one point in the tested cases.
- **VERIFIED — DIRECT OBSERVATION:** Sampled accepted expressions include `2 * (16 + 3) = 38`, `(12 + 1) * (5 + 3) = 104`, `(6 - 2) * (7 + 2) + 3 = 39`, `(30 + 5) * 5 = 175`, `2 + 9 * (14 - 6) = 74`, `(85 + 7) * 5 = 460`, `2 * (104 + 1) = 210`, `5 + 7 * 4 = 33`, and replay `10 + 9 * 2 = 28`. These illustrate compound expressions and normal multiplication precedence, not a complete grammar or distribution.
- **VERIFIED — DIRECT OBSERVATION:** Entering `999` and pressing Enter for `(12 + 1) * (5 + 3)` did not change the score or question; replacing it with `104` advanced. At 0 seconds the results showed 8 points and the last unanswered question `5 * (39 + 1) = 200`, plus Play Again and Back.
- **UNVERIFIED:** Full expression templates, operand ranges and distributions, division, negative or decimal results, input edge cases, scoring beyond samples, adaptive progression, precise countdown and background semantics, simultaneous input and expiry behavior. Further research is needed; Pro cannot be treated as simply larger arithmetic.

### Research limitations and next pass

Public page assets were identified, but the web inspection tool could not access the page's JavaScript bundle. No access control was bypassed. More direct sessions and, where legitimately accessible, inspection of publicly delivered assets are needed to determine generators and edge cases. Treat unresolved behavior as unverified rather than exact Classic Mode rules.

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

