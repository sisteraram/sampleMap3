<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Simple Map</title>
<meta name="viewport" content="initial-scale=1.0">
<meta charset="utf-8">
<style>
/* Always set the map height explicitly to define the size of the div
     * element that contains the map. */

#select{
  margin: 20px;
  margin-left: -300px;
  position: absolute;
}


 
.tab-wrapper {
background-color: tomato;
  float: right;
  margin: 0px auto;
  width: 20%;
  max-width:500px;
}

.tab-menu li {
background-color: #fff;
  position:relative;
  color:#bcbcbc;
  display: inline-block;
  padding: 10px 20px;
  opacity: 0.8;
  cursor:pointer;
  z-index:0;
}

.tab-menu li:hover {
  color:#464646;
}

.tab-menu li.active {
  color:#464646;
  opacity: 1;
}

.tab-menu li.active:hover {
  color:#464646;
}

.tab-content>div {
  box-sizing:border-box;
  width: 100%;
  padding: 0px;   
  min-height:200px;
}

.line {
  position:absolute;
  width: 0;
  height: 7px;
  background-color: #008fff;
  top: 0;
  left: 0;
}
     
     
#map {
	width: 80%;
	background-color: deepskyblue;
	height: 98vh;
	float: left;
}
/* Optional: Makes the sample page fill the window. */
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}

.container {
	width: 100%;
	background-color: #999999;
	margin: 0 auto;
}

.sidebar {
	float: right;
	width: 20%;
	
	height: 90vh;
}

#sortable {
	list-style-type: none;
	margin-left: 15%;
	padding: 0;
	width: 80%;
	overflow: auto;
	height: 55vh;
}

#sortable li {
	margin: 3px 3px 3px 3px;
	padding: 0.4em;
	padding-left: 1.5em;
	font-size: 1em;
	height: 30px;
}

#sortable li span {
	position: absolute;
	margin-left: -1.3em;
}

.list {
	height: 70%;
}
.search{
	margin-left: 10%;
	padding: 0;
	height: 65vh;
}


button {
	width: 70%;
	background: none;
	border: 3px solid #fff;
	border-radius: 5px;
	color: #fff;
	display: block;
	font-size: 1em;
	font-weight: bold;
	margin: 1em auto;
	padding: 1em 1em;
	position: relative;
	text-transform: uppercase;
}

button, button::after {
	-webkit-transition: all 0.3s;
	-moz-transition: all 0.3s;
	-o-transition: all 0.3s;
	transition: all 0.3s;
}

button::before, button::after {
	background: #fff;
	content: '';
	position: absolute;
	z-index: -1;
}

button:hover {
	color: #008fff;
}

  .btn-2::after {
    height: 100%;
    left: 0;
    top: 0;
    width: 0;
  }

  .btn-2:hover:after {
    width: 100%;
  }
</style>
</head>
<body>
	<div class="container">
		<div id="map" class="map"></div>
		<div class="tab-wrapper">
		  <div id="select">
		  	<input type="checkbox" value="1">1
		  	<input type="checkbox" value="2">2
		  	<input type="checkbox" value="3">3
		  	<input type="button" value="4">
		  </div>
			<ul class="tab-menu">
				<li class="active">tab #1</li>
				<li>tab #2</li>
			</ul>
			
			<div class="tab-content">
				<div class="sidebar">
					<div class="list">
						<button id="jsonBtn">JSON 데이터 보기</button>
						<ul id="sortable">
						</ul>
					</div>
					<div class="btns">
						<button id="saveBtn">저장하고 종료</button>
						<button id="shareBtn">공유하기</button>
						<button id="removeBtn">삭제</button>
					</div>
				</div>
				<div class="tab2">
					<div class="search">
						<input type="text">
						<input type="button" value="search">
					</div>
					<div class="btns">
						<button id="saveBtn">저장하고 종료</button>
						<button id="shareBtn">공유하기</button>
						<button id="removeBtn">삭제</button>
					</div>
				</div>
			</div> <!-- end tab-content -->
		</div> <!-- end tab-wrapper -->
	</div> <!-- end container -->

	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

	<script>
	
	$(document).ready(function() {
		  
		  $('.tab-content>div:not(":first-of-type")').hide();
		  $('<div class="line"></div>').appendTo('.tab-menu li');
		  $('.tab-menu li:first-of-type').find(':first').width('100%')
		  
		  $('.tab-menu li').each(function(i) {
		    $(this).attr('data-tab', 'tab'+i);
		  });
		  
		  $('.tab-content>div').each(function(i) {
		    $(this).attr('data-tab', 'tab'+i);
		  });
		  
		  $('.tab-menu li').on('click', function() {
		    
		    var dataTab = $(this).data('tab');
		    var getWrapper = $(this).closest('.tab-wrapper');
		    var line = $(this).find('.line');
		    
		    getWrapper.find('.tab-menu li').removeClass('active');
		    $(this).addClass('active');
		    
		    getWrapper.find('.line').width(0);
		    line.animate({'width':'100%'}, 'fast');
		    getWrapper.find('.tab-content>div').hide();
		    getWrapper.find('.tab-content>div[data-tab='+dataTab+']').show();
		  });

		});//end ready
		
	
	
	
	
		var map, poly;
		var mindMapArr = [];
		var recommendArr = [];
		var course = [];
		var markerArr = [];
		var recommendMarkerArr = [];

		var sortableUL = $("#sortable");
		console.log(sortableUL);

		// initialize map by callback
		function initMap() {
			console.log("init map...............");
			getMarkerData();
		}

		function getMarkerData() {
			//get mindmap data
			$.getJSON("/sample/dataEx.json", function(json1) {
				$.each(json1, function(key, data) {
					mindMapArr.push(data);
					course.push(data);
					drawList(course);
				});

				map = new google.maps.Map(document.getElementById('map'), {
					center : course[course.length - 1],
					zoom : 15,
					minZoom : 13
				});

				drawMarker(course, 1);
				drawPath();

				//get recommend data
				$.getJSON("/sample/dataEx2.json", function(json2) {
					$.each(json2, function(key, data) {
						recommendArr.push(data);
					});
					drawMarker(recommendArr, 2);
				});
			});
		}

		// draw marker
		function drawMarker(arr, type) {
			for (var i = 0; i < arr.length; i++) {
				var marker = new google.maps.Marker({
					position : arr[i],
					title : arr[i].title,
					descs : arr[i].descs,
					myPos : arr[i],
					map : map
				});

				if (type === 1) {
					markerArr.push(marker)

				} else if (type === 2) {
					recommendMarkerArr.push(marker);
				}
				drawInfoWin(marker);
				addEventByClick(marker);
			}//end for 
		}

		//draw infowindow
		function drawInfoWin(marker) {
			var infoWindow = new google.maps.InfoWindow;

			google.maps.event.addListener(marker, 'mouseover', function() {
				var str = "<div><strong>"
				str += marker.title;
				str += "</strong>";
				str += "<br><text>" + marker.descs;
				str += "</text></div>";

				infoWindow.setContent(str);
				infoWindow.open(map, marker);
			});
			google.maps.event.addListener(marker, 'mouseout', function() {
				infoWindow.close();
			});
		}

		// draw path
		function drawPath() {

			poly = new google.maps.Polyline({ //선분 모양 설정
				strokeColor : '#000000',
				strokeOpacity : 1.0,
				strokeWeight : 3
			});

			for (var i = 0; i < markerArr.length; i++) {
				poly.getPath().push(markerArr[i].position);
			}
			poly.setMap(map);
		}

		//add path when marker clicked
		function addEventByClick(marker) {
			google.maps.event.addListener(marker, "click", function() {
				course.push(marker.myPos);
				markerArr.push(marker);
				checkDupl(marker);
				drawList(course);
				sortableUL.scrollTop(sortableUL[0].scrollHeight);
			});
		}

		//check duplication
		function checkDupl(marker) {

			var uniq = course.reduce(function(a, b) {
				if (a.indexOf(b) < 0)
					a.push(b);
				return a;
			}, []);

			if (uniq.length == course.length) { //폴리 연결시 중복체크
				poly.getPath().push(marker.position);
			} else {
				course = uniq;
				alert("이미 선택된 경로입니다.");
			}
		}

		//draw list
		function drawList(arr) {
			var str = "";
			$("#sortable").html("");
			for (var i = 0; i < arr.length; i++) {
				(function(arr) {
					str = "<li class='courseList' data-idx ='"+i+"'><span class='ui-icon ui-icon-arrowthick-2-n-s'></span>"
							+ course[i].title;
					str += "<input type='button' data-idx='" + i + "' value='x'></input></li>";
					$("#sortable").append(str);
				})(course);
			}
		}

		// sort list
		sortableUL.sortable({
			update : function() {
				console.log("ddddd");
				var liList = sortableUL.find("li");
				var arr = [];
				for (var i = 0; i < liList.length; i++) {
					arr.push($(liList[i]).attr("data-idx"));
				}
				var temp = [];
				var tempCourse = [];

				for (var i = 0; i < liList.length; i++) {
					temp.push(markerArr[arr[i]]);
					tempCourse.push(course[arr[i]]);
				}
				markerArr = temp;
				course = tempCourse;
				redrawMarker(markerArr);
				reArrangeIdx();
			}
		});

		//rearrange idx
		function reArrangeIdx() {
			var liList = sortableUL.find("li");
			var idxList = sortableUL.find("input");
			var arr = [];
			for (var i = 0; i < liList.length; i++) {
				$(liList[i]).attr("data-idx", i);
				$(idxList[i]).attr("data-idx", i);
			}
		}

		//redraw marker
		function redrawMarker(arr) {
			for (var i = 0; i < markerArr.length; i++) {
				arr[i].setMap(null);
				poly.getPath().pop(arr[i].position);
			}
			for (var i = 0; i < arr.length; i++) { //마인드맵 마커 생성
				arr[i].setMap(map);
				poly.getPath().push(arr[i].position); //경로 그리기   
			}
		}

		//read json data
		$("#jsonBtn").on("click", function() {
			alert(JSON.stringify(course));
		});

		//delete by button click
		$("#sortable").on("click", "input", function() {

			var idx = $(this).attr("data-idx");
			var pathIdx = poly.getPath().indexOf(markerArr[idx].position);
			var deletedMarker = markerArr.splice(idx, 1);

			poly.getPath().removeAt(pathIdx);
			course.splice(idx, 1);

			//add deleted marker to recommendMarkerArr
			if (recommendMarkerArr.indexOf(deletedMarker[0]) < 0) {
				recommendMarkerArr.push(deletedMarker[0]);
			}
			drawList(course);
			redrawMarker(markerArr);
		});
	</script>
	<script
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCIdmqOHKEfF4mfn6EXtuLeeP2-h3yJr6A&callback=initMap"></script>
</body>
</html>