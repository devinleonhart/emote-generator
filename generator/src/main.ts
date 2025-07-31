import { createApp } from "vue"
import { createPinia } from "pinia"
import axios from "axios"
import VueAxios from "vue-axios"
import settings from "./settings"
import App from "./App.vue"
import { createDiscreteApi } from 'naive-ui'
import "./stores/emoteStore"

// Import fonts for OS theme
import 'vfonts/Lato.css'
import 'vfonts/FiraCode.css'

axios.defaults.baseURL = settings.apiOptions.baseURL
axios.defaults.headers.common["Accept"] = settings.apiOptions.headers["Accept"]
axios.defaults.headers.common["Content-Type"] = settings.apiOptions.headers["Content-Type"]

const app = createApp(App)

// Create discrete API for Naive UI
const { message } = createDiscreteApi(['message'])

app.use(createPinia())
app.use(VueAxios, axios)

// Make discrete API available globally
app.config.globalProperties.$message = message

app.mount("#app")
