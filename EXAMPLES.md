# Operating examples

These examples illustrate the guidelines. Project-specific permissions and approval requirements still apply.

| Request or situation | Expected behavior |
|---|---|
| "Check server A's status." | Run necessary read-only checks on A and report the findings. Don't restart services or inspect unrelated servers. |
| "Should we restart the service?" | Diagnose with necessary read-only checks and recommend an action. The question alone doesn't authorize a restart. |
| "Restart service X on server A." | Confirm the actual target and relevant impact. If covered by the request and project permissions, proceed without asking again; verify recovery using health checks and an actual request. |
| The active account differs from the authorized target. | Stop before changing anything. Report the mismatch and confirm the intended account; don't substitute another target. |
| A resource creation request times out. | Check whether the resource exists and its current state before deciding whether to retry. A timeout doesn't prove creation failed. |
| A configuration change fails verification. | Follow the recovery criteria defined before the change. If rollback could cause data loss or additional downtime outside existing authorization, ask before rolling back. |
| Another operator changes the config after inspection or before rollback. | Stop before overwriting it. Reassess the current state and recovery plan; don't restore an old backup over the other operator's work. |
| A required verification check is unavailable before the change. | Follow the project's pre-change criteria. In the staging example below, stop before editing; a `needs verification` label doesn't authorize bypassing that requirement. |
| An nginx access restriction was changed and an allowed request succeeds. | Also check that a request that should be blocked is denied. If that check can't be performed, report it as needing verification; don't claim the restriction is fully verified. |
| The user asks whether an API key is configured. | Check presence only and report it. Don't print the key or the entire configuration file. |
| "Fix the wording in this document." | Edit that document within the request. Don't rewrite other files just because local changes are easy to undo. |
| While changing an IP, a related reference outside the change scope is found. | Report its location and impact. Don't update it automatically; ask before expanding the change or lookup scope. |
| Historical logs are unavailable during diagnosis. | Analyze the available current state, report the missing evidence and label hypotheses as inference. Don't claim a confirmed cause without sufficient evidence. |

## Example project settings

This fictional staging environment shows how to fill in **Fill In Per Project**. Replace the values and have the project owner confirm the permissions and recovery criteria before use. This example grants no access to real systems.

| Field | Example value |
|---|---|
| Tools and access | Linux, Bash, OpenSSH and systemd. Connect using SSH alias `staging-web-01` with a dedicated agent account and an SSH agent; no credentials in this file. |
| Targets | Only `staging-web-01`, the `nginx` service, `/etc/nginx/conf.d/demo.conf` and the task-specific backup path `/var/backups/infra-ops/demo/<task-id>/demo.conf` on that host. Keep backups outside nginx's loaded configuration paths. Confirm the alias resolves to the intended staging host before running commands. |
| Permissions and approval | Read-only diagnosis of this host and service is allowed within the task. An explicit request to apply this config change authorizes creating the task-specific backup directory and file, editing the config, validating it and reloading nginx, plus the recovery steps below. Preserve the config's access restrictions on the backup. Service stops, restarts, package installs and other permission changes need separate approval. |
| Off-limits targets | Production hosts, databases, other virtual hosts and other teams' resources. Report dependencies outside this scope; don't inspect or change them without authorization. |
| Before changing | Validate the existing config, check nginx state and run the same health and access checks used for completion. Record the observed results and expected differences after the change; access rules being changed may legitimately produce different responses beforehand. If the config is invalid, the service is unhealthy or required checks can't be performed, stop and report before editing. Save the inspected config to a new task-specific backup without overwriting an existing backup. Immediately before writing, compare the live config with that backup; stop on differences. Coordinate exclusive access with other operators or use a supported lock covering the change and recovery; a comparison alone doesn't prevent concurrent writes. Record the exact config written by this task for comparison before recovery. |
| Completion criteria | For an access-rule change: config validation passes, nginx is active, an allowed client gets HTTP 200 from `/healthz`, and a blocked client gets HTTP 403. Check three times, 10 seconds apart. If a required check becomes unavailable after editing, report it as needing verification and don't claim completion. Stop further changes and report the current state; an unavailable check alone doesn't authorize rollback. An observed failure follows the recovery criteria below. |
| Stop and recovery criteria | No downtime is authorized. Before either recovery path below, compare the live config with the exact config written by this task. If it differs or the comparison can't be made, stop and report; don't overwrite another operator's work. If validation fails, restore the backup and validate it without reloading. If reload fails or an observed health or access check fails, restore the backup once, validate it, and reload only if valid. After either recovery path, repeat the health and access checks three times, 10 seconds apart, against the recorded pre-change expectations. Report whether recovery was verified and identify any failed or unverified checks. If recovery fails, stop changes and report the state. Don't restart the service or restore data without separate approval. |

## 한국어

이 예제는 지침의 적용 방식을 설명합니다. 프로젝트별 권한·승인 조건도 함께 적용합니다.

| 요청 또는 상황 | 기대 행동 |
|---|---|
| "서버 A 상태 확인해줘." | A에 필요한 읽기 전용 확인을 하고 결과를 보고한다. 서비스를 재시작하거나 무관한 서버를 조회하지 않는다. |
| "서비스를 재시작해야 할까?" | 필요한 읽기 전용 진단 후 권고한다. 질문만으로 재시작이 승인된 것은 아니다. |
| "서버 A의 서비스 X를 재시작해줘." | 실제 대상과 관련 영향을 확인한다. 요청과 프로젝트 권한에 포함되면 다시 묻지 않고 진행하고, 상태 점검과 실제 요청으로 복구를 검증한다. |
| 현재 계정이 승인된 대상과 다르다. | 변경 전에 멈춘다. 불일치를 보고하고 의도한 계정을 확인한다. 다른 대상으로 임의 대체하지 않는다. |
| 리소스 생성 요청이 타임아웃됐다. | 리소스 존재 여부와 현재 상태를 조회한 뒤 재시도를 판단한다. 타임아웃만으로 생성 실패를 단정하지 않는다. |
| 설정 변경 후 검증에 실패했다. | 변경 전에 정한 복구 기준을 따른다. 원복이 기존 승인 범위를 벗어나는 데이터 손실이나 추가 중단을 일으킬 수 있으면 실행 전에 묻는다. |
| 조회 후 또는 원복 전에 다른 운영자가 설정을 변경했다. | 덮어쓰기 전에 멈춘다. 현재 상태와 복구 계획을 다시 판단하고, 오래된 백업으로 다른 운영자의 작업을 덮어쓰지 않는다. |
| 변경 전부터 필수 검사를 수행할 수 없다. | 프로젝트의 변경 전 기준을 따른다. 아래 스테이징 예시에서는 수정 전에 멈춘다. `검증 필요` 표시는 이 조건을 건너뛸 권한이 아니다. |
| nginx 접근 제한을 변경했고 허용된 요청이 성공했다. | 차단되어야 할 요청이 거부되는지도 확인한다. 확인할 수 없으면 `검증 필요`로 보고하고 접근 제한 전체를 검증했다고 하지 않는다. |
| "API 키가 설정되어 있어?" | 존재 여부만 확인해 보고한다. 키 값이나 설정 파일 전체를 출력하지 않는다. |
| "이 문서의 표현을 다듬어줘." | 요청 범위 안에서 해당 문서를 수정한다. 로컬 변경을 되돌리기 쉽다는 이유로 다른 파일까지 고치지 않는다. |
| IP 변경 중 수정 범위 밖의 관련 참조가 발견됐다. | 위치와 영향을 보고한다. 자동으로 수정하지 않고, 수정이나 조회 범위를 넓히기 전에 묻는다. |
| 원인 분석에 필요한 과거 로그를 확보할 수 없다. | 확보한 현재 상태로 분석하되 누락된 증거를 보고하고 가설은 추정으로 표시한다. 증거가 부족한 상태에서 원인을 확정하지 않는다. |

## 프로젝트 설정 예시

가상의 스테이징 환경으로 **프로젝트별로 채울 것**의 작성 방법을 보여줍니다. 실제 값으로 바꾸고, 사용 전에 프로젝트 책임자에게 권한과 복구 기준을 확인받습니다. 이 예시 자체는 실제 시스템에 대한 권한을 부여하지 않습니다.

| 항목 | 작성 예 |
|---|---|
| 도구·접속 방식 | Linux, Bash, OpenSSH, systemd. 에이전트 전용 계정과 SSH agent로 SSH 별칭 `staging-web-01`에 접속한다. 이 파일에 인증정보를 적지 않는다. |
| 작업 대상 | `staging-web-01`의 `nginx` 서비스, `/etc/nginx/conf.d/demo.conf`, 같은 호스트의 작업별 백업 경로 `/var/backups/infra-ops/demo/<task-id>/demo.conf`만 대상이다. 백업은 nginx가 읽어 들이는 설정 경로 밖에 둔다. 명령 실행 전에 별칭이 의도한 스테이징 호스트를 가리키는지 확인한다. |
| 권한·승인 범위 | 작업 범위 안에서 이 호스트·서비스의 읽기 전용 진단을 허용한다. 해당 설정 변경의 적용을 명시적으로 요청받으면 작업별 백업 디렉터리·파일 생성, 설정 수정·검증, nginx reload와 아래 복구 절차를 허용한다. 백업에도 원본 설정의 접근 제한을 유지한다. 서비스 중단·재시작, 패키지 설치, 그 밖의 권한 변경은 별도 승인이 필요하다. |
| 건드리면 안 되는 대상 | 운영 호스트, 데이터베이스, 다른 vhost, 다른 팀 리소스. 범위 밖 의존성은 보고하고, 승인 없이 조회하거나 변경하지 않는다. |
| 변경 전 확인 | 기존 설정을 검증하고 nginx 상태와 완료 기준에 사용할 상태·접근 검사를 수행한다. 관측 결과와 변경 후 예상 차이를 기록한다. 변경하려는 접근 규칙은 적용 전 응답이 달라도 정상일 수 있다. 기존 설정이 유효하지 않거나 서비스가 비정상이거나 필요한 검사를 수행할 수 없으면 수정 전에 멈추고 보고한다. 확인한 설정을 새 작업별 백업에 저장하고 기존 백업은 덮어쓰지 않는다. 쓰기 직전에 실제 설정과 백업을 비교하고 다르면 멈춘다. 다른 운영자와 변경·복구 동안의 독점 작업을 조율하거나 지원되는 잠금을 사용한다. 비교만으로 동시 변경을 막을 수는 없다. 복구 전 비교할 수 있도록 이 작업에서 쓴 정확한 설정을 기록한다. |
| 완료 기준 | 접근 규칙 변경 시 설정 검증 통과, nginx 활성 상태, 허용 클라이언트의 `/healthz` HTTP 200, 차단 클라이언트의 HTTP 403을 확인한다. 10초 간격으로 3회 확인한다. 수정 후 필수 검사를 수행할 수 없게 되면 해당 조건을 `검증 필요`로 보고하고 완료로 처리하지 않는다. 추가 변경을 멈추고 현재 상태를 보고한다. 검사 불가만으로 원복이 승인되지는 않는다. 관측한 실패는 아래 복구 기준을 따른다. |
| 중단·복구 기준 | 중단은 허용하지 않는다. 아래 어느 복구 경로든 실행 전에 실제 설정과 이 작업에서 쓴 정확한 설정을 비교한다. 다르거나 비교할 수 없으면 멈추고 보고하며 다른 운영자의 작업을 덮어쓰지 않는다. 설정 검증 실패 시 백업을 복원하고 reload 없이 설정을 검증한다. reload 실패 또는 관측한 상태·접근 검사 실패 시 백업을 한 번 복원하고, 설정 검증을 통과한 경우에만 reload한다. 어느 복구 경로든 변경 전 기록한 기대 상태를 기준으로 상태·접근 검사를 10초 간격으로 3회 다시 수행한다. 복구 검증 여부와 실패·미확인 항목을 보고한다. 복구도 실패하면 변경을 멈추고 상태를 보고한다. 서비스 재시작이나 데이터 복원은 별도 승인을 받는다. |
