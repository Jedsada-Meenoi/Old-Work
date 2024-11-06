function generateDS() {
    const salt = "6s25p5ox5y14umn1p61aqyyvbvvl3lrt"
    const date = /* @__PURE__ */ new Date()
    const time = Math.floor(date.getTime() / 1e3)
    let random = ""
    const characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for (let i = 0; i < 6; i++) {
        const randomIndex = Math.floor(Math.random() * characters.length)
        const randomChar = characters.charAt(randomIndex)
        random += randomChar
    }
    const hash = (0, import_crypto.createHash)("md5").update("salt=".concat(salt, "&t=").concat(time, "&r=").concat(random)).digest("hex")
    return "".concat(time, ",").concat(random, ",").concat(hash)
}

function delay(second) {
    return new Promise((resolve) => {
        setTimeout(resolve, second * 1e3)
    })
}

function toCamelCase(str) {
    const words = str.split("_")
    const camelCaseWords = words.map((word, index) => {
        return index === 0 ? word : word.charAt(0).toUpperCase() + word.slice(1)
    })
    return camelCaseWords.join("")
}

function toSnakeCase(text) {
    return text.replace(/([A-Z])/g, " $1").split(" ").join("_").toLowerCase()
}

module.exports = {
    generateDS,
    delay,
    toCamelCase,
    toSnakeCase
}