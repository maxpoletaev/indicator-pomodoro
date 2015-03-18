namespace Pomodoro {

    class PomodoroTimer {
        public signal void timeout ();
        public signal void tick ();

        public void set_time() {

        }

        public void run() {
            this.timeout();
        }
    }

}
