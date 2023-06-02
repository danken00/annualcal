<template>
    <div v-for="(event, index) in this.events" :key="index">
        {{ event.name }}
    </div>
</template>

<script>
import dayjs from 'dayjs'
import {reactive, onMounted} from 'vue'

const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween)

export default {
    name: 'DayDrawer',
    props: ['events'],
    // data() {
    //
    // },
    created() {
        console.log(this.events);
        // this.generateCalendar()
    },
    methods: {},
    computed: {}
}

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">

</style>
