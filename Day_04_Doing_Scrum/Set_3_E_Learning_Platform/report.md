# Set 3 — E-Learning Platform

## 1. Sprint plan
Given velocity = **30 story points**. Sample sprint backlog: EL-01 (5), EL-02 (3), EL-03 (2), EL-04 (5), EL-05 (3), EL-06 (2), EL-07 (5), EL-08 (2), EL-10 (2) = **29 points**.
**Sprint Goal:** Help learners discover and enrol in courses, continue lessons and complete learning activities with visible progress.

## 2. New request — certificate download on day 6
The Product Owner requests certificate download for an upcoming launch. Assess urgency and impact with Developers. Do not automatically add five points to an in-progress sprint. Discuss what can be swapped while preserving the Sprint Goal. Example: defer EL-11 learning history (3) and EL-10 completion notification (2) only if the team believes the swap is feasible and the Product Owner agrees. The new certificate story is EL-09 (5 points). If it cannot be completed without endangering the Sprint Goal, order it near the top of the Product Backlog for the next Sprint. If the Sprint Goal becomes obsolete, the Product Owner may cancel the Sprint.

## 3. Blocked developer stand-up
Developer: Yesterday I completed the certificate eligibility rule draft. Today I will continue once the certificate API contract is available. Impediment: the API contract is missing, so I cannot complete integration or verify the response.
Scrum Master follow-up: contact the API owner, arrange a short contract clarification, document required fields and error responses, escalate if no response by the agreed time, and help the team use a contract stub for independent work where safe.

## 4. Sprint velocity calculation
See `velocity_calculation.csv`. Completed stories: 5 + 3 + 2 + 5 + 3 = **18 points**. EL-06 is 80% complete, but it does not meet the Definition of Done; therefore it contributes **0 completed points** this Sprint. It returns to the Product Backlog for re-planning. Sprint velocity = **18 points**.

## 5. Start-Stop-Continue retrospective
- **Start:** agree API contracts and test examples before stories enter a sprint.
- **Stop:** treating partially completed work as finished velocity.
- **Continue:** demonstrate working increments and raise blockers early.

**SMART action items**
1. Scrum Master will arrange an API contract review with the service owner within two working days; record the agreed request/response schema in the team workspace.
2. Developers will add automated tests for certificate eligibility and download failure cases before the next Sprint Review; target completion by the end of the next sprint.
3. Product Owner will add certificate acceptance criteria and launch priority to the backlog before the next refinement session.

## 6. Automation and Definition of Done
- Unit tests verify business rules and prevent regressions.
- Linting enforces consistent style and catches common defects.
- CI pipeline runs build and tests on each change.
- Review and merge checks ensure changes are inspected and integrated.
- A story is Done only when all agreed DoD checks pass; automation provides repeatable evidence but does not replace acceptance criteria or team review.
