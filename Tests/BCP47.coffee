{ expect } = require "chai"
{ BCP47 } = require "../Build/langtag.js"

describe "BCP47", ->

  it "exists", ->
    expect BCP47
      .a "function"

  describe "Identity", ->

    it "has the correct API ID", ->
      expect BCP47
        .has.ownProperty "ℹ"
        .which.equals "https://go.KIBI.family/langtag/"

    it "has the correct version", ->
      packageVersion = process.env.npm_package_version
      [ major, minor, patch ] = packageVersion.split "."
      expect BCP47, "… numero"
        .has.ownProperty "Nº"
      expect BCP47.Nº, "… major"
        .has.ownProperty "major"
        .which.equals +major
      expect BCP47.Nº, "… minor"
        .has.ownProperty "minor"
        .which.equals +minor
      expect BCP47.Nº, "… patch"
        .has.ownProperty "patch"
        .which.equals +patch
      expect "#{BCP47.Nº}", "… string"
        .equals packageVersion
      expect +BCP47.Nº, "… value"
        .equals +major * 100 + +minor + +patch / 100

    it "has a context", ->
      expect BCP47
        .has.ownProperty "context"
        .a "object"

  describe "Constructor", ->

    it "can be called as a constructor", ->
      expect tag = new BCP47 "lo-rem-Ipsu-MD-olors-i-ta-x-me"
        .instanceOf BCP47
      expect (do tag.valueOf), "… to produce correct value"
        .has.ordered.members "lo-rem-Ipsu-MD-olors-i-ta-x-me".split "-"

    it "can be called as a function", ->
      expect tag = new BCP47 "lo-rem-Ipsu-MD-olors-i-ta-x-me"
        .instanceOf BCP47
      expect (do tag.valueOf), "… to produce correct value"
        .has.ordered.members "lo-rem-Ipsu-MD-olors-i-ta-x-me".split "-"

    describe "Properties", ->

      it ".regex", ->
        expect BCP47
          .has.ownProperty "regex"
          .instanceOf RegExp

    describe "Methods", ->

      it ".test()", ->
        expect BCP47
          .has.ownProperty "test"
          .a "function"
        expect BCP47.test "lo"
          .is.true
        expect do BCP47.test
          .is.false

      it ".testǃ()", ->
        expect BCP47
          .has.ownProperty "testǃ"
          .a "function"
        expect BCP47.testǃ "lo"
          .is.undefined
        do expect BCP47.testǃ
          .throws

  describe "Instances", ->

    it "is iterable", ->
      expect tag = new BCP47 "lo-rem-Ipsu-MD-olors-i-ta-x-me"
        .instanceOf BCP47
      continue for _, index in tag
      expect index
        .equals tag.length

    describe "Properties", ->  #  See later tests for subtag mapping

      it "[]", ->
        expect tag = new BCP47 "lo-rem-Ipsu-MD-olors-i-ta-x-me"
          .instanceOf BCP47
        expect tag
          .has.ownProperty i = 0
          .which.equals "lo"
        expect tag
          .has.ownProperty ++i
          .which.equals "rem"
        expect tag
          .has.ownProperty ++i
          .which.equals "Ipsu"
        expect tag
          .has.ownProperty ++i
          .which.equals "MD"
        expect tag
          .has.ownProperty ++i
          .which.equals "olors"
        expect tag
          .has.ownProperty ++i
          .which.equals "i"
        expect tag
          .has.ownProperty ++i
          .which.equals "ta"
        expect tag
          .has.ownProperty ++i
          .which.equals "x"
        expect tag
          .has.ownProperty ++i
          .which.equals "me"

      it ".length", ->
        expect tag = new BCP47 "lo-rem-Ipsu-MD-olors-i-ta-x-me"
          .instanceOf BCP47
        expect tag
          .has.ownProperty "length"
          .which.equals 9

      it "sets non-present tags to `undefined`", ->
        expect tag = new BCP47 "lo"
          .instanceOf BCP47
        expect tag
          .has.ownProperty "extlang"
          .which.is.undefined
        expect tag
          .has.ownProperty "script"
          .which.is.undefined
        expect tag
          .has.ownProperty "region"
          .which.is.undefined
        expect tag
          .has.ownProperty "variant"
          .which.is.undefined
        expect tag
          .has.ownProperty "extension"
          .which.is.undefined
        expect tag
          .has.ownProperty "singleton"
          .which.is.undefined
        expect tag
          .has.ownProperty "privateuse"
          .which.is.undefined
        expect tag
          .has.ownProperty "grandfathered"
          .which.is.undefined
        expect tag
          .has.ownProperty "irregular"
          .which.is.undefined
        expect tag
          .has.ownProperty "regular"
          .which.is.undefined
        expect tag = new BCP47 "x-rem-ipsum"
          .instanceOf BCP47
        expect tag
          .has.ownProperty "langtag"
          .which.is.undefined
        expect tag
          .has.ownProperty "language"
          .which.is.undefined

    describe "Methods", ->

      it ".toString()", ->
        expect tag = new BCP47 "lo-rem-ips-umd-Olor-SI-tamet"
          .instanceOf BCP47
        expect do tag.toString
          .equals "lo-rem-ips-umd-Olor-SI-tamet"

      it ".valueOf()", ->
        expect tag = new BCP47 "lo-rem-ips-umd-Olor-SI-tamet"
          .instanceOf BCP47
        expect do tag.valueOf
          .has.ordered.members "lo-rem-ips-umd-Olor-SI-tamet".split "-"

  describe "Tag Tests", ->

    describe "Appendix A.  Examples of Language Tags (Informative)", ->

      describe "Simple language subtag", ->

        it "German", ->
          expect tag = new BCP47 "de"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "de" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "de"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 1

        it "French", ->
          expect tag = new BCP47 "fr"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "fr" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "fr"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 1

        it "Japanese", ->
          expect tag = new BCP47 "ja"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "ja" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "ja"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 1

        it "example of a grandfathered tag", ->
          expect tag = new BCP47 "i-enochian"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "i", "enochian" ]
          expect tag, "… has correct grandfathered"
            .has.ownProperty "grandfathered"
            .which.has.ordered.members [ "i", "enochian" ]
          expect tag, "… has correct irregular"
            .has.ownProperty "irregular"
            .which.has.ordered.members [ "i", "enochian" ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

      describe "Language subtag plus Script subtag", ->

        it "Chinese written using the Traditional Chinese script", ->
          expect tag = new BCP47 "zh-Hant"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "zh", "Hant" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "zh"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Hant"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "Chinese written using the Simplified Chinese script", ->
          expect tag = new BCP47 "zh-Hans"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "zh", "Hans" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "zh"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Hans"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "Serbian written using the Cyrillic script", ->
          expect tag = new BCP47 "sr-Cyrl"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sr", "Cyrl" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sr"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Cyrl"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "Serbian written using the Latin script", ->
          expect tag = new BCP47 "sr-Latn"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sr", "Latn" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sr"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Latn"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

      describe "
        Extended language subtags and their primary language subtag
          counterparts
      ", ->

        it "Chinese, Mandarin, Simplified script, as used in China", ->
          expect tag = new BCP47 "zh-cmn-Hans-CN"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "zh", "cmn", "Hans", "CN" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.has.ordered.members [ "zh", "cmn" ]
          expect tag, "… has correct extlang"
            .has.ownProperty "extlang"
            .which.equals "cmn"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Hans"
          expect tag, "… has correct tag"
            .has.ownProperty "region"
            .which.equals "CN"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 4

        it "Mandarin Chinese, Simplified script, as used in China", ->
          expect tag = new BCP47 "cmn-Hans-CN"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "cmn", "Hans", "CN" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "cmn"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Hans"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "CN"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "Chinese, Cantonese, as used in Hong Kong SAR", ->
          expect tag = new BCP47 "zh-yue-HK"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "zh", "yue", "HK" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.has.ordered.members [ "zh", "yue" ]
          expect tag, "… has correct extlang"
            .has.ownProperty "extlang"
            .which.equals "yue"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "HK"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "Cantonese Chinese, as used in Hong Kong SAR", ->
          expect tag = new BCP47 "yue-HK"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "yue", "HK" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "yue"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "HK"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

      describe "Language-Script-Region", ->

        it "
          Chinese written using the Simplified script as used in
            mainland China
        ", ->
          expect tag = new BCP47 "zh-Hans-CN"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "zh", "Hans", "CN" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "zh"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Hans"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "CN"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "
          Serbian written using the Latin script as used in
            Serbia
        ", ->
          expect tag = new BCP47 "sr-Latn-RS"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sr", "Latn", "RS" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sr"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Latn"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "RS"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

      describe "Language-Variant", ->

        it "Resian dialect of Slovenian", ->
          expect tag = new BCP47 "sl-rozaj"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sl", "rozaj" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sl"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.equals "rozaj"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "San Giorgio dialect of Resian dialect of Slovenian", ->
          expect tag = new BCP47 "sl-rozaj-biske"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sl", "rozaj", "biske" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sl"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.has.ordered.members [ "rozaj", "biske" ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "Nadiza dialect of Slovenian", ->
          expect tag = new BCP47 "sl-nedis"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sl", "nedis" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sl"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.equals "nedis"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

      describe "Language-Region-Variant", ->

        it "
          German as used in Switzerland using the 1901 variant
            (orthography)
        ", ->
          expect tag = new BCP47 "de-CH-1901"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "de", "CH", "1901" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "de"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "CH"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.equals "1901"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "Slovenian as used in Italy, Nadiza dialect", ->
          expect tag = new BCP47 "sl-IT-nedis"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sl", "IT", "nedis" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sl"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "IT"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.equals "nedis"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

      describe "Language-Script-Region-Variant", ->

        it "
          Eastern Armenian written in Latin script, as used in Italy
        ", ->
          expect tag = new BCP47 "hy-Latn-IT-arevela"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "hy", "Latn", "IT", "arevela" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "hy"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Latn"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "IT"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.equals "arevela"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 4

      describe "Language-Region", ->

        it "German for Germany", ->
          expect tag = new BCP47 "de-DE"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "de", "DE" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "de"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "DE"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "English as used in the United States", ->
          expect tag = new BCP47 "en-US"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "en", "US" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "en"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "US"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "
          Spanish appropriate for the Latin America and Caribbean
            region using the UN region code
        ", ->
          expect tag = new BCP47 "es-419"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "es", "419" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "es"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "419"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

      describe "Private use subtags", ->

        it "de-CH-x-phonebk", ->
          expect tag = new BCP47 "de-CH-x-phonebk"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "de", "CH", "x", "phonebk" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "de"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "CH"
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members ["x", "phonebk"]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 4

        it "az-Arab-x-AZE-derbend", ->
          expect tag = new BCP47 "az-Arab-x-AZE-derbend"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "az", "Arab", "x", "AZE", "derbend"
            ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "az"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Arab"
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members ["x", "AZE", "derbend"]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 5

      describe "Private use registry values", ->

        it "private use using the singleton 'x'", ->
          expect tag = new BCP47 "x-whatever"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "x", "whatever" ]
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members ["x", "whatever"]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "all private tags", ->
          expect tag = new BCP47 "qaa-Qaaa-QM-x-southern"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "qaa", "Qaaa", "QM", "x", "southern"
            ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "qaa"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Qaaa"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "QM"
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members ["x", "southern"]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 5

        it "German, with a private script", ->
          expect tag = new BCP47 "de-Qaaa"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "de", "Qaaa" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "de"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Qaaa"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 2

        it "Serbian, Latin script, private region", ->
          expect tag = new BCP47 "sr-Latn-QM"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sr", "Latn", "QM" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sr"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Latn"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "QM"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

        it "Serbian, private script, for Serbia", ->
          expect tag = new BCP47 "sr-Qaaa-RS"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "sr", "Qaaa", "RS" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "sr"
          expect tag, "… has correct script"
            .has.ownProperty "script"
            .which.equals "Qaaa"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "RS"
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 3

      describe "Tags that use extensions", ->

        it "en-US-u-islamcal", ->
          expect tag = new BCP47 "en-US-u-islamcal"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "en", "US", "u", "islamcal" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "en"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "US"
          expect tag, "… has correct singleton"
            .has.ownProperty "singleton"
            .which.equals "u"
          expect tag, "… has correct extension"
            .has.ownProperty "extension"
            .which.has.ordered.members [ "u", "islamcal" ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 4

        it "zh-CN-a-myext-x-private", ->
          expect tag = new BCP47 "zh-CN-a-myext-x-private"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "zh", "CN", "a", "myext", "x", "private"
            ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "zh"
          expect tag, "… has correct region"
            .has.ownProperty "region"
            .which.equals "CN"
          expect tag, "… has correct singleton"
            .has.ownProperty "singleton"
            .which.equals "a"
          expect tag, "… has correct extension"
            .has.ownProperty "extension"
            .which.has.ordered.members [ "a", "myext" ]
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members [ "x", "private" ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 6

        it "en-a-myext-b-another", ->
          expect tag = new BCP47 "en-a-myext-b-another"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "en", "a", "myext", "b", "another" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "en"
          expect tag, "… has correct singleton"
            .has.ownProperty "singleton"
            .which.has.ordered.members [ "a", "b" ]
          expect tag, "… has correct extension"
            .has.ownProperty "extension"
            .which.has.ordered.members [ "a", "myext", "b", "another" ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 5

      describe "Some invalid tags", ->

        it "two region tags", ->
          do expect -> new BCP47 "de-419-DE"
            .throws

        it "use of a single-character subtag in primary position", ->
          do expect -> new BCP47 "a-DE"
            .throws

        it "two extensions with same single-letter prefix", ->
          #  This is still well-formed, so we need to support it.
          expect tag = new BCP47 "ar-a-aaa-b-bbb-a-ccc"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "ar", "a", "aaa", "b", "bbb", "a", "ccc"
            ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "ar"
          expect tag, "… has correct singleton"
            .has.ownProperty "singleton"
            .which.has.ordered.members [ "a", "b", "a" ]
          expect tag, "… has correct extension"
            .has.ownProperty "extension"
            .which.has.ordered.members [
              "a", "aaa", "b", "bbb", "a", "ccc"
            ]
          expect tag, "… has correct length"
            .has.ownProperty "length"
            .which.equals 7

    describe "Additional tags", ->

        it "four-letter language tag", ->
          expect tag = new BCP47 "lore"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "lore" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "lore"

        it "five-letter language tag", ->
          expect tag = new BCP47 "lorem"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "lorem" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "lorem"

        it "six-letter language tag", ->
          expect tag = new BCP47 "loremi"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "loremi" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "loremi"

        it "seven-letter language tag", ->
          expect tag = new BCP47 "loremip"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "loremip" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "loremip"

        it "eight-letter language tag", ->
          expect tag = new BCP47 "loremips"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "loremips" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "loremips"

        it "two-part extlang", ->
          expect tag = new BCP47 "lo-rem-ips"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "lo", "rem", "ips" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.has.ordered.members [ "lo", "rem", "ips" ]
          expect tag, "… has correct extlang"
            .has.ownProperty "extlang"
            .which.has.ordered.members [ "rem", "ips" ]

        it "three-part extlang", ->
          expect tag = new BCP47 "lo-rem-ips-umd"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "lo", "rem", "ips", "umd" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.has.ordered.members [ "lo", "rem", "ips", "umd" ]
          expect tag, "… has correct extlang"
            .has.ownProperty "extlang"
            .which.has.ordered.members [ "rem", "ips", "umd" ]

        it "six- and eight- letter variants", ->
          expect tag = new BCP47 "lo-remips-umdolors"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [ "lo", "remips", "umdolors" ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "lo"
          expect tag, "… has correct variant"
            .has.ownProperty "variant"
            .which.has.ordered.members [ "remips", "umdolors" ]

        it "
          two-, three-, four-, and six-letter extension components
        ", ->
          expect tag = new BCP47 "lo-r-em-ips-umdo-lorsit"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "lo", "r", "em", "ips", "umdo", "lorsit"
            ]
          expect tag, "… has correct language"
            .has.ownProperty "language"
            .which.equals "lo"
          expect tag, "… has correct extension"
            .has.ownProperty "extension"
            .which.has.ordered.members [
              "r", "em", "ips", "umdo", "lorsit"
            ]

        it "one-, two-, four-, five-, and six-letter privateuse", ->
          expect tag = new BCP47 "x-l-or-emip-sumdo-lorsit"
            .instanceOf BCP47
          expect (do tag.valueOf), "… has correct value"
            .has.ordered.members [
              "x", "l", "or", "emip", "sumdo", "lorsit"
            ]
          expect tag, "… has correct privateuse"
            .has.ownProperty "privateuse"
            .which.has.ordered.members [
              "x", "l", "or", "emip", "sumdo", "lorsit"
            ]

        it "regular grandfathered tag", ->
          expect tag = new BCP47 "zh-min-nan"
            .instanceOf BCP47
          expect tag, "… has no language"
            .has.ownProperty "language"
            .which.is.undefined
          expect tag, "… has no extlang"
            .has.ownProperty "extlang"
            .which.is.undefined
          expect tag, "… has correct grandfathered"
            .has.ownProperty "grandfathered"
            .which.has.ordered.members [ "zh", "min", "nan" ]
          expect tag, "… has correct regular"
            .has.ownProperty "regular"
            .which.has.ordered.members [ "zh", "min", "nan" ]

    describe "Not-well-formed tags", ->

      it "empty tag", ->
        do expect -> new BCP47 ""
          .throws

      it "nine-letter tag", ->
        do expect -> new BCP47 "loremipsu"
          .throws

      it "four-component extlang", ->
        do expect -> new BCP47 "lo-rem-ips-umd-olo"
          .throws
