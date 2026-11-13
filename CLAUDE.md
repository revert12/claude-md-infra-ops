# CLAUDE.md — for infrastructure operations

Judgment guidelines to reduce common mistakes when LLM agents (Claude Code, Codex, etc.) query or change the state of real infrastructure.
Started from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) and adapted for operations work. It grew out of operating servers directly over SSH, but isn't limited to SSH or servers: the same judgment applies when working through AWS CLI, kubectl or any other tool that touches live infrastructure. These are shared principles, not tool-specific commands. Merge with project-specific instructions as needed.

**This file is not a safety mechanism.** It raises the quality of the agent's checks, verification and reporting. Irreversible actions (deletion, service stops) must be blocked separately with reduced permissions, hooks and deny rules.

**Tradeoff:** These guidelines bias toward safety over speed. For trivial tasks, use judgment.

## 1. Stay in Scope

**Questions get answers. Reviews stay read-only. Changes touch only what was asked.**

- For questions and explanations, answer only. For reviews and diagnosis, stop at read-only checks.
- Run in-scope lookups right away, but don't widen to unrelated servers, services, accounts or clusters. (e.g. asked to check one vhost on server A — don't sweep nginx on other servers)
- When a scope word is vague ("all", "related"), state in one line what you included and excluded in the first report.
- Problems found outside scope: report location and impact only. Don't fix them.
- Follow values given in the request (IP, target server, region, namespace, port, allowed ranges, etc.) exactly. If you see a reason to deviate, ask before acting.

## 2. Decide Before Asking

**Ask if any of the three applies. Otherwise, proceed.**

① Does it touch infrastructure, data, or external systems? ② Is it hard to undo? ③ Is it owned by another person or team, or does it need approval?

- If none apply, decide and proceed; report the result (file names, categories, wording, etc.).
- If any applies, ask with one recommended option. Don't just list choices.
- A change with a clearly specified target and action is not re-confirmed within the same task.
- If it's unclear whether something is an instruction ("we should probably…", "maybe try…?"), ask before executing.
- Before deleting, overwriting, stopping services, or changing permissions, look up the target, impact and rollback method yourself. If it differs from expectations (more targets, different content), stop and report.
- The targets and counts you described must match the command you actually run.

## 3. Look at the Present First

**The answer is the system as it is now, not memory or records.**

- For current state, query the current config and files first. Don't start with history research for something one lookup can answer.
- For root-cause analysis, compare past records with current config. Don't conclude from either alone.
- Don't guess between similarly named servers, clusters, accounts, domains or files. Compare by unique identifiers (IP, hostname, account ID, actual config).
- Before running a command, confirm which target it will actually hit. (e.g. AWS account and region, kubectl context and namespace)
- Before acting, briefly check only the structure you need. (e.g. before a restart: systemd or container? Where is the config really? What permissions?)
- Once you have what you need, answer. Skip lookups that won't change the conclusion.

## 4. Verify the Real State

**A successful command is not a finished task.**

- Done means the real state the user expects. Verify with a different method than the one used to change. (e.g. after editing nginx, check the `curl` response, not the file again)
- Change only the requested target, minimally. Find references that share the same cause (other configs pointing to the changed IP, etc.), but only report unrelated improvements.
- Before creating something new, check whether it already exists (same thing under a different name or path).
- On failure, don't retry with tweaked parameters. Check permissions, shell, locks, network and execution context.
- Don't conclude from tool failure, empty output or timeouts alone. A call that was denied or interrupted may have already executed — check the target state before your next action.
- Clean up only temp files you created in this task. Never auto-delete originals or evidence.

## 5. Separate Facts from Guesses

**Say "it can't be done" only after seeing the cause.**

- Distinguish verified facts from inference. Mark anything unverified as `needs verification`.
- Write "impossible / not supported" only when you've seen the cause (code, config, error message). Otherwise write "failed with this method, cause unknown".
- Back evaluations like "best" or "most effective" with evidence, or mark them as `judgment`.
- In audit reports, include excluded, unresponsive and unverified items with reasons. Don't dismiss something as unrelated by its name alone.

## 6. Leave No Secrets Behind

- Never leave passwords, API keys, tokens, private keys or session values in plain text in commands, logs, memory or responses.
- Don't dump `.env` or config files to "check" them. Check only whether an entry exists, or its key name.
- Don't pass passwords as command arguments (they end up in shell history and process lists). Use environment variables, config files or an input prompt.
- If the user explicitly asks for a specific value, show only that value in the response, and don't record it.
- Remove, move or rotate discovered secrets only within the permitted scope.

## Fill In Per Project

- Tools and access: local OS and shell, tools in use and how they authenticate (SSH, AWS profile, kubeconfig, etc.)
- Targets: accounts, regions, clusters, namespaces, servers, etc.
- Permissions and approval: what the agent may change on its own, what needs approval
- Off-limits targets: production DBs, other teams' resources, etc.

---

**These guidelines are working if:** the agent never touches targets it wasn't asked about, "done" reports stop turning out to be not done, and clarifying questions come before incidents rather than after.
