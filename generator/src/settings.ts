interface emoteSettings {
  apiOptions: {
    baseURL: string
    headers: {
      Accept: string,
      'Content-Type': string
    }
  }

}

const emoteSettings:emoteSettings = {
  apiOptions: {
    baseURL: 'http://localhost:3000/api/',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
  },
}

export default emoteSettings
