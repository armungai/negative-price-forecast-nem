# NEM Negative Price Forecast

Predicting negative wholesale electricity price events in Australia's National Electricity Market using machine learning.

---

## Setup

### 1. Clone the Repo

```bash
git clone https://github.com/OWNER-USERNAME/negative-price-forecast-nem.git
cd negative-price-forecast-nem
```

### 2. Install Dependencies

```bash
pip install -r requirements.txt
```

### 3. Set Your Git Identity

```bash
git config user.name "Your Name"
git config user.email "your-email@example.com"
```
---

## Daily Workflow

### Start of session — pull latest changes

```bash
git pull
```

### Do your work

Open notebooks in VS Code or run `jupyter notebook` in the terminal.

### Push your changes

```bash
git add -A
git commit -m "describe what you did"
git push
```

If the push fails, someone else pushed first. Just pull and push again:

```bash
git pull
git push
```
---

## Project Structure

```
├── notebooks/          # Jupyter notebooks (one per person per task)
├── src/                # Shared Python modules
│   └── __init__.py
├── data/               # Data files (gitignored — don't push these)
├── requirements.txt    # Shared pip dependencies
├── .gitignore
└── README.md
```

---

## Rules to Avoid Merge Conflicts

1. **One notebook per person per task** — name them clearly, e.g. `andrew_eda.ipynb`, `ashton_model_v1.ipynb`
2. **Clear outputs before committing** — in VS Code: click `⋯` at the top of the notebook → `Clear All Outputs`
3. **Always pull before you push**
4. **Let the group know** when you're working on a shared file

---

## Data

The `data/` folder is gitignored — large files don't belong in GitHub.

To share data with the team, we will use a shared Google Drive or OneDrive folder and link to it here:

**Shared data folder:** need to do this... 

For small reference files (<1MB), you can remove the gitignore entry and push them directly.

---

## Adding a New Dependency

If you need a new package:

1. Install it: `pip install package-name`
2. Add it to `requirements.txt`
3. Commit and push so everyone else can install it

---

## Common Issues

| Problem | Fix |
|---------|-----|
| `error: failed to push` | Run `git pull` first, then `git push` |
| Merge conflict in .ipynb | Save your work elsewhere, run `git checkout --theirs notebook.ipynb`, re-apply your changes |
| `ModuleNotFoundError` | Run `pip install -r requirements.txt` |

---
