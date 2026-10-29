# QA Agent Lab

## Язык
Отвечай на русском. Код, комментарии в коде и коммиты — на английском.

A learning lab for building and evaluating QA-focused AI workflows in Claude Code
(skills, subagents, prompts) against fictional test logs in `sample-logs/`.

## Scope of this file
These are behavioral instructions, not technical enforcement. Actual restrictions
come from permission settings (`.claude/settings.json`), the session's permission
mode, and each subagent's tool list. Follow these rules even where the tools would
allow more.

## Permitted without asking: read-only inspection
- Read, Grep, and Glob.
- Safe, read-only shell commands when the dedicated tools are not enough
  (e.g. `ls`, `cat`, `head`, `wc`, `find` without `-delete`/`-exec`, `grep`).
  No redirection to files, no pipes into commands that write or execute.

## Requires explicit authorization of the specific action
- Creating, editing, moving, or deleting any file.
- Destructive or state-changing commands (e.g. `rm`, `mv`, `chmod`, `git` writes).
- Installing packages or tools (`pip`, `npm`, `apt`, etc.).
- Network access of any kind (`curl`, `wget`, web fetch/search, external APIs).
- Running tests or application code.
Authorization covers only the action approved; it does not carry over to later
tasks. When a change would help, propose it (show the diff or contents) and wait.

## Evidence-based analysis
- Base every conclusion on something observable: quote the log line, file, or
  config it rests on, with `path:line` where possible.
- Do not invent errors, stack frames, timings, or system state. If evidence is
  missing, say "not shown" and name what would be needed.

## Separate facts, hypotheses, and recommendations
- **Fact (Confirmed):** directly observed; cite it.
- **Hypothesis:** an inference; give the reasoning, a confidence level, and what
  would confirm or refute it. Rank competing hypotheses rather than picking one.
- **Recommendation:** a proposed action for a human; concrete and safe. Never
  perform it yourself without authorization.

## Use existing Skills and subagents
- Test or CI failure analysis: use the `test-failure-analyzer` skill.
- Isolated investigation of specific, named log files: delegate to the
  `qa-log-investigator` subagent with the exact file paths.
- Their own definitions are the source of truth for analysis procedures and
  report formats; do not restate or override them here.

## Lab conventions
- All sample data is fictional (`.test` domains, made-up users). Keep it that way.
- When editing a skill or subagent (once authorized), keep its read-only and
  evidence rules consistent with this file.
