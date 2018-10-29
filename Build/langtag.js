/*
#  langtag  #
🌐🏷 A RegExp‐based BCP47 parser

___

Copyright (C) 2018 Kyebego

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

The GNU General Public License is available online at
<https://www.gnu.org/licenses/>.

___

##  Usage:

Simply pass the `BCP47()` constructor a language tag.

    var bcp47 = new BCP47("en-CA");
*/
"use strict";

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

(function () {
  var _BCP, buildSubtagArray, gatherSubtagsFrom, globalObject, regex, _splitTags;

  regex = /^(?:(x(?:-[0-9A-Za-z]{1,8})+)|((en-GB-oed|i-(?:ami|bnn|default|enochian|hak|klingon|lux|mingo|navajo|pwn|tao|tay|tsu)|sgn-(?:BE-FR|BE-NL|CH-DE))|(art-lojban|cel-gaulish|no-bok|no-nyn|zh-(?:guoyu|hakka|min(?:-nan)?|xiang)))|(([A-Za-z]{2,3}(?:-([A-Za-z]{3}(?:-[A-Za-z]{3}){0,2}))?|[A-za-z]{4}|[A-Za-z]{5,8})(?:-([A-Za-z]{4}))?(?:-([A-Za-z]{2}|\d{3}))?(?:-((?:[0-9A-Za-z]{5,8}|\d[0-9A-Za-z]{3})(?:-(?:[0-9A-Za-z]{5,8}|\d[0-9A-Za-z]{3}))*))?(?:-((?:(?:[0-9]|[A-W]|[Y-Z]|[a-w]|[y-z])(?:-[0-9A-Za-z]{2,8})+)(?:-(?:[0-9A-WY-Za-wy-z](?:-[0-9A-Za-z]{2,8})+))*))?(?:-(x(?:-[0-9A-Za-z]{1,8})+))?))$/;

  _splitTags = function splitTags(input) {
    if (input == null) {
      return [];
    }

    if (input instanceof Array) {
      return Array.prototype.reduce.call(input, function (result, current) {
        result.push.apply(result, _toConsumableArray(_splitTags(current)));
        return result;
      }, []);
    } else {
      return String.prototype.split.call(input, "-");
    }
  };

  gatherSubtagsFrom = function gatherSubtagsFrom(subtags) {
    var tags;
    tags = _splitTags(subtags);

    if (!tags.length) {
      return;
    }

    if (tags.length === 1) {
      return tags[0] || void 0;
    }

    return tags;
  };

  buildSubtagArray = function buildSubtagArray(tag) {
    var _tags;

    var ref, ref1, ref2, ref3, ref4, ref5, ref6, tags;

    if (tag == null) {
      return [];
    }

    if (tags = (ref = tag.langtag) != null ? ref : (ref1 = tag.privateuse) != null ? ref1 : (ref2 = tag.grandfathered) != null ? ref2 : (ref3 = tag.irregular) != null ? ref3 : tag.regular) {
      return _splitTags(tags);
    }

    if (!(tags = tag.language != null)) {
      return _splitTags(tag, "-");
    }

    tags = _splitTags(tags);
    return (_tags = tags).push.apply(_tags, _toConsumableArray(_splitTags(tag.script)).concat(_toConsumableArray(_splitTags(tag.region)), _toConsumableArray(_splitTags((ref4 = tag.variant) != null ? ref4 : tag.variants)), _toConsumableArray(_splitTags((ref5 = tag.extension) != null ? ref5 : tag.extensions)), _toConsumableArray(_splitTags((ref6 = tag.privateuse) != null ? ref6 : tag.privateUse))));
  };

  _BCP = function BCP47(tag) {
    var extensions, extlang, grandfathered, i, index, irregular, langtag, language, len, match, privateuse, privateuseonly, region, regular, result, script, subtag, subtags, variants;

    if (!(tag != null && (match = String.prototype.match.call(tag, regex)))) {
      throw new TypeError("Language tag not well-formed under BCP47.");
    }

    var _match = match;

    var _match2 = _slicedToArray(_match, 13);

    match = _match2[0];
    privateuseonly = _match2[1];
    grandfathered = _match2[2];
    irregular = _match2[3];
    regular = _match2[4];
    langtag = _match2[5];
    language = _match2[6];
    extlang = _match2[7];
    script = _match2[8];
    region = _match2[9];
    variants = _match2[10];
    extensions = _match2[11];
    privateuse = _match2[12];
    result = this instanceof _BCP ? this : Object.create(_BCP.prototype);
    Object.defineProperties(result, {
      langtag: {
        value: gatherSubtagsFrom(langtag)
      },
      language: {
        value: gatherSubtagsFrom(language)
      },
      extlang: {
        value: gatherSubtagsFrom(extlang)
      },
      script: {
        value: gatherSubtagsFrom(script)
      },
      region: {
        value: gatherSubtagsFrom(region)
      },
      variant: {
        value: gatherSubtagsFrom(variants)
      },
      extension: {
        value: gatherSubtagsFrom(extensions)
      },
      singleton: {
        value: gatherSubtagsFrom(_splitTags(extensions).filter(function (subtag) {
          return subtag.length === 1;
        }))
      },
      privateuse: {
        value: gatherSubtagsFrom(privateuse != null ? privateuse : privateuseonly)
      },
      grandfathered: {
        value: gatherSubtagsFrom(grandfathered)
      },
      irregular: {
        value: gatherSubtagsFrom(irregular)
      },
      regular: {
        value: gatherSubtagsFrom(regular)
      }
    });
    subtags = _splitTags(match);

    for (index = i = 0, len = subtags.length; i < len; index = ++i) {
      subtag = subtags[index];
      Object.defineProperty(result, index, {
        enumerable: true,
        value: subtag
      });
    }

    return Object.defineProperty(result, "length", {
      value: subtags.length
    });
  };

  Object.defineProperty(_BCP, "prototype", {
    writable: false,
    value: Object.defineProperties({}, {
      constructor: {
        value: _BCP
      },
      toString: {
        value: function value() {
          return buildSubtagArray(this).join("-");
        }
      },
      valueOf: {
        value: function value() {
          return buildSubtagArray(this);
        }
      }
    })
  });
  Object.defineProperties(_BCP, {
    regex: {
      enumerable: true,
      value: regex
    },
    test: {
      enumerable: true,
      value: function value(tag) {
        return regex.test(tag);
      }
    },
    testǃ: {
      enumerable: true,
      value: function value(tag) {
        if (!regex.test(tag)) {
          throw new TypeError("Language tag not well-formed under to BCP47.");
        }
      }
    }
  });
  globalObject = typeof self !== "undefined" && self !== null ? self : typeof window !== "undefined" && window !== null ? window : typeof exports !== "undefined" && exports !== null ? exports : typeof global !== "undefined" && global !== null ? global : null;

  if (globalObject == null) {
    throw new ReferenceError("Unknown global object.");
  }

  (function () {
    var GLOBE, LABEL;
    GLOBE = "\uD83C\uDF10";
    LABEL = "\uD83C\uDFF7";
    return Object.defineProperties(globalObject, _defineProperty({
      BCP47: {
        configurable: true,
        value: _BCP
      }
    }, "".concat(GLOBE).concat(LABEL), {
      configurable: true,
      value: _BCP
    }));
  })();

  Object.defineProperties(_BCP, {
    ℹ: {
      value: "https://go.KIBI.family/langtag/"
    },
    Nº: {
      value: Object.freeze({
        major: 1,
        minor: 0,
        patch: 1,
        toString: function toString() {
          return "".concat(this.major, ".").concat(this.minor, ".").concat(this.patch);
        },
        valueOf: function valueOf() {
          return this.major * 100 + this.minor + this.patch / 100;
        }
      })
    },
    context: {
      writable: true,
      value: typeof self !== "undefined" && self !== null ? self : typeof window !== "undefined" && window !== null ? window : {}
    }
  });
}).call(void 0);
