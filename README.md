<header>
  <div align="right">
    <b><cite>langtag</cite></b><br />
    Source and Documentation<br />
    <code>README.md</code>
  </div>
  <hr />
  <div align="justify">
    <small>
      Copyright © 2018 Kyebego.
      Code released under GNU GPLv3 (or any later version);
        documentation released under CC BY-SA 4.0.
      For more information, see the license notice at the bottom of
        this document.
    </small>
  </div>
</header>

#  langtag  #

>   Reference specifications:
>   + <https://tools.ietf.org/html/bcp47>

A language tag parser, matching the ABNF specified in BCP47.
Only tests well&hyphen;formedness, *not* validity.

##  Usage  ##

This script provides a single constructor, which will attach itself to
  the `BCP47` property on `self`/`window`/`exports`.
Calling with `new` is optional.
Pass in a string, and get an object back.

If a tag does not contain a production, you will get `undefined`.
If a production contains multiple subtags, you will get back an array.
Otherwise, you will get a string.
For example:

>   ```js
>   BCP47("en").language
>   //  ⇒  "en"
>
>   BCP47("en").script
>   //  ⇒  undefined
>
>   BCP47("zh-yue-HK").language
>   //  ⇒  ["zh", "yue"]
>
>   BCP47("en-a-myext-b-another").singleton
>   //  ⇒  ["a", "b"]
>   ```

##  Annotated Source  ##

The remainder of this document gives the source code for langtag.

###  Setup:

The following is just a regexification of the ABNF in BCP47.

    regex = ///
      ^
      (?:
        (  #  `privateuseonly` [= `privateuse`]
          x
          (?:
            -
            [0-9A-Za-z]{1,8}
          )+
        ) | (  #  `grandfathered`
               #  non-redundant tags registered
               #  during the RFC 3066 era
          (  #  `irregular`
             #  irregular tags do not match
             #  the 'langtag' production and
             #  would not otherwise be
             #  considered 'well-formed'
             #  These tags are all valid,
             #  but most are deprecated
             #  in favor of more modern
             #  subtags or subtag
             #  combination
            en-GB-oed
            | i-(?:
              ami
              | bnn
              | default
              | enochian
              | hak
              | klingon
              | lux
              | mingo
              | navajo
              | pwn
              | tao
              | tay
              | tsu
            ) | sgn-(?:
              BE-FR |
              BE-NL |
              CH-DE
            )
          ) | (  #  `regular`
                 #  these tags match the 'langtag'
                 #  production, but their subtags
                 #  are not extended language
                 #  or variant subtags: their meaning
                 #  is defined by their registration
                 #  and all of these are deprecated
                 #  in favor of a more modern
                 #  subtag or sequence of subtags
            art-lojban
            | cel-gaulish
            | no-bok
            | no-nyn
            | zh-(?:
              guoyu
              | hakka
              | min(?:
                -nan
              )? | xiang
            )
          )
        ) | (  #  `langtag`
          (  #  `language`
            [A-Za-z]{2,3}  #  shortest ISO 639 code
            (?:  #  sometimes followed by extended language subtags
              -
              (  # `extlang`
                [A-Za-z]{3}  #  selected ISO 639 codes
                (?:-[A-Za-z]{3}){0,2}  #  permanently reserved
              )
            )?
            | [A-za-z]{4}  #  or reserved for future use
            | [A-Za-z]{5,8}  #  or registered language subtag
          )
          (?:
            -
            (  #  `script`
              [A-Za-z]{4}  #  ISO 15924 code
            )
          )?
          (?:
            -
            (  #  `region`
              [A-Za-z]{2}  #  ISO 3166-1 code
              | \d{3}  #  UN M.49 code
            )
          )?
          (?:
            -
            (  #  `variants`
              (?:  #  [= `variant`]
                [0-9A-Za-z]{5,8}  #  registered variants
                | \d[0-9A-Za-z]{3}
              )
              (?:
                -
                (?:  #  [= `variant`]
                  [0-9A-Za-z]{5,8}
                  | \d[0-9A-Za-z]{3}
                )
              )*
            )
          )?
          (?:
            -
            (  #  `extensions`
              (?:  #  [= `extension`]
                (?:  #  [= `singleton`]
                           #  Single alphanumerics
                           #  "x" reserved for private use
                  [0-9]    #  0 - 9
                  | [A-W]  #  A - W
                  | [Y-Z]  #  Y - Z
                  | [a-w]  #  a - w
                  | [y-z]  #  y - z
                )
                (?:
                  -
                  [0-9A-Za-z]{2,8}
                )+
              )
              (?:
                -
                (?:  #  [= `extension`]
                  [0-9A-WY-Za-wy-z]  #  [= `singleton`]
                  (?:
                    -
                    [0-9A-Za-z]{2,8}
                  )+
                )
              )*
            )
          )?
          (?:
            -
            (  #  `privateuse`
              x
              (?:
                -
                [0-9A-Za-z]{1,8}
              )+
            )
          )?
        )
      )
      $
    ///

The helper function `splitTags()` splits the given input on `"-"`.

    splitTags = (input) ->
      return [] unless input?
      if input instanceof Array then Array::reduce.call input, (
        (result, current) ->
          result.push (splitTags current)...
          result
      ), []
      else String::split.call input, "-"

`BCP47`'s properties will return an array of subtags if more than one
  apply, or a string if there is only one result.
`gatherSubtagsFrom(subtags)` produces the correct return value.

    gatherSubtagsFrom = (subtags) ->
      tags = splitTags subtags
      return unless tags.length
      if tags.length is 1
        return tags[0] or undefined  #  Don't return the empty string
      return tags

The helper function `buildSubtagArray()` returns an array of subtags
  given a string or `BCP47`&hyphen;like object.

    buildSubtagArray = (tag) ->
      return [] unless tag?
      if tags = tag.langtag ? (
        tag.privateuse ? (
          tag.grandfathered ? (tag.irregular ? tag.regular)
        )
      ) then return splitTags tags
      return splitTags tag, "-" unless tags = tag.language?
      tags = splitTags tags
      tags.push (splitTags tag.script)...,
        (splitTags tag.region)...,
        (splitTags tag.variant ? tag.variants)...,
        (splitTags tag.extension ? tag.extensions)...,
        (splitTags tag.privateuse ? tag.privateUse)...

###  The Constructor:

The `BCP47()` function returns an object whose properties give the
  various components of the language tag, as arrays.

    BCP47 = (tag) ->
      throw new TypeError "
        Language tag not well-formed under BCP47.
      " unless tag? and match = String::match.call tag, regex
      [ match
        privateuseonly
        grandfathered
        irregular
        regular
        langtag
        language
        extlang
        script
        region
        variants
        extensions
        privateuse
      ] = match

It is not required that `BCP47()` be called as a constructor.

      result = if @ instanceof BCP47 then @ else Object.create BCP47::
      Object.defineProperties result,

###  Instance Properties:

####  `bcp47.langtag`.

`langtag` can be used to access the entire language tag, unless it is
  a grandfathered or private-use tag.

        langtag: value: gatherSubtagsFrom langtag

####  `bcp47.language`.

The `language` component of the tag, or the empty string.

        language: value: gatherSubtagsFrom language

####  `bcp47.extlang`.

The `extlang` component of the tag, or the empty string.

        extlang: value: gatherSubtagsFrom extlang

####  `bcp47.script`.

The `script` component of the tag, or the empty string.

        script: value: gatherSubtagsFrom script

####  `bcp47.region`.

The `region` component of the tag, or the empty string.

        region: value: gatherSubtagsFrom region

####  `bcp47.variant`.

The `variant` component of the tag, or the empty string.

        variant: value: gatherSubtagsFrom variants

####  `bcp47.extension`.

The `extension` component of the tag, or the empty string.

        extension: value: gatherSubtagsFrom extensions

####  `bcp47.singleton`.

The `singleton` component of the tag, or the empty string.
This holds the first (single&hyphen;character) subtag of each
  extension.

        singleton: value: gatherSubtagsFrom (
          splitTags extensions
            .filter (subtag) -> subtag.length is 1
        )

####  `bcp47.privateuse`.

The `privateuse` component of the tag, or the empty string.

        privateuse: value: gatherSubtagsFrom privateuse ? privateuseonly

####  `bcp47.grandfathered`.

The `grandfathered` component of the tag, or the empty string.

        grandfathered: value: gatherSubtagsFrom grandfathered

####  `bcp47.irregular`.

The `irregular` component of the tag, or the empty string.
This holds irregular grandfathered tags.

        irregular: value: gatherSubtagsFrom irregular

####  `bcp47.regular`.

The `regular` component of the tag, or the empty string.
This holds regular grandfathered tags.

        regular: value: gatherSubtagsFrom regular

####  `bcp47[n]`.

Subscripting may also be used to access the subtags of the instance.

      subtags = splitTags match
      for subtag, index in subtags
        Object.defineProperty result, index,
          enumerable: yes
          value: subtag

####  `bcp47.length`.

`length` gives the number of subtags.

      Object.defineProperty result, "length", value: subtags.length

###  The Prototype:

`BCP47` just inherits from `Object`.

    Object.defineProperty BCP47, "prototype",
      writable: no
      value: Object.defineProperties {},

###  Instance Methods:

####  `bcp47.constructor()`.

`constructor()` is just the `BCP47()` constructor.

        constructor: value: BCP47

####  `bcp47.toString()`.

The `toString()` method returns string representation of the tag.

        toString: value: -> (buildSubtagArray @).join "-"

####  `bcp47.valueOf()`.

The `valueOf()` method returns the `Array` representation of the tag.

        valueOf: value: -> buildSubtagArray @

###  Constructor Properties:

####  `BCP47.regex`.

The BCP47 `regex` is available as a property on the `BCP47()`
  constructor itself.

    Object.defineProperties BCP47,
      regex:
        enumerable: yes
        value: regex

###  Constructor Methods:

####  `BCP47.test(tag)`.

The `test()` function checks if a given string is a well-formed tag,
  returning `true` or `false`.

      test:
        enumerable: yes
        value: (tag) -> regex.test tag

####  `BCP47.testǃ(tag)`.

The `testǃ()` function does the same, but returns `undefined`, and
  throws an error if it is not.

      testǃ:
        enumerable: yes
        value: (tag) -> throw new TypeError "
          Language tag not well-formed under to BCP47.
        " unless regex.test tag


###  Availability:

langtag's `BCP47` constructor is defined on "the global object", which
  is the first of the following which is defined:

+ `self`
+ `window`
+ `exports`
+ `global`

    globalObject = self ? (window ? (exports ? (global ? null)))

It is an error if no global object could be found.

    throw new ReferenceError "
      Unknown global object.
    " unless globalObject?

langtag targets vanilla ES 5.1, so it doesn't bother with modules or
  similar.
It simply attaches its constructor to the global object at `"BCP47"`.
For the adventurous, you can also access the BCP47 constructor from
  the emoji sequence `"🌐🏷"`.

    do ->
      GLOBE = "\u{1F310}"
      LABEL = "\u{1F3F7}"
      Object.defineProperties globalObject,
        BCP47:
          configurable: yes
          value: BCP47
        "#{GLOBE}#{LABEL}":
          configurable: yes
          value: BCP47

###  Identity Information:

The global `BCP47` constructor identifies itself using a number of
  properties, so that you can easily tell which version you are using
  (and so that you can build tools which support multiple versions!)

    Object.defineProperties BCP47,

The `ℹ` property provides an identifying URI for the API author of this
  version of langtag.
If you fork langtag and change its API, you should also change this
  value.

      ℹ: value: "https://go.KIBI.family/langtag/"

The `Nº` property provides the version number of this version of
  ｍｅｒｍａｉｄ, as an object with three parts: `major`, `minor`, and
  `patch`.
It is up to the API author (identified above) to determine how these
  parts should be interpreted.
It is recommended that the `toString()` and `valueOf()` methods be
  implemented as well.

      Nº: value: Object.freeze
        major: 1
        minor: 0
        patch: 0
        toString: -> "#{@major}.#{@minor}.#{@patch}"
        valueOf: -> @major * 100 + @minor + @patch / 100

###  Dependencies:

`BCP47` doesn't have any dependencies.
If it did, it would access them from the `context` property, which
  defaults to `self` or `window`.
This is only defined for compatibility with other scripts.

      context:
        writable: yes
        value: self ? (window ? {})

<footer>
  <details>
  <summary>License notice</summary>
  <p>This program is free software is free software: you can
    redistribute it and/or modify it under the terms of the GNU
    General Public License as published by the Free Software
    Foundation, either version 3 of the License, or (at your option)
    any later version. Similarly, you can redistribute and/or modify
    the documentation sections of this document under the terms of the
    Creative Commons Attribution-ShareAlike 4.0 International
    License.</p>
  <p>This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
    General Public License for more details.</p>
  <p>You should have received copies of the GNU General Public License
    and the Creative Commons Attribution-ShareAlike 4.0 International
    License along with this source. If not, see
    https://www.gnu.org/licenses/ and
    https://creativecommons.org/licenses/by-sa/4.0/.</p>
  </details>
</footer>
