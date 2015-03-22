namespace Pomodoro {

    class PomodoroTimer : Object {
        const ulong SECOND = 1000000;

        public signal void start_event ();
        public signal void tick_event ();
        public signal void stop_event ();

        private double duration = 0;
        private bool active = false;
        private Timer timer;

        public PomodoroTimer (double duration = 0) {
            this.duration = duration;
            timer = new Timer ();
        }

        public virtual double elapsed {
            get {
                return timer.elapsed ();
            }
        }

        public virtual double remaining {
            get {
                return duration - elapsed;
            }
        }

        public virtual double percent {
            get {
                var percent = 100.0 / duration * elapsed;
                return percent;
            }
        }

        public void start () {
            timer.start ();
            active = true;

            new Thread <int> (null, () => {
                while (active && elapsed < duration) {
                    tick_event ();
                    Thread.usleep (SECOND);
                }

                stop_event ();
                return 0;
            });

            start_event ();
        }

        public void stop () {
            timer.stop ();
            timer.reset ();
            active = false;
            stop_event ();
        }
    }

}
