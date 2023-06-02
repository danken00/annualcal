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
                    <DayDrawer :events="getDayEvents(day, events)"></DayDrawer>
                </td>
            </template>
        </tr>
        </thead>
    </table>

  <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    ...
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>

</template>

<script>
import dayjs from 'dayjs'
import {reactive, onMounted} from 'vue'
import DayDrawer from './DayDrawer.vue'

const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween)

export default {
    name: 'HelloWorld',
    components: {
        DayDrawer
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
        getDayBorders(day, week, events) {
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

const state = reactive({
    modal_demo: null,
})

onMounted(() => {
    state.modal_demo = new bootstrap.Modal('#modal_demo', {})
})

function openModal() {
    state.modal_demo.show()
}

function closeModal() {
    state.modal_demo.hide()
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
