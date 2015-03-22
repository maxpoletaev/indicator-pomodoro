namespace Pomodoro {
    const string APP_NAME = "Pomodoro";
    private Settings settings;

    class Pomodoro : Object {
        public PomodoroIndicator indicator;
        public PomodoroTimer timer = null;
        private int iteration = 0;

        public Pomodoro () {
            init_settings ();
        }

        public void init_objects () {
            indicator = new PomodoroIndicator ();
        }

        public void init_signals () {
            indicator.menu.exit.activate.connect (Gtk.main_quit);
            indicator.menu.start.activate.connect (start_timer);
            indicator.menu.stop.activate.connect (stop_timer);
            indicator.menu.stop.hide ();
        }

        public void start_timer () {
            timer = timer_factory (indicator, "pomodoro");
            timer.start ();
        }

        public void stop_timer () {
            timer.stop ();
        }
    }

    private PomodoroTimer timer_factory (PomodoroIndicator indicator, string type) {
        var duration = settings.get_double (@"$type-duration");
        var timer = new PomodoroTimer (duration);

        timer.start_event.connect (() => {
            indicator.menu.start.hide ();
            indicator.menu.stop.show ();
        });

        timer.stop_event.connect (() => {
            indicator.menu.start.show ();
            indicator.menu.stop.hide ();
        });

        timer.tick_event.connect (() => {
            indicator.set_value (timer.remaining, timer.percent);
        });

        timer.stop_event.connect (() => {
            indicator.reset ();
        });

        return timer;
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

        var pomodoro = new Pomodoro ();
        pomodoro.init_objects ();
        pomodoro.init_signals ();

        Gtk.main ();
        return 0;
    }
}
