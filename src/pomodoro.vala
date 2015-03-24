namespace Pomodoro {
    const string APP_NAME = "Pomodoro";
    private Settings settings;

    class Pomodoro : Object {
        public PomodoroIndicator indicator;
        public PomodoroTimer timer;

        public void init_objects () {
            indicator = new PomodoroIndicator ();
            timer = new PomodoroTimer (indicator);
        }

        public void init_signals () {
            indicator.menu.start.activate.connect (start_timer);
            indicator.menu.stop.activate.connect (stop_timer);
            indicator.menu.exit.activate.connect (quit);
            indicator.menu.stop.hide ();
        }

        public void start_timer () {
            indicator.menu.start.hide ();
            indicator.menu.stop.show ();
            timer.start_iteration ();
        }

        public void stop_timer () {
            indicator.menu.start.show ();
            indicator.menu.stop.hide ();
            timer.stop ();
            indicator.reset ();
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

        Gtk.main ();
        return 0;
    }
}
