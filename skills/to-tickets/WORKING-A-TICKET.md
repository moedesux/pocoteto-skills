# Working a ticket

Rules for anyone implementing a ticket that `to-tickets` cut. `implement` and `implement-spec` follow them, and so does any build that starts from one of these tickets. The spec is the source of truth, and a ticket only moves toward it.

## 1. Before you start, run the gate

Run the ticket's Proof against the current code, before writing anything.

- **Some checks fail** (the normal case). Build only the failing criteria.
- **Every check passes.** Don't close the ticket. It is now a **verify-only** ticket. Run its Proof, then run `code-review`'s Spec axis against this ticket's criteria. If the Spec axis finds a gap, the gap is this ticket's work. If it finds none, close the ticket and name the commit that satisfied it: "satisfied by #01 (`abc123`), verified here".

The gate can narrow a ticket. It never widens one.

## 2. Build only what you own

Each acceptance criterion belongs to exactly one ticket. Write code only to turn **your own** ticket's criteria green.

- You notice another ticket's criterion failing. Note it in your report and leave it.
- Another ticket's checks go green as a side effect of your work. Fine. Don't claim it: your PR doesn't say it closes that ticket. Add a note to that ticket: "criteria 1–3 green at `abc123`, side effect of #01". Its own gate handles it when its turn comes.

## 3. New behaviour goes through the spec

Your design may reveal a behaviour that no ticket's criteria describe.

- If the spec already says it, add it to the ticket that owns that part of the spec, quoting the spec line.
- If the spec doesn't say it, it is a new decision, not an implementation detail. Amend the spec and cut a new ticket with its own Proof, Touches, and blocking edges. With a human present, ask first. Unattended, mark the decision `ASSUMED (evidence: …)` in the spec and carry on.

Never fold new behaviour into the ticket you happen to be holding.

## 4. Stop on a contradiction

If satisfying your ticket would break a criterion owned by another ticket (open or closed), stop. That is a spec conflict, not a choice for the implementer. Report both criteria and the case where they disagree. With a human present, wait for the call. Unattended, pick the reading the spec supports best, amend the spec with an `ASSUMED` note, and record it in your report.

## 5. Re-run every earlier Proof when you close

Closing a ticket re-runs the Proof of every ticket closed before it, not just your own. A green suite plus your own Proof isn't enough. Another ticket's Proof catches the regression you didn't think to test for. Keep the Proofs as runnable commands (one script that runs them all is best) so this stays cheap.

## 6. Shared seams don't run in parallel

Two tickets whose **Touches** lines name the same seam must not be built at the same time, even if neither blocks the other. Treat a shared seam as a blocking edge: the lower-numbered ticket goes first.
