namespace Pomodoro {

    class PomodoroTimer : Object {
        private PomodoroIndicator indicator;
        private BasicTimer timer = null;
        private bool active = false;
        private int iteration = 0;

        public PomodoroTimer (PomodoroIndicator ind) {
            indicator = ind;
        }

        public void start_iteration () {
            iteration++;
            active = true;
            start_pomodoro ();
        }

        public void start_pomodoro () {
            var pomodoro_duration = settings.get_double ("pomodoro-duration");

            timer = new BasicTimer (pomodoro_duration);

            timer.tick_event.connect (() => {
                indicator.set_value (timer.remaining, timer.percent);
            });

            timer.stop_event.connect (() => {
                if (active)
                    start_break ();
            });

            timer.start ();
            notify_send ("Working started");
        }

        public void start_break () {
            var long_break_interval = (int) settings.get_double ("long-break-interval");
            var is_long_break = (iteration >= long_break_interval);

            var break_duration = settings.get_double(
                ((is_long_break) ? "long-break" : "short-break") + "-duration"
            );

            if (is_long_break)
                iteration = 0;

            timer = new BasicTimer (break_duration);

            timer.tick_event.connect (() => {
                indicator.set_value (timer.remaining, timer.percent);
            });

            timer.stop_event.connect (() => {
                indicator.reset ();

                if (active)
                    start_iteration ();
            });

            timer.start ();
            notify_send ((is_long_break) ? "Long break started" : "Break started");
        }

        public void stop () {
            active = false;
            timer.stop ();
        }
    }

}
