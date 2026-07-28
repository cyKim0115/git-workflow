# git-workflow

커밋·푸시 관련 Cursor **룰/스킬**을 프로젝트에 공통으로 배포하기 위한 팩입니다.

다른 저장소에 git submodule로 넣은 뒤 sync 스크립트로 `.cursor/rules`와 `.cursor/skills`에 반영합니다.

## 포함 내용

| 종류 | 경로 | 역할 |
|------|------|------|
| Rule | `cursor/rules/korean-git-commit.mdc` | 한글 커밋 메시지 형식 |
| Rule | `cursor/rules/git-commit-on-finish.mdc` | 작업 완료 커밋·`+커푸` |
| Skill | `skills/project-workflows/korean-git-commit/` | 커밋/푸시 절차 |
| Skill | `skills/project-workflows/grouped-git-commit/` | 관심사별 묶음 커밋 · 「전체」단위 분할 |

## 설치

```powershell
# HTTPS (키 없이 / 다른 사람용 — 권장 기본 예시)
git submodule add https://github.com/<owner>/git-workflow.git .cursor/git-workflow

# SSH (키가 설정된 경우)
git submodule add git@github.com:<owner>/git-workflow.git .cursor/git-workflow

# 로컬 절대 경로
git -c protocol.file.allow=always submodule add --force /absolute/path/to/git-workflow .cursor/git-workflow

powershell -File .cursor/git-workflow/scripts/sync-to-project.ps1
```

또는 설치 스크립트:

```powershell
# HTTPS
powershell -File ..\git-workflow\scripts\install-as-submodule.ps1 -PackUrl https://github.com/<owner>/git-workflow.git

# SSH
powershell -File ..\git-workflow\scripts\install-as-submodule.ps1 -PackUrl git@github.com:<owner>/git-workflow.git
```

## 업데이트

```powershell
git submodule update --remote .cursor/git-workflow
powershell -File .cursor/git-workflow/scripts/sync-to-project.ps1
```

프로젝트 전용 오버라이드는 `.cursor/rules/local/`에 둡니다.
