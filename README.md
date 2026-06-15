# Linux Site Monitoring

Simple Linux/Bash monitoring project for checking website availability and practicing basic DevOps/Linux operations.

## Features

* checks multiple URLs from `urls.txt`
* ignores empty lines and comments
* trims spaces around URLs
* validates URL format
* checks website availability using Bash and `curl`
* logs results into `.log` and `.csv` files
* creates alert events: `DOWN` / `RECOVERED`
* stores website state to prevent repeated alert spam
* creates a current status report in `status.txt`
* supports cron execution
* supports systemd service and systemd timer
* uses `flock` to prevent parallel runs
* supports log rotation with `logrotate`

## Main technologies

* Linux
* Bash
* curl
* cron
* systemd
* systemd timer
* journalctl
* flock
* logrotate
* Git / GitHub

## Project files

* `site.sh` - checks one URL
* `run-sites.sh` - runs checks for all URLs from `urls.txt`
* `urls.txt` - list of monitored URLs
* `logs/status.txt` - current status report
* `logs/alerts.log` - DOWN/RECOVERED alert history
* `state/` - internal state files for monitored URLs

## What I learned

This project helped me practice Linux, Bash scripting, working with files and paths, exit codes, logging, troubleshooting, cron automation, systemd services, systemd timers, journalctl, flock, logrotate and basic monitoring logic.

The goal was not to use a ready-made monitoring tool, but to understand how monitoring, logs, automation and operational behavior work directly in Linux.

---

# Linux monitoring webů

Jednoduchý Linux/Bash monitoring projekt pro kontrolu dostupnosti webů a procvičení základů Linux/DevOps provozu.

## Funkce

* kontrola více URL ze souboru `urls.txt`
* ignorování prázdných řádků a komentářů
* ořezání mezer kolem URL
* validace formátu URL
* kontrola dostupnosti webů pomocí Bash a `curl`
* logování výsledků do `.log` a `.csv` souborů
* alerty `DOWN` / `RECOVERED`
* ukládání stavu webů, aby se neopakovaly stejné alerty pořád dokola
* aktuální status report v souboru `status.txt`
* podpora spouštění přes cron
* podpora systemd service a systemd timeru
* ochrana proti paralelnímu spuštění pomocí `flock`
* rotace logů pomocí `logrotate`

## Použité technologie

* Linux
* Bash
* curl
* cron
* systemd
* systemd timer
* journalctl
* flock
* logrotate
* Git / GitHub

## Hlavní soubory projektu

* `site.sh` - kontrola jedné URL
* `run-sites.sh` - spouští kontrolu všech URL ze souboru `urls.txt`
* `urls.txt` - seznam monitorovaných URL
* `logs/status.txt` - aktuální stav monitoringu
* `logs/alerts.log` - historie alertů DOWN/RECOVERED
* `state/` - interní stavové soubory pro monitorované URL

## Co jsem se naučil

Na projektu jsem si procvičil Linux, Bash skriptování, práci se soubory a cestami, exit kódy, logování, troubleshooting, automatizaci přes cron, systemd služby, systemd timery, journalctl, flock, logrotate a základní logiku monitoringu.

Cílem nebylo použít hotové monitorovací řešení, ale pochopit, jak monitoring, logy, automatizace a provozní chování fungují přímo v Linuxu.

