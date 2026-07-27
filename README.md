# git-workflow

커밋·푸시 관련 Cursor **룰/스킬**을 프로젝트에 공통으로 배포하기 위한 팩입니다.

다른 저장소에 git submodule로 넣은 뒤 sync 스크립트로 `.cursor/rules`와 `.cursor/skills`에 반영합니다.

## 포함 내용

| 종류 | 경로 | 역할 |
|------|------|------|
| Rule | `cursor/rules/korean-git-commit.mdc` | 한글 커밋 메시지 형식 |
| Rule | `cursor/rules/git-commit-on-finish.mdc` | 작업 완료 커밋·`+커푸` |
| Skill | `skills/project-workflows/korean-git-commit/` | 커밋/푸시 절차 |
| Skill | `skills/project-workflows/grouped-git-commit/` | 관심사별 묶음 커밋 |

## 설치

```powershell
# GitHub 원격(권장)
git submodule add git@github.com:<you>/git-workflow.git .cursor/git-workflow

# 로컬 절대 경로
git -c protocol.file.allow=always submodule add --force C:/Users/cykim/repo/git-workflow .cursor/git-workflow

powershell -File .cursor/git-workflow/scripts/sync-to-project.ps1
```

## 업데이트

```powershell
git submodule update --remote .cursor/git-workflow
powershell -File .cursor/git-workflow/scripts/sync-to-project.ps1
```

프로젝트 전용 오버라이드는 `.cursor/rules/local/`에 둡니다.
