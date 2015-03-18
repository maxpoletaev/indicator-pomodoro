namespace Pomodoro {

    class IndicatorMenu : Gtk.Menu {
        public Gtk.MenuItem item_start;
        public Gtk.MenuItem item_stop;

        private void create_menu () {
            this.item_start = new Gtk.MenuItem.with_label ("_Start");
            this.append (this.item_start);
            this.item_start.show ();

            this.item_stop = new Gtk.MenuItem.with_label ("_Stop");
            this.append (this.item_stop);

            var item_quit = new Gtk.MenuItem.with_label ("_Exit");
            item_quit.activate.connect (Gtk.main_quit);
        }
    }

    class PomodoroIndicator : AppIndicator.Indicator {
        public signal void start ();
        public signal void stop ();

        public void set_time () {

        }

        public void clear_time () {

        }

        private void create_menu () {
            var menu = new IndicatorMenu ();

            menu.item_start.activate.connect(() => {
                menu.item_start.hide ();
                menu.item_stop.show ();
                this.start ();
            });

            menu.item_start.activate.connect(() => {
                menu.item_start.show ();
                menu.item_stop.hide ();
                this.stop ();
            });

            this.set_menu (menu);
        }
    }

}
