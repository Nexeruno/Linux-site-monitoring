# Linux Site Monitoring

A small Linux/DevOps monitoring project written in Bash.

The project checks a list of websites from `urls.txt`, stores logs and state, detects failed/recovered websites, and can run automatically through a `systemd` timer.

This project was built as a practical Linux automation portfolio project.

---

## What this project does

- Reads monitored URLs from `urls.txt`
- Skips empty lines and comments
- Validates that URLs start with `http://` or `https://`
- Checks website availability with `curl`
- Logs results into local log files
- Stores previous website state in `state/`
- Detects status changes such as DOWN and RECOVERED
- Can run manually or automatically with `systemd`
- Provides install, uninstall, health-check and test scripts
- Includes a Makefile for common project commands
- Includes GitHub Actions CI for basic project checks

---

## Technologies used

- Linux
- Bash
- curl
- systemd service
- systemd timer
- journalctl
- logrotate
- Git
- GitHub Actions
- Makefile

---

## Project structure

```text
.
├── .github/workflows/
│   └── project-check.yml
├── logrotate/
│   └── site-monitor
├── systemd/
│   ├── site-monitor.service
│   └── site-monitor.timer
├── config.env.example
├── health-check.sh
├── install.sh
├── Makefile
├── README.md
├── run-sites.sh
├── site.sh
├── test-project.sh
├── uninstall.sh
└── urls.txt
```

Runtime/local files and directories:

```text
config.env
logs/
state/
```

These are not meant to be committed to Git.

---

## Configuration

Copy the example configuration:

```bash
cp config.env.example config.env
```

Then edit it if needed:

```bash
nano config.env
```

The real `config.env` file is local only and should not be committed.

---

## URLs file

Websites are configured in:

```text
urls.txt
```

Example:

```text
https://google.com
https://seznam.cz
# https://example.com
```

Empty lines and lines starting with `#` are ignored.

---

## Manual run

Run monitoring manually:

```bash
./run-sites.sh
```

Run a single website check:

```bash
./site.sh https://example.com
```

---

## Install

The install script prepares the project and installs the systemd files.

```bash
./install.sh
```

It performs these steps:

- checks required commands
- creates `config.env` from `config.env.example` if needed
- creates runtime directories
- installs systemd service and timer files
- reloads systemd
- enables and starts the timer
- verifies that the timer is enabled and active

---

## Health check

Check the current project/systemd status:

```bash
./health-check.sh
```

Or through Makefile:

```bash
make health
```

The health check verifies:

- required local files
- runtime directories
- systemd timer enabled state
- systemd timer active state
- recent service logs

Note: `site-monitor.service` is a short-running service. It does not need to stay active all the time. The important part is that `site-monitor.timer` is active.

---

## Uninstall

Remove the installed systemd timer and service:

```bash
./uninstall.sh
```

The uninstall script removes systemd files but keeps local runtime data:

```text
config.env
logs/
state/
```

---

## Common commands

Using Makefile:

```bash
make test
make health
make install
make uninstall
make run
make logs
make timer
make status
```

Direct script usage:

```bash
./test-project.sh
./health-check.sh
./install.sh
./uninstall.sh
./run-sites.sh
```

---

## Testing

Run local project checks:

```bash
./test-project.sh
```

Or:

```bash
make test
```

The test script checks:

- Bash syntax
- required project files
- required project directories

It does not require local runtime files such as:

```text
config.env
logs/
state/
```

because those are created during installation or runtime.

---

## GitHub Actions CI

This project includes a GitHub Actions workflow:

```text
.github/workflows/project-check.yml
```

The workflow runs on:

- push
- pull request

It checks the project by running:

```bash
./test-project.sh
```

This keeps CI safe because it does not try to install systemd services on the GitHub runner.

---

## What I practiced in this project

This project was built to practice practical Linux/DevOps fundamentals:

- Bash scripting
- functions and arguments
- if/else conditions
- file and directory checks
- working with logs
- working with state files
- curl-based website checks
- systemd service and timer setup
- journalctl debugging
- install/uninstall automation
- health-check scripting
- local project tests
- Makefile command shortcuts
- Git workflow
- GitHub Actions CI
- debugging differences between local environment and CI

---

# Česká část

## Linux Site Monitoring

Malý Linux/DevOps monitoring projekt napsaný v Bashi.

Projekt kontroluje seznam webů ze souboru `urls.txt`, ukládá logy a stav, pozná výpadek nebo obnovení webu a umí běžet automaticky přes `systemd` timer.

Projekt je vytvořený jako praktický portfolio projekt pro Linux, automatizaci a DevOps základy.

---

## Co projekt dělá

- čte sledované URL ze souboru `urls.txt`
- ignoruje prázdné řádky a komentáře
- kontroluje, že URL začíná na `http://` nebo `https://`
- kontroluje dostupnost webů pomocí `curl`
- ukládá výsledky do logů
- ukládá předchozí stav webů do `state/`
- pozná změny stavu jako DOWN a RECOVERED
- dá se spustit ručně nebo automaticky přes `systemd`
- obsahuje instalační, odinstalační, testovací a health-check skripty
- obsahuje Makefile pro jednoduché příkazy
- obsahuje GitHub Actions CI pro základní kontrolu projektu

---

## Použité technologie

- Linux
- Bash
- curl
- systemd service
- systemd timer
- journalctl
- logrotate
- Git
- GitHub Actions
- Makefile

---

## Instalace

```bash
./install.sh
```

Instalační skript:

- zkontroluje potřebné příkazy
- vytvoří `config.env` z `config.env.example`, pokud chybí
- vytvoří runtime složky
- nainstaluje systemd service a timer
- provede `systemctl daemon-reload`
- zapne a spustí timer
- ověří, že timer je enabled a active

---

## Kontrola stavu

```bash
./health-check.sh
```

Nebo:

```bash
make health
```

Health-check kontroluje:

- konfigurační soubory
- runtime složky
- jestli je timer enabled
- jestli je timer active
- poslední logy služby

Důležité: `site-monitor.service` je krátce běžící služba. Nemusí být pořád aktivní. Důležité je, že `site-monitor.timer` běží.

---

## Odinstalace

```bash
./uninstall.sh
```

Odinstalace smaže systemd service/timer soubory, ale nechá lokální data:

```text
config.env
logs/
state/
```

---

## Testování

```bash
./test-project.sh
```

Nebo:

```bash
make test
```

Testovací skript kontroluje:

- Bash syntaxi
- důležité projektové soubory
- důležité projektové složky

Nekontroluje lokální runtime věci jako `config.env`, `logs/` a `state/`, protože ty vznikají až při instalaci nebo běhu projektu.

---

## Co jsem se na projektu naučil

Na projektu jsem si procvičil:

- Bash skriptování
- funkce a argumenty
- podmínky `if/else`
- kontroly souborů a složek
- práci s logy
- práci se stavovými soubory
- kontrolu webů přes `curl`
- systemd service
- systemd timer
- debugování přes `journalctl`
- instalační a odinstalační automatizaci
- health-check skript
- lokální testovací skript
- Makefile
- Git workflow
- GitHub Actions CI
- rozdíl mezi lokálním prostředím a čistým CI prostředím
