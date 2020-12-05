<TeXmacs|1.99.16>

<style|source>

<\body>
  <active*|<\src-title>
    <src-package|comment|1.0>

    <\src-purpose>
      Various types of comments by various authors on a text
    </src-purpose>

    <src-copyright|2020|Joris van der Hoeven>

    <\src-license>
      This software falls under the <hlink|GNU general public license,
      version 3 or later|$TEXMACS_PATH/LICENSE>. It comes WITHOUT ANY
      WARRANTY WHATSOEVER. You should have received a copy of the license
      which the software. If not, see <hlink|http://www.gnu.org/licenses/gpl-3.0.html|http://www.gnu.org/licenses/gpl-3.0.html>.
    </src-license>
  </src-title>>

  <use-package|std-shadow>

  <use-module|(various comment-menu)>

  <\active*>
    <\src-comment>
      Rendering macros
    </src-comment>
  </active*>

  <assign|comment-color|<macro|by|dark magenta>>

  <assign|abbreviate-name|<macro|by|<extern|ext-abbreviate-name|<arg|by>>>>

  <assign|render-inline-comment|<macro|by|body|<surround|<with|color|<comment-color|<arg|by>>|[<condensed|<name|<abbreviate-name|<arg|by>>>>:
  >|<with|color|<comment-color|<arg|by>>|]>|<arg|body>>>>

  <assign|render-block-comment|<macro|by|body|<surround|<with|color|<comment-color|<arg|by>>|<condensed|<name|<abbreviate-name|<arg|by>>>>\<rangle\>
  >|<right-flush>|<arg|body>>>>

  <assign|render-box-comment|<\macro|by|body>
    <with|shadow-elevation|0.75|<\half-bend-in-shadow>
      <\wide-tabular>
        <tformat|<cwith|1|1|1|1|cell-background|<comment-color|<arg|by>>>|<cwith|1|-1|1|1|cell-lsep|1spc>|<cwith|1|-1|1|1|cell-rsep|1spc>|<cwith|1|-1|1|1|cell-tsep|0.5spc>|<cwith|1|-1|1|1|cell-bsep|0.5spc>|<cwith|2|-1|1|1|cell-tsep|2spc>|<cwith|2|-1|1|1|cell-bsep|1spc>|<table|<row|<\cell>
          <samp|<with|color|white|locus-color|preserve|<copy|<arg|by>>>>
        </cell>>|<row|<\cell>
          <arg|body>
        </cell>>>>
      </wide-tabular>
    </half-bend-in-shadow>>
  </macro>>

  <\active*>
    <\src-comment>
      Various kinds of comments
    </src-comment>
  </active*>

  <assign|inline-comment|<macro|unique-id|mirror-id|type|by|time|body|<with|old-locus-color|<value|locus-color>|locus-color|preserve|<style-with|src-compact|none|<locus|<id|<arg|mirror-id>>|<observer|<arg|unique-id>|mirror-notify>|<with|locus-color|<value|old-color>|<surround|<extern|mirror-initialize|<quote-arg|body>>||<expand-as|<arg|body>|<render-inline-comment|<arg|by>|<arg|body>>>>>>>>>>

  <assign|block-comment|<macro|unique-id|mirror-id|type|by|time|body|<with|old-locus-color|<value|locus-color>|locus-color|preserve|<style-with|src-compact|none|<locus|<id|<arg|mirror-id>>|<observer|<arg|unique-id>|mirror-notify>|<with|locus-color|<value|old-color>|<surround|<extern|mirror-initialize|<quote-arg|body>>||<expand-as|<arg|body>|<render-block-comment|<arg|by>|<arg|body>>>>>>>>>>

  <assign|show-comment|<macro|unique-id|mirror-id|type|by|time|body|<expand-as|<arg|body>|<compound|<if|<equal|<get-label|<quote-arg|body>>|document>|block-comment|inline-comment>|<arg|unique-id>|<arg|mirror-id>|<arg|type>|<arg|by>|<arg|time>|<arg|body>>>>>

  <assign|nested-comment|<macro|unique-id|mirror-id|type|by|time|body|<expand-as|<arg|body>|<compound|<if|<equal|<get-label|<quote-arg|body>>|document>|block-comment|inline-comment>|<arg|unique-id>|<arg|mirror-id>|<arg|type>|<arg|by>|<arg|time>|<arg|body>>>>>

  <assign|hide-comment|<macro|unique-id|mirror-id|type|by|time|body|<with|old-locus-color|<value|locus-color>|locus-color|preserve|<style-with|src-compact|none|<locus|<id|<arg|mirror-id>>|<observer|<arg|unique-id>|mirror-notify>|<expand-as|<arg|body>|<extern|mirror-initialize|<quote-arg|body>><flag|<abbreviate-name|<arg|by>>|<comment-color|<arg|by>>><hidden|<arg|body>>>>>>>>

  <assign|mirror-comment|<macro|unique-id|mirror-id|type|by|time|body|<with|old-locus-color|<value|locus-color>|locus-color|preserve|<style-with|src-compact|none|<locus|<id|<arg|mirror-id>>|<observer|<arg|unique-id>|mirror-notify>|<with|locus-color|<value|old-color>|<surround|<extern|mirror-initialize|<quote-arg|body>>||<render-box-comment|<arg|by>|<arg|body>>>>>>>>>

  <assign|preview-comment|<\macro|unique-id|mirror-id|type|by|time|body>
    <\preview-balloon>
      <render-block-comment|<arg|by>|<arg|body>>
    </preview-balloon>
  </macro>>

  <drd-props|show-comment|arity|6|accessible|5>

  <drd-props|nested-comment|arity|6|accessible|5>

  <drd-props|mirror-comment|arity|6|accessible|5>

  <\active*>
    <\src-comment>
      Completely invisible comments (except when they contain visible nested
      comments)
    </src-comment>
  </active*>

  <assign|invisible-comment|<macro|unique-id|mirror-id|type|by|time|body|<hidden|<arg|body>>>>

  <assign|invisible-show-comment|<macro|unique-id|mirror-id|type|by|time|body|<compound|<if|<extern|ext-contains-visible-comments?|<quote-arg|body>>|<if|<equal|<get-label|<quote-arg|body>>|document>|block-comment|inline-comment>|invisible-comment>|<arg|unique-id>|<arg|mirror-id>|<arg|type>|<arg|by>|<arg|time>|<arg|body>>>>

  <assign|invisible-hide-comment|<macro|unique-id|mirror-id|type|by|time|body|<compound|<if|<extern|ext-contains-visible-comments?|<quote-arg|body>>|hide-comment|invisible-comment>|<arg|unique-id>|<arg|mirror-id>|<arg|type>|<arg|by>|<arg|time>|<arg|body>>>>

  <assign|invisible-nested-comment|<macro|unique-id|mirror-id|type|by|time|body|<compound|<if|<extern|ext-contains-visible-comments?|<quote-arg|body>>|nested-comment|invisible-comment>|<arg|unique-id>|<arg|mirror-id>|<arg|type>|<arg|by>|<arg|time>|<arg|body>>>>

  \;
</body>

<\initial>
  <\collection>
    <associate|preamble|true>
  </collection>
</initial>