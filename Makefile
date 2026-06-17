.PHONY: test health install uninstall run logs timer status

test:
	./test-project.sh

health:
	./health-check.sh

install:
	./install.sh

uninstall:
	./uninstall.sh

run:
	./run-sites.sh

logs:
	journalctl -u site-monitor.service -n 30 --no-pager

timer:
	systemctl list-timers | grep site-monitor || true

status:
	systemctl status site-monitor.timer --no-pager