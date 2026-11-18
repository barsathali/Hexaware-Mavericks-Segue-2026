# Set 2 — Airline Web Check-in

## 1. Team capacity
Six members × 8 working days × 8 hours/day = **384 gross team-hours**.
384 × 70% focus factor = **268.8 net team-hours**, approximately **269 hours**.
Capacity is expressed in hours, not story points. The assignment does not provide historical velocity for this team, so a defensible point commitment cannot be calculated from capacity alone. Use the team's observed velocity if available; otherwise treat any point forecast as provisional and select stories based on the team's demonstrated throughput and capacity.

## 2. Sprint goal and sample selected stories
**Sprint Goal:** Allow eligible passengers to retrieve a booking, confirm passenger details, select an available seat and obtain a boarding pass.
Sample sprint selection: AIR-02 (3), AIR-03 (3), AIR-04 (5), AIR-07 (3), AIR-09 (2), AIR-11 (2) = **18 points**. This is an illustrative selection, not a velocity-derived commitment.

## 3. Definition of Ready check
For each selected story, confirm:
- User/customer value is clear.
- Acceptance criteria are specific and testable.
- Dependencies and external services are identified.
- Story is small enough to complete in a sprint.
- UX/API or business rules are available where needed.
- Team understands the story and can estimate it.

## 4. Impediment — payment-gateway sandbox unavailable
See `impediment_log.csv`. Impact: AIR-05 and AIR-06 cannot be fully integrated or verified against the real sandbox. Scrum Master action: contact the gateway/sandbox owner, request an ETA, escalate through the agreed support path, communicate the impact, and help the Developers agree on a safe mock/stub for non-production development. Do not claim the real integration is tested until the sandbox is restored.

## 5. Backlog refinement — top five stories
| Story | Refinement outcome | Estimate |
|---|---|---:|
| AIR-05 Pay for seat upgrade | Split vertically into quote upgrade and complete payment | 5 + 3 |
| AIR-04 Choose available seat | Keep; clarify seat locking and expiry | 5 |
| AIR-02 Retrieve booking | Keep; specify invalid reference behaviour | 3 |
| AIR-07 Download boarding pass | Keep; define PDF and mobile support | 3 |
| AIR-06 Receive payment result | Keep; define success, decline and timeout outcomes | 3 |

The oversized payment story is split by user-visible outcomes, not by technical layer.

## 6. Sprint Review agenda
1. State Sprint Goal and scope.
2. Demonstrate booking retrieval with valid and invalid details.
3. Demonstrate passenger detail confirmation.
4. Demonstrate seat selection and unavailable-seat handling.
5. Demonstrate boarding pass download.
6. Review acceptance criteria and collect stakeholder feedback.
7. Record backlog changes for Product Owner ordering.

**Demo script:** As a passenger, open the check-in page, enter booking reference and surname, confirm passenger details, choose an available seat, complete check-in and download the boarding pass. Show validation for an invalid booking and a seat that has become unavailable.

## 7. Distributed asynchronous stand-up
**Team member 1 (UTC+5:30):** Yesterday: completed booking retrieval validation. Today: finish passenger detail confirmation. Blocker: waiting for test booking data.
**Team member 2 (UTC+1):** Yesterday: implemented seat map selection. Today: handle seat-lock expiry. Blocker: sandbox seat inventory refresh is delayed.
**Team member 3 (UTC+5:30):** Yesterday: prepared boarding pass PDF. Today: test download on mobile browsers. Blocker: awaiting final branding asset.

Async vs live: async updates support different time zones and create a written record, but questions may take longer to resolve. A live stand-up enables immediate clarification and conversation, but requires overlapping working hours. Both should focus on progress toward the Sprint Goal and impediments, not status reporting to a manager.

## 8. Note on points and commitment
Capacity hours describe available time. Story points express relative size/complexity/uncertainty. Do not convert hours directly into points. The team should use historical velocity to forecast a realistic point range.
