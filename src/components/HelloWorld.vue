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
      <th>
        {{ week.monthName }}
      </th>
      <template v-for="day in week.weekData" :key="day">
        <td :class="{'border-top': day.borderTop, 'border-start': day.borderStart, 'border-dark': true}">
          {{ day.dateObject.format('D') }}
        </td>
      </template>
    </tr>
    </thead>
  </table>
</template>

<script>
import dayjs from 'dayjs'

export default {
  name: 'HelloWorld',
  data() {
    return {
      weeks: {}
    }
  },
  created() {
    this.generateCalendar()
  },
  methods: {
    generateCalendar(year) {
      let targetYear = year != null ? year : dayjs().year()
      let currentDay = dayjs(targetYear + '-01-01')
      let lastDayOfYear = dayjs(targetYear + '-12-31')
      let previousMonth = -1
      let currentWeek = []
      let weekCounter = 1;

      while (currentDay <= lastDayOfYear) {
        let borderTop = currentDay.date() == 1
        let borderStart = currentDay.date() == 1

        let dayObject = {
          'dateObject': currentDay, 'monthDayNumber': currentDay.format('D'), 'borderTop': borderTop,
          'borderStart': borderStart
        }

        currentWeek.push(dayObject)

        // If Sunday, bump the week
        if (currentDay.day() == 0) {
          let monthChange = previousMonth != currentDay.month()

          this.weeks[weekCounter] = {
            weekData: currentWeek, monthName: monthChange ? currentDay.format('MMMM') : null
          }

          previousMonth = currentDay.month()
          currentWeek = []
          weekCounter++;
        }

        currentDay = currentDay.add(1, 'day')
      }
    }
  },
  computed: {
    getBorders() {
      console.log(this)
      return this.borderTop ? 'border-top' : '';
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.monthName {
  width: 300px;
  text-align: left;
}

.dayNumber {
  width: 40px;
}
</style>
