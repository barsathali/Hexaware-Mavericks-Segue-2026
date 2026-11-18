# Set 2 – Insurance Claims Portal

## 1. Product vision
For insurance customers who need to lodge and follow a claim, the self-service Claims Portal provides guided registration, supporting-document upload, transparent claim tracking and settlement notifications. It reduces avoidable calls and gives customers visibility of the claim journey while allowing the insurer to process information consistently.

## 2. Waterfall versus Agile (why Agile suits this programme)
Waterfall typically organises work into sequential phases such as requirements, design, implementation, testing and release. It can be useful when requirements are stable and changes are limited, but a claims portal has changing policy rules, document requirements, customer expectations and integration constraints. Discovering usability or validation problems late may make them expensive to correct.

Agile delivers in small increments and uses frequent stakeholder feedback. The insurer can first release a thin but valuable claim-registration journey, then improve document upload, status tracking and notifications. The Product Owner can reorder work as regulatory, operational and customer priorities become clearer. Sprint Reviews expose working software early, while the Retrospective supports process improvement. Agile does not remove governance: security, privacy, auditability and regulatory controls must be included in acceptance criteria and the Definition of Done.

## 3. Epics and 12 user stories
The four epics are Claim Registration (INS-01–03), Document Upload (INS-04–06), Claim Tracking (INS-07–09), and Settlement Notifications (INS-10–12). Every story uses the As a / I want / so that format. The full estimates and priorities are in `backlog.csv`.

## 4. INVEST review and vertical splitting
INVEST = Independent, Negotiable, Valuable, Estimable, Small and Testable. The final 12 backlog stories are vertical user outcomes rather than technical-layer tasks.

| Oversized original | INVEST concern | Vertical split |
|---|---|---|
| “Build the complete claim registration module” | Too large and not independently testable | INS-01 Start a claim; INS-02 Validate policy eligibility; INS-03 Submit incident details |
| “Implement all document-management services and storage” | Describes technical layers, not customer outcomes | INS-04 Upload a supporting document; INS-05 See uploaded document status; INS-06 Replace an incorrect document |

The vertical stories each deliver a customer-visible capability and can be accepted independently.

## 5. Given / When / Then acceptance criteria – Claim Registration
**INS-01 – Start a claim**
- Given the customer is authenticated and has an active policy, When they select Start Claim, Then the portal creates a draft and displays a claim reference.
- Given the customer has no eligible policy, When they try to start a claim, Then the portal explains that no eligible policy is available.

**INS-02 – Validate policy eligibility**
- Given the policy is active on the incident date, When the customer submits the policy details, Then the portal confirms eligibility.
- Given the policy number is unknown, When the customer submits it, Then a validation error is shown and no claim is created. *(Validation failure.)*
- Given the policy has expired before the incident date, When eligibility is checked, Then the portal explains that the policy is not eligible.

**INS-03 – Submit incident details**
- Given all required incident fields are valid, When the customer submits the form, Then the claim is registered and a reference is displayed.
- Given the incident date or description is missing, When the customer submits, Then the form remains open and identifies the missing field.

## 6. Planning Poker estimates and backlog size
Estimates use only the requested Planning Poker values: 1, 2, 3, 5, 8 and 13.

| Story | Points | Rationale |
|---|---:|---|
| INS-01 | 3 | Simple guided start with claim draft |
| INS-02 | 5 | Policy and incident-date rules add edge cases |
| INS-03 | 5 | Form validation and registration |
| INS-04 | 3 | Single-document upload |
| INS-05 | 2 | Display upload result |
| INS-06 | 3 | Replace and confirm one document |
| INS-07 | 3 | Display current status |
| INS-08 | 5 | Ordered status history |
| INS-09 | 5 | Customer response and status transition |
| INS-10 | 2 | Registration confirmation |
| INS-11 | 3 | Status change notification |
| INS-12 | 5 | Settlement outcome and next-step message |

**Total backlog size: 44 story points.**

**Outlier discussion:** INS-04 was initially estimated at 13 points when described as “upload all document types, bulk files, virus scanning, storage, retry and preview”. The team challenged the estimate because it bundled several capabilities and technical concerns. It was split vertically into INS-04 (upload one supporting document), INS-05 (see upload status) and INS-06 (replace a document). The revised estimates are 3, 2 and 3 points respectively. Security scanning and permitted file types remain acceptance/technical constraints, not separate user-value layers.

## 7. Scrum roles, events and artifacts
- **Product Owner:** owns product value and orders the backlog.
- **Scrum Master:** coaches Scrum, facilitates improvement and helps remove impediments.
- **Developers:** design, build, test and integrate a Done Increment.
- **Sprint:** fixed-length event for creating an Increment.
- **Sprint Planning:** agrees why the Sprint is valuable, what can be done and how.
- **Daily Scrum:** Developers inspect progress toward the Sprint Goal and adapt the plan.
- **Sprint Review:** stakeholders inspect the Increment and discuss future adaptations.
- **Sprint Retrospective:** team plans improvements to quality and effectiveness.
- **Artifacts:** Product Backlog, Sprint Backlog and Increment; their commitments are Product Goal, Sprint Goal and Definition of Done.

## 8. Definition of Done
- [ ] Acceptance criteria pass.
- [ ] Code review is complete.
- [ ] Unit and integration tests pass.
- [ ] Document type, size and security validations pass.
- [ ] Sensitive claim data is protected and access-controlled.
- [ ] Audit-relevant events are logged.
- [ ] No critical or high-severity defects remain.
- [ ] Increment is integrated and demonstrable.

## 9. Jira setup
Create a Scrum project named “Insurance Claims Portal”. Import `jira_import.csv`, map Issue Type, Summary, Description, Priority, Story Points and Epic Link, and ensure epics and stories are linked. Configure workflow states To Do, In Progress, In Review and Done. Attach this DoD and capture a real board export/screenshot from Jira.
