
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN"
          "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>db/migrate/20100916021613_add_purpose_and_sourse_data_to_project.rb - gpo in АИС &quot;Проекты ГПО&quot; - Gitorious</title>
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
        <li class="project"><a href="/tusur-gpo">АИС &quot;Проекты ГПО&quot;</a></li><li class="repository"><a href="/tusur-gpo/gpo">gpo</a></li><li class="branch"><a href="/tusur-gpo/gpo/commits/master">master</a></li><li class="tree"><a href="/tusur-gpo/gpo/trees/master">/</a></li><li class="folder"><a href="/tusur-gpo/gpo/trees/master/db">db</a></li><li class="folder"><a href="/tusur-gpo/gpo/trees/master/db/migrate">migrate</a></li><li class="file"><a href="/tusur-gpo/gpo/blobs/master/db/migrate/20100916021613_add_purpose_and_sourse_data_to_project.rb">20100916021613_add_purpose_and_sourse_data_to_project.rb</a></li>      </ul>
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
    <li><a href="/tusur-gpo/gpo/blobs/blame/472e06195f56491c7bb6ae70e9e60a97ccd86723/db/migrate/20100916021613_add_purpose_and_sourse_data_to_project.rb" class="blame js-pjax" data-pjax="#codeblob">Blame</a></li>
    <li><a href="/tusur-gpo/gpo/blobs/history/master/db/migrate/20100916021613_add_purpose_and_sourse_data_to_project.rb" class="js-pjax" data-pjax="#codeblob">Blob history</a></li>
    <li><a href="/tusur-gpo/gpo/blobs/raw/master/db/migrate/20100916021613_add_purpose_and_sourse_data_to_project.rb">Raw blob data</a></li>
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
<td class="code"><pre class="prettyprint lang-rb">class AddPurposeAndSourseDataToProject &lt; ActiveRecord::Migration</pre></td>
</tr>
<tr id="line2">
<td class="line-numbers"><a href="#line2" name="line2">2</a></td>
<td class="code"><pre class="prettyprint lang-rb">  def self.up</pre></td>
</tr>
<tr id="line3">
<td class="line-numbers"><a href="#line3" name="line3">3</a></td>
<td class="code"><pre class="prettyprint lang-rb">    add_column :projects, :goal, :text</pre></td>
</tr>
<tr id="line4">
<td class="line-numbers"><a href="#line4" name="line4">4</a></td>
<td class="code"><pre class="prettyprint lang-rb">    add_column :projects, :source_data, :text</pre></td>
</tr>
<tr id="line5">
<td class="line-numbers"><a href="#line5" name="line5">5</a></td>
<td class="code"><pre class="prettyprint lang-rb">  end</pre></td>
</tr>
<tr id="line6">
<td class="line-numbers"><a href="#line6" name="line6">6</a></td>
<td class="code"><pre class="prettyprint lang-rb"></pre></td>
</tr>
<tr id="line7">
<td class="line-numbers"><a href="#line7" name="line7">7</a></td>
<td class="code"><pre class="prettyprint lang-rb">  def self.down</pre></td>
</tr>
<tr id="line8">
<td class="line-numbers"><a href="#line8" name="line8">8</a></td>
<td class="code"><pre class="prettyprint lang-rb">    remove_column :projects, :source_data</pre></td>
</tr>
<tr id="line9">
<td class="line-numbers"><a href="#line9" name="line9">9</a></td>
<td class="code"><pre class="prettyprint lang-rb">    remove_column :projects, :goal</pre></td>
</tr>
<tr id="line10">
<td class="line-numbers"><a href="#line10" name="line10">10</a></td>
<td class="code"><pre class="prettyprint lang-rb">  end</pre></td>
</tr>
<tr id="line11">
<td class="line-numbers"><a href="#line11" name="line11">11</a></td>
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
