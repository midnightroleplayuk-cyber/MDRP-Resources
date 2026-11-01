var storagewarsresourcename = "rtx_wateractivities";

function closeMain() {
	$("body").css("display", "none");
}

function openMain() {
	$("body").css("display", "block");
}

$(".closestoragewarsbuy").click(function(){
	$.post('https://'+storagewarsresourcename+'/closestoragewarsbuy', JSON.stringify({}));
});

$(".closestoragewarssign").click(function(){
	$.post('https://'+storagewarsresourcename+'/closestoragewarsbuy', JSON.stringify({}));
});

$(".closestoragewarsbid").click(function(){
	$.post('https://'+storagewarsresourcename+'/closestoragewarsbid', JSON.stringify({}));
});


window.addEventListener('message', function (event) {

	var item = event.data;
	if (item.message == "infonotifyshow") {
		document.getElementsByClassName("infonotifytext")[0].innerHTML = item.infonotifytext;
		openMain();
		$("#infonotifyshow").show();	
	}
	
	if (item.message == "storagewarsbuyshow") {
		openMain();
		document.getElementById("storagewarsbuystarttextdata").innerHTML = item.storagewarsnextauctiondata;
		document.getElementById("storagewarsbuyregistredtextdata").innerHTML = item.storagewarsregistredplayersdata;
		document.getElementById("storagewarsbuystorageidtextdata").innerHTML = item.storagewarsstorageiddata;
		document.getElementById("storagewarsbuypricetextdata").innerHTML = item.storagewarsstoragefeedata;
		$("#storagewarssignshow").hide();
		$("#storagewarsbuyshow").show();		
	}	
	
	if (item.message == "storagewarsshow") {
		openMain();
		if (item.storagewarsbindshow == true) {	
			document.getElementById("storagewarskeysdata1").innerHTML = item.storagewarskeydata1;
			document.getElementById("storagewarskeysdata2").innerHTML = item.storagewarskeydata2;
			$("#storagewarskeysshow").show();	
		} else {
			$("#storagewarskeysshow").hide();
		}	
		if (item.storagewarsmainshow == true) {	
			document.getElementById("storagewarskeysinfolockeridtext").innerHTML = item.storagewarsstorageiddata;
			document.getElementById("storagewarskeysinfowinnerdata").innerHTML = item.storagewarsstorageplayerdata;
			document.getElementById("storagewarskeysinfobiddata").innerHTML = item.storagewarsstoragebiddata;
			document.getElementById("storagewarsinprogressenddata").innerHTML = item.storagewarsstoragetimedata;
			$("#storagewarskeysinfoshow").show();	
		} else {
			$("#storagewarskeysinfoshow").hide();
		}	
		if (item.storagewarsstartingshow == true) {	
			document.getElementById("storagewarskeysstartinfolockeridtext").innerHTML = item.storagewarsstorageiddata;
			document.getElementById("storagewarsstartprogressenddata").innerHTML = item.storagewarsstoragetimedata;
			$("#storagewarsstartinfoshow").show();	
		} else {
			$("#storagewarsstartinfoshow").hide();
		}	
		if (item.storagewarsstartbidshow == true) {	
			document.getElementById("storagewarsstartbidinfolockeridtext").innerHTML = item.storagewarsstorageiddata;
			document.getElementById("storagewarsstartbidminimumdata").innerHTML = item.storagewarsstorageminimumbiddata;
			document.getElementById("storagewarsstartbidinprogressenddata").innerHTML = item.storagewarsstoragetimedata;
			$("#storagewarsstartbidinfoshow").show();	
		} else {
			$("#storagewarsstartbidinfoshow").hide();
		}				
		$("#storagewarsshow").show();		
	}	

	if (item.message == "storagewarsnotifyshow") {
		openMain();
		document.getElementById("storagewarsnotifydata1").innerHTML = item.storagewarsnotifynamedata;
		document.getElementById("storagewarsnotifydata2").innerHTML = item.storagewarsnotifyamountdata;
		$("#storagewarsnotifyshow").fadeIn();	
	}	

	if (item.message == "storagewarsnotifyhide") {
		$("#storagewarsnotifyshow").fadeOut();	
	}			
			
		
	if (item.message == "storagewarssearchshow") {
		openMain();
		document.getElementById("storagewarssearchinfoidtext").innerHTML = item.storagewarssearchiddata;
		document.getElementById("storagewarssearchinfoitemstext").innerHTML = item.storagewarssearchitemsdata;
		document.getElementById("storagewarssearchprogressdatatext").innerHTML = item.storagewarsstoragetimedata;
		$("#storagewarssearchshow").show();		
	}		

	if (item.message == "storagewarsbidshow") {
		openMain();
		$("#storagewarsbidshow").show();		
	}	
	
	if (item.message == "storagewarsendedshow") {
		openMain();
		document.getElementById("storagewarsendedinfolockeridtext").innerHTML = item.storagewarslockeriddata;
		document.getElementById("storagewarsendedinfowinnernametext").innerHTML = item.storagewarswinnerdata;
		document.getElementById("storagewarsendedinfopricetext").innerHTML = item.storagewarspricedata;
		$("#storagewarsendedshow").fadeIn();	
	}	
	
	if (item.message == "storagewarsprogressbarshow") {
		document.getElementsByClassName("storagewarsprogressbartext")[0].innerHTML = item.storagewarsprogressbartext;
		$('.storagewarsprogressbarmaincontainerdata').css("width", "0%")	
		$("#storagewarsprogressbarshow").show();	
		openMain();
	}		
		
	if (item.message == "updatestoragewarsprogressbar") {
		$('.storagewarsprogressbarmaincontainerdata').css("width", item.progressbardata+"%")
	}		
	
	if (item.message == "hide") {
		$("#infonotifyshow").hide();	
	}
	
	if (item.message == "storagewarsbuyhide") {
		$("#storagewarssignshow").hide();		
		$("#storagewarsbuyshow").hide();	
	}	
	
	if (item.message == "storagewarshide") {	
		$("#storagewarsshow").hide();	
	}	

	if (item.message == "storagewarssearchhide") {	
		$("#storagewarssearchshow").hide();	
	}

	if (item.message == "storagewarsbidhide") {	
		$("#storagewarsbidshow").hide();	
	}	

	if (item.message == "storagewarsendedhide") {	
		$("#storagewarsendedshow").hide();	
	}	

	if (item.message == "hideprogress") {
		$("#storagewarsprogressbarshow").hide();	
	}	
	
	if (item.message == "updateinterfacedata") {
		storagewarsresourcename = item.storagewarsresourcenamedata;
		let root = document.documentElement;
		root.style.setProperty('--color', item.interfacecolordata);	
	}
});

$(".storagewarsbuybutton").click(function () {
	$("#storagewarsbuyshow").hide();	
	$("#storagewarssignshow").show();	
});

$(".storagewarssignbutton").click(function () {
	$.post('https://'+storagewarsresourcename+'/signup', JSON.stringify({
		nicknamedata: $("#storagewarssigninputdata").val().trim()
	}));
});

$(".storagewarsbidbutton").click(function () {
	$("#storagewarsbidshow").hide();	
	$.post('https://'+storagewarsresourcename+'/custombid', JSON.stringify({
		biddata: $("#storagewarsbidinputdata").val().trim()
	}));
});