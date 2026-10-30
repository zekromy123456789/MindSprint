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
- **VERIFIED — DIRECT OBSERVATION (additional session):** `66 * 8 = 528` did not advance for `0528` despite the field reporting numeric value 528; `528` advanced. For `85 + 3 = 88`, pasted `88.0` did not advance, while `88` did. Hiding the timer and revealing it later showed a lower remaining time; hiding did not pause that sampled session. These observations suggest string-sensitive matching, but the general matching algorithm is unverified.
- **UNVERIFIED:** Exact random generator, operator weights, complete number and answer ranges, adaptive difficulty, leading zeros, decimals, zero, overflow, exact matching rules, timer accuracy or background handling, rapid input/expiry races, skips, and whether incorrect entries have hidden consequences. No complete rule has been established from the limited samples.

## Arithmetic Pro

Observations on 2026-10-30, unsigned-in at the shared source above. Two sessions sampled; first was allowed to expire.

- **VERIFIED — DIRECT OBSERVATION:** Selection and Play Again start with score 0, a visible countdown, and a timer initially showing 120 seconds; a focused numeric input is provided. Correct answers immediately advance and add one point in the tested cases.
- **VERIFIED — DIRECT OBSERVATION:** Sampled accepted expressions include `2 * (16 + 3) = 38`, `(12 + 1) * (5 + 3) = 104`, `(6 - 2) * (7 + 2) + 3 = 39`, `(30 + 5) * 5 = 175`, `2 + 9 * (14 - 6) = 74`, `(85 + 7) * 5 = 460`, `2 * (104 + 1) = 210`, `5 + 7 * 4 = 33`, and replay `10 + 9 * 2 = 28`. These illustrate compound expressions and normal multiplication precedence, not a complete grammar or distribution.
- **VERIFIED — DIRECT OBSERVATION:** Entering `999` and pressing Enter for `(12 + 1) * (5 + 3)` did not change the score or question; replacing it with `104` advanced. At 0 seconds the results showed 8 points and the last unanswered question `5 * (39 + 1) = 200`, plus Play Again and Back.
- **VERIFIED — DIRECT OBSERVATION (additional session):** `(8 * 3) + 6 + 1 = 31` did not advance for `031` or pasted `31.0`, but accepted `31`. The next expression `16 - (4 + 3) * (14 + 1) = -89` accepted `-89` and increased the score. These samples suggest string-sensitive matching, without proving the full algorithm.
- **UNVERIFIED:** Full expression templates, operand ranges and distributions, division, negative or decimal results, input edge cases, scoring beyond samples, adaptive progression, precise countdown and background semantics, simultaneous input and expiry behavior. Further research is needed; Pro cannot be treated as simply larger arithmetic.

### Public implementation analysis — 2026-10-30

Source: user-supplied publicly delivered `math-game-3c79ba5d0d428fde.js`, SHA-256 `1a4b0c3c95ffb3bc6cdcd9de393a1cefe52530969185646be86d33850a919b51`. Its contents are not included in this repository; retain this fingerprint for matching the user's copy. The statements below describe this specific build, not necessarily later site versions. Independently implement behavior; do not copy source or the question list.

**Arithmetic — VERIFIED — PUBLIC IMPLEMENTATION:**

- Four operations are selected with equal nominal probability using a uniform inclusive integer helper. For addition and subtraction, each operand is independently selected from 2–99 inclusive. Results therefore range 4–198 and −97–97 respectively, including zero for equal subtraction operands.
- Multiplication independently chooses one factor from 2–12 and one from 2–99, then swaps their positions with probability 1/2; results range 4–1188. Division chooses quotient 2–99 and divisor 2–12 independently and displays their product divided by the divisor. It always produces an integer quotient; dividend range is 4–1188, though not every integer in that range is possible.
- These are independent random draws with replacement; no score-dependent difficulty or streak bonus appears in this mode's generator and state update. Answer is converted to its canonical string and compared exactly to the input change value. A match adds one point, clears the input and replaces the question; nonmatches do nothing to score/question. Empty input cannot match any generated answer. No explicit submit or skip appears in the observed component.
- A three-second countdown precedes a 120-second game, measured with wall-clock `Date.now()` and an interval that updates roughly once per second. The active clock starts when the countdown transition is processed. When elapsed whole seconds reach 120, status becomes finished; score and last question/answer are shown. Displayed timer hiding is presentation only. Delayed callbacks, clock changes, background scheduling and answer-at-expiration races are not separately tested; do not describe this as monotonic timing.
- Examples for later tests: 2 + 2 = 4, 2 − 99 = −97, 99 − 99 = 0, 12 × 99 = 1188, and 1188 ÷ 12 = 99. These are derived from implementation ranges and arithmetic, not separately observed outputs.

**Arithmetic Pro — VERIFIED — PUBLIC IMPLEMENTATION:**

- A fixed bundled pool contains 2,881 distinct equation strings with stored integer answers. The inspected list contains addition, subtraction, multiplication, division and parentheses; answer values range −271 to 996, including 12 zero and 157 negative entries. An independent local exact-rational evaluation of every expression, normalizing the Unicode minus sign, found no discrepancies with the stored answers. This verifies the supplied list's mathematical consistency, not all future site versions.
- Selection is with replacement and does not adapt to score. The inclusive helper is called with bounds 0 and pool length, so it can return index 2,881, one beyond the last valid index 2,880. Under ideal uniform random selection this occurs with probability 1/2,882 per draw, and dereferencing that entry would fail. This is an implementation defect inferred directly from source; it was not reproduced in live play. A safe independent generator should avoid out-of-range access and document that deviation rather than silently claim exact behavior.
- Input matching, +1 scoring, reset, three-second countdown, 120-second wall-clock timer and end display follow the same structure as Arithmetic in the supplied build. Examples observed in play include `5 + 7 * 4 = 33` and `16 - (4 + 3) * (14 + 1) = -89`. Difficulty progression, multiple-answer handling, erroneous and malformed input interactions, and expiry races beyond the inspected path remain unverified.
- The source pool is protected material: do not copy it into MindSprint. Exact reproduction of its question distribution without the list is unresolved; independently authored generators or questions must be labelled as provisional/custom until fidelity can be established.

**Research limits:** Tests inspected and evaluated the supplied snapshot and observed live samples, not all sessions or runtime races. No authentication, private endpoints or protections were bypassed. Later changes to the reference may alter these findings. Future work should preserve and revisit these open issues before implementing Classic mode.

## Sequence

Source: [OpenQuant game room](https://openquant.co/math-game), direct unsigned-in play on 2026-10-30, and the user-supplied public script fingerprinted in the Arithmetic section. Source observations describe that snapshot, which may change.

- **VERIFIED — DIRECT OBSERVATION:** The mode starts with a countdown and 120-second display. `6, 19, 32, 45, ?` accepted `58` and advanced from 0 to 1 point; `1, 8, 27, 64, ?` accepted `125` and advanced to 2. Entering `0` and pressing Enter on the first prompt did not advance or change score. Play Again reset the score and timer; `9, 16, 25, 36, ?` accepted `49` in the replay.
- **VERIFIED — PUBLIC IMPLEMENTATION:** A uniformly chosen family (arithmetic, geometric, quadratic, special) generates five integers. An independent random direction reverses the five terms half the time; the last term of the resulting order is hidden. Reversal does not guarantee numerically decreasing values for every quadratic.
  - Arithmetic: initial term 5–22 and positive step 2–22, inclusive; generate five successive terms.
  - Geometric: initial term 5–22 and multiplier 2–9, inclusive; generate five successive terms.
  - Quadratic: independent integer coefficients a, b, c each −8 through 8; evaluate a*n² + b*n + c for n=1…5. Zero coefficients and negative values are possible.
  - Special: uniformly choose squares, cubes, or triangular numbers, with starting index 1–5; produce five consecutive terms.
- **VERIFIED — PUBLIC IMPLEMENTATION:** The hidden answer is converted to a string. An exact match on numeric-field change adds one point, clears input and advances; a nonmatch does not advance or deduct points. Three-second countdown precedes 120 seconds, using wall-clock time and roughly one-second updates; the result shows score and the last sequence/answer. There is no source-visible adaptive difficulty or skip in this mode. Timer background/clock-change and answer-expiry races have not been tested.
- **INDEPENDENT CHECK:** Exhaustively enumerating the stated finite parameter sets and both directions yielded 10,621 distinct four-term prefixes and no prefix with more than one fifth value within these generator families. This does not prove uniqueness among all conceivable mathematical rules. Example test vectors: 5, 7, 9, 11 → 13; 5, 10, 20, 40 → 80; 1, 4, 9, 16 → 25; 1, 3, 6, 10 → 15; reversed 25, 16, 9, 4 → 1.
- **UNVERIFIED:** Actual expiry transition and last-question UI in live Sequence play, invalid-format variations, timing races, and behavior under OS backgrounding. Do not infer a device-monotonic clock from the reference's wall clock.

## Optiver 80 in 8

Source: same site and script snapshot; direct unsigned-in samples on 2026-10-30. The game shown by OpenQuant should not be assumed to match an actual employer assessment.

- **VERIFIED — DIRECT OBSERVATION:** An initial countdown is followed by a display of Question 1 / 80, 480 seconds, an equation with one missing component, and four tappable choices. `? / 29 = −4.8` accepted `−139.2`, awarded +1, and advanced. Choosing `140` for `? − 59 = 27` advanced and changed score from 1 to −1 (−2). Replay reset question number, score and timer; `95.75 − 56.16 = ?` accepted `39.59` and earned +1.
- **VERIFIED — PUBLIC IMPLEMENTATION:** At start, 80 questions are generated in advance. Each selects addition, subtraction, multiplication or division and hides first operand, second operand or result, with each operation and position chosen uniformly by the code. There are four shuffled string choices, one designated correct; every choice immediately advances, adding +1 if it exactly equals the designated answer or −2 otherwise. The session finishes at 80 answered or after 480 elapsed seconds following a three-second countdown. A wall-clock interval drives time display/status; answer-at-expiry and rapid-tap races are unverified.
- **VERIFIED — PUBLIC IMPLEMENTATION:** Number type is selected independently from an array containing two integer entries and one decimal entry (nominal 2/3 integer, 1/3 decimal). Addition/subtraction use the first type for both operands: integers 2–99 inclusive or decimal values sampled from 0.1 up to 99 and rounded/displayed to two decimals. Multiplication/division use independently selected types: integers 2–99, or values sampled from −5 up to 5 and rounded/displayed to one decimal. Division constructs the dividend as a product so the intended quotient is a sampled factor; precision depends on operand types. Floating-point rounding and formatting need independent compatibility tests.
- **VERIFIED — PUBLIC IMPLEMENTATION:** Distractors use offsets according to the hidden value's display precision: integer offsets include one small positive, one larger positive, and one small negative; decimal choices use analogous offsets at one or two decimal places, then shuffle. Result view displays score and all 80 generated question rows, treating an unanswered row's missing correctness flag as false; no live full-session/timeout result was checked.
- **STRONGLY INFERRED FROM PUBLIC IMPLEMENTATION:** Decimal sampling can round a divisor to zero. A division question can therefore display an invalid zero-divisor equation while retaining a designated answer; this defect was not reproduced live. Avoid generating invalid divisions in MindSprint and document this fidelity deviation. Potential rounding, duplicate choices and negative-zero cases need targeted testing before implementation.
- **UNVERIFIED:** Full run through all 80 questions, expiry/results in live play, score floor, overlapping rapid taps, rounding edge cases and background timing. No assumption that the reference has a numeric keypad or accepts free-text input.

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

