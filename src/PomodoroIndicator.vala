using AppIndicator;

namespace Pomodoro {
    struct PomodoroMenu {
        public Gtk.MenuItem start;
        public Gtk.MenuItem stop;
        public Gtk.MenuItem exit;
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
            create_menu ();
        }

        public void set_value (double seconds, double percent) {
            icon_name = percent_to_icon (percent);
        }

        public void reset () {
            icon_name = get_icon_name ("stop");
            label = null;
        }

        public void create_menu () {
            var gtk_menu = new Gtk.Menu ();

            menu = PomodoroMenu () {
                start = new Gtk.MenuItem.with_label ("Start"),
                stop = new Gtk.MenuItem.with_label ("Stop"),
                exit =  new Gtk.MenuItem.with_label ("Exit")
            };

            menu.exit.activate.connect (() => {
                Gtk.main_quit ();
            });

            gtk_menu.append (menu.start);
            gtk_menu.append (menu.stop);
            gtk_menu.append (menu.exit);

            gtk_menu.show_all ();
            set_menu (gtk_menu);
        }

        private string percent_to_icon (double percent) {
            var icon_id = Math.round(36 / 100.0 * percent).to_string ();

            if (icon_id.length == 1) {
                icon_id = "0" + icon_id;
            }

            return get_icon_name(icon_id);
        }
    }
}
