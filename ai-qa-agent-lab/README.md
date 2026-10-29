# QA Agent Lab

An educational project for learning how to extend Claude Code with **skills** and **subagents**, using a QA use case: analyzing failed automated tests.

## Structure

```
ai-qa-agent-lab/
├── .claude/
│   ├── settings.json             # Permission rules (ask before Bash/Edit/Write/Web*)
│   ├── agents/
│   │   └── qa-log-investigator.md  # Read-only subagent for named log files
│   └── skills/
│       └── test-failure-analyzer/
│           └── SKILL.md          # Skill definition loaded by Claude Code
├── sample-logs/
│   ├── login-failure.txt         # Fictional pytest run: failed login test (401)
│   └── api-timeout.txt           # Fictional pytest run: API ReadTimeout
├── CLAUDE.md                     # Project instructions for Claude
└── README.md
```

## How skills work

Claude Code discovers project skills in `.claude/skills/<skill-name>/SKILL.md`. Each skill has:

- **YAML frontmatter** with `name` and `description`. Claude reads the description to decide when the skill is relevant.
- **A Markdown body** with the instructions Claude follows once the skill is loaded.

## The `test-failure-analyzer` skill

The skill turns Claude into a careful, read-only test-failure analyst. It:

- Explains how to read pytest tracebacks, assertion failures, timeouts, and availability errors.
- Requires quoting log evidence before suggesting any root cause.
- Labels each claim as **Confirmed** (seen in the log) or **Hypothesis** (inferred).
- Never modifies code or runs commands during analysis.
- Produces a structured report: **failure summary, evidence, likely cause, confidence, next diagnostic step**.

## The `qa-log-investigator` subagent

A read-only subagent (`.claude/agents/qa-log-investigator.md`) for isolated investigation
of specific log files. It:

- Reads only the log files explicitly named in the task; its only tool is `Read`.
- Cites exact log lines as evidence and labels claims as **Confirmed** or **Hypothesis**.
- Returns a structured report: summary, evidence, timeline, likely root cause, confidence,
  next diagnostic step.

Example: `Use qa-log-investigator to analyze sample-logs/api-timeout.txt`

## Try it

Start Claude Code in this folder and ask, for example:

```
Analyze sample-logs/login-failure.txt
```

```
Why did the test in sample-logs/api-timeout.txt fail?
```

You can also invoke the skill explicitly with `/test-failure-analyzer`.

Things to notice in the output:

- Does every hypothesis cite a quoted log line?
- Is the confidence level justified?
- Is the next diagnostic step concrete and safe?

## Safety

- All logs are **fictional**: hosts use the reserved `.test` domain, and users and data are made up.
- The project installs no packages, calls no external services, and contains no executable code.
- `.claude/settings.json` requires confirmation for `Bash`, `Edit`, `Write`, `NotebookEdit`,
  `WebFetch`, and `WebSearch`, and disables bypass-permissions mode.
