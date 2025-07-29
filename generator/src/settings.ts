interface emoteSettings {
  apiOptions: {
    baseURL: string
    headers: {
      Accept: string,
      "Content-Type": string
    }
  }

}

const emoteSettings:emoteSettings = {
  apiOptions: {
    baseURL: import.meta.env.PROD ? window.location.origin : import.meta.env.VITE_DEVELOPMENT_API_URL,
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
  },
}

export default emoteSettings
