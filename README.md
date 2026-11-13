# claude-md-infra-ops

A single `CLAUDE.md` with judgment guidelines for LLM agents (Claude Code, Codex, etc.) that **query or change real infrastructure**.

[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) covers coding pitfalls. This file covers the ops side: checking before acting, verifying the real state, and reporting facts separately from guesses. It grew out of day-to-day work operating servers directly over SSH, with an agent in the loop.

SSH is where it started, not what it's limited to. The principles don't depend on any tool or environment, so they apply just as well when the agent works through AWS CLI, kubectl or anything else that touches live infrastructure. It's a set of shared judgment principles, not a command reference.

**English | [한국어](#한국어)**

## What's inside

| # | Principle | In one line |
|---|---|---|
| 1 | Stay in Scope | Questions and reviews allow necessary read-only checks; changes touch only what was asked |
| 2 | Decide Before Asking | Proceed within existing authorization; ask when scope, impact or required approval changes |
| 3 | Look at the Present First | The current system is the answer, not memory or old records |
| 4 | Verify the Real State | A successful command is not a finished task |
| 5 | Separate Facts from Guesses | Say "it can't be done" only after seeing the cause |
| 6 | Leave No Secrets Behind | No credentials in commands, logs or memory |

## Why six, not four

Infrastructure operations can affect running services and data beyond the files tracked in git. Mistakes at each stage have different consequences, so each stage gets its own principle.

| Stage | Typical ops mistake | Principle |
|---|---|---|
| Receiving the request | Widening scope and touching other targets | 1. Scope |
| Before acting | Running something irreversible without asking | 2. Decide |
| Looking things up | Trusting memory or records over the live system | 3. Present first |
| After acting | Mistaking a successful command for a finished task | 4. Verify |
| Reporting | Writing guesses as facts | 5. Facts vs guesses |
| Throughout | Leaving secrets behind in commands and logs | 6. Secrets |

"Surgical Changes" from the original splits into scope (1) and minimal change (4); "Goal-Driven Execution" carries over into verification (4). Principles 2, 3 and 6 address risks that become especially important in operations.

## Usage

Copy `CLAUDE.md` (English) or `CLAUDE.ko.md` (Korean, rename to `CLAUDE.md`) into your ops workspace. Then fill in the **Fill In Per Project** section: your tools, targets, permissions, off-limits resources, and completion and recovery criteria.

For Codex and other tools, use the same content as `AGENTS.md`.

If the destination already has a `CLAUDE.md` or `AGENTS.md`, merge the relevant sections into it instead of overwriting it. Preserve project-specific targets, permissions and restrictions. Resolve conflicting instructions before using the merged file for operations.

See [operating examples](EXAMPLES.md) for expected behavior in common situations and a [filled-in project example](EXAMPLES.md#example-project-settings) (English and Korean).

## What this is not

**This is not a safety mechanism.** Instruction files are context, not enforcement — agents can and sometimes do ignore them. Block irreversible actions (deletion, service stops, permission changes) with:

- a dedicated agent account with reduced permissions
- hooks / deny rules for destructive commands
- an access gateway or audit log that records what was run

This file improves how carefully the agent checks, verifies and reports. Pair it with real guardrails.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for bilingual updates and local document checks, and [evaluating agent behavior](EXAMPLES.md#evaluating-agent-behavior) for the case evaluation procedure and recording template. Expected behavior is documented; agent evaluation results have not yet been recorded.

## Credits

Inspired by [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), which turned Andrej Karpathy's observations on LLM coding pitfalls into a single CLAUDE.md.

## License

MIT

---

## 한국어

LLM 에이전트(Claude Code, Codex 등)가 **실제 인프라를 조회·변경**할 때 쓰는 판단 기준 `CLAUDE.md` 한 장입니다.

[andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)가 코딩 실수를 다룬다면, 이 파일은 운영 쪽을 다룹니다. 실행 전에 확인하고, 실제 상태로 검증하고, 사실과 추정을 나눠 보고하는 습관입니다. SSH로 서버를 직접 운영하면서 에이전트와 함께 일한 경험에서 나왔습니다.

SSH는 출발점일 뿐 적용 범위의 한계가 아닙니다. 원칙은 특정 도구나 환경에 묶이지 않아서, AWS CLI, kubectl 등 실제 인프라를 다루는 다른 도구로 작업할 때도 그대로 적용됩니다. 도구별 명령 모음이 아니라 공통 판단 원칙입니다.

**왜 4개가 아니라 6개인가:** 인프라 운영은 git이 추적하는 파일을 넘어 실행 중인 서비스와 데이터에 영향을 줄 수 있습니다. 요청·실행 전·조회·실행 후·보고 단계마다 실수의 결과가 달라서, 단계마다 원칙이 하나씩 필요합니다. 2(판정)·3(현재 조회)·6(비밀정보)은 운영에서 특히 중요해지는 위험을 다룹니다.

**사용법:** `CLAUDE.ko.md`를 운영 작업 폴더에 `CLAUDE.md`로 복사하고, 맨 아래 **프로젝트별로 채울 것**(도구, 작업 대상, 권한, 건드리면 안 되는 대상, 완료·복구 기준)을 채웁니다. Codex 등 다른 도구에서는 같은 내용을 `AGENTS.md`로 씁니다.

대상 폴더에 `CLAUDE.md`나 `AGENTS.md`가 이미 있으면 덮어쓰지 말고 필요한 내용을 병합합니다. 기존 프로젝트의 대상·권한·제한은 유지하고, 충돌하는 지시는 운영에 사용하기 전에 정리합니다.

흔한 상황에서 기대하는 행동은 [운영 예제](EXAMPLES.md#한국어), 각 항목의 작성 방법은 [프로젝트 설정 예시](EXAMPLES.md#프로젝트-설정-예시)를 참고하세요.

**기여·검증:** 한영 동시 수정과 로컬 문서 검사는 [기여 안내](CONTRIBUTING.md#한국어), 사례 평가 방법과 기록 양식은 [에이전트 행동 평가](EXAMPLES.md#에이전트-행동-평가)를 참고하세요. 기대 행동은 문서화되어 있으며, 실제 에이전트 평가 결과는 아직 기록되지 않았습니다.

**한계:** 이 문서는 안전장치가 아닙니다. 지시 파일은 강제가 아니라 참고용 맥락이라 에이전트가 무시할 수 있습니다. 삭제·중단·권한 변경처럼 되돌릴 수 없는 작업은 에이전트 전용 계정의 권한 축소, hook·deny 규칙, 접속 기록 도구로 따로 막으세요.
