var routes = require("./routes-interface")
const BBS_API = "https://bbs-api-os.hoyolab.com"
const ACCOUNT_API = "https://api-account-os.hoyolab.com"
const HK4E_API = "https://sg-hk4e-api.hoyolab.com"
const PUBLIC_API = "https://sg-public-api.hoyolab.com"
const DEFAULT_REFERER = "https://hoyolab.com"
const USER_GAMES_LIST = "".concat(ACCOUNT_API, "/account/binding/api/getUserGameRolesByCookieToken")
const GAME_RECORD_CARD_API = "".concat(BBS_API, "/game_record/card/wapi/getGameRecordCard")

const getEventName = (game) => {
  if (game == routes.GamesEnum.GENSHIN_IMPACT) {
    return "sol"
  } else if (game === routes.GamesEnum.HONKAI_IMPACT) {
    return "mani"
  } else if (game === routes.GamesEnum.HONKAI_STAR_RAIL) {
    return "luna/os"
  }
  return ""
}
const getEventBaseUrl = (game) => {
  if (game === routes.GamesEnum.GENSHIN_IMPACT) {
    return HK4E_API
  } else if (game === routes.GamesEnum.HONKAI_IMPACT || game === routes.GamesEnum.HONKAI_STAR_RAIL) {
    return PUBLIC_API
  }
  return ""
}
const getActId = (game) => {
  if (game === routes.GamesEnum.GENSHIN_IMPACT) {
    return "e202102251931481"
  } else if (game === routes.GamesEnum.HONKAI_IMPACT) {
    return "e202110291205111"
  } else if (game === routes.GamesEnum.HONKAI_STAR_RAIL) {
    return "e202303301540311"
  }
  return ""
}
const DAILY_INFO_API = (game) => {
  return "".concat(getEventBaseUrl(game), "/event/").concat(getEventName(
    game
  ), "/info?act_id=").concat(getActId(game))
}
const DAILY_REWARD_API = (game) => {
  return "".concat(getEventBaseUrl(game), "/event/").concat(getEventName(
    game
  ), "/home?act_id=").concat(getActId(game))
}
const DAILY_CLAIM_API = (game) => {
  return "".concat(getEventBaseUrl(game), "/event/").concat(getEventName(
    game
  ), "/sign?act_id=").concat(getActId(game))
}

const REDEEM_CLAIM_API = "".concat(HK4E_API, "/common/apicdkey/api/webExchangeCdkey")
const HSR_RECORD_CHARACTER_API = "".concat(BBS_API, "/game_record/hkrpg/api/avatar/info")
const HSR_RECORD_INDEX_API = "".concat(BBS_API, "/game_record/hkrpg/api/index")
const HSR_RECORD_NOTE_API = "".concat(BBS_API, "/game_record/hkrpg/api/note")
const HSR_RECORD_FORGOTTEN_HALL_API = "".concat(BBS_API, "/game_record/hkrpg/api/challenge")

module.exports = {
    DAILY_INFO_API,
    DAILY_REWARD_API,
    DAILY_CLAIM_API,
    REDEEM_CLAIM_API,
    HSR_RECORD_CHARACTER_API,
    HSR_RECORD_INDEX_API,
    HSR_RECORD_NOTE_API,
    HSR_RECORD_FORGOTTEN_HALL_API,
    USER_GAMES_LIST,
    GAME_RECORD_CARD_API
}
