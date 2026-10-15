---
name: to-tickets
description: Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (edges as text in one file per ticket locally, or native blocking links on a real tracker).
disable-model-invocation: true
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets**: tracer-bullet vertical slices, each declaring the tickets that **block** it.

The issue tracker and triage label vocabulary should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

### 2. Explore the codebase and sketch the shape

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

Then write a **shape sketch** of a few lines: the data shape the change introduces, and the **seams** it will live at (name them by concept, such as "definition stripping" or "span rewriting", not by file path). Settle the shape, not the code. Leave competing designs and implementation choices to build time. Cut the slices along these seams, so one design decision doesn't quietly complete several tickets.

### 3. Draft vertical slices

Break the work into **tracer bullet** tickets.

<vertical-slice-rules>

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests): vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own, and the ticket says how (its **Proof** line)
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first
- **Every acceptance criterion has exactly one owning ticket.** If two tickets would assert the same behaviour, keep it in the earlier one
- If one design choice would make a later ticket's criteria pass on its own, those criteria belong in the earlier ticket
- A criterion that stops user input from becoming markup, code, or a query (escaping, quoting, sanitising) belongs to the ticket that first emits that output, never to a later hardening ticket. Otherwise the earlier ticket ships an injection hole

</vertical-slice-rules>

Give each ticket its **blocking edges**: the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change (rename a column, retype a shared symbol) whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket; green is promised only there.

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:

- **Title**: short descriptive name
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work
- **Touches**: the seams from the shape sketch that this ticket changes
- **Proof**: how an agent shows it works on the real artifact, not a proxy. Name the surface (browser route, CLI command, API call, script) and the observable result (the value, screen, or output a person would check). Add the test seam when one is obvious. "Tests pass" or "it compiles" is not a Proof.
  - If the ticket adds a regex or scanner that runs over user input, its Proof includes a timing check: an adversarial input of at least 64 KB (long runs of the characters the pattern backtracks on, such as spaces) finishes in well under a second.

Before you show the breakdown, **dry-run every Proof** against the current code. It must fail, and for the reason you predicted. A Proof that passes already, errors for another reason, or selects zero tests (a name filter that matches nothing and still exits 0) is broken: fix it before the user sees it.

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct: does each ticket only depend on tickets that genuinely gate it?
- Is each Proof something you would accept as evidence the ticket is done?
- Do any two tickets touch the same seam without a blocking edge between them? Those can't run in parallel.
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 5. Publish the tickets to the configured tracker

Publish the approved tickets. **How** depends on the tracker `/setup-matt-pocock-skills` configured; the tickets are the same either way, only the shape of the blocking edges changes:

- **Local files** → write one file per ticket under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers first). Each file's "Blocked by" lists the numbers/titles it depends on. Use the per-ticket file template below: one ticket per file, never a single combined file.
- **A real issue tracker (GitHub, Linear, …)** → publish one issue per ticket in dependency order (blockers first) so each ticket's blocking edges can reference real identifiers. Use the platform's native blocking relationship where it has one; otherwise set each ticket's "Blocked by" to the blocking issues. If the source was an existing issue, make each ticket its sub-issue (tracker doc's operation). Apply the `ready-for-agent` triage label unless instructed otherwise; the tickets are agent-grabbable by construction.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means top to bottom.

Do NOT close or modify any parent issue.

<local-ticket-template>

# <NN>: <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective, not a layer-by-layer implementation list.

**Blocked by:** the numbers/titles of the tickets that gate this one, or "None (can start immediately)".

**Touches:** the seams this ticket changes, from the shape sketch.

**Status:** ready-for-agent

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2

**Proof:** the surface to drive and the observable result that shows it works (plus the test seam, if one is obvious).

</local-ticket-template>

<issue-template>

## Parent

A reference to the parent issue on the tracker (if the source was an existing issue, otherwise omit this section).

## What to build

The end-to-end behaviour this ticket makes work, from the user's perspective, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Proof

The surface to drive and the observable result that shows it works on the real artifact (plus the test seam, if one is obvious). Implementers verify against this before calling the ticket done.

## Touches

The seams this ticket changes, from the shape sketch.

## Blocked by

- A reference to each blocking ticket, or "None (can start immediately)". Omit this section when blockers were set as native edges.

</issue-template>

In either form, avoid specific file paths or code snippets: they go stale fast. The Proof line is the exception: it may name the exact commands and fixture paths needed to run it. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts, not a working demo, just the important bits.
