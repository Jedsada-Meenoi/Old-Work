const {
    parseCookie,
    parseCookieString
} = require("./cookie/cookie.js");
const request_im = require("./httpRequest.js");
const routes = require("./routes/routes.js");
const {
    parseLang
} = require("./lang/lang.js");
const APIError = require('./error/APIError.js');

class Hoyolab {
    constructor(options) {

        const cookie = typeof options.cookie === "string" ? parseCookieString(options.cookie) : options.cookie
        this.cookie = cookie
        if (!options.lang) {
            options.lang = parseLang(cookie.mi18nLang)
        }
        options.lang = parseLang(options.lang)
        this.request = new request_im.HttpRequest(parseCookie(this.cookie))
        this.request.setLang(options.lang)
        this.lang = options.lang
        
    }

    /**
     * Get the list of games on this Hoyolab account.
     *
     * @async
     * @param {GamesEnum} [game] The optional game for which to retrieve accounts.
     * @throws {HoyoAPIError} Thrown if there are no game accounts on this Hoyolab account.
     * @returns {Promise<IGame[]>} The list of games on this Hoyolab account.
     */

    async gameList(game) {
        var _err;

        if (!this.cookie.cookieTokenV2) {
            throw new APIError('options.cookie.cookieTokenV2 is required')
        }

        if (game) {
            this.request.setQueryParams({
                game_biz: game
            })
        }

        this.request.setQueryParams({
            uid: this.cookie.ltuid,
            sLangKey: this.cookie.mi18nLang
        })

        const {
            response: res,
            params,
            body,
            headers
        } = await this.request.send(routes.USER_GAMES_LIST)

        const data = res.data

        if (!res.data || !data.list) {
            throw new APIError((_err = res.message) != null ? _err : `You don't have any Honkai: Star Rail accounts.`,
                res.retcode, {
                    response: res,
                    request: {
                        body,
                        headers,
                        params
                    }
                }
            )
        }

        return data.list
    }

    /**
     * Get the account of a specific game from the games list.
     *
     * @async
     * @param {GamesEnum} game - The game that the account belongs to.
     * @throws {APIError} If there is no game account on this hoyolab account.
     * @returns {Promise<IGame>} The game account.
     *
     */
    async gameAccount(game) {
        const games = await this.gameList(game)

        if (games.length < 1) {
            throw new APIError(`You don't have any ${game} accounts.`)
        }

        return games.reduce((first, second) => {
            return second.level > first.level ? second : first
        })
    }

    /**
     * Retrieves the game record card
     *
     * @async
     * @returns {Promise<IGameRecordCard>} The game account.
     */
    async gameRecordCard() {
        this.request.setQueryParams({
            uid: this.cookie.ltuid || this.cookie.accountId || this.cookie.accountIdV2
        });
        const {
            response: res
        } = await this.request.send(routes.GAME_RECORD_CARD_API)
        return res.data.list
    }
}

exports.Hoyolab = Hoyolab;