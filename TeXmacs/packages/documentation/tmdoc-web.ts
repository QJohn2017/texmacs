<TeXmacs|1.0.3.4>

<style|<tuple|source|common-base>>

<\body>
  <assign|tmdoc-web-package|1.0>

  \;

  <assign|tmweb-current|<macro|main|sub|<assign|tmweb-main|<arg|main>><assign|tmweb-sub|<arg|sub>>>>

  <assign|tmweb-suffix|<macro|<case|<equal|<language>|german>|.de.tm|<equal|<language>|french>|.fr.tm|<equal|<language>|italian>|.it.tm|<equal|<language>|portuguese>|.pt.tm|<equal|<language>|spanish>|.es.tm|.en.tm>>>

  <assign|tmweb-link|<macro|what|to|<hlink|<with|color|<if|<or|<equal|<arg|what>|<tmweb-main>>|<equal|<arg|what>|<tmweb-sub>>>|dark
  green|brown>|<translate|<arg|what>|english|<language>>>|<if|<equal|<find-file|<merge|<arg|to>|<tmweb-suffix>>>|false>|<merge|<arg|to>|.en.tm>|<merge|<arg|to>|<tmweb-suffix>>>>>>

  <assign|tmweb-list-extra|<macro|x| \| <arg|x>>>

  <assign|tmweb-list|<xmacro|x| <arg|x|0><map-args|tmweb-list-extra|concat|x|1>
  >>

  \;

  <assign|tmweb-main-links|<macro|<tmweb-list|<tmweb-link|Home|../home/welcome>|<tmweb-link|Download|../download/download>|<tmweb-link|Help|../help/help>|<tmweb-link|Contribute|../contribute/contribute>|<tmweb-link|Plug-ins|../plugins/plugins>|<tmweb-link|About|../about/authors>|<tmweb-link|Contact|../contact/contact>|<hlink|<with|color|brown|<translate|Search|english|<language>>>|http://www.texmacs.org/search>>>>

  <assign|tmweb-title|<macro|title|bar|<tmdoc-title**|<tmweb-main-links>|<arg|title>|<arg|bar>>>>

  <assign|tmweb-license|<\macro>
    <\tmdoc-license>
      <active*|<\with|color|dark grey|font-size|0.84>
        This webpage is part of <hlink|GNU <TeXmacs>|http://www.texmacs.org>
        and the larger <hlink|GNU project|http://www.gnu.org>. Verbatim
        copying and distribution of it is permitted in any medium, provided
        this notice is preserved. For more information or questions, please
        contact <hlink|Joris van der Hoeven|http://www.texmacs.org/Web/Mail.html>.

        <hlink|Free Software Foundation|http://www.fsf.org/fsf/fsf.html>,
        Inc., 59 Temple Place - Suite 330, Boston, MA 02111, USA
      </with>>
    </tmdoc-license>
  </macro>>

  \;

  <assign|tmweb-home-links|<macro|<tmweb-list|<tmweb-link|Welcome|welcome>|<tmweb-link|Screen
  shots|screenshots>|<tmweb-link|News|news>|<tmweb-link|Mailing lists|ml>>>>

  <assign|tmweb-download-links|<macro|<tmweb-list|<tmweb-link|General|download>|<tmweb-link|Sources|sources>|<tmweb-link|Binaries|unix>|<tmweb-link|RPM|rpm>|<tmweb-link|Knoppix|knoppix>|<tmweb-link|CVS|cvs>|<tmweb-link|Fonts|fonts>|<tmweb-link|Requirements|requirements>>>>

  <assign|tmweb-help-links|<macro|<tmweb-list|<tmweb-link|General|help>|<tmweb-link|FAQ|faq>|<tmweb-link|Tutorial|tutorial>|<tmweb-link|Manual|manual>|<tmweb-link|Articles|articles>>>>

  <assign|tmweb-contribute-links|<macro|<tmweb-list|<tmweb-link|Helping|contribute>|<tmweb-link|Documentation|documentation>|<tmweb-link|Translations|translations>|<tmweb-link|Extensions|plugins>|<tmweb-link|Donations|donations>>>>

  <assign|tmweb-plugin-links|<macro|<tmweb-list|<tmweb-link|All|plugins>|<tmweb-link|Mathematics|cas>|<tmweb-link|Numerics|numerics>|<tmweb-link|Statistics|statistics>|<tmweb-link|Physics|physics>|<tmweb-link|Graphics|graphics>|<tmweb-link|Education|education>|<tmweb-link|Tools|tools>>>>

  <assign|tmweb-about-links|<macro|<tmweb-list|<tmweb-link|Authors|authors>|<tmweb-link|Philosophy|philosophy>|<tmweb-link|Changes|changes>|<tmweb-link|Plans|plans>|<tmweb-link|Artwork|artwork>|<tmweb-link|License|license>>>>

  <assign|tmweb-contact-links|<macro|<tmweb-list|<tmweb-link|Feedback|contact>|<tmweb-link|Bugs|bugs>|<tmweb-link|Suggestions|wishes>|<tmweb-link|Patches|patches>>>>

  \;

  <assign|tmweb-manual-links|<macro|previous|next|<tmweb-list|<tmweb-link|Manual|../help/manual>|<tmweb-link|Top|web-manual>|<tmweb-link|Previous|<arg|previous>>|<tmweb-link|Next|<arg|next>>>>>

  <assign|tmweb-tutorial-links|<macro|previous|next|<tmweb-list|<tmweb-link|Tutorial|../help/tutorial>|<tmweb-link|Top|web-tutorial>|<tmweb-link|Previous|<arg|previous>>|<tmweb-link|Next|<arg|next>>>>>

  \;

  <assign|tmweb-image|<macro|name|<postscript|<merge|http://www.texmacs.org/Samples/|<arg|name>>|*2/3|||||>>>

  <assign|tmweb-email|<macro|name|domain|<active*|<with|font-family|tt|color|dark
  magenta|\<less\>>><with|font-family|tt|color|dark
  blue|<arg|name>><active*|<with|font-family|tt|color|dark
  magenta|@>><with|font-family|tt|color|dark
  blue|<arg|domain>><active*|<with|font-family|tt|color|dark
  magenta|\<gtr\>>>>>

  \;

  <assign|texmacs-stable-targz|<macro|1.0.2>>

  <assign|texmacs-stable-rpm|<macro|1.0.2-1>>

  <assign|texmacs-version|<macro|1.0.2.1>>

  \;
</body>

<\initial>
  <\collection>
    <associate|language|english>
    <associate|page-bot|30mm>
    <associate|page-even|30mm>
    <associate|page-odd|30mm>
    <associate|page-reduce-bot|15mm>
    <associate|page-reduce-left|25mm>
    <associate|page-reduce-right|25mm>
    <associate|page-reduce-top|15mm>
    <associate|page-right|30mm>
    <associate|page-top|30mm>
    <associate|page-type|a4>
    <associate|par-width|150mm>
    <associate|preamble|true>
    <associate|sfactor|4>
  </collection>
</initial>