namespace Pomodoro {

    class Pomodoro {
        public PomodoroIndicator indicator;
        public PomodoroTimer timer;

        public void Pomodoro () {
            this.timer = new PomodoroTimer ();
            this.indicator = new PomodoroIndicator ();


            this.indicator.start.connect (this.start_timer);
            this.indicator.stop.connect (this.stop_timer);
        }

        public void start_timer () {
            this.timer.tick.connect (() => {
                this.indicator.set_time ();
            });
        }

        public void stop_timer () {
            this.indicator.clear_time ();
        }
    }

    static int main (string[] args) {
        Gtk.init (ref args);
        new Pomodoro ();
        Gtk.main ();
        return 0;
    }
}
