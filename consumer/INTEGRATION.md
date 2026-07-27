# Consuming git-workflow

## Layout

`
your-project/
  .cursor/
    git-workflow/          ← submodule
    rules/
      korean-git-commit.mdc
      git-commit-on-finish.mdc
      local/               ← project overrides (not overwritten)
    skills/
      project-workflows/   ← synced skills
`

## Install

`powershell
powershell -File ..\git-workflow\scripts\install-as-submodule.ps1
`

## Update

`powershell
git submodule update --remote .cursor/git-workflow
powershell -File .cursor/git-workflow/scripts/sync-to-project.ps1
`
