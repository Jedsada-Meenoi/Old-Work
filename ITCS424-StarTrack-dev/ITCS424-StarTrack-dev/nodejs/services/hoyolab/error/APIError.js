class APIError extends Error {
    /**
   * Constructs a new instance of the HoyolabError class with the specified message.
   *
   * @param message The message to associate with this error.
   */
  constructor(message, code, http) {
    super(message)

    this.name = this.constructor.name
    this.message = message
    this.code = code
    this.http = http
    Error.captureStackTrace(this, this.constructor)
  }
}

module.exports = {
    APIError
}