import dayjs from 'dayjs'
import { createApp } from 'vue'
import App from './App.vue'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap'

const app = createApp(App)

app.config.globalProperties.$dayjs = dayjs

app.mount('#app')
