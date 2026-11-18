# Set 1 — Digital Wallet Application

## 1. Velocity and sprint selection
Previous sprint velocities: 21, 24 and 23 story points.
Average velocity = (21 + 24 + 23) / 3 = **22.67**, rounded to **23 points** for planning.
Selected sprint scope: WAL-01 (3), WAL-02 (5), WAL-03 (3), WAL-05 (5), WAL-06 (2), WAL-09 (5) = **23 points**.
The refund-to-wallet request is represented by WAL-09. The sprint goal is:

**Sprint Goal:** Enable customers to fund their wallet, pay a merchant, view transactions and receive an eligible refund in their wallet, with clear confirmation of payment outcomes.

The selection is a planning forecast, not a guarantee. The Product Owner orders the Product Backlog; Developers select feasible work during Sprint Planning.

## 2. Task breakdown
Three selected stories (WAL-01, WAL-02 and WAL-05) are broken into tasks with hour estimates in `selected_story_tasks.csv`. Estimates are planning estimates and should be refined by the team.

## 3. Day-3 stand-up updates
- Developer A — Yesterday: completed wallet balance API. Today: connect balance summary to the screen. Impediment: test account has stale balance data.
- Developer B — Yesterday: completed saved-payment token validation. Today: implement top-up confirmation. Impediment: waiting for sandbox test credentials.
- Developer C — Yesterday: completed merchant payment request handling. Today: add insufficient-balance handling. Impediment: payment timeout behaviour needs product clarification.

## 4. Mid-sprint change — refund to wallet
Added: WAL-09, eligible refund credited to wallet (5 points).
Removed/deferred: WAL-07 spending limit (3), WAL-12 temporary freeze (3), and WAL-04 transaction filter (3) are candidates to move out of the sprint only after Developers and Product Owner discuss impact. Protect the Sprint Goal; do not silently add work or force Developers to absorb unlimited scope.
Decision: Product Owner orders the Product Backlog. During the Sprint, scope may be clarified and renegotiated with the Product Owner as more is learned; Developers own the Sprint Backlog plan. If the Sprint Goal becomes obsolete, only the Product Owner can cancel the Sprint.

## 5. Burndown interpretation
See `sprint_burndown.png` and `burndown_data.csv`. The actual line stays flat on days 3–4, indicating no net story-point work was completed/recognised during that period. It then falls faster and reaches zero on day 10. The chart is illustrative data because the assignment refers to a supplied completed-points table that was not included in the uploaded document.

## 6. Retrospective
**What went well:** payment flow integration progressed; acceptance criteria exposed insufficient-balance cases early; team raised blockers during stand-up.
**What to improve:** sandbox access was not confirmed before sprint start; product clarification arrived mid-sprint.
**Action items:**
1. Scrum Master to confirm sandbox access and test credentials before the next Sprint Planning; due before next sprint.
2. Product Owner to add refund eligibility rules and examples to backlog acceptance criteria before refinement; due at next refinement.

## 7. Definition of Done mapped to build pipeline
- Build: source compiles and dependencies resolve.
- Test: unit and relevant integration tests pass.
- Review: peer review approved; static checks pass.
- Merge: changes merged to the shared branch after required checks.
- Release readiness: acceptance criteria met, no critical defects open, and documentation updated.

## 8. Impediment log
| ID | Impediment | Impact | Owner | Escalation / action | Expected resolution |
|---|---|---|---|---|---|
| I-01 | Sandbox credentials unavailable | Top-up validation delayed | Scrum Master | Contact sandbox administrator; escalate to engineering lead | Before next test cycle |
| I-02 | Refund eligibility rules unclear | Refund story acceptance uncertain | Product Owner | Arrange clarification with business owner; update story criteria | Before WAL-09 development |
