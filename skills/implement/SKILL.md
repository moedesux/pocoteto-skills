---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

If the user passes a ticket reference, fetch it from the issue tracker and state its title before starting. If the reference is ambiguous, ask. Note the ticket's **Proof** line: it is the definition of done for close-out step 1.

If the work comes from tickets, read the `to-tickets` skill's [WORKING-A-TICKET.md](../to-tickets/WORKING-A-TICKET.md) and follow it: run the gate before you start, build only the criteria this ticket owns, route new behaviour through the spec, and stop on a contradiction.

Call the Skill tool with "tdd" where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

## Close-out

Run these in order. Each catches something the others miss.

1. **Prove it works.** Read the `principle-prove-it-works` skill's SKILL.md and follow it. pstack is a plugin here, so the file lives in the plugin's folder: `find ~/.claude/plugins -path '*/skills/principle-prove-it-works/SKILL.md'`. Drive the surface the ticket's Proof line names and observe the result it names. Then re-run the Proof of every ticket already closed, per WORKING-A-TICKET.md rule 5. If the ticket has no Proof line, pick the surface a user of this change would touch. Green tests are not this step. If a project-local `verify` skill exists (made by `/create-verification-skill`), use it.
2. **Spec and standards.** Call the Skill tool with "code-review" to review the work. Its Spec axis checks you built what the ticket asked for.
3. **Adversarial review.** Read the `interrogate` skill's SKILL.md and follow it over the same diff. It is user-invoked, so open its file rather than calling the Skill tool. pstack is a plugin here, so the file lives in the plugin's folder: `find ~/.claude/plugins -path '*/skills/interrogate/SKILL.md'`. Use the ticket or spec as the intent in its Step 2 instead of asking the user. Skip this step only for trivial diffs (copy, config, one-line fixes) and say you skipped it.
4. Fix what steps 2 and 3 raise that you agree with. Dismiss the rest with a one-line reason each.

Commit your work to the current branch. In your report, show the Proof evidence (the command and its output, or what you observed on screen), then the review findings and what you did with each.
