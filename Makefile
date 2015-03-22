all:
	valac \
		src/PomodoroTimer.vala src/PomodoroIndicator.vala src/SettingsWindow.vala src/Pomodoro.vala \
		--pkg=appindicator3-0.1 --pkg=libnotify --pkg=glib-2.0 --pkg=gtk+-3.0 --pkg gio-2.0 \
		--output=bin/indicator-pomodoro \
		--target-glib 2.32 \
		-X -lm

install-gschema:
	sudo cp data/apps.indicator-pomodoro.gschema.xml /usr/share/glib-2.0/schemas/
	sudo glib-compile-schemas /usr/share/glib-2.0/schemas/
