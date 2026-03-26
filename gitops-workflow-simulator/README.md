# 🔄 Project 1: GitOps Workflow Simulator

> **Week 1 — Git Version Control | DevOps Learning Journey**
> **Author:** Krishna Chavan

A hands-on project that **simulates the complete GitOps workflow** — from a developer bumping an app version all the way to automated manifest updates via GitHub Actions. No Kubernetes cluster needed.

---

## 🎯 What is GitOps?

GitOps is a way of doing operations where **Git is the single source of truth** for your infrastructure and application state.

```
Developer pushes code
       ↓
Git detects change
       ↓
CI/CD pipeline triggers automatically
       ↓
Pipeline builds image & updates Kubernetes manifests in Git
       ↓
GitOps controller sees manifest change → applies to cluster
       ↓
Cluster state matches Git state ✅
```

---

## 📁 Project Structure

```
gitops-workflow-simulator/
├── app/
│   └── version.txt              ← Bump this to trigger the pipeline!
├── manifests/
│   ├── dev/deployment.yaml      ← Auto-updated by GitHub Actions
│   ├── staging/deployment.yaml  ← Auto-updated by GitHub Actions
│   └── prod/deployment.yaml     ← Manually promoted (best practice)
├── scripts/
│   └── update-manifest.sh       ← Reusable manifest update script
├── simulate-gitops.sh            ← Run the full flow locally
└── README.md
```

And in `.github/workflows/`:
```
.github/workflows/
└── gitops-simulator.yml         ← The GitHub Actions GitOps pipeline
```

---

## 🚀 How to Use This Project

### Option A: Trigger via GitHub (Real GitOps!)

1. Edit `app/version.txt` — change `v1.0.0` to `v1.1.0`
2. Commit and push:
   ```bash
   git add gitops-workflow-simulator/app/version.txt
   git commit -m "feat: bump app version to v1.1.0"
   git push
   ```
3. Watch GitHub Actions run → it will **auto-update `manifests/dev/` and `manifests/staging/`**
4. Pull the changes: `git pull` → see the updated image tags

### Option B: Simulate Locally (Linux/Mac/WSL)

```bash
cd gitops-workflow-simulator
bash simulate-gitops.sh
```

This runs the full 6-step GitOps simulation and auto-increments the patch version.

---

## 🌍 Environment Promotion Strategy

| Environment | Updated By | Strategy |
|---|---|---|
| **dev** | GitHub Actions (auto) | Every push to `main` |
| **staging** | GitHub Actions (auto) | Every push to `main` |
| **prod** | Manual (Team Lead) | After staging validation |

> **Why manual for PROD?** This is a DevOps best practice — automated pipelines should never    auto-deploy to production without human approval.

---

## 🔑 Key Concepts Learned

### 1. `sed` for Manifest Updates
```bash
# Replace the image tag in-place — this is the core GitOps pattern
sed -i "s|image: app:.*|image: app:v1.1.0|g" manifests/dev/deployment.yaml
```

### 2. GitHub Actions `[skip ci]`
The pipeline commits updated manifests back to the repo with `[skip ci]` in the commit message to prevent an infinite loop of pipeline triggers.

### 3. Declarative Configuration
The manifests in `manifests/` describe the *desired state*. A GitOps controller (like ArgoCD or Flux) would continuously reconcile the actual cluster state to match this desired state.

### 4. Rollback = `git revert`
```bash
# Instant rollback — revert the manifest update commit
git revert HEAD
git push
```
The previous image tag is restored in Git → pipeline auto-deploys the old version.

---

## 📸 GitOps Pipeline Flow

```
 app/version.txt  →  GitHub Actions  →  sed updates manifests  →  git commit & push
      (change)         (triggered)          (dev + staging)          (back to repo)
```

---

## 🧰 Technologies Used

`Git` · `GitHub Actions` · `Bash/Shell Scripting` · `sed` · `YAML` · `Kubernetes Manifests` · `GitOps Pattern`

---

## ⏭️ Next Steps

- Replace simulated Docker build with a real `docker build` + `docker push`
- Add a manual approval gate for prod promotion using GitHub Environments
- Integrate with ArgoCD to apply manifests to a real Kubernetes cluster
- Add Slack/email notifications on deployment
