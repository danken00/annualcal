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
            <th :class="getWeekBorders(week)" class="monthName">
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
                'id': 1,
                'name': 'Chamonix',
                'location': 'Private Garden Le Praz',
                'startDate': dayjs('2023-07-02'),
                'endDate': dayjs('2023-07-07'),
                'colour': '#a7bed3'
            }, {
                'id': 2,
                'name': 'Italy - Genoa',
                'location': 'The Seven Residence',
                'startDate': dayjs('2023-07-07'),
                'endDate': dayjs('2023-07-10'),
                'colour': '#c6e2e9'
            }, {
                'id': 3,
                'name': 'Italy - Lake Como',
                'location': 'Residence Diaz',
                'startDate': dayjs('2023-07-10'),
                'endDate': dayjs('2023-07-12'),
                'colour': '#f1ffc4'
            }, {
                'id': 4,
                'name': 'Italy - Milan',
                'location': 'Idea Hotel AIRPORT',
                'startDate': dayjs('2023-07-12'),
                'endDate': dayjs('2023-07-13'),
                'colour': '#ffcaaf'
            }, {
                'id': 5,
                'name': 'Hungary - Budapest',
                'location': 'Hilto Garden Inn',
                'startDate': dayjs('2023-07-13'),
                'endDate': dayjs('2023-07-16'),
                'colour': '#dab894'
            }, {
                'id': 6,
                'name': 'Hungary - Budapest',
                'location': 'Dormero',
                'startDate': dayjs('2023-07-20'),
                'endDate': dayjs('2023-07-21'),
                'colour': '#ffc6ff'
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

            return ['border-dark', borderTop ? 'border-top' : null, borderBottom ? 'border-bottom' : null, borderStart ? 'border-start' : null]
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
  width: 150px;
  text-align: left;
  padding-left: 30px;
  color: #777;
  //font-size: 0.8rem;
  font-weight: normal;
}

.dayNumber {
  width: 40px;
}

table {
  td {
    position: relative;
    font-size: 0.9rem;
    padding: 4px 3px;
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
