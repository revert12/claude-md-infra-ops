# Contributing

Keep the six principles concise and tool-independent. Add operational detail to [EXAMPLES.md](EXAMPLES.md) when an example explains the rule better than another instruction.

- Update `CLAUDE.md` and `CLAUDE.ko.md` together when changing behavior. Keep the English and Korean examples aligned too.
- Describe the failure a change addresses and the expected agent behavior. Use the [evaluation procedure](EXAMPLES.md#evaluating-agent-behavior) for behavior claims; distinguish expected behavior from observed results.
- Use fictional targets and sanitized evidence. Don't include credentials or live infrastructure access.

Run these checks from the repository root with PowerShell (Windows PowerShell 5.1 or PowerShell 7):

```powershell
./scripts/check-docs.ps1
git diff --check
```

The script checks root Markdown files for local link targets, heading anchors, trailing whitespace and a final newline. It doesn't check external URLs or translation accuracy; review both languages manually.

## 한국어

여섯 원칙은 간결하고 도구에 종속되지 않게 유지합니다. 지시를 늘리는 것보다 예제로 설명하는 편이 나으면 [EXAMPLES.md](EXAMPLES.md)에 운영 세부사항을 추가합니다.

- 행동 기준을 바꾸면 `CLAUDE.md`와 `CLAUDE.ko.md`를 함께 수정합니다. 영문·한글 예제도 같은 의미를 유지합니다.
- 어떤 실패를 줄이려는 변경인지와 기대 행동을 설명합니다. 효과를 주장할 때는 [평가 절차](EXAMPLES.md#에이전트-행동-평가)를 따르고 기대 행동과 실제 관측 결과를 구분합니다.
- 가상 대상과 비밀정보를 제거한 증거를 사용합니다. 인증정보나 실제 인프라 접속 정보를 넣지 않습니다.

저장소 루트에서 위 PowerShell 명령으로 검사합니다. 스크립트는 루트 Markdown의 로컬 링크·제목 앵커·줄 끝 공백·마지막 줄바꿈을 검사합니다. 외부 URL과 번역 정확성은 검사하지 않으므로 두 언어를 직접 검토합니다.
