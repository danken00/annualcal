<template>
    <table>
        <thead>
        <tr>
            <th class="monthName"></th>
            <th class="dayNumber text-center">M</th>
            <th class="dayNumber text-center">T</th>
            <th class="dayNumber text-center">W</th>
            <th class="dayNumber text-center">T</th>
            <th class="dayNumber text-center">F</th>
            <th class="dayNumber text-center">S</th>
            <th class="dayNumber text-center">S</th>
        </tr>
        <tr v-for="(week, index) in weeks" :key="index">
            <th :class="getWeekBorders(week)">
                {{ week.firstFullWeekOfMonth ? week.monthName : '' }}
            </th>
            <template v-for="day in week.weekData" :key="day">
                <td :class="getDayBorders(day, week, events)">
                    {{ day.dateObject.format('D') }}
                    <DayCell :events="getDayEvents(day, events)"></DayCell>
                </td>
            </template>
        </tr>
        </thead>
    </table>
</template>

<script>
import dayjs from 'dayjs'
import DayCell from './DayCell.vue'

const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween)

export default {
    name: 'HelloWorld',
    components: {
        DayCell
    },
    data() {
        return {
            weeks: {},
            events: [{
                'name': 'Preseason testing (Bahrain)',
                'startDate': dayjs('2023-02-23'),
                'endDate': dayjs('2023-02-28')
            }, {
                'name': 'Bahrain',
                'startDate': dayjs('2023-03-03'),
                'endDate': dayjs('2023-03-05')
            }]
        }
    },
    created() {
        this.generateCalendar()
    },
    methods: {
        getWeekBorders(week) {
            const borderTop = week.firstFullWeekOfMonth;
            return ['border-dark', borderTop ? 'border-top' : null]
        },
        getDayBorders(day, week) {
            const borderStart = day.dateObject.date() == 1 && day.dateObject.day() != 1;
            const borderTop = week.monthChangeWeek && day.dateObject.date() <= 7;
            const borderBottom = week.monthChangeWeek && day.dateObject.date() >= 20;
            let shouldHighlight = false;
            let shouldHighlightStart = false;
            let shouldHighlightEnd = false;

            // events.forEach((calendarEvent) => {
            //     if (day.dateObject.isBetween(calendarEvent.startDate, calendarEvent.endDate, 'day', '[]')) {
            //         shouldHighlight = true;
            //
            //         if (day.dateObject.isSame(calendarEvent.startDate, 'day')) {
            //             shouldHighlightStart = true;
            //         }
            //         if (day.dateObject.isSame(calendarEvent.endDate, 'day')) {
            //             shouldHighlightEnd = true;
            //         }
            //     }
            // });

            return ['border-dark', borderTop ? 'border-top' : null, shouldHighlight ? 'highlight' : null,
                shouldHighlightStart ? 'highlight-start' : null, shouldHighlightEnd ? 'highlight-end' : null,
                borderBottom ? 'border-bottom' : null, borderStart ? 'border-start' : null]
        },
        getDayEvents(day, events) {
            const eventsForDay = [];

            events.forEach((calendarEvent) => {
                if (day.dateObject.isBetween(calendarEvent.startDate, calendarEvent.endDate, 'day', '[]')) {
                    eventsForDay.push(calendarEvent);
                }
            });

            return eventsForDay;
        },
        generateCalendar(year) {
            let targetYear = year != null ? year : dayjs().year()
            let currentDay = dayjs(targetYear + '-01-01')
            let lastDayOfYear = dayjs(targetYear + '-12-31')
            let previousMonth = -1
            let currentWeek = []
            let weekCounter = 1;
            let firstFullWeekOfMonth = false;

            while (currentDay <= lastDayOfYear) {
                let dayObject = {
                    'dateObject': currentDay, 'monthDayNumber': currentDay.format('D')
                }

                currentWeek.push(dayObject)

                if (currentDay.date() == 7) {
                    firstFullWeekOfMonth = true;
                }

                // If Sunday, bump the week
                if (currentDay.day() == 0) {
                    let monthChange = previousMonth != currentDay.month()

                    this.weeks[weekCounter] = {
                        weekData: currentWeek,
                        monthName: currentDay.format('MMMM'),
                        monthChangeWeek: monthChange,
                        firstFullWeekOfMonth: firstFullWeekOfMonth
                    }

                    // Reset the tracker for first full week of month
                    if (firstFullWeekOfMonth) {
                        firstFullWeekOfMonth = false;
                    }

                    previousMonth = currentDay.month()
                    currentWeek = []
                    weekCounter++;
                }

                currentDay = currentDay.add(1, 'day')
            }
        }
    },
    computed: {}
}


</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.monthName {
  width: 300px;
  text-align: left;
}

.dayNumber {
  width: 40px;
}

table {
    td {
        position: relative;
    }
}

.highlight {
  /*display: inline;*/
  /*padding: .25em 0;*/
  background: #FFC107;
  /*color: #ffffff;*/
  /*box-shadow: .5em 0 0 #FFC107, -.5em 0 0 #FFC107;*/

  background-clip: content-box;

  &.highlight-start {
    border-start-start-radius: 15px;
    border-end-start-radius: 15px;
  }

  &.highlight-end {
    border-start-end-radius: 15px;
    border-end-end-radius: 15px;
  }
}
</style>
