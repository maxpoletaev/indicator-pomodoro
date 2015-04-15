all:
	valac \
		lib/basic-timer.vala lib/keybinding-manager.vala \
		src/pomodoro-timer.vala src/pomodoro-indicator.vala src/pomodoro.vala \
		--pkg appindicator3-0.1 --pkg libnotify --pkg glib-2.0 --pkg gtk+-3.0 --pkg gio-2.0 \
		--pkg x11 --pkg gdk-x11-3.0 --pkg gee-1.0 \
		--output bin/indicator-pomodoro \
		--target-glib 2.32 \
		-X -lm

install-gschema:
	sudo cp data/apps.indicator-pomodoro.gschema.xml /usr/share/glib-2.0/schemas/
	sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
