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
* supports cron execution as an alternative
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
* `systemd/site-monitor.service` - example systemd service file
* `systemd/site-monitor.timer` - example systemd timer file
* `logs/status.txt` - current status report
* `logs/alerts.log` - DOWN/RECOVERED alert history
* `state/` - internal state files for monitored URLs

> Runtime files such as `logs/` and `state/` are ignored by Git and are generated when the project runs.

## Systemd usage

Example systemd files are included in the `systemd/` directory.

To install them manually:

```bash
sudo cp systemd/site-monitor.service /etc/systemd/system/site-monitor.service
sudo cp systemd/site-monitor.timer /etc/systemd/system/site-monitor.timer
sudo systemctl daemon-reload
sudo systemctl enable --now site-monitor.timer
```

Useful commands:

```bash
systemctl status site-monitor.timer
systemctl status site-monitor.service
systemctl list-timers | grep site-monitor
journalctl -u site-monitor.service -n 50
```

The timer runs the monitoring script every 5 minutes through `site-monitor.service`.

## Cron usage

Cron support was used as the first automation step. The recommended current setup is systemd timer, but cron can still be used as an alternative.

Example cron command:

```bash
*/5 * * * * (mkdir -p /root/training/cron_logs && /usr/bin/flock -n -E 99 /tmp/site-monitor.lock /root/training/site/run-sites.sh) >> /root/training/cron_logs/cron.log 2>&1
```

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
* podpora spouštění přes cron jako alternativa
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
* `systemd/site-monitor.service` - ukázkový systemd service soubor
* `systemd/site-monitor.timer` - ukázkový systemd timer soubor
* `logs/status.txt` - aktuální stav monitoringu
* `logs/alerts.log` - historie alertů DOWN/RECOVERED
* `state/` - interní stavové soubory pro monitorované URL

> Runtime soubory jako `logs/` a `state/` nejsou ukládané do Gitu a vytvoří se až při běhu projektu.

## Použití přes systemd

Ukázkové systemd soubory jsou ve složce `systemd/`.

Ruční instalace:

```bash
sudo cp systemd/site-monitor.service /etc/systemd/system/site-monitor.service
sudo cp systemd/site-monitor.timer /etc/systemd/system/site-monitor.timer
sudo systemctl daemon-reload
sudo systemctl enable --now site-monitor.timer
```

Užitečné příkazy:

```bash
systemctl status site-monitor.timer
systemctl status site-monitor.service
systemctl list-timers | grep site-monitor
journalctl -u site-monitor.service -n 50
```

Timer spouští monitoring každých 5 minut přes `site-monitor.service`.

## Použití přes cron

Cron byl použitý jako první krok automatizace. Aktuálně je doporučený systemd timer, ale cron může zůstat jako alternativa.

Příklad cron příkazu:

```bash
*/5 * * * * (mkdir -p /root/training/cron_logs && /usr/bin/flock -n -E 99 /tmp/site-monitor.lock /root/training/site/run-sites.sh) >> /root/training/cron_logs/cron.log 2>&1
```

## Co jsem se naučil

Na projektu jsem si procvičil Linux, Bash skriptování, práci se soubory a cestami, exit kódy, logování, troubleshooting, automatizaci přes cron, systemd služby, systemd timery, journalctl, flock, logrotate a základní logiku monitoringu.

Cílem nebylo použít hotové monitorovací řešení, ale pochopit, jak monitoring, logy, automatizace a provozní chování fungují přímo v Linuxu.

