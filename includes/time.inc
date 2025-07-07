#if defined _time_included
    #endinput
#endif
#define _time_included

/* Time functions */
native gettime(&hour=0, &minute=0, &second=0);
native getdate(&year=0, &month=0, &day=0);
native tickcount(&granularity=0);
native settimer(const funcname[], interval, repeating);
native killtimer(timerid);

/* Date/time constants */
#define TIME_SECONDS_IN_MINUTE  60
#define TIME_MINUTES_IN_HOUR    60
#define TIME_HOURS_IN_DAY       24
#define TIME_DAYS_IN_WEEK       7
#define TIME_WEEKS_IN_YEAR      52
#define TIME_MONTHS_IN_YEAR     12

/* Timestamp functions */
native timestamp(&year=0, &month=0, &day=0, &hour=0, &minute=0, &second=0);
native cvttimestamp(timestamp, &year=0, &month=0, &day=0, &hour=0, &minute=0, &second=0);

/* Timer precision */
#define TIMER_PRECISION_LOW     0
#define TIMER_PRECISION_NORMAL  1
#define TIMER_PRECISION_HIGH    2