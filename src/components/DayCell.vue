<script>
import dayjs from 'dayjs'
import {Modal} from 'bootstrap'

const isBetween = require('dayjs/plugin/isBetween');
dayjs.extend(isBetween)

let modalDemo = null;

export default {
    name: 'DayCell',
    props: ['events'],
    data() {
        return {
            // modalTitle: ''
        }
    },
    methods: {
        openModal() {
            modalDemo = new Modal(document.getElementById('modal_demo'), {})
            modalDemo.show()
        }, closeModal() {
            modalDemo.hide()
        }, setTitle() {
            if (this.events.length == 1) {
                console.log(this.events[0].name)
                // this.modalTitle = this.events[0].name
                return this.events[0].name
            } else if (this.events.length > 1) {
                // this.modalTitle = 'Busy day!'
                return 'Busy day!'
            } else {
                return ''
                // this.modalTitle = ''
            }

            // console.log(this.modalTitle)
        }
    },
    computed: {
        modalTitle() {
            return this.setTitle()
        }
    },
    created() {
        // this.setTitle()
    }
}
</script>

<template>
    <div class="day-cell-bar" v-for="(event, index) in this.events" :key="index" @click="openModal"></div>

    <div class="modal fade" id="modal_demo" tabindex="-1" aria-labelledby="modal_demo_label" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modal_demo_label">{{ modalTitle }}</h5>
<!--                    {{ event.name }}-->
                    <button type="button" class="btn-close" aria-label="Close" @click="closeModal"></button>
                </div>
                <div class="modal-body">
                    ...
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" @click="closeModal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="scss">
.day-cell-bar {
  position: absolute;
  top: 5px;
  height: 13px;
  width: 100%;
  background-color: #FFC107;
}
</style>
