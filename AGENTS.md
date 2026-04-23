# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, Cursor, Copilot, and others)
when working in this repository. It is loaded into agent context automatically — keep it concise.

## Overview

`onflow/flip-fest` is an **archived, documentation-only repository** for the Flow FLIP Fest —
a past two-month hackathon event organized by the Flow team and moderated through HackerEarth,
where teams tackled improvement proposals for the Flow ecosystem. The repo contains the event
README, the final `winners.md` results table, a pull-request template, judging resources, and
archived milestone submissions under `submissions/` and `submission/`. There is no source code,
no build system, and no tests — only Markdown and a CSV.

Current home for Flow Improvement Proposals is `onflow/flips` (linked from the README's
"About Flow" section), not this repo.

## Build and Test Commands

None. This repository has no `Makefile`, `package.json`, `go.mod`, `flow.json`, CI workflows,
or any other build manifest. There is nothing to build, test, lint, or deploy.

## Repository Layout

- `README.md` — event overview, tracks/tiers, submission instructions, resource links.
- `winners.md` — final results table with teams, milestones completed, demo/repo links, and
  payout amounts for each issue (see issue summaries such as `#2` Block explorer GUI).
- `pull_request_template.md` — template auto-applied to PRs opened against this repo
  (submissions followed the format `[Issue Name] - Milestone [Milestone #]`).
- `resources/` — event-support documents:
  - `judging-criteria.md` — high-level judging rubric (Community Impact, User & Developer
    Friendly, Quality & Excellence).
  - `pr-template.md` — pointer to `pull_request_template.md`.
  - `specification-template.md` — functional-overview / solution-design template teams used.
  - `flow-team-directory.csv` — Flow team contact directory for the event.
- `submissions/` — archived milestone submissions. Exactly 24 top-level entries:
  `issue-2`, `issue-3`, `issue-5`, `issue-5-milestone-2`, `issue-6`, `issue-10`, `issue-11`,
  `issue-12`, `issue-14`, `issue-15`, `issue-16`, `issue-17`, `issue-19`, `issue-20`,
  `issue-21`, `issue-22`, `issue-23`, `issue-24`, `issue-27`, `issue-28`, `issue-29`,
  `issue-46`, plus two hash-prefixed siblings `issue-#18` and `issue-#29`. Note: there is
  no `issue-13` and no bare `issue-18`; issue 18 lives only under `issue-#18`. Most entries
  follow `submissions/issue-<N>/milestone-<N>/<team-name>/`, but `issue-5-milestone-2/`
  sits at the top level alongside `issue-5/` (which itself contains `milestone-1/` and
  `milestone-2/`).
- `submission/` — a small parallel tree (singular, not `submissions`) with four entries:
  `issue-18`, `issue-30`, `issue-58`, and `issue-#58`. Leave both trees intact as historical
  record; do not reconcile, merge, or rename them.
- `.gitignore` — single entry: `.DS_Store`.

## Conventions and Gotchas

- **This repo is archived event documentation.** Do not add new code, dependencies, build
  tooling, CI workflows, or scripts. Edits should be limited to correcting typos, fixing
  broken links, or appending clarifying notes to `winners.md` / `README.md`.
- **Preserve submission directory names verbatim.** Hash-prefixed paths
  (`submissions/issue-#18/`, `submissions/issue-#29/`, `submission/issue-#58/`) coexist with
  unprefixed siblings (`submissions/issue-29/`, `submission/issue-58/`). The
  `issue-5-milestone-2/` top-level folder is not redundant with `issue-5/milestone-2/` —
  both exist, with different content. Do not "normalize" any of these names.
- **The `submissions/` vs `submission/` split is intentional.** The singular-named folder
  is not a typo to fix; it is an independently committed tree.
- **HackerEarth links and Discord invites in README are historical.** Do not treat them as
  live calls to action; the event has ended. Flow's current FLIP process lives at
  `onflow/flips`.
- **`winners.md` uses HTML `<table>` markup** (not Markdown tables) to render team rosters
  with nested lists. Keep the HTML structure if editing rows.
- **Payout amounts in `winners.md` are final and denominated in USD** (paid out in FLOW at
  November average price, per the note at the top of the file). Do not modify amounts
  without an issue-and-correction trail as the file's top note instructs.

## Files Not to Modify

- `winners.md` — final event record; only correct typos or broken links, never amounts or
  team attributions without following the correction process noted at the top of the file.
- `submissions/**` and `submission/**` — archived team submissions; historical artifacts.
- `resources/flow-team-directory.csv` — historical contact data.
