# Set 1 – Online Grocery Delivery Application

## 1. Product vision
For local households who need convenient grocery shopping, the Grocery Delivery Application is a mobile and web service that makes it easy to discover products, build a basket, pay securely and follow home delivery. Unlike phone-based ordering, it provides a visible catalogue, clear order confirmation and delivery updates.

## 2. Scrum roles and anti-patterns
| Scrum role | Responsibility | One anti-pattern to avoid |
|---|---|---|
| Product Owner | Maximises product value and orders the Product Backlog | Acting as a command-and-control manager who assigns tasks to Developers |
| Scrum Master | Establishes Scrum and helps remove impediments | Acting only as a meeting scheduler or project secretary |
| Developers | Build a usable Increment that meets the Definition of Done | Working in isolated silos and handing work across functional walls |

## 3. Epics and user stories
The 12 stories are grouped into Browse and Search (GROC-01–04), Cart and Checkout (GROC-05–09), and Delivery Tracking (GROC-10–12). Each story is in As a / I want / so that form. The complete prioritised backlog and point estimates are in `backlog.csv`.

## 4. INVEST review
INVEST means Independent, Negotiable, Valuable, Estimable, Small and Testable. All final stories in the backlog are written to meet these properties and can be refined further with the Product Owner.

| Story reviewed | Potential INVEST issue | Improved vertical story |
|---|---|---|
| Original: “As a shopper, I want the complete ordering system built so that I can buy groceries.” | Too large; not Small, not independently testable | Split into GROC-05 Add item to cart, GROC-07 Enter delivery address, GROC-08 Pay securely and GROC-09 Receive order confirmation. Each delivers a user-visible outcome. |
| Original: “As a shopper, I want search, filters and recommendations implemented in the backend so that the catalogue is fast.” | Technical-layer phrasing; unclear user value and not independently testable | Split into GROC-02 Search products and GROC-03 Filter search results. Each is independently demonstrable and testable. |

## 5. Acceptance criteria (Given / When / Then)
**GROC-02 – Search products**
- Given the catalogue contains “Milk”, When the shopper searches “milk”, Then matching products are shown.
- Given no product matches the query, When search completes, Then a clear “No products found” message is shown.

**GROC-05 – Add item to cart**
- Given a product is available, When the shopper selects Add to Cart, Then it appears in the cart with quantity one.
- Given a product is out of stock, When the shopper attempts to add it, Then the item is not added and an availability message is shown. *(Negative scenario.)*

**GROC-07 – Enter delivery address**
- Given checkout is open, When the shopper submits all required valid address fields, Then the address is saved against the order.
- Given a required address field is blank, When the shopper submits, Then validation identifies the missing field and checkout does not continue.

**GROC-08 – Pay securely**
- Given valid order details and an approved payment response, When payment completes, Then the order is confirmed.
- Given the payment provider declines the transaction, When the response is received, Then the order is not marked paid and a retry option is shown.

**GROC-10 – Track delivery status**
- Given an order has a delivery status update, When the shopper opens tracking, Then the latest status and its timestamp are displayed.

## 6. MoSCoW prioritisation and Planning Poker
| MoSCoW | Stories |
|---|---|
| Must have | GROC-01, 02, 04, 05, 06, 07, 08, 09 |
| Should have | GROC-03, 10, 11 |
| Could have | GROC-12 |
| Won't have this release | Advanced personalised recommendations (deferred) |

Fibonacci estimates used: 1, 2, 3, 5, 8, 13. Reference story: **GROC-01 Browse categories = 3 points**. The team uses it as a small, familiar end-to-end catalogue interaction. Other stories are compared with its relative complexity, uncertainty and effort. GROC-08 is 8 points because payment integration, error handling and security coordination create more uncertainty. Points are relative size, not hours.

**Total estimated backlog: 47 story points.**

## 7. Definition of Ready (DoR)
- [ ] Story has a clear user and user value.
- [ ] Story is small enough to complete within a sprint.
- [ ] Acceptance criteria are written and testable.
- [ ] Dependencies and external integrations are identified.
- [ ] UX/content or business rules needed are available.
- [ ] Product Owner has clarified open questions and priority.
- [ ] Team can estimate the story.

## 8. Definition of Done (DoD)
- [ ] Code is implemented and peer-reviewed.
- [ ] Unit and relevant integration tests pass.
- [ ] Acceptance criteria pass, including negative cases.
- [ ] Security and privacy checks relevant to the change pass.
- [ ] No critical or high-severity defects remain open.
- [ ] User-facing changes are documented.
- [ ] Increment is integrated and demonstrated in a working environment.

## 9. Jira setup
Create a Scrum project named “Online Grocery Delivery”. Create the three epics listed above and import `jira_import.csv` using the Issue Type, Summary, Description, Priority, Story Points and Epic Link fields. Set workflow states to To Do, In Progress, In Review and Done. Capture a screenshot of the board and backlog after import; this package provides import-ready data but does not create a board in your Jira account.
