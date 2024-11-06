const { parseLang } = require('../lang/lang.js')
const { toCamelCase, toSnakeCase } = require('../helper.js')
const error = require('../error/APIError.js')

class Cookie {
    /**
   * Parses a cookie string and returns a parsed ICookie object.
   *
   * @param cookieString - The cookie string to be parsed.
   * @returns {string} - A parsed ICookie object.
   * @throws {APIError} when ltuid or ltoken keys are not found in the cookie string.
   */
  static parseCookieString(cookieString) {
    const cookies = /* @__PURE__ */ new Map()
    const keys = [
      "ltoken",
      "ltuid",
      "account_id",
      "cookie_token",
      "account_id_v2",
      "account_mid_v2",
      "cookie_token_v2",
      "mi18nLang"
    ]
    cookieString.split("; ").forEach((cookie) => {
      const cookieSplited = cookie.trim().split(/=(?=.+)/)
      if (keys.includes(cookieSplited[0]) === false) {
        return;
      }
      const key = (0, toCamelCase)(cookieSplited[0]).trim()
      const val = decodeURIComponent(cookieSplited[1]).replace(";", "").trim()
      cookies.set(key, val)
      if (["ltuid", "account_id", "account_id_v2"].includes(cookieSplited[0])) {
        cookies.set(key, parseInt(cookies.get(key), 10))
      } else if (cookieSplited[0] === "mi18nLang") {
        cookies.set(key, parseLang(cookies.get(key)))
      }
    })
    const ltuid = cookies.get("ltuid")
    const accountId = cookies.get("accountId")
    const accountIdV2 = cookies.get("accountIdV2")
    if (ltuid && !accountId) {
      cookies.set("accountId", ltuid)
    } else if (!ltuid && accountId) {
      cookies.set("ltuid", accountId)
    }
    if (!accountIdV2 && (accountId || ltuid) !== null) {
      cookies.set("accountIdV2", accountId || ltuid)
    }
    if (!cookies.get("ltoken") || !cookies.get("ltuid")) {
      throw new error.APIError("Cookie key ltuid or ltoken doesnt exist !")
    }
    return Object.fromEntries(cookies)
  }
  /**
   * Converts an `ICookie` object into a cookie string.
   * @param {ICookie} cookie - The `ICookie` object to convert.
   * @returns {string} A string representing the cookie.
   * @throws {HoyoAPIError} If the `ltuid` or `ltoken` key is missing in the `ICookie` object.
   */
  static parseCookie(cookie) {
    if (!cookie.accountId) {
      cookie.accountId = cookie.ltuid
    }
    const cookies = Object.entries(cookie).map(([key, value]) => {
      if (!value) {
        return void 0
      }
      if ([
        "cookieToken",
        "accountId",
        "cookieTokenV2",
        "accountIdV2",
        "accountMidV2"
      ].includes(key)) {
        key = (0, toSnakeCase)(key)
      }
      return "".concat(key, "=").concat(value)
    }).filter((val) => {
      return val !== void 0
    })
    return cookies.join("; ")
  }

}



module.exports = Cookie