# Set 3 – Hospital Appointment Booking Application

## 1. Product vision
For patients who need convenient access to hospital services, the Hospital Appointment Application provides a simple way to find doctors, book, reschedule or cancel appointments and receive reminders. It gives patients clear appointment information and helps hospital staff maintain an accurate doctor schedule.

## 2. Stakeholders and Scrum role mapping
| Stakeholder | Mapping | Reason |
|---|---|---|
| Hospital product manager / service owner | Product Owner | Represents product goals, patient value and backlog ordering |
| Agile facilitator | Scrum Master | Coaches the team in Scrum and helps remove impediments |
| Mobile developers | Developers | Build and maintain patient-facing features |
| Backend/API developers | Developers | Implement booking and schedule rules |
| QA/test engineers | Developers | Verify acceptance criteria and product quality |
| UX/UI designer | Developers | Contributes design work to the usable Increment |
| Patients | Customers / users | Use the service to manage appointments |
| Doctors | Customers / users and key stakeholders | Need accurate schedules and appointment information |
| Reception/clinic administrators | Customers / operational stakeholders | Coordinate clinic schedules and patient support |

A stakeholder is not automatically a Scrum role. The mapping above identifies who performs each Scrum accountability in this sample team and who provides requirements/feedback as a customer or stakeholder.

## 3. Epics and 12 user stories
Four epics: Booking (HOSP-01–04), Rescheduling and Cancellation (HOSP-05–06), Reminders (HOSP-07–09), Doctor Schedule Management (HOSP-10–12). Each story follows As a / I want / so that. Full backlog is in `backlog.csv`.

## 4. INVEST review
INVEST = Independent, Negotiable, Valuable, Estimable, Small and Testable. The final stories are independently demonstrable and have testable outcomes.

| Original story | INVEST issue | Rewritten vertical story |
|---|---|---|
| “As a patient, I want the complete appointment lifecycle implemented so that I can manage visits.” | Not Small or independently testable | Split into HOSP-03 Book an available slot, HOSP-05 Reschedule an appointment, HOSP-06 Cancel an appointment and HOSP-07 Receive booking confirmation. |
| “As a doctor, I want the database, API and UI schedule modules built.” | Technical-layer phrasing; no direct user outcome | Split into HOSP-10 Doctor sets availability and HOSP-11 Doctor blocks unavailable time. |

## 5. Given / When / Then acceptance criteria
**HOSP-02 – View available appointment slots**
- Given a doctor has published working hours, When a patient views the schedule, Then available slots are displayed with date and time.
- Given a slot is already booked or blocked, When the schedule is displayed, Then the slot is not offered as available.

**HOSP-03 – Book an available slot**
- Given the selected slot is still available, When the patient confirms booking, Then the appointment is created and a booking reference is displayed.
- Given another patient books the slot first, When the patient attempts to confirm, Then the system rejects the booking, refreshes availability and asks the patient to choose another slot. *(Slot already taken case.)*

**HOSP-05 – Reschedule an appointment**
- Given a patient has a future appointment and a new slot is available, When the patient confirms the change, Then the old slot is released and the appointment is moved to the new slot.
- Given the requested new slot is no longer available, When the patient confirms, Then the original appointment remains unchanged and alternative slots are displayed.

**HOSP-06 – Cancel an appointment**
- Given a patient has a cancellable future appointment, When the patient confirms cancellation, Then the appointment status becomes Cancelled and the slot is released.
- Given an appointment is already completed, When the patient attempts cancellation, Then the portal prevents cancellation and explains the reason.

## 6. Business value versus effort prioritisation
| Story | Business value (1–5) | Effort (points) | Priority rationale |
|---|---:|---:|---|
| HOSP-01 | 4 | 3 | Enables discovery |
| HOSP-02 | 5 | 3 | Required to make a booking choice |
| HOSP-03 | 5 | 5 | Core patient value |
| HOSP-04 | 4 | 2 | Gives patients visibility of visits |
| HOSP-05 | 4 | 5 | Important flexibility |
| HOSP-06 | 5 | 3 | Releases slots and prevents wasted capacity |
| HOSP-07 | 4 | 2 | Confirms successful booking |
| HOSP-08 | 3 | 3 | Reduces missed appointments |
| HOSP-09 | 4 | 3 | Keeps patients informed of changes |
| HOSP-10 | 5 | 5 | Enables schedule publishing |
| HOSP-11 | 5 | 3 | Prevents booking during leave |
| HOSP-12 | 5 | 5 | Prevents double-booking |

Must-have first: HOSP-01, 02, 03, 04, 06, 07, 10, 11, 12. Should-have: HOSP-05, 08, 09, with rescheduling promoted as capacity allows. The Product Owner can revise ordering based on actual hospital feedback.

## 7. Planning Poker and story points
Planning Poker uses relative estimates and a Fibonacci-like sequence (1, 2, 3, 5, 8, 13). Reference story: **HOSP-04 View my upcoming appointments = 2 points**, a small, familiar read-only patient outcome. HOSP-03 is 5 points because it requires availability checks, booking confirmation and a race-condition/slot-taken path. **Total estimated backlog: 42 story points.**

A story point is a relative estimate of the overall size of a story, considering effort, complexity and uncertainty. An hour is a unit of elapsed time. Points are not a direct conversion to hours; teams learn their own delivery capacity from completed work.

## 8. Definition of Ready (at least six items)
- [ ] User story has a clear patient, doctor or staff persona.
- [ ] User value and business reason are clear.
- [ ] Acceptance criteria include normal and relevant failure paths.
- [ ] Story is small and independently testable.
- [ ] Dependencies, permissions and schedule rules are identified.
- [ ] UX flow and required content are available.
- [ ] Data/privacy implications are understood.
- [ ] Team can estimate the story.

## 9. Definition of Done (at least six items)
- [ ] Acceptance criteria pass, including slot-already-taken and conflict cases.
- [ ] Code is peer-reviewed and merged.
- [ ] Unit and integration tests pass.
- [ ] Booking concurrency and schedule overlap checks pass.
- [ ] Patient data is access-controlled and handled securely.
- [ ] Notifications are tested for the relevant event.
- [ ] No critical or high-severity defects remain.
- [ ] User-facing changes are documented and demonstrated.

## 10. Jira setup
Create a Scrum project named “Hospital Appointment Booking”. Import `jira_import.csv`; create the four epics and associate stories using Epic Link. Configure To Do, In Progress, In Review and Done columns. Attach DoR/DoD and capture a real board screenshot. The supplied CSV is ready for Jira import; a live Jira board cannot be created without access to your Jira account.
