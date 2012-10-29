
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
          "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>db/migrate/20100209131137_create_schema.rb - gpo in АИС &quot;Проекты ГПО&quot; - Gitorious</title>
<link href="/stylesheets/gts-common.css?1346159567" media="screen" rel="stylesheet" type="text/css" />
<link href="//fonts.googleapis.com/css?family=Nobile&amp;v1" type="text/css" rel="stylesheet">

<script src="/javascripts/all.js?1346159641" type="text/javascript"></script>      <link href="/stylesheets/prettify/prettify.css?1346159567" media="screen" rel="stylesheet" type="text/css" />    <script src="/javascripts/lib/prettify.js?1346159567" type="text/javascript"></script>      <!--[if IE 8]><link rel="stylesheet" href="/stylesheets/ie8.css" type="text/css"><![endif]-->
<!--[if IE 7]><link rel="stylesheet" href="/stylesheets/ie7.css" type="text/css"><![endif]-->
<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-52238-3']);
_gaq.push(['_setDomainName', '.gitorious.org'])
_gaq.push(['_trackPageview']);
(function() {
   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
   (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
})();
</script>
</head>
<body id="blobs">
  <div id="wrapper">
        <ul id="user-nav">
      <li><a href="/">Dashboard</a></li>
      
          <li class="secondary"><a href="/users/new">Register</a></li>
    <li class="secondary"><a href="/login">Login</a></li>
    </ul>
    <div id="header">
      <h1 id="logo">
        <a href="/"><img alt="Logo" src="/img/logo.png?1294322727" /></a>
      </h1>
      <ul id="menu">
                  <li class="activity"><a href="/activities">Activities</a></li>
          <li class="projects"><a href="/projects">Projects</a></li>
          <li class="teams"><a href="/teams">Teams</a></li>
              </ul>
    </div>
    <div id="top-bar">
      <ul id="breadcrumbs">
        <li class="project"><a href="/tusur-gpo">АИС &quot;Проекты ГПО&quot;</a></li><li class="repository"><a href="/tusur-gpo/gpo">gpo</a></li><li class="branch"><a href="/tusur-gpo/gpo/commits/master">master</a></li><li class="tree"><a href="/tusur-gpo/gpo/trees/master">/</a></li><li class="folder"><a href="/tusur-gpo/gpo/trees/master/db">db</a></li><li class="folder"><a href="/tusur-gpo/gpo/trees/master/db/migrate">migrate</a></li><li class="file"><a href="/tusur-gpo/gpo/blobs/master/db/migrate/20100209131137_create_schema.rb">20100209131137_create_schema.rb</a></li>      </ul>
              <div id="searchbox">
          


<div class="search_bar">
  <form action="/search" method="get">    <p>
      <input class="text search-field round-5" id="q" name="q" type="text" />      <input type="submit" value="Search" class="search-submit round-5" />
    </p>
    <p class="hint search-hint" style="display: none;">
      eg. 'wrapper', 'category:python' or '"document database"'
          </p>
  </form></div>
        </div>
          </div>
    <div id="container" class="">
      <div id="content" class="">
        
        



<div class="page-meta">
  <ul class="page-actions">
    <li>Blob contents</li>
    <li><a href="/tusur-gpo/gpo/blobs/blame/472e06195f56491c7bb6ae70e9e60a97ccd86723/db/migrate/20100209131137_create_schema.rb" class="blame js-pjax" data-pjax="#codeblob">Blame</a></li>
    <li><a href="/tusur-gpo/gpo/blobs/history/master/db/migrate/20100209131137_create_schema.rb" class="js-pjax" data-pjax="#codeblob">Blob history</a></li>
    <li><a href="/tusur-gpo/gpo/blobs/raw/master/db/migrate/20100209131137_create_schema.rb">Raw blob data</a></li>
  </ul>
</div>



<!-- mime: application/ruby -->

       <div id="long-file" style="display:none"
                  class="help-box center error round-5">
               <div class="icon error"></div>        <p>
          This file looks large and may slow your browser down if we attempt
          to syntax highlight it, so we are showing it without any
          pretty colors.
          <a href="#highlight-anyway" id="highlight-anyway">Highlight
          it anyway</a>.
        </p>
     </div>    <table id="codeblob" class="highlighted lang-rb">
<tr id="line1">
<td class="line-numbers"><a href="#line1" name="line1">1</a></td>
<td class="code"><pre class="prettyprint lang-rb">class CreateSchema &lt; ActiveRecord::Migration</pre></td>
</tr>
<tr id="line2">
<td class="line-numbers"><a href="#line2" name="line2">2</a></td>
<td class="code"><pre class="prettyprint lang-rb">  def self.up</pre></td>
</tr>
<tr id="line3">
<td class="line-numbers"><a href="#line3" name="line3">3</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;activities&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line4">
<td class="line-numbers"><a href="#line4" name="line4">4</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;action&quot;</pre></td>
</tr>
<tr id="line5">
<td class="line-numbers"><a href="#line5" name="line5">5</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;comment&quot;</pre></td>
</tr>
<tr id="line6">
<td class="line-numbers"><a href="#line6" name="line6">6</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;context_type&quot;</pre></td>
</tr>
<tr id="line7">
<td class="line-numbers"><a href="#line7" name="line7">7</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;context_id&quot;</pre></td>
</tr>
<tr id="line8">
<td class="line-numbers"><a href="#line8" name="line8">8</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line9">
<td class="line-numbers"><a href="#line9" name="line9">9</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line10">
<td class="line-numbers"><a href="#line10" name="line10">10</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;chair_id&quot;</pre></td>
</tr>
<tr id="line11">
<td class="line-numbers"><a href="#line11" name="line11">11</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;actor&quot;</pre></td>
</tr>
<tr id="line12">
<td class="line-numbers"><a href="#line12" name="line12">12</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line13">
<td class="line-numbers"><a href="#line13" name="line13">13</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line14">
<td class="line-numbers"><a href="#line14" name="line14">14</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;chairs&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line15">
<td class="line-numbers"><a href="#line15" name="line15">15</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;title&quot;</pre></td>
</tr>
<tr id="line16">
<td class="line-numbers"><a href="#line16" name="line16">16</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;abbr&quot;</pre></td>
</tr>
<tr id="line17">
<td class="line-numbers"><a href="#line17" name="line17">17</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;chief&quot;</pre></td>
</tr>
<tr id="line18">
<td class="line-numbers"><a href="#line18" name="line18">18</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line19">
<td class="line-numbers"><a href="#line19" name="line19">19</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line20">
<td class="line-numbers"><a href="#line20" name="line20">20</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line21">
<td class="line-numbers"><a href="#line21" name="line21">21</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line22">
<td class="line-numbers"><a href="#line22" name="line22">22</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;gpodays&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line23">
<td class="line-numbers"><a href="#line23" name="line23">23</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.date     &quot;date&quot;</pre></td>
</tr>
<tr id="line24">
<td class="line-numbers"><a href="#line24" name="line24">24</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line25">
<td class="line-numbers"><a href="#line25" name="line25">25</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line26">
<td class="line-numbers"><a href="#line26" name="line26">26</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.boolean  &quot;kt&quot;,         :default =&gt; false</pre></td>
</tr>
<tr id="line27">
<td class="line-numbers"><a href="#line27" name="line27">27</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line28">
<td class="line-numbers"><a href="#line28" name="line28">28</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line29">
<td class="line-numbers"><a href="#line29" name="line29">29</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;managers&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line30">
<td class="line-numbers"><a href="#line30" name="line30">30</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;user_id&quot;</pre></td>
</tr>
<tr id="line31">
<td class="line-numbers"><a href="#line31" name="line31">31</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;project_id&quot;</pre></td>
</tr>
<tr id="line32">
<td class="line-numbers"><a href="#line32" name="line32">32</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line33">
<td class="line-numbers"><a href="#line33" name="line33">33</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line34">
<td class="line-numbers"><a href="#line34" name="line34">34</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;state&quot;</pre></td>
</tr>
<tr id="line35">
<td class="line-numbers"><a href="#line35" name="line35">35</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line36">
<td class="line-numbers"><a href="#line36" name="line36">36</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line37">
<td class="line-numbers"><a href="#line37" name="line37">37</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;order_projects&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line38">
<td class="line-numbers"><a href="#line38" name="line38">38</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;order_id&quot;</pre></td>
</tr>
<tr id="line39">
<td class="line-numbers"><a href="#line39" name="line39">39</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;project_id&quot;</pre></td>
</tr>
<tr id="line40">
<td class="line-numbers"><a href="#line40" name="line40">40</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line41">
<td class="line-numbers"><a href="#line41" name="line41">41</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line42">
<td class="line-numbers"><a href="#line42" name="line42">42</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line43">
<td class="line-numbers"><a href="#line43" name="line43">43</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line44">
<td class="line-numbers"><a href="#line44" name="line44">44</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;ordinances&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line45">
<td class="line-numbers"><a href="#line45" name="line45">45</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;number&quot;</pre></td>
</tr>
<tr id="line46">
<td class="line-numbers"><a href="#line46" name="line46">46</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.date     &quot;approved_at&quot;</pre></td>
</tr>
<tr id="line47">
<td class="line-numbers"><a href="#line47" name="line47">47</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;chair_id&quot;</pre></td>
</tr>
<tr id="line48">
<td class="line-numbers"><a href="#line48" name="line48">48</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line49">
<td class="line-numbers"><a href="#line49" name="line49">49</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line50">
<td class="line-numbers"><a href="#line50" name="line50">50</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;type&quot;</pre></td>
</tr>
<tr id="line51">
<td class="line-numbers"><a href="#line51" name="line51">51</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;state&quot;</pre></td>
</tr>
<tr id="line52">
<td class="line-numbers"><a href="#line52" name="line52">52</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;file_file_name&quot;</pre></td>
</tr>
<tr id="line53">
<td class="line-numbers"><a href="#line53" name="line53">53</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;file_content_type&quot;</pre></td>
</tr>
<tr id="line54">
<td class="line-numbers"><a href="#line54" name="line54">54</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;file_file_size&quot;</pre></td>
</tr>
<tr id="line55">
<td class="line-numbers"><a href="#line55" name="line55">55</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.date     &quot;file_updated_at&quot;</pre></td>
</tr>
<tr id="line56">
<td class="line-numbers"><a href="#line56" name="line56">56</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line57">
<td class="line-numbers"><a href="#line57" name="line57">57</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line58">
<td class="line-numbers"><a href="#line58" name="line58">58</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;participants&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line59">
<td class="line-numbers"><a href="#line59" name="line59">59</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;student_id&quot;</pre></td>
</tr>
<tr id="line60">
<td class="line-numbers"><a href="#line60" name="line60">60</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;state&quot;</pre></td>
</tr>
<tr id="line61">
<td class="line-numbers"><a href="#line61" name="line61">61</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line62">
<td class="line-numbers"><a href="#line62" name="line62">62</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line63">
<td class="line-numbers"><a href="#line63" name="line63">63</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;project_id&quot;</pre></td>
</tr>
<tr id="line64">
<td class="line-numbers"><a href="#line64" name="line64">64</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;course&quot;</pre></td>
</tr>
<tr id="line65">
<td class="line-numbers"><a href="#line65" name="line65">65</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;chair_id&quot;</pre></td>
</tr>
<tr id="line66">
<td class="line-numbers"><a href="#line66" name="line66">66</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;first_name&quot;</pre></td>
</tr>
<tr id="line67">
<td class="line-numbers"><a href="#line67" name="line67">67</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;mid_name&quot;</pre></td>
</tr>
<tr id="line68">
<td class="line-numbers"><a href="#line68" name="line68">68</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;last_name&quot;</pre></td>
</tr>
<tr id="line69">
<td class="line-numbers"><a href="#line69" name="line69">69</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;chair_abbr&quot;</pre></td>
</tr>
<tr id="line70">
<td class="line-numbers"><a href="#line70" name="line70">70</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;edu_group&quot;</pre></td>
</tr>
<tr id="line71">
<td class="line-numbers"><a href="#line71" name="line71">71</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.boolean  &quot;contingent_active&quot;</pre></td>
</tr>
<tr id="line72">
<td class="line-numbers"><a href="#line72" name="line72">72</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.boolean  &quot;contingent_gpo&quot;</pre></td>
</tr>
<tr id="line73">
<td class="line-numbers"><a href="#line73" name="line73">73</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line74">
<td class="line-numbers"><a href="#line74" name="line74">74</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line75">
<td class="line-numbers"><a href="#line75" name="line75">75</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;passwords&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line76">
<td class="line-numbers"><a href="#line76" name="line76">76</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;user_id&quot;</pre></td>
</tr>
<tr id="line77">
<td class="line-numbers"><a href="#line77" name="line77">77</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;reset_code&quot;</pre></td>
</tr>
<tr id="line78">
<td class="line-numbers"><a href="#line78" name="line78">78</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;expiration_date&quot;</pre></td>
</tr>
<tr id="line79">
<td class="line-numbers"><a href="#line79" name="line79">79</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line80">
<td class="line-numbers"><a href="#line80" name="line80">80</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line81">
<td class="line-numbers"><a href="#line81" name="line81">81</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line82">
<td class="line-numbers"><a href="#line82" name="line82">82</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line83">
<td class="line-numbers"><a href="#line83" name="line83">83</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;projects&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line84">
<td class="line-numbers"><a href="#line84" name="line84">84</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;cipher&quot;</pre></td>
</tr>
<tr id="line85">
<td class="line-numbers"><a href="#line85" name="line85">85</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;title&quot;</pre></td>
</tr>
<tr id="line86">
<td class="line-numbers"><a href="#line86" name="line86">86</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line87">
<td class="line-numbers"><a href="#line87" name="line87">87</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line88">
<td class="line-numbers"><a href="#line88" name="line88">88</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;chair_id&quot;</pre></td>
</tr>
<tr id="line89">
<td class="line-numbers"><a href="#line89" name="line89">89</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;stakeholders&quot;</pre></td>
</tr>
<tr id="line90">
<td class="line-numbers"><a href="#line90" name="line90">90</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;funds_required&quot;</pre></td>
</tr>
<tr id="line91">
<td class="line-numbers"><a href="#line91" name="line91">91</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;funds_sources&quot;</pre></td>
</tr>
<tr id="line92">
<td class="line-numbers"><a href="#line92" name="line92">92</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;purpose&quot;</pre></td>
</tr>
<tr id="line93">
<td class="line-numbers"><a href="#line93" name="line93">93</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;features&quot;</pre></td>
</tr>
<tr id="line94">
<td class="line-numbers"><a href="#line94" name="line94">94</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;analysis&quot;</pre></td>
</tr>
<tr id="line95">
<td class="line-numbers"><a href="#line95" name="line95">95</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;novelty&quot;</pre></td>
</tr>
<tr id="line96">
<td class="line-numbers"><a href="#line96" name="line96">96</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;expected_results&quot;</pre></td>
</tr>
<tr id="line97">
<td class="line-numbers"><a href="#line97" name="line97">97</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;release_cost&quot;</pre></td>
</tr>
<tr id="line98">
<td class="line-numbers"><a href="#line98" name="line98">98</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;forecast&quot;</pre></td>
</tr>
<tr id="line99">
<td class="line-numbers"><a href="#line99" name="line99">99</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;state&quot;</pre></td>
</tr>
<tr id="line100">
<td class="line-numbers"><a href="#line100" name="line100">100</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;editable_state&quot;</pre></td>
</tr>
<tr id="line101">
<td class="line-numbers"><a href="#line101" name="line101">101</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;close_reason&quot;</pre></td>
</tr>
<tr id="line102">
<td class="line-numbers"><a href="#line102" name="line102">102</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;theme_id&quot;</pre></td>
</tr>
<tr id="line103">
<td class="line-numbers"><a href="#line103" name="line103">103</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line104">
<td class="line-numbers"><a href="#line104" name="line104">104</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line105">
<td class="line-numbers"><a href="#line105" name="line105">105</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;rules&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line106">
<td class="line-numbers"><a href="#line106" name="line106">106</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;user_id&quot;</pre></td>
</tr>
<tr id="line107">
<td class="line-numbers"><a href="#line107" name="line107">107</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;role&quot;</pre></td>
</tr>
<tr id="line108">
<td class="line-numbers"><a href="#line108" name="line108">108</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;context_type&quot;</pre></td>
</tr>
<tr id="line109">
<td class="line-numbers"><a href="#line109" name="line109">109</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;context_id&quot;</pre></td>
</tr>
<tr id="line110">
<td class="line-numbers"><a href="#line110" name="line110">110</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line111">
<td class="line-numbers"><a href="#line111" name="line111">111</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line112">
<td class="line-numbers"><a href="#line112" name="line112">112</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line113">
<td class="line-numbers"><a href="#line113" name="line113">113</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line114">
<td class="line-numbers"><a href="#line114" name="line114">114</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;stages&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line115">
<td class="line-numbers"><a href="#line115" name="line115">115</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;project_id&quot;</pre></td>
</tr>
<tr id="line116">
<td class="line-numbers"><a href="#line116" name="line116">116</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;title&quot;</pre></td>
</tr>
<tr id="line117">
<td class="line-numbers"><a href="#line117" name="line117">117</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.date     &quot;start&quot;</pre></td>
</tr>
<tr id="line118">
<td class="line-numbers"><a href="#line118" name="line118">118</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.date     &quot;finish&quot;</pre></td>
</tr>
<tr id="line119">
<td class="line-numbers"><a href="#line119" name="line119">119</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;funds_required&quot;</pre></td>
</tr>
<tr id="line120">
<td class="line-numbers"><a href="#line120" name="line120">120</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;activity&quot;</pre></td>
</tr>
<tr id="line121">
<td class="line-numbers"><a href="#line121" name="line121">121</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.text     &quot;results&quot;</pre></td>
</tr>
<tr id="line122">
<td class="line-numbers"><a href="#line122" name="line122">122</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line123">
<td class="line-numbers"><a href="#line123" name="line123">123</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line124">
<td class="line-numbers"><a href="#line124" name="line124">124</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line125">
<td class="line-numbers"><a href="#line125" name="line125">125</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line126">
<td class="line-numbers"><a href="#line126" name="line126">126</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;themes&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line127">
<td class="line-numbers"><a href="#line127" name="line127">127</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;name&quot;</pre></td>
</tr>
<tr id="line128">
<td class="line-numbers"><a href="#line128" name="line128">128</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line129">
<td class="line-numbers"><a href="#line129" name="line129">129</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line130">
<td class="line-numbers"><a href="#line130" name="line130">130</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line131">
<td class="line-numbers"><a href="#line131" name="line131">131</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line132">
<td class="line-numbers"><a href="#line132" name="line132">132</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;users&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line133">
<td class="line-numbers"><a href="#line133" name="line133">133</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;login&quot;,                     :limit =&gt; 40</pre></td>
</tr>
<tr id="line134">
<td class="line-numbers"><a href="#line134" name="line134">134</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;email&quot;,                     :limit =&gt; 100</pre></td>
</tr>
<tr id="line135">
<td class="line-numbers"><a href="#line135" name="line135">135</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;crypted_password&quot;,          :limit =&gt; 40</pre></td>
</tr>
<tr id="line136">
<td class="line-numbers"><a href="#line136" name="line136">136</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;salt&quot;,                      :limit =&gt; 40</pre></td>
</tr>
<tr id="line137">
<td class="line-numbers"><a href="#line137" name="line137">137</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line138">
<td class="line-numbers"><a href="#line138" name="line138">138</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line139">
<td class="line-numbers"><a href="#line139" name="line139">139</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;remember_token&quot;,            :limit =&gt; 40</pre></td>
</tr>
<tr id="line140">
<td class="line-numbers"><a href="#line140" name="line140">140</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;remember_token_expires_at&quot;</pre></td>
</tr>
<tr id="line141">
<td class="line-numbers"><a href="#line141" name="line141">141</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;mid_name&quot;</pre></td>
</tr>
<tr id="line142">
<td class="line-numbers"><a href="#line142" name="line142">142</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;first_name&quot;</pre></td>
</tr>
<tr id="line143">
<td class="line-numbers"><a href="#line143" name="line143">143</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;last_name&quot;</pre></td>
</tr>
<tr id="line144">
<td class="line-numbers"><a href="#line144" name="line144">144</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;post&quot;</pre></td>
</tr>
<tr id="line145">
<td class="line-numbers"><a href="#line145" name="line145">145</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;chair_id&quot;</pre></td>
</tr>
<tr id="line146">
<td class="line-numbers"><a href="#line146" name="line146">146</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;float&quot;</pre></td>
</tr>
<tr id="line147">
<td class="line-numbers"><a href="#line147" name="line147">147</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.string   &quot;phone&quot;</pre></td>
</tr>
<tr id="line148">
<td class="line-numbers"><a href="#line148" name="line148">148</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line149">
<td class="line-numbers"><a href="#line149" name="line149">149</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line150">
<td class="line-numbers"><a href="#line150" name="line150">150</a></td>
<td class="code"><pre class="prettyprint lang-rb">    add_index &quot;users&quot;, [&quot;login&quot;], :name =&gt; &quot;index_users_on_login&quot;, :unique =&gt; true</pre></td>
</tr>
<tr id="line151">
<td class="line-numbers"><a href="#line151" name="line151">151</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line152">
<td class="line-numbers"><a href="#line152" name="line152">152</a></td>
<td class="code"><pre class="prettyprint lang-rb">    create_table &quot;visitations&quot;, :force =&gt; true do |t|</pre></td>
</tr>
<tr id="line153">
<td class="line-numbers"><a href="#line153" name="line153">153</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;participant_id&quot;</pre></td>
</tr>
<tr id="line154">
<td class="line-numbers"><a href="#line154" name="line154">154</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.integer  &quot;gpoday_id&quot;</pre></td>
</tr>
<tr id="line155">
<td class="line-numbers"><a href="#line155" name="line155">155</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.float    &quot;rate&quot;</pre></td>
</tr>
<tr id="line156">
<td class="line-numbers"><a href="#line156" name="line156">156</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;created_at&quot;</pre></td>
</tr>
<tr id="line157">
<td class="line-numbers"><a href="#line157" name="line157">157</a></td>
<td class="code"><pre class="prettyprint lang-rb">      t.datetime &quot;updated_at&quot;</pre></td>
</tr>
<tr id="line158">
<td class="line-numbers"><a href="#line158" name="line158">158</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line159">
<td class="line-numbers"><a href="#line159" name="line159">159</a></td>
<td class="code"><pre class="prettyprint lang-rb">  end</pre></td>
</tr>
<tr id="line160">
<td class="line-numbers"><a href="#line160" name="line160">160</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line161">
<td class="line-numbers"><a href="#line161" name="line161">161</a></td>
<td class="code"><pre class="prettyprint lang-rb">  def self.down</pre></td>
</tr>
<tr id="line162">
<td class="line-numbers"><a href="#line162" name="line162">162</a></td>
<td class="code"><pre class="prettyprint lang-rb">    tables.each do |table|</pre></td>
</tr>
<tr id="line163">
<td class="line-numbers"><a href="#line163" name="line163">163</a></td>
<td class="code"><pre class="prettyprint lang-rb">      drop_table table unless table == &quot;schema_migrations&quot;</pre></td>
</tr>
<tr id="line164">
<td class="line-numbers"><a href="#line164" name="line164">164</a></td>
<td class="code"><pre class="prettyprint lang-rb">    end</pre></td>
</tr>
<tr id="line165">
<td class="line-numbers"><a href="#line165" name="line165">165</a></td>
<td class="code"><pre class="prettyprint lang-rb">  end</pre></td>
</tr>
<tr id="line166">
<td class="line-numbers"><a href="#line166" name="line166">166</a></td>
<td class="code"><pre class="prettyprint lang-rb">end</pre></td>
</tr>
</table>  
<script type="text/javascript" charset="utf-8">
  (function () {
      if ($("#codeblob tr td.line-numbers:last").text().length < 3500) {
          prettyPrint();
      } else {
          $("#long-file").show().find("a#highlight-anyway").click(function(e){
              prettyPrint();
              e.preventDefault();
          });
      }
  }());
</script>

      </div>
          </div>
    <div id="footer">
      
<div class="powered-by">
  <a href="http://gitorious.org"><img alt="Poweredby" src="/images/../img/poweredby.png?1294322727" title="Powered by Gitorious" /></a></div>
<script type="text/javascript">
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-52238-3']);
_gaq.push(['_setDomainName', '.gitorious.org'])
_gaq.push(['_trackPageview']);
(function() {
   var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
   ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
   (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
})();
</script><script src="/javascripts/onload.js?1346159567" type="text/javascript"></script>
      
<div id="footer-links">
  <h3>Gitorious</h3>
  <ul>
    <li><a href="/">Home</a></li>
    <li><a href="/about">About</a></li>
    <li><a href="/about/faq">FAQ</a></li>
    <li><a href="/contact">Contact</a></li>
  </ul>
  
    <ul>
      <li><a href="http://groups.google.com/group/gitorious">Discussion group</a></li>
      <li><a href="http://blog.gitorious.org">Blog</a></li>
    </ul>
  
      
<ul>
  <li><a href="http://en.gitorious.org/tos">Terms of Service</a></li>
  <li><a href="http://en.gitorious.org/privacy_policy">Privacy Policy</a></li>
</ul>

  
  
    <ul>
      
        <li><a href="http://gitorious.com/">Professional Gitorious Services</a></li>
      
    </ul>
  
</div>
      <p class="footer-blurb">
  
    <a href="http://gitorious.com">Professional Gitorious services</a> - Git
    hosting at your company, custom features, support and more.
    <a href="http://gitorious.com">gitorious.com</a>.
  
</p>

      <div class="clear"></div>
    </div>
  </div>
</body>
</html>
