const langEnum = require('./lang-interface')

class Language {
    /**
   * Parses a language string into its corresponding LanguageEnum value.
   *
   * @param lang The language string to parse, or null/undefined to default to English.
   * @returns The LanguageEnum value corresponding to the provided string, or English if the string is invalid or undefined.
   */
  static parseLang(lang) {
    if (!lang) {
      return langEnum.langEnum.ENGLISH;
    }
    const langKeys = Object.keys(langEnum.langEnum);
    const matchingKey = langKeys.find(
      (key) => langEnum.langEnum[key] === lang
    );
    return matchingKey ? langEnum.langEnum[matchingKey] : langEnum.langEnum.ENGLISH;
  }
}

module.exports = Language