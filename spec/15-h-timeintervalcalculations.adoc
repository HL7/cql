[[appendix-h-time-interval-calculation-examples]]
= Appendix H – Time Interval Calculation Examples
:page-layout: dev
:backend: xhtml
:sectnums:
:sectanchors:
:toc:
:page-standards-status: informative

To determine the length of time between two dates, CQL provides two different approaches, _duration_, the number of whole periods between two dates, and _difference_, the number of period boundaries crossed between two dates.

The first approach, calculating the _duration_, determines the number of whole periods that occur between the two dates. Conceptually, the calculation is performed by considering the two dates on a timeline, and counting the number of whole periods that fit on that timeline between the two dates. For example:

Date 1: 2012-03-10 +
Date 2: 2013-03-10 +
Duration In Years: years between Date1 and Date2

The Duration In Years expression gives one year, because an entire year has passed between the two dates. Note that time is considered for the purposes of calculating the number of years:

DateTime 1: 2012-03-10 10:20:00 +
DateTime 2: 2013-03-10 09:20:00 +
Duration in Years: years between DateTime1 and DateTime2

This expression gives zero years, because the year has not passed until 10:20:00 on the day in the following year. To calculate the number of years, ignoring the time, extract the date from the datetime value:

DateTime 1: 2012-03-10 10:20:00 +
DateTime 2: 2013-03-10 09:20:00 +
Duration In Years: years between (date from DateTime1) and (date from DateTime2)

The second approach, calculating the _difference_, determines the number of boundaries crossed between two dates. To illustrate the difference, consider the following example:

Date 1: 2012-12-31 +
Date 2: 2013-01-01 +
Duration In Years: years between Date1 and Date2 +
Difference In Years: difference in years between Date1 and Date2

The Duration In Years expression returns zero because a full year has not passed between the two dates. However, the Difference In Years expression returns 1 because one year boundary was crossed between the two dates.

[.note-info]
____
Durations above seconds are calendar durations that are not comparable with definite quantity UCUM duration units
____

In addition to duration and difference calculations, CQL provides timing phrases to allow flexible and precise natural language comparisons of date and time values and intervals. The available timing phrases in CQL fall into four categories:

* `same as`
* `before` and `after`
* `within`
* `during` and `includes`

The following sections provide detailed examples of calculating duration and difference, as well as interpreting timing phrases of CQL.

[[calculating-duration-in-years]]
== Calculating Duration in Years

[[definition]]
=== Definition

In CQL, a _year_ is defined as the duration of any time interval which starts at a certain time of day at a certain calendar date of the calendar year and ends at:

* The same time of day on the same calendar date of the next calendar year, if it exists
* The same time of day on the immediately following calendar date of the next calendar year, if the same calendar date of the next calendar year does not exist.

*Note:* When in the next calendar year the same calendar date does not exist, the ISO states that the ending calendar day has to be agreed upon. The above convention is used in CQL as a resolution to this issue.

[[examples]]
=== Examples

==== Scenario 1
When month (date 2) < month (date 1): +
Duration (years) = year (date 2) - year (date 1) - 1

*Example 1:* +
Date 1: 2012-*03*-10 22:05:09 +
Date 2: 2013-*02*-18 19:10:03 +
Duration = year (date 2) - year (date 1) - 1 = 2013 - 2012 - 1 = *0 years*

==== Scenario 2
When month (date 2) = month (date 1) and day (date 2) >= day (date 1) +
Duration (years) = year (date 2) - year (date 1)

*Example 2.a:* day (date 1) = day (date 2) +
Date 1: 2012-03-*10* 22:05:09 +
Date 2: 2013-03-*10* 22:05:09 +
Duration = year (date 2) - year (date 1) = 2013 - 2012 = *1 year*

*Note:* Time of day is important in this calculation. If the time of day of Date 2 were less than the time of day for Date 1, the duration of the time interval would be 0 years according to the definition.

*Example 2.b:* day (date 2) > day (date 1) +
Date 1: 2012-03-*10* 22:05:09 +
Date 2: 2013-03-*20* 04:01:30 +
Duration = year (date 2) - year (date 1) = 2013 - 2012 = *1 year*

==== Scenario 3
When month (date 2) = month (date 1) and day (date 2) < day (date 1) +
Duration (years) = year (date 2) - year (date 1) - 1

*Example 3.a:* +
Date 1: 2012-02-*20* +
Date 2: 2014-02-*10* +
Duration = year (date 2) - year (date 1) - 1 = 2014 - 2012 - 1 = *1 year*

==== Scenario 4
When month (date 2) > month (date 1) +
Duration (years) = year (date 2) - year (date 1)

*Example 4.a:* +
Date 1: 2012-*03*-10 11:16:02 +
Date 2: 2013-*08*-15 21:34:16 +
Duration = year (date 2) - year (date 1) = 2013 - 2012 - *1 year*

*Example 4.b:* +
Date 1: 2012-*02*-29 10:18:56 +
Date 2: 2014-*02*-28 19:02:34 +
Duration = year (date 2) - year (date 1) = 2014 - 2012 = *2 years*

*Note:* Because there is no February 29 in 2014, per the <<05-languagesemantics.adoc#datetime-arithmetic-1,Date and Time Arithmetic>> section, the last day of the calendar month is used. Thus the number of years can only change when the date reaches February 28. (e.g. 2012-02-29 + *1 year* = 2013-02-28)

[[negative-examples]]
=== Negative Examples

==== Scenario 5
When month (date 1) < month (date 2) +
Duration (years) = year (date 2) - year (date 1) + 1

*Example 5:* +
Date 1: 2012-*02*-20 10:20:56 +
Date 2: 2011-*03*-19 19:16:02 +
Duration = year (date 2) - year (date 1) + 1 = 2011 - 2012 + 1 = *0 years*

==== Scenario 6
When month (date 2) = month (date 1) and day (date 2) +<=+ day (date 1) +
Duration (years) = year (date 2) - year (date 1)

*Example 6.a:* day (date 1) = day (date 2) +
Date 1: 2013-05-*11* 20:06:10 +
Date 2: 2012-05-*11* 20:06:10 +
Duration = year (date 2) - year (date 1) = 2012 - 2013 = *-1 year*

*Example 6.b:* day (date 1) > day (date 2) +
Date 1: 2013-05-*15* 10:19:55 +
Date 2: 2012-05-*10* 12:20:25 +
Duration = year (date 2) - year (date 1) = 2012 - 2013 = *-1 year*

==== Scenario 7
When month (date 2) = month (date 1) and day (date 2) > day (date 1) +
Duration (years) = year (date 2) - year (date 1) + 1

*Example 7:* +
Date 1: 2013-03-*20* 05:01:30 +
Date 2: 2011-03-*30* 06:45:50 +
Duration = year (date 2) - year (date 1) + 1 = 2011 - 2013 + 1 = *-1 year*

==== Scenario 8
When month (date 2) < month (date 1) +
Duration (years) = year (date 2) - year (date 1)

*Example 8.a:* +
Date 1: 2014-*08*-12 09:10:15 +
Date 2: 2013-*05*-14 01:17:10 +
Duration = year (date 2) - year (date 1) = 2013 - 2014 = *-1 year*

*Example 8.b:* +
Date 1: 2015-*11*-05 05:50:45 +
Date 2: 2013-*03*-29 11:01:05 +
Duration = year (date 2) - year (date 1) = 2013 - 2015 = *-2 years*

[[calculating-duration-in-months]]
== Calculating Duration in Months

[[definition-1]]
=== Definition

A month in CQL is defined as the duration of any time interval which starts at a certain time of day at a certain calendar day of the calendar month and ends at:

* The same time of day at the same calendar day of the ending calendar month, if it exists
* The same time of day at the immediately following calendar date of the ending calendar month, if the same calendar date of the ending month in the ending year does not exist.

*Notes:* When in the next calendar year the same calendar date does not exist, the ISO states that the ending calendar day has to be agreed upon. The above convention is used in CQL as a resolution to this issue.

[[examples-1]]
=== Examples

==== Scenario 1
When day (date 2) >= day (date 1) +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1))

*Example 1.a:* +
Date 1: 2012-03-*01* 14:05:45 +
Date 2: 2012-03-*31* 23:01:49 +
Duration = (year (date 2) - year (date 1)) * 12 + (month (date 2) - (month (date 1)) +
= (2012 - 2012) * 12 + (3 - 3) = *0 months*

*Example 1.b:* +
Date 1: 2012-03-*10* 22:05:09 +
Date 2: 2013-06-*30* 13:00:23 +
Duration = (year (date 2) - year (date 1)) * 12 + (month (date 2) - (month date 1)) +
= (2013 - 2012) * 12 + (6 - 3) = 12 + 3 = *15 months*

==== Scenario 2
When day (day 2) < day (date 1) +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) - 1

*Example 2:* +
Date 1: 2012-03-*10* 22:05:09 +
Date 2: 2013-01-*09* 07:19:33 +
Duration = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) - 1 +
= (2013 - 2012) * 12 + (1 - 3) - 1 = 12 - 2 - 1 = *9 months*

[[negative-exapmles-1]]
=== Negative Examples

==== Scenario 3
When day (date 2) +<=+ day (date 1) +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1))

*Example 3.a:* +
Date 1: 2013-10-*15* 13:07:40 +
Date 2: 2013-10-*02* 10:13:59 +
Duration = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) +
= (2013 - 2013) * 12 - (10 - 10) = *0 months*

*Example 3.b:* +
Date 1: 2014-05-*10* 21:02:45 +
Date 2: 2013-01-*08* 11:13:06 +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) +
= (2013 - 2014) * 12 + (1 - 5) = (-12) + (-4) = *-16 months*

==== Scenario 4
When day (day 2) > day (date 1) +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) + 1

*Example 4:* +
Date 1: 2012-06-*11* 12:16:17 +
Date 2: 2011-08-*21* 05:48:02 +
Duration (months) = (year (date 2) - year (date 1)) * 12 + (month (date 2) - month (date 1)) + 1 +
= (2011 - 2012) * 12 + (8 - 6) + 1 = (-12) + (2) + 1 = *-9 months*

[[calculating-duration-in-weeks]]
== Calculating Duration in Weeks

[[definition-2]]
=== Definition

In CQL, a week is defined as a duration of any time interval which starts at a certain time of day at a certain calendar day at a certain calendar week and ends at the same time of day at the same calendar day of the ending calendar week. In other words, a complete week is always seven days long.

[[examples-2]]
=== Examples

Duration = +++[+++date 2 - date 1 (days)+++]+++ / 7

*Example 1:* +
Date 1: 2012-03-10 22:05:09 +
Date 2: 2012-03-20 07:19:33 +
Duration = +++[+++# days (month (date 1)) - day (date 1) + # days (month (date 1) + 1) + # days (month (date 1) + 2) + ... + # days (month (date 2) - 1) + day (date 2)+++]+++ / 7 +
= (20 - 10) / 7 = 10 / 7 = *1 week*

*Example 2:* +
Date 1: 2013-05-26 23:06:11 +
Date 2: 2013-05-12 20:25:30 +
Duration = +++[+++# days (month (date 1)) - day (date 1) + # days (month (date 1) + 1) + # days (month (date 1) + 2) + ... + # days (month (date 2) - 1) + day (date 2)+++]+++ / 7 +
= (12 - 26) / 7 = -14/7 = *-2 weeks*

[[calculating-duration-in-days]]
== Calculating Duration in Days

[[definition-3]]
=== Definition

In CQL, a day is defined as a duration of any time interval which starts at a certain calendar day and ends at the next calendar day (1 second to 23 hours, 59 minutes, and 59 seconds).

The duration in days between two dates will generally be given by subtracting the start calendar date from the end calendar date, respecting the time of day between the two dates.

[[examples-3]]
=== Examples

==== Scenario 1
When time (date 2) < time (date 1) +
Duration = +++[+++date 2 - date 1 (days)+++]+++ - 1

*Example 1:* +
Date 1: 2012-01-31 *12:30:00* +
Date 2: 2012-02-01 *09:00:00* +
Duration = 02-01 - 01-31 - 1 = *0 days*

==== Scenario 2
When time (date 2) >= time (date 1) +
Duration = date 2 - date 1 (days)

*Example 2:* +
Date 1: 2012-01-31 *12:30:00* +
Date 2: 2012-02-01 *14:00:00* +
Duration = 02-01 - 01-31 = *1 day*

[[negative-examples-2]]
=== Negative Examples

==== Scenario 3
When time (date 2) > time (date 1) +
Duration = +++[+++date 2 - date 1 (days)+++]+++ + 1

*Example 3:* +
Date 1: 2011-12-05 *05:00:00* +
Date 2: 2011-12-04 *08:45:00* +
Duration = 12-04 - 12-05 + 1 = *0 days*

==== Scenario 4
When time (date 2) +<=+ time (date 1) +
Duration = date 2 - date 1 (days)

*Example 4:* +
Date 1: 2011-12-05 *05:00:00* +
Date 2: 2011-12-04 *01:30:00* +
Duration = 12-04 - 12-05 = *-1 day*



[[calculating-duration-in-hours]]
== Calculating Duration in Hours

[[definition-4]]
=== Definition

In CQL, an hour is defined as 60 minutes. The duration in hours between two dates is the number of minutes between the two dates, divided by 60. The result is truncated to the unit.

[[examples-4]]
=== Examples

*Example 1:* +
Date 1: 2012-03-01 03:10:00 +
Date 2: 2012-03-01 05:09:00 +
Duration = *1 hour*

*Example 2:* +
Date 1: 2012-02-29 23:10:00 +
Date 2: 2012-03-01 00:10:00 +
Duration = *1 hour*

*Example 3:* +
Date 1: 2012-03-01 03:10 +
Date 2: 2012-03-01 04:00 +
Duration = *0 hours*

[[negative-examples-3]]
=== Negative Examples

*Example 4:* +
Date 1: 2013-10-10 12:30:00 +
Date 2: 2013-10-10 08:40:00 +
Duration = *-3 hours*

*Example 5:* +
Date 1: 2013-10-10 01:45:00 +
Date 2: 2013-10-09 23:45:00 +
Duration = *-2 hours*

*Example 6:* +
Date 1: 2013-10-10 12:00:00 +
Date 2: 2013-10-10 11:30:00 +
Duration = *0 hours*

[[calculating-duration-in-minutes]]
== Calculating Duration in Minutes

[[definition-5]]
=== Definition

In CQL, a minute is defined as 60 seconds. The duration in minutes between two dates is the number of seconds between the two dates, divided by 60. The result is truncated to the unit.

[[examples-5]]
=== Examples

*Example 1:* +
Date 1: 2012-03-01 03:10:00 +
Date 2: 2012-03-01 05:20:00 +
Duration = *130 minutes*

*Example 2:* +
Date 1: 2012-02-29 23:10:00 +
Date 2: 2012-03-01 00:20:00 +
Duration = *70 minutes*

[[negative-examples-4]]
=== Negative Examples

*Example 3:* +
Date 1: 2012-12-30 08:40:00 +
Date 2: 2012-12-30 06:50:00 +
Duration = *-110 minutes*

*Example 4:* +
Date 1: 2012-12-30 00:20:00 +
Date 2: 2012-12-29 22:00:00 +
Duration = *-140 minutes*

[[difference-calculations]]
== Difference Calculations

Difference calculations are performed by truncating the datetime values at the next precision, and then performing the corresponding duration calculation on the truncated values.

Implementations need to consider the calculation of the "difference between" two datetimes with different timezone offsets. There are multiple use cases when this might occur, but the most prevalent is likely due to Daylight Saving Time (DST).

To support the expected results in all cases, normalization of datetime values may be needed, depending on the precision used in the difference calculation. Normalization refers to adjustment of one or both of the two datetime values used in the difference calculation, if the timezone offsets are not the same, to a common timezone offset (namely, the timezone offset of the evaluation request timestamp).

When difference is calculated for hours or finer units, timezone offsets should be normalized prior to truncation to correctly consider real (actual elapsed) time. When difference is calculated for days or coarser units, however, the time components (including timezone offset) should be truncated without normalization to correctly reflect the difference in calendar days, months, and years.

[[examples-6]]
=== Examples

*Example 1:* +
Date 1: 2012-03-01 03:10:00 +
Date 2: 2012-12-31 10:10:00 +
Difference (years) = Duration (years) between 2012-01-01 00:00:00 and 2012-01-01 00:00:00 +
Difference (years) = *0*

*Example 2:* +
Date 1: 2012-12-31 03:10:00 +
Date 2: 2013-01-01 10:10:00 +
Difference (years) = Duration (years) between 2012-01-01 00:00:00 and 2013-01-01 00:00:00 +
Difference (years) = *1*

*Example 3:* +
Date 1: 2016-10-10 09:00:00 +
Date 2: 2016-10-11 11:59:00 +
Difference (days) = Duration (days) between 2016-10-10 00:00:00 and 2016-10-11 00:00:00 +
Difference (days) = *1*

*Example 4:* +
Date 1: 2016-10-10 09:00:00 +
Date 2: 2016-10-12 00:00:00 +
Difference (days) = Duration (days) between 2016-10-10 00:00:00 and 2016-10-12 00:00:00 +
Difference (days) = *2*

*Example 5:* +
Date 1: 2017-03-12 01:12:05.1 (-05:00) +
Date 2: 2017-03-12 03:22:27.6 (-04:00) +
Date 2 (normalized): 2017-03-12 02:22:27.6 (-05:00) +
Difference (hours) = Duration (hours) between 2017-03-12 01:00:00.0 (-05:00) and 2017-03-12 02:00:00.0 (-05:00) +
On the day that DST goes into effect, one might compare +
1:00am Eastern Standard Time (EST) 2017-03-12 01:00:00.0 (-05:00) to +
3:00am Eastern Daylight Time (EDT) 2017-03-12 03:00:00.0 (-04:00) +
Since time "springs forward" at 2:00am, only one hour of _real_ time has elapsed. +
To calculate the "difference in hours" as 1, the second time (3:00am EDT) is normalized to the first time's offset (making it 2:00am EST). +
The difference between 1:00am EST and 2:00am EST is clearly one hour. +
In a clinical setting, recognizing this as only one hour (and not two, as the clock might suggest) is important.

*Example 6:* +
Date 1: 2017-11-05 01:30:00.0 (-04:00) +
Date 2: 2017-11-05 01:15:00.0 (-05:00) +
Date 2 (normalized): 2017-11-05 02:15:00.0 (-04:00) +
Difference (minutes) = Duration (minutes) between 2017-11-05 01:30:00.0 (-04:00) and 2017-11-05 02:15:00.0 (-04:00) +
Similarly, when DST ends, one might compare 1:30am EDT to 1:15am EST. +
If we did not respect timezone offsets, the difference would appear to be -15 minutes. +
Again, to calculate the "difference in minutes" as 45, the second time (1:15am EST) is normalized to the first time's offset (making it 2:15am EDT). +
The difference between 1:30am EDT and 2:15am EDT is clearly 45 minutes.

*Example 7:* +
Date 1: 2017-03-12 00:00:00.0 (-05:00) +
Date 2: 2017-03-13 00:00:00.0 (-04:00) +
Without normalization of the dates: +
Difference (days) = Duration (days) between 2017-03-12 00:00:00.0 and 2017-03-13 00:00:00.0 +
In some cases, normalization prior to truncation may give unexpected results. Consider the "difference in days" between midnight (EST) on the day that DST goes into effect and midnight (EDT) the next day. One would expect that since the second date is the "next day" on the calendar, difference in days should be 1. +
With normalization prior to truncation, the second date would become 11:00pm EST on the same day as the first date. +
The difference in days would be 0, which is not the expected result.

[[negative-examples-5]]
=== Negative Examples

*Example 8:* +
Date 1: 2015-05-30 12:30:14 +
Date 2: 2015-01-05 01:14:45 +
Difference (years) = Duration (years) between 2015-01-01 00:00:00 and 2015-01-01 00:00:00 +
Difference (years) = *0 years*

*Example 9:* +
Date 1: 2019-01-01 14:40:30 +
Date 2: 2018-12-31 13:30:45 +
Difference (years) = Duration (years) between 2019-01-01 00:00:00 and 2018:01:01 00:00:00 +
Difference (years) = *-1 year*

*Example 10:* +
Date 1: 2013-05-30 12:15:15 +
Date 2: 2013-01-15 13:01:45 +
Difference (months) = Duration (months) between 2013-05-01 00:00:00 and 2013-01-01 00:00:00 +
Difference (months) = *-4 months*

*Example 11:* +
Date 1: 2017-11-14 11:30:00 +
Date 2: 2017-11-12 13:00:00 +
Difference (days) = Duration (days) between 2017-11-14 00:00:00 and 2017-11-12 00:00:00 +
Difference (days) = *-2 days*

*Example 12:* +
Date 1: 2011-06-29 15:45:59 (-5:00) +
Date 2: 2011-06-29 13:30:12 (-4:00) +
Date 2 (normalized): 2011-06-29 12:30:12 (-5:00) +
Difference (hours) = Duration (hours) between 2011-06-29 15:00:00.0 and 2011-06-29 12:00:00.0 +
Difference (hours) = *-3 hours*

*Example 13:* +
Date 1: 2016-10-31 04:30:17 (-4:00) +
Date 2: 2016-10-31 02:45:55 (-5:00) +
Date 2 (normalized): 2016-10-31 03:45:55 +
Difference (minutes) = Duration (minutes) between 2016-10-31 04:30:00.0 and 2016-10-31 03:45:00.0 +
Difference (minutes) = *-45 minutes*

[[interpreting-timing-phrases]]
== Interpreting Timing Phrases

[[same-as]]
=== Same as
To directly compare two date/time values, you can use the standard equality operators:

[source,cql]
----
@2020-07-30 = @2020-07-30
@2020-07-30 != @020-07-31
----

However, CQL also supports a `same as` timing phrase to support precision-based comparison of date/time values:

[source,cql]
----
@2020-07-30 same as @2020-07-30
----

When used without a precision specifier as in the above example, the `same as` timing phrase is the same as equality. Precision specifiers can be used to compare date/time values to a specific precision:

[source,cql]
----
@2020-07-30 same month as @2020-07-31
----

This returns true because the comparison only proceeds to the `month` precision.

[[relative-comparison]]
=== Relative comparison

To determine whether a date/time value is before or after another, CQL supports relative comparisons. As with equality, the standard relative comparison operators can be used:

[source,cql]
----
@2020-07-30 < @2020-07-31
@2020-07-31 <= @2020-07-31
----

These comparisons both return true because the date July 30th, 2020 is _before_ July 31st, 2020, and July 31st is _on or before_ July 31st. As with direct comparison, CQL supports the `before` and `after` keywords:

[source,cql]
----
@2020-07-30 before @2020-07-31 // equivalent to @2020-07-30 < @2020-07-31
@2020-07-31 on or before @2020-07-31 // equivalent to @2020-02-31 <= @2020-07-31
----

When no precision specifier is provided, these phrases are equivalent to the standard relative comparison operators. To compare to a particular precision:

[source,cql]
----
@2020-07-30 before month of @2020-07-31
----

This comparison returns false, because although July 30th is _before_ July 31st, the comparison only proceeds to the _month_ and the months are the same.

[[direct-comparison-with-offsets]]
=== Direct comparison with offsets

Timing phrases for comparison can also include an _offset_, which allows a _duration_ to be considered as part of the comparison. For example:

[source,cql]
----
@2020-07-01T09:30:00.0 1 hour before @2020-07-01T10:30:00.0
----

This returns true because 9:30AM on July 1st is exactly 1 hour before 10:30AM on July 1st. Note that this usage is a _direct_ comparison, not a relative comparison, so:

[source,cql]
----
@2020-07-01T08:30:00.0 1 hour before @2020-07-01T10:30:00.0
----

This returns false because 8:30AM on July 1st is more than 1 hour before 10:30AM on July 1st. To support relative comparison with offsets, include the `or more` or `or less` keywords:

[source,cql]
----
@2020-07-01T08:30:00.0 1 hour or more before @2020-07-01T10:30:00.0
----

The result of this comparison is true.

[[relative-comparison-with-offsets]]
=== Relative comparison with offsets

When using `or less`, the comparison is evaluated by considering an interval:

[source,cql]
----
@2020-07-01T09:30:00.0 1 hour or less on or before @2020-07-01T10:30:00.0
----

The above comparison returns true because 9:30AM on July 1st, 2020 is 1 hour or less on or before 10:30AM on July 1st, 2020. This is equivalent to asking

[source,cql]
----
@2020-07-01T09:30:00.0 >= (@2020-07-01T10:30:00.0 - 1 hour)
  and @2020-07-01T09:30:00.0 <= @2020-07-01T10:30:00.0
----

Some further examples using this timing phrase:

[source,cql]
----
@2020-07-01T09:29:59.999 1 hour or less on or before @2020-07-01T10:30:00.0
----

This example returns false because 9:29:59.999AM on July 1st, 2020 is just barely more than 1 hour before 10:30AM on July 1st, 2020.

[source,cql]
----
@2020-07-01T09:29:59.999 1 hour or less on or before hour of @2020-07-01T10:30:00.0
----

However, the above example returns true because the comparison only proceeds to the hour, and the hour, 9, is 1 hour or less before the hour, 10.

[source,cql]
----
@2020-07-01T08:31:00.0 1 hour or less on or before @2020-07-01T10:30:00.0
----

The above example returns false because 8:31AM is more than 1 hour before 10:30AM (even though it is 1 hour and 59 minutes before).

To illustrate this point another way:

[source,cql]
----
hours between @2020-07-01T08:31:00.0 and @2020-07-01T10:30:00.0 <= 1 // true
----

The above example returns true because the duration in hours between 8:31AM and 10:30 AM is less than or equal to 1 (even though there is 1 hour and 59 minutes between the two times, it's still less than or equal to 1 and the duration calculation is only looking for full hours).

[source,cql]
----
difference in hours between @2020-07-01T08:31:00.0 and @2020-07-01T10:30:00.0 <= 1 // false
----

The above example returns false, because in using the `difference` calculation, we are indicating that we are concerned with the number of boundaries crossed, rather than the number of full hours, and two hour boundaries have been crossed between 8:31AM and 10:30AM.

Looking at another example, this time using `after` and to the `day`:

[source,cql]
----
@2020-07-12T10:00:00.0 1 day after day of @2020-07-11T10:00:00.0 // true
----

The above example returns true because the comparison only proceeds to the day, and July 12th, 2020 is exactly 1 day after July 11th 2020.

[source,cql]
----
@2020-07-11T23:59:59.999 1 day after day of @2020-07-11T10:00:00.0 // false
----

The above example returns false, again because the comparison only proceeds to the day, and July 11th, 2020 is the same day as July 11th, 2020, not the day after.

[source,cql]
----
@2020-07-13T00:00:00.0 1 day after day of @2020-07-11T10:00:00.0 // false
----

And finally, the above example returns false because July 13th is _more than_ 1 day after July 11th.

Looking at another example, this time using `or less before` and `weeks`:

[source,cql]
----
@2019-09-23 42 weeks or less before @2020-07-13 // true
----

The above example returns true because September 23rd, 2019 is 42 weeks or less before July 13th, 2020.

[source,cql]
----
@2019-09-23T09:00:00.0 42 weeks or less before @2020-07-13T10:00:00.0 // false
----

Adding time into the comparison, the above example returns false, because 9:00AM on September 23rd is more than 42 weeks before July 13th 2020. Only 1 hour more, but still more.

[source,cql]
----
@2019-09-23T09:00:00.0 42 weeks or less before day of @2020-07-13T10:00:00.0 // true
----

However, the above example returns true, because the comparison only proceeds to the day, September 23rd 2019 is 42 weeks before July 13th 2020, again because the time components are not considered in the comparison.

[source,cql]
----
@2019-09-22T11:00:00.0 42 weeks or less before day of @2020-07-13T10:00:00.0 // false
----

And finally, the above example returns false, because the comparison proceeds to the day, and September 22nd 2019 is 1 day more than 42 weeks before July 13th 2020.

=== Interval Example Summary

The following table provides a summary of the timing phrase examples:

[[table-h-a]]
|===
|Scenario: OneHourOrLessOnOrBefore |Calculation Type |CQL Timing Phrase |Result |Comment

.3+|Start: @2020-07-01T08:31:00.0 +
End: @2020-07-01T10:30:00.0
| Interval
| @2020-07-01T08-08:31:00.0 1 hour *or less* on or before @2020-07-01T10:30:00.0 | `false` | Keyword `or less` is used +
Interval calculation is used, and the time difference is 1 hour and 59 minutes

|Duration |hours *between* @2020-07-01T08:31:00.0 and @2020-07-01T10:30:00.0 <= 1 | `true` | Keyword `between` is used +
Duration calculation is used and the hours are rounded down to the closest hour

|Difference |*difference* in hours between @2020-07-01T08:31:00.0 and @2020-07-01T10:30:00.0 <= 1 | `false` | Keyword `difference` is used +
Difference calculation is used

.3+|Start: @2020-07-01T09:29:59.999 +
End: @2020-07-01T10:30:00.0
|Interval
|@2020-07-01T09:29:59.999 1 hour *or less* on or before @2020-07-01T10:30:00.0 |`false` |Result of calculation is 1 hour and 1 millisecond

|Duration |hours *between* @2020-07-01T09:29:59.999 and @2020-07-01T10:30:00.0 <= 1 |`true` |Keyword `between` is used

|Difference |*difference* in hours between @2020-07-01T09:29:59.999 and @2020-07-01T10:30:00.0 <= 1 |`true` |Keyword `difference` is used

|===

Table H-A - Timing phrase examples (hours)

[[table-h-b]]
|===
|Scenario: OneDayAfterDayOf |Calculation Type |Timing Phrase |Result |Comment

|Start: @2020-07-12T10:00:00.0 +
End: @2020-07-11T10:00:00.0
|Comparison
|@2020-07-12T10:00:00.0 1 day after day of @2020-07-11T10:00:00.0 |`true` |True since calculation = 24 hours = 1 day. The keyword `day of` sets precision to `day`

|Start: @2020-07-12T08:00:00.0 +
End: @2020-07-11T10:00:00.0
|Comparison
|@2020-07-12T08:00:00.0 1 day after day of @2020-07-11T10:00:00.0 |`true` |True since the calculation < 24 hours but crossing one day = 1 day. The keyword `day of` sets precision to `day`

|Start: @2020-07-12T23:59:59.999 +
End: @2020-07-11T10:00:00.0
|Comparison
|@2020-07-12T23:59:59.999 1 day after day of @2020-07-11T10:00:00.0 |`true` |True since the calculation > 24 hours and crossing one day = 1 day. The keyword `day of` sets precision to `day`

|Start: @2020-07-11T23:59:59.999 +
End: @2020-07-11T10:00:00.0
|Comparison
|@2020-07-011T23:59:59.999 1 day after day of @2020-07-11T10:00:00.0 |`false` |False since the dates are the same day, calculation = 0 days

|Start: @2020-07-13T00:00:00.0 +
End: @2020-07-11T10:00:00.0
|Comparison
|@2020-07-13T00:00:00.0 1 day after day of @2020-07-11T10:00:00.0 |`false` |False since 7/11 to 7/13 = 2 days

|===

Table H-B - Timing phrase examples (days)

[[table-h-c]]
|===
|Scenario: FortyTwoWeeksOrLessBefore |Calculation Type |Timing Phrase |Result |Comment

|Start: @2019-09-23 +
End: @2020-07-13
|Interval
|@2019-09-23 42 weeks or less before @2020-07-13 |`true` |True since calculation = 42 weeks. Data only has date, but no time, so the precision is `day`

.2+|Start: @2019-09-23T09:00:00.0 +
End: @2020-07-13T10:00:00.0
|Interval
|@2019-09-23T09:00:00.0 42 weeks or less before @2020-07-13T10:00:00.0 |`false` |False since time is added to data, time precision is used and calculation = 42 weeks and 1 hour fails

|Interval
|@2019-09-23T09:00:00.0 42 weeks or less before *day of* @2020-07-13T10:00:00.0 |`true` |True since `day of` is setting the precision to `day`, 42 weeks 1 hour = 24 weeks 0 days

|Start: @2019-09-22T11:00:00.0 +
End: @2020-07-13T10:00:00.0
|Interval
|@2019-09-22T11:00:00.0 42 weeks or less before day of @2020-07-13T10:00:00.0 |`false` |False since calculation = 42 weeks and 1 day

|===

Table H-C - Timing phrase examples (weeks)

[[table-h-d]]
|===
|CQL Syntax |CQL Calculation Type

|A starts (ends) *before* start (end) of B +
A starts (ends) *after* start (end) of B +
A starts (ends) 3 days (weeks, hours) *or more* before start (end) of B
|Comparison

|A starts (ends) 3 days (weeks, hours) *or less* before start (end) of B +
A starts (ends) *within* 3 days (weeks, hours) of start (end) of B
|Interval

|A starts (ends) 3 days (weeks, hours) *before* start (end) of B +
A starts (ends) 3 days (weeks, hours) *after* start (end) of B +
days (weeks, hours) *between* A and B +
*duration in* days (weeks, hours) between A and B
|Duration

|*difference* in days (weeks, hours) *between* A and B
|Difference

|===

Table H-D - Timing phrase interpretation summary

[[during-and-includes]]
=== During and includes

[source,cql]
----
@2020-01-01T00:00:00.0 during Interval[@2020-01-01T00:00:00.0, @2020-01T10:30:00.00]
@2020-01-01T10:30:00.0 during Interval[@2020-01-01T00:00:00.0, @2020-01T10:30:00.00]
----

These examples return true because during is defined inclusively.
