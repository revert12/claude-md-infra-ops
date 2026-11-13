# claude-md-infra-ops

A single `CLAUDE.md` with judgment guidelines for LLM agents (Claude Code, Codex, etc.) that **query or change real infrastructure**.

[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) covers coding pitfalls. This file covers the ops side: checking before acting, verifying the real state, and reporting facts separately from guesses. It grew out of day-to-day work operating servers directly over SSH, with an agent in the loop.

SSH is where it started, not what it's limited to. The principles don't depend on any tool or environment, so they apply just as well when the agent works through AWS CLI, kubectl or anything else that touches live infrastructure. It's a set of shared judgment principles, not a command reference.

**English | [한국어](#한국어)**

## What's inside

| # | Principle | In one line |
|---|---|---|
| 1 | Stay in Scope | Questions get answers, reviews stay read-only, changes touch only what was asked |
| 2 | Decide Before Asking | Ask only if it touches systems, is hard to undo, or belongs to someone else / needs approval |
| 3 | Look at the Present First | The current system is the answer, not memory or old records |
| 4 | Verify the Real State | A successful command is not a finished task |
| 5 | Separate Facts from Guesses | Say "it can't be done" only after seeing the cause |
| 6 | Leave No Secrets Behind | No credentials in commands, logs or memory |

## Why six, not four

Coding is mostly one action — editing code — and git can undo it. Operations fail differently at each stage, so each stage gets its own principle.

| Stage | Typical ops mistake | Principle |
|---|---|---|
| Receiving the request | Widening scope and touching other targets | 1. Scope |
| Before acting | Running something irreversible without asking | 2. Decide |
| Looking things up | Trusting memory or records over the live system | 3. Present first |
| After acting | Mistaking a successful command for a finished task | 4. Verify |
| Reporting | Writing guesses as facts | 5. Facts vs guesses |
| Throughout | Leaving secrets behind in commands and logs | 6. Secrets |

"Surgical Changes" from the original splits into scope (1) and minimal change (4); "Goal-Driven Execution" carries over into verification (4). Principles 2, 3 and 6 come from risks that coding doesn't have.

## Usage

Copy `CLAUDE.md` (English) or `CLAUDE.ko.md` (Korean, rename to `CLAUDE.md`) into your ops workspace. Then fill in the **Fill In Per Project** section: your tools, targets, permissions and off-limits resources.

For Codex and other tools, use the same content as `AGENTS.md`.

## What this is not

**This is not a safety mechanism.** Instruction files are context, not enforcement — agents can and sometimes do ignore them. Block irreversible actions (deletion, service stops, permission changes) with:

- a dedicated agent account with reduced permissions
- hooks / deny rules for destructive commands
- an access gateway or audit log that records what was run

This file improves how carefully the agent checks, verifies and reports. Pair it with real guardrails.

## Credits

Inspired by [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), which turned Andrej Karpathy's observations on LLM coding pitfalls into a single CLAUDE.md.

## License

MIT

---

## 한국어

LLM 에이전트(Claude Code, Codex 등)가 **실제 인프라를 조회·변경**할 때 쓰는 판단 기준 `CLAUDE.md` 한 장입니다.

[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)가 코딩 실수를 다룬다면, 이 파일은 운영 쪽을 다룹니다. 실행 전에 확인하고, 실제 상태로 검증하고, 사실과 추정을 나눠 보고하는 습관입니다. SSH로 서버를 직접 운영하면서 에이전트와 함께 일한 경험에서 나왔습니다.

SSH는 출발점일 뿐 적용 범위의 한계가 아닙니다. 원칙은 특정 도구나 환경에 묶이지 않아서, AWS CLI, kubectl 등 실제 인프라를 다루는 다른 도구로 작업할 때도 그대로 적용됩니다. 도구별 명령 모음이 아니라 공통 판단 원칙입니다.

**왜 4개가 아니라 6개인가:** 코딩은 대부분 "코드 수정" 한 가지이고 git으로 되돌릴 수 있습니다. 운영은 요청·실행 전·조회·실행 후·보고 단계마다 실수하는 방식이 달라서, 단계마다 원칙이 하나씩 필요합니다. 2(판정)·3(현재 조회)·6(비밀정보)은 코딩에는 없던 운영 고유의 위험에서 나왔습니다.

**사용법:** `CLAUDE.ko.md`를 운영 작업 폴더에 `CLAUDE.md`로 복사하고, 맨 아래 **프로젝트별로 채울 것**(도구, 작업 대상, 권한, 건드리면 안 되는 대상)을 채웁니다. Codex 등 다른 도구에서는 같은 내용을 `AGENTS.md`로 씁니다.

**한계:** 이 문서는 안전장치가 아닙니다. 지시 파일은 강제가 아니라 참고용 맥락이라 에이전트가 무시할 수 있습니다. 삭제·중단·권한 변경처럼 되돌릴 수 없는 작업은 에이전트 전용 계정의 권한 축소, hook·deny 규칙, 접속 기록 도구로 따로 막으세요.
