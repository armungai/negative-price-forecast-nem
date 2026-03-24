## Quick Start

### 1. Set Up a GitHub Personal Access Token

You need this so Colab can push to GitHub on your behalf.

1. Go to [github.com/settings/tokens](https://github.com/settings/tokens)
2. Click **Generate new token (classic)**
3. Give it a name like `colab`
4. Select the **repo** scope (full control of private repositories)
5. Click **Generate token**
6. **Copy the token immediately** — you won't see it again

### 2. Save Your Token as a Colab Secret

1. Open any notebook in [Google Colab](https://colab.research.google.com)
2. Click the **🔑 key icon** in the left sidebar (Secrets)
3. Click **Add new secret**
4. Name: `GITHUB_TOKEN` — Value: paste your token
5. Toggle **Notebook access** on

### 3. Open a Notebook and Clone the Repo

At the top of every Colab session, run this cell:

```python
import os
from google.colab import userdata

# Your details
GITHUB_USERNAME = "your-username"       # ← change this
REPO_NAME = "your-repo-name"            # ← change this
GITHUB_TOKEN = userdata.get('GITHUB_TOKEN')

# Clone (only if not already cloned)
if not os.path.exists(REPO_NAME):
    !git clone https://{GITHUB_USERNAME}:{GITHUB_TOKEN}@github.com/OWNER_USERNAME/{REPO_NAME}.git

%cd {REPO_NAME}

# Set your git identity
!git config user.name "{GITHUB_USERNAME}"
!git config user.email "your-email@example.com"   # ← change this
```

Replace `OWNER_USERNAME` with whoever created the repo.

### 4. Do Your Work

Open or create notebooks in the `notebooks/` folder:

```python
# Example: open an existing notebook
# Just navigate in Colab's file browser (📁 icon) to your-repo-name/notebooks/

# Or create a new one and save it there
```

### 5. Push Your Changes

When you're done, run this cell:

```python
!git add -A
!git commit -m "describe what you did"
!git push
```

### 6. Pull Before You Start (Every Session)

Always pull latest changes at the start of a session:

```python
!git pull
```

---

## Avoiding Merge Conflicts

Notebook files (.ipynb) are JSON under the hood, so merge conflicts are messy. Follow these rules:

1. **One notebook per person per task** — don't edit the same notebook at the same time
2. **Clear outputs before pushing** — run `Cell → All outputs → Clear` or add this cell:
   ```python
   !pip install nbstripout -q
   !nbstripout notebooks/*.ipynb
   ```
3. **Pull before you push** — always `git pull` first
4. **Communicate** — let the group know in your chat when you're working on a specific file

---

## Project Structure

```
├── notebooks/          # All Jupyter notebooks go here
│   └── example.ipynb   # Starter notebook with setup cell
├── src/                # Shared Python code (importable modules)
│   └── __init__.py
├── data/               # Data files (gitignored — see below)
├── requirements.txt    # Shared pip dependencies
├── .gitignore
└── README.md
```

### About the `data/` folder

Large data files should NOT be pushed to GitHub. The `data/` folder is gitignored.

Instead, either:
- Upload data to Google Drive and mount it in Colab:
  ```python
  from google.colab import drive
  drive.mount('/content/drive')
  ```
- Use a shared Google Drive folder and link to it in your notebook
- For small reference files (<1MB), put them in `data/` and remove the gitignore entry

---

## Installing Shared Dependencies

If someone adds a new package, they should add it to `requirements.txt`:

```python
# Install all shared dependencies
!pip install -r requirements.txt -q
```

To add a new dependency:

```python
# Add it to requirements.txt
!echo "pandas" >> requirements.txt

# Then commit and push
!git add requirements.txt
!git commit -m "added pandas to requirements"
!git push
```

---

## Common Issues

| Problem | Fix |
|---------|-----|
| `fatal: Authentication failed` | Your token expired or is wrong — generate a new one (Step 2) |
| `error: failed to push` | Someone pushed before you — run `git pull` first, then push |
| Merge conflict in .ipynb | Don't try to fix it manually. Save your version elsewhere, run `git checkout --theirs notebook.ipynb`, then re-apply your changes |
| `ModuleNotFoundError` | Run `!pip install -r requirements.txt -q` |
| Can't find the repo after restarting | Colab resets the filesystem on restart — re-run the clone cell (Step 4) |

---

## Tips

- **Bookmark the clone cell** — you'll run it at the start of every session
- **Use `src/` for shared functions** — import them in notebooks with `from src.utils import my_function`
- **Name notebooks clearly** — e.g. `andrew_eda.ipynb`, `preprocessing_v2.ipynb`

