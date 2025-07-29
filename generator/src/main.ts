import { createApp } from "vue"
import { createPinia } from "pinia"
import axios from "axios"
import VueAxios from "vue-axios"
import settings from "./settings"
import App from "./App.vue"
import { Quasar } from "quasar"
import "@quasar/extras/material-icons/material-icons.css"
import "quasar/src/css/index.sass"
import "./stores/emoteStore"

axios.defaults.baseURL = settings.apiOptions.baseURL
axios.defaults.headers.common["Accept"] = settings.apiOptions.headers["Accept"]
axios.defaults.headers.common["Content-Type"] = settings.apiOptions.headers["Content-Type"]

const app = createApp(App)
app.use(Quasar, {
  plugins: {},
})
app.use(createPinia())
app.use(VueAxios, axios)
app.mount("#app")
