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
    baseURL: import.meta.env.PROD ? window.location.origin : "/api",
    headers: {
      Accept: "application/json",
      "Content-Type": "application/json",
    },
  },
}

export default emoteSettings
