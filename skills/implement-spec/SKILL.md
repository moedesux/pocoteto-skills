---
name: implement-spec
description: "Implement the result of /to-spec and /to-tickets in code."
disable-model-invocation: true
---

You have been provided a spec. This spec should have tickets associated with it, describing how to implement the spec.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

The goal is the entire spec implemented on a single **integration branch**, with every ticket resolved the way the issue tracker closes work.

The tickets are not a list of steps. They are a **task graph** with blocking relationships between them. This means there is always a **frontier** of tickets which are ready to be grabbed.

Two tickets whose **Touches** lines name the same seam also block each other: the lower-numbered one goes first. Every implementer follows the `to-tickets` skill's [WORKING-A-TICKET.md](../to-tickets/WORKING-A-TICKET.md).

Communication to and from subagents should be sparse. Communicate primarily through **context pointers**: to the spec, tickets, research notes, and previous commits. Don't duplicate information already available via pointers.

**Implementer subagents** should be run in the background where possible for maximum concurrency.

## Steps

1. Read the spec and tickets to understand the task graph.

2. (optional) Use an **exploration subagent** to conduct any exploration required by the tickets - relevant codebase files or external documentation. Ensure the exploration subagent can save files - it should save its markdown notes in a directory outside the repo, accessible by all future subagents. This lets **implementer subagents** focus on implementation rather than exploration.

3. Create the integration branch. If the issue tracker closes work through PRs, or the user asks for one, open a draft PR after the first merge in step 5 (a branch with no commits ahead of main can't open one), marked as closing the spec and tickets.

4. Use **implementer subagents** to implement each ticket, each in its own worktree on its own branch. Each implementer subagent:
   - confirms its worktree is based on the integration branch before starting, and resets onto it if not;
   - runs the WORKING-A-TICKET.md gate first, against the integration branch tip. A ticket whose Proof already passes becomes verify-only;
   - calls the Skill tool with `tdd` to build only the criteria its ticket owns;
   - proves the ticket works by driving the surface its **Proof** line names and observing the result it names (read the `principle-prove-it-works` skill's SKILL.md), and puts that evidence in its report. Green tests alone are not a Proof;
   - merges the integration branch tip into its own branch, then re-runs the Proof of every ticket already merged, before reporting done;
   - stops and reports instead of choosing, if its ticket contradicts another ticket's criteria

5. Once an **implementer subagent** completes, merge its work to the integration branch with a **merger subagent**.

6. If this changes the **frontier** of available tickets, kick off more **implementer subagents** to work on the new tickets. This allows for maximum concurrency.

7. Once all tickets are complete, review the integration branch two ways, in parallel:
   - call the Skill tool with `code-review` (Standards and Spec axes);
   - read the `interrogate` skill's SKILL.md and follow it over the same diff (it is user-invoked, so open its file rather than calling the Skill tool; pstack is a plugin here, so the file lives in the plugin's folder: `find ~/.claude/plugins -path '*/skills/interrogate/SKILL.md'`). Use the spec as the intent in its Step 2.

   Fix the findings you agree with in a single **implementer subagent**, and dismiss the rest with a one-line reason each. Then re-run every ticket's Proof against the integration branch tip, since merges can break a ticket that passed in its own worktree.

8. If a draft PR exists, mark it ready for review. Otherwise, resolve each ticket the way the issue tracker closes work, and report the integration branch.

9. Clean up all **implementer subagent** worktrees.
