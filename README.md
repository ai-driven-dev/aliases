# AI-Driven Dev {Aliases}

A list of aliases and pre-written scripts to help you inject AI into your dev workflow.

- [📦 Installation](#-installation)
  - [Proprietary LLM: OpenAI](#proprietary-llm-openai)
  - [Local LLM: Ollama support](#local-llm-ollama-support)
- [💻 Development](#-development)
  - [Scripts](#scripts)
- [🚀 Usage](#-usage)

## 📦 Installation

```shell
#!/bin/sh
curl -sSf "https://raw.githubusercontent.com/alexsoyes/ai-driven-dev-community/main/scripts/aiddc/install.sh" | bash
```

### Proprietary LLM: OpenAI

Provide an OpenAI API key in the `.env` file.

```bash
OPENAI_API_KEY=sk-<your-api-key>
```

Or directly in your `.bashrc` file.

```bash
export OPENAI_API_KEY=sk-<your-api-key>
```

### Local LLM: Ollama support

Alternatively, you can use Ollama.

You just need to provide the following environment variable:

```bash
LOCAL_MODEL=codellama # deepseek-coder, qwen2 etc.
```

Note: Responses might be way less effective than OpenAI's GPT calls.

## 💻 Development

In the `aiddc` directory, you can run the following command to install the scripts locally and add the aliases to your `.bashrc` file.

### Scripts

When you do want to test your new scripts without pushing those to the repository.

```bash
cd scripts/aiddc
bash install-local.sh && source ~/.bashrc && aidd-commit-msg  
```

## 🚀 Usage

```text

    _    ___      ____       _                   ____             
   / \  |_ _|    |  _ \ _ __(_)_   _____ _ __   |  _ \  _____   __
  / _ \  | |_____| | | | '__| \ \ / / _ \ '_ \  | | | |/ _ \ \ / /
 / ___ \ | |_____| |_| | |  | |\ V /  __/ | | | | |_| |  __/\ V / 
/_/   \_\___|    |____/|_|  |_| \_/ \___|_| |_| |____/ \___| \_/  


Usage: `aidd-help`

Provides help and usage information for aidd scripts.

Available Aliases:
-------------------
- `aidd-changes-from-main` Copies the changes from the main branch to the clipboard.
- `aidd-changes` Copies the current git changes to the clipboard.
- `aidd-commit-date` <[required] Date in the format 'YYYY-MM-DD HH:MM:SS', Commit ID.> Changes the commit date of the specified commit using a specified date.
- `aidd-commit-last` Copies the last 10 commit messages to the clipboard.
- `aidd-commit-msg` Prepares a commit message based on current changes.
- `aidd-commits-diff-main` Copies the commit differences between the current branch and main.
- `aidd-help` Provides help and usage information for aidd scripts.
- `aidd-pull-request` <Template file path.> Prepares a pull request using a pre-filled template.
- `aidd-review` <'changed', 'staged', 'diff-from-main'> Reviews changes based on the specified parameter.
- `aidd-tree` <Exclude directories pattern.> Generates a directory tree excluding specified directories.
-------------------

Usage Example:
  `aidd-help`
```
