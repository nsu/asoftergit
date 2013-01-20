<!DOCTYPE html>

<html>

<head>
<link href="/css/softer2.css" rel="stylesheet" type="text/css"/> <!-- this is the css for the whole page -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
<script src="/alttext.js"></script>

<meta name="description" content="A random parody of asofterworld.com comics using the flickr and github APIs" />

<?php
$images = array();
if ($handle = opendir('img')) {
    while (false !== ($entry = readdir($handle))) {
        if ($entry != "." && $entry != "..") {
            $image = explode(".", $entry);
            $images[] = $image[0];
        }
    }
    closedir($handle);
}
sort($images);
$latest = $images[count($images)-1];
?>

<script type="text/javascript" charset="utf-8">
    $(function(){
        var latest = <?php echo $latest?>;
        var pathname = window.location.pathname.split("/");
        var comicID = pathname[1];
        if (Boolean(comicID) == false) {
          comicID = latest;
        }
        $("#thecomic").append("<img src=/img/"+comicID+".png />");
        $("#thecomic").attr("title", alttext[comicID])

        $("title").append("A Softer Git: "+comicID)

        if (comicID == latest) {
          $("#next").attr("href", "#")
        } else {
          $("#next").attr("href", "/"+(parseInt(comicID)+1))  
        }
        if (comicID == "0"){
          $("#back").attr("href", "#")
        } else {
          $("#back").attr("href", "/"+(parseInt(comicID)-1))
        }

        $("#first").attr("href", "/0")
        $("#last").attr("href", latest)

    });
</script>


<title></title>
</head>

<body>

<div id="padder" style="padding-top:40px"></div>

<div id="mainbody"> 



<table id="header" border-spacing=0>
  <tr valign=bottom>
  

<td>
 <a id="mainsitelink" href="http://www.asoftergit.com/">a softer git</a>
</td>
<!-- <td>
  <div id = "sitenav">
 <a id="navlink" href="http://www.asoftergit.com/archive.php">archive</a>/
  <a id="navlink" href="http://www.asoftergit.com/about.php">about</a>/
  <a id="navlink"
  href="http://www.topatoco.com/merchant.mvc?Screen=CTGY&amp;Store_Code=TO&amp;Category_Code=ASW">store</a>/
  <a id="navlink" 
  href="http://www.asoftergit.com/index.php?id=23">fnord</a>/  <a id="navlink" href="http://www.asoftergit.com/projects.php">our
  projects</a>/
  <a id="navlink" href="http://www.ohnorobot.com/index.pl?comic=796">search</a>
  </div> 

</td> -->
</tr>
</table>

  <div id= "displaycomic">
	        	        
  <p id="thecomic">	
      
  </p>
		

<div id="comicnav">



    <div id="backbutton">
      <a id="first" href="#"><< first</a>
      <span style="padding-left: 20px"></span>
			<a id="back" href="#">< back</a>
    </div>



<div id="nextbutton">

			<a id="next" href="#">next ></a>
      <span style="padding-right: 20px"></span>
      <a id="last" href="#">last >></a>
</div> <!-- the end of div id="nextbutton" -->










</div> <!-- ends div id "comicnav" -->
  
</div>  <!-- end div id = "displaycomic" -->



<div id="lowerbody">

<div id = "verticalnews">

  <!-- this is the navigation on the side -->

<!-- Project Wonderful Ad Box Code -->
<div id="pw_adbox_9398_3_0"></div>
<script type="text/javascript"></script>
<noscript><map name="admap9398" id="admap9398"><area href="http://www.projectwonderful.com/out_nojs.php?r=0&c=0&id=9398&type=3" shape="rect" coords="0,0,160,600" title="" alt="" target="_blank" /></map>
<table cellpadding="0" cellspacing="0" style="width:160px;border-style:none;background-color:#ffffff;"><tr><td><img src="http://www.projectwonderful.com/nojs.php?id=9398&type=3" style="width:160px;height:600px;border-style:none;" usemap="#admap9398" alt="" /></td></tr><tr><td style="background-color:#ffffff;" colspan="1"><center><a style="font-size:10px;color:#0000ff;text-decoration:none;line-height:1.2;font-weight:bold;font-family:Tahoma, verdana,arial,helvetica,sans-serif;text-transform: none;letter-spacing:normal;text-shadow:none;white-space:normal;word-spacing:normal;" href="http://www.projectwonderful.com/advertisehere.php?id=9398&type=3" target="_blank">Your ad could be here, right now.</a></center></td></tr></table>
</noscript>
<!-- End Project Wonderful Ad Box Code -->





 
  
</div>  <!-- end id = "vertical news" -->


  <div id="title">
  
    <a href="http://asofterworld.com"><p id="hello">"With the deepest apologies to Joey Comeau &amp; Emily Horne."</p></a>
  </div> <!-- end div "title" -->

  <div id="padder" style="padding-top:400px"></div>

 


</div> <!-- end div id="lowerbody" -->

</div> <!-- end div id = "mainbody" -->

<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-36420637-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</body>
  
</html>
