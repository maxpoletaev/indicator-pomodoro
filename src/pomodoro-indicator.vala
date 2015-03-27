using AppIndicator;

namespace Pomodoro {
    class PomodoroMenu : Gtk.Menu {
        public Gtk.MenuItem start_item;
        public Gtk.MenuItem stop_item;
        public Gtk.MenuItem quit_item;

        public Gtk.CheckMenuItem show_time_item;
        public Gtk.CheckMenuItem play_sounds_item;

        public PomodoroMenu () {
            Object ();
            setup_items ();
            show_all ();
        }

        private void setup_items () {
            start_item = new Gtk.MenuItem.with_label ("Start");
            stop_item = new Gtk.MenuItem.with_label ("Stop");
            quit_item =  new Gtk.MenuItem.with_label ("Quit");

            show_time_item = new Gtk.CheckMenuItem.with_label ("Show time");
            show_time_item.set_active (settings.get_boolean ("show-remaining-time"));

            play_sounds_item = new Gtk.CheckMenuItem.with_label ("Play sounds");
            play_sounds_item.set_active (true); // TODO

            append (start_item);
            append (stop_item);

            append (new Gtk.SeparatorMenuItem ());

            append (show_time_item);
            append (play_sounds_item);

            append (new Gtk.SeparatorMenuItem ());

            append (quit_item);
        }
    }

    class PomodoroIndicator : Indicator {
        public PomodoroMenu menu;

        public PomodoroIndicator () {
            Object (
                id: "Pomodoro Indicator",
                category: "ApplicationStatus",
                icon_name: get_icon_name ("start"),
                icon_theme_path: get_theme_path ()
            );

            set_status (IndicatorStatus.ACTIVE);
            setup_menu ();
        }

        public void set_value (double remaining, double percent) {
            icon_name = percent_to_icon (percent);

            if (settings.get_boolean ("show-remaining-time")) {
                label = seconds_to_time (remaining);
            } else {
                label = null;
            }
        }

        public void reset () {
            icon_name = get_icon_name ("stop");
            label = null;
        }

        public void setup_menu () {
            menu = new PomodoroMenu ();
            set_menu (menu);
        }

        private string percent_to_icon (double percent) {
            var icon_id = Math.round (36 / 100.0 * percent).to_string ();

            if (icon_id.length == 1)
                icon_id = "0" + icon_id;

            return get_icon_name (icon_id);
        }

        private string seconds_to_time (double time) {
            var minutes = (int) (time / 60);
            var seconds = (int) (time % 60);

            var str_minutes = minutes.to_string ();
            var str_seconds = seconds.to_string ();

            if (str_minutes.length == 1)
                str_minutes = "0" + str_minutes;

            if (str_seconds.length == 1)
                str_seconds = "0" + str_seconds;

            return @"$str_minutes:$str_seconds";
        }
    }
}
