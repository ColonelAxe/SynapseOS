# Development and release branches

- `dev` is the active integration branch. Put implementation, tests, previews and beta work here.
- `main` is the stable release branch. Keep it at the latest reviewed release.
- Prepare a release by reviewing and validating `dev`, then merge `dev` into `main` through a pull request. Publish mod updates from the resulting `main` commit.
- Never force-push either shared branch. Fix mistakes with follow-up commits or revert.
- Use short-lived branches from `dev` for larger isolated changes and merge them back into `dev`.

The local checkout is configured on `dev`. To confirm or switch:

```powershell
git status --short --branch
git switch dev
git pull
```

To promote a tested build, open a pull request from `dev` to `main`, review the changes and release notes, merge it, then tag/package that `main` commit. This repository currently has no automated branch protection configured, so take care to keep routine work on `dev`.
