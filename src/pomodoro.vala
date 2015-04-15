namespace Pomodoro {
    const string APP_NAME = "Pomodoro";
    private Settings settings;

    class Pomodoro : Object {
        public KeybindingManager keybinding;
        public PomodoroIndicator indicator;
        public PomodoroTimer timer;

        public void init_objects () {
            indicator = new PomodoroIndicator ();
            timer = new PomodoroTimer (indicator);
            keybinding = new KeybindingManager ();
        }

        public void init_signals () {
            indicator.menu.start_item.activate.connect (start_timer);
            indicator.menu.stop_item.activate.connect (stop_timer);
            indicator.menu.quit_item.activate.connect (quit);

            indicator.menu.show_time_item.toggled.connect (toggle_remaining_time);
            indicator.menu.stop_item.hide ();
        }

        public void init_hotkeys () {
            var toggle_timer_shortcut = settings.get_string("toggle-timer-shortcut");

            if (toggle_timer_shortcut != "") {
                keybinding.bind(toggle_timer_shortcut, toggle_timer);
            }
        }

        public void start_timer () {
            indicator.menu.start_item.hide ();
            indicator.menu.stop_item.show ();
            timer.start_iteration ();
        }

        public void stop_timer () {
            indicator.menu.start_item.show ();
            indicator.menu.stop_item.hide ();
            timer.stop ();
            indicator.reset ();
        }

        public void toggle_timer () {
            if (timer.is_active ()) {
                stop_timer ();
            } else {
                start_timer ();
            }
        }

        public void toggle_remaining_time () {
            indicator.menu.show_time_item.active = !settings.get_boolean ("show-remaining-time");
            settings.set_boolean ("show-remaining-time", indicator.menu.show_time_item.active);
            timer.refresh_value ();
        }

        public void quit () {
            timer.stop ();
            Gtk.main_quit ();
        }
    }

    private void notify_send (string message) {
        try {
            var notify = new Notify.Notification (APP_NAME, message, null);
            notify.show ();
        } catch (Error e) {
            error ("Error: %s", e.message);
        }
    }

    private void init_settings () {
        settings = new Settings ("apps.indicator-pomodoro");
    }

    private string get_icon_name (string icon) {
        return "pomodoro-" + icon + "-light";
    }

    private string get_theme_path () {
        return "/home/maxim/Workspace/indicator-pomodoro/data/icons/";
    }

    static int main (string[] args) {
        Notify.init (APP_NAME);
        Gtk.init (ref args);
        init_settings ();

        var pomodoro = new Pomodoro ();
        pomodoro.init_objects ();
        pomodoro.init_signals ();
        pomodoro.init_hotkeys ();

        Gtk.main ();
        return 0;
    }
}
