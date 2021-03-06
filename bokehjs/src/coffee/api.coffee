_ = require("underscore")

module.exports = {
  ## api/linalg.ts
  LinAlg:                                 require("./api/linalg")

  ## api/plotting.d.ts
  Plotting:                               require("./api/plotting")

  ## api/typings/models/document.d.ts
  Document:                               require("./document").Document
}

_.extend(module.exports, require("./api/models"))
