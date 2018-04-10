<%@ page import="com.sun.org.apache.xpath.internal.operations.Bool" %>
<%@ page import="java.util.Arrays" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" errorPage="./error.jsp" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="ja">
<head>
	<meta charset="utf-8">
	<title>ワンナイト人狼支援サイト</title>
	<meta name="viewport" content="width=device-width">
	<meta name="keywords" content="">
	<meta name="description" content="">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<script type="text/javascript" src="js/jquery-3.3.1.js"></script>
	<script type="text/javascript" src="js/jquery-migrate-1.2.1.min.js"></script>
	<script type="text/javascript" src="js/jquery.smoothscroll.js"></script>
	<script type="text/javascript" src="js/jquery.scrollshow.js"></script>
	<script type="text/javascript" src="js/jquery-qrcode-0.14.0.js"></script>
	<script type="text/javascript" src="js/script.js"></script>
	<script>
        $(function ($) {
            $('html').smoothscroll({easing: 'swing', speed: 1000, margintop: 30, headerfix: $('nav')});
            $('.totop').scrollshow({position: 500});
        });
	</script>
	<!--[if lt IE 9]>
	<script src="js/html5shiv.js"></script>
	<script src="js/css3-mediaqueries.js"></script>
	<![endif]-->
	<script>
        $(function () {
            // 自身のページを履歴に追加
            history.pushState(null, null, null);
            // ページ戻り時にも自身のページを履歴に追加
            $(window).on("popstate", function () {
                history.pushState(null, null, null);
            });
        });
	</script>
</head>
<%
	boolean loggedInBefore = false;
	if (session.getAttribute("loggedIn") != null) {
		loggedInBefore = (boolean) session.getAttribute("loggedIn");
	}
	boolean villageCreated = false;
	boolean villageCreatedFirst = false;
	if (session.getAttribute("villageCreated") != null) {
		villageCreated = (boolean) session.getAttribute("villageCreated");
	}
	boolean villageDeleted = false;
	if (session.getAttribute("villageDeleted") != null) {
		villageDeleted = (boolean) session.getAttribute("villageDeleted");
	}
	if (request.getParameter("villageDeleted") != null) {
		villageDeleted = Boolean.getBoolean(request.getParameter("villageDeleted"));
	}
	boolean loggedIn = false;
	if (session.getAttribute("loggedIn") != null) {
		loggedIn = (boolean) session.getAttribute("loggedIn");
	}
	int loggedInNumber = -1;
	long firstVillagerCount = 0;
	if (session.getAttribute("firstVillagerCount") != null) {
		firstVillagerCount = (long) session.getAttribute("firstVillagerCount");
	}
	boolean gameStarted = false;
	boolean readyToGameStart = false;
	boolean gameStartRequested = false;
%>
<%!
	int[] loggedinPlayerMax;
	boolean[] playerMaxDecided;
%>
<%!
	byte[] loggedInCount;
%>
<%
	loggedinPlayerMax = new int[villageCreatedCount];
	playerMaxDecided = new boolean[villageCreatedCount];
	for (int i = 0; i < villageCreatedCount; i++) {
		loggedinPlayerMax[i] = 0;
	}
	for (int i = 0; i < villageCreatedCount; i++) {
		playerMaxDecided[i] = false;
	}
	if (session.getAttribute("loggedInNumber") != null && (int) session.getAttribute("loggedInNumber") != -1) {
		loggedInNumber = (int) session.getAttribute("loggedInNumber");
		if (loggedinPlayerMax.length > loggedInNumber && application.getAttribute("loggedinPlayerMax" + loggedInNumber) != null) {
			loggedinPlayerMax[loggedInNumber] = (int) application.getAttribute("loggedinPlayerMax" + loggedInNumber);
		}
	}
	if (playerMaxDecided.length > loggedInNumber && application.getAttribute("playerMaxDecided" + loggedInNumber) != null) {
		playerMaxDecided[loggedInNumber] = (boolean) application.getAttribute("playerMaxDecided" + loggedInNumber);
	}
	request.setCharacterEncoding("UTF-8");
	boolean villageLeft = false;
	loggedInCount = new byte[villageCreatedCount];
	for (int i = 0; i < villageCreatedCount; i++) {
		loggedInCount[i] = 0;
	}
	if (loggedInCount.length >= loggedInNumber && loggedInNumber >= 0 && application.getAttribute("loggedInCount" + loggedInNumber) != null) {
		loggedInCount[loggedInNumber] = (byte) application.getAttribute("loggedInCount" + loggedInNumber);
	}
	byte loggedInVillagerNumber = 1;
	if (session.getAttribute("loggedInVillagerNumber") != null) {
		loggedInVillagerNumber = (byte) session.getAttribute("loggedInVillagerNumber");
	}
	if (request.getParameter("villageLeft") != null && request.getParameter("villageLeft").equals("true")) {
		playerArray[loggedInNumber][loggedInVillagerNumber] = null;
		application.removeAttribute("playerArray" + loggedInNumber + "_" + loggedInVillagerNumber);
		loggedInNumber = -1;
		loggedInVillagerNumber = 1;
		loggedIn = false;
		villageCreated = false;
		villageLeft = false;
	}
	byte playerArrayNullCount = 0;
%>
<body>
<header>
	<h1>ワンナイト人狼支援サイト</h1>
	<p>
		ワンナイト人狼のプレイングを支援するサイトを製作中です。(非公認)
	</p>
</header>

<nav>
	<ul>
		<li><a href="index.jsp">RELOAD</a></li>
	</ul>
</nav>

<div id="contents">
	<h2 id="playerCount">プレイ人数</h2>
	<p>
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="playerCount">
			<option value="" selected disabled></option>
			<%
				byte playerMax = 8;
				for (byte i = 3; i <= playerMax && loggedIn == false && (villageCreated == false || villageLeft == true); i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String playerCountStr = request.getParameter("playerCount");
		int playerCount = 0;
		if (session.isNew()) {
			session.setAttribute("playerCount", playerCount);
		}
		if (!session.isNew() && session.getAttribute("playerCount") != null) {
			playerCount = (int) session.getAttribute("playerCount");
		}
		if (playerCountStr != null) {
			playerCount = Integer.parseInt(playerCountStr);
		}
		boolean playerCountOn = (playerCount >= 3 && playerCount <= playerMax);
		if (playerCountOn) {
			out.println(playerCount + "人に設定されました");
		}
	%>
	<h2 id="role">配役</h2>
	<%
		int villagerCardCount = 0, werewolfCardCount = 0, thiefCardCount = 0, augerCardCount = 0, suiciderCardCount = 0, lunaticCardCount = 0;
		if (playerCountOn == true) {
			out.println("計" + (playerCount + 2) + "枚のカードを設定してください<br><br>");
		}
	%>
	村人カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="villagerCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= playerCount + 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String villagerCardCountStr = request.getParameter("villagerCardCount");
		if (!session.isNew() && session.getAttribute("villagerCardCount") != null) {
			villagerCardCount = (int) session.getAttribute("villagerCardCount");
		}
		if (villagerCardCountStr != null) {
			villagerCardCount = Integer.parseInt(villagerCardCountStr);
		}
		boolean villagerCardCountOn = (villagerCardCount >= 0 && villagerCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
				case 4:
					villagerCardCount = 2;
					break;
				case 5:
				case 8:
					villagerCardCount = 3;
					break;
				case 6:
				case 7:
					villagerCardCount = 4;
					break;
				default:
					villagerCardCount = 0;
					break;
			}
			villagerCardCountOn = true;
		}
		if (villagerCardCountOn == true) {
			out.println(villagerCardCount + "枚に設定されています");
		}
	%><br>
	人狼カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="werewolfCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= playerCount + 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String werewolfCardCountStr = request.getParameter("werewolfCardCount");
		if (!session.isNew() && session.getAttribute("werewolfCardCount") != null) {
			werewolfCardCount = (int) session.getAttribute("werewolfCardCount");
		}
		if (werewolfCardCountStr != null) {
			werewolfCardCount = Integer.parseInt(werewolfCardCountStr);
		}
		boolean werewolfCardCountOn = (werewolfCardCount >= 0 && werewolfCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
					werewolfCardCount = 1;
					break;
				case 4:
				case 5:
				case 8:
				case 6:
				case 7:
					werewolfCardCount = 2;
					break;
				default:
					werewolfCardCount = 0;
					break;
			}
			werewolfCardCountOn = true;
		}
		if (werewolfCardCountOn == true) {
			out.println(werewolfCardCount + "枚に設定されています");
		}
	%>
	<br>
	怪盗カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="thiefCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String thiefCardCountStr = request.getParameter("thiefCardCount");
		if (!session.isNew() && session.getAttribute("thiefCardCount") != null) {
			thiefCardCount = (int) session.getAttribute("thiefCardCount");
		}
		if (thiefCardCountStr != null) {
			thiefCardCount = Integer.parseInt(thiefCardCountStr);
		}
		boolean thiefCardCountOn = (thiefCardCount >= 0 && thiefCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
				case 4:
				case 5:
				case 8:
				case 6:
				case 7:
					thiefCardCount = 1;
					break;
				default:
					thiefCardCount = 0;
					break;
			}
			thiefCardCountOn = true;
		}
		if (thiefCardCountOn == true) {
			out.println(thiefCardCount + "枚に設定されています");
		}
	%>
	<br>
	占い師カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="augerCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= playerCount + 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String augerCardCountStr = request.getParameter("augerCardCount");
		if (!session.isNew() && session.getAttribute("augerCardCount") != null) {
			augerCardCount = (int) session.getAttribute("augerCardCount");
		}
		if (augerCardCountStr != null) {
			augerCardCount = Integer.parseInt(augerCardCountStr);
		}
		boolean augerCardCountOn = (augerCardCount >= 0 && augerCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
				case 4:
				case 5:
				case 6:
					augerCardCount = 1;
					break;
				case 7:
				case 8:
					augerCardCount = 2;
					break;
				default:
					augerCardCount = 0;
					break;
			}
			augerCardCountOn = true;
		}
		if (augerCardCountOn == true) {
			out.println(augerCardCount + "枚に設定されています");
		}
	%>
	<br>
	吊人カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="suiciderCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String suiciderCardCountStr = request.getParameter("suiciderCardCount");
		if (!session.isNew() && session.getAttribute("suiciderCardCount") != null) {
			suiciderCardCount = (int) session.getAttribute("suiciderCardCount");
		}
		if (suiciderCardCountStr != null) {
			suiciderCardCount = Integer.parseInt(suiciderCardCountStr);
		}
		boolean suiciderCardCountOn = (suiciderCardCount >= 0 && suiciderCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
					suiciderCardCount = 0;
					break;
				case 8:
					suiciderCardCount = 1;
					break;
				default:
					suiciderCardCount = 0;
					break;
			}
			suiciderCardCountOn = true;
		}
		if (suiciderCardCountOn == true) {
			out.println(suiciderCardCount + "枚に設定されています");
		}
	%><br>
	狂人カードの枚数
	<form action="index.jsp#role" method="post">
		<select required onChange="this.form.submit()" name="lunaticCardCount">
			<option value="" selected disabled></option>
			<%
				for (byte i = 0; i <= playerCount + 1; i++) {
					out.println("<option value=\"" + i + "\">" + i + "</option>");
				}
			%>
		</select>
	</form>
	<%
		request.setCharacterEncoding("UTF-8");
		String lunaticCardCountStr = request.getParameter("lunaticCardCount");
		if (!session.isNew() && session.getAttribute("lunaticCardCount") != null) {
			lunaticCardCount = (int) session.getAttribute("lunaticCardCount");
		}
		if (lunaticCardCountStr != null) {
			lunaticCardCount = Integer.parseInt(lunaticCardCountStr);
		}
		boolean lunaticCardCountOn = (lunaticCardCount >= 0 && lunaticCardCount <= playerMax + 1);
		if (request.getParameter("playerCount") != null) {
			switch (Byte.parseByte(request.getParameter("playerCount"))) {
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
					lunaticCardCount = 0;
					break;
				case 8:
					lunaticCardCount = 1;
					break;
				default:
					lunaticCardCount = 0;
					break;
			}
			lunaticCardCountOn = true;
		}
		if (lunaticCardCountOn == true) {
			out.println(lunaticCardCount + "枚に設定されています");
		}
	%>
	<%!
		byte[] villagerCardCountArray;
		byte[] werewolfCardCountArray;
		byte[] thiefCardCountArray;
		byte[] augerCardCountArray;
		byte[] suiciderCardCountArray;
		byte[] lunaticCardCountArray;
		byte[] gameStartRequestCount;
	%>
	<h2 id="village">村建て</h2>
	<%
		request.setCharacterEncoding("UTF-8");
		String villageCreatedStr = request.getParameter("villageCreated");
		if (villageCreatedStr != null && !villageCreatedStr.equals("")) {
			villageCreated = Boolean.parseBoolean(villageCreatedStr);
		}
		if (!session.isNew() && villageCreatedStr == null && session.getAttribute("villageCreated") != null) {
			villageCreated = (boolean) session.getAttribute("villageCreated");
		}
		if (villagerCardCount + werewolfCardCount + thiefCardCount + augerCardCount + suiciderCardCount + lunaticCardCount == playerCount + 2 && playerCountOn == true && villageCreated == false && villageDeleted == false) {
			out.print("村建て可能です");
		} else if (villageCreated == false && villageDeleted == false) {
			out.print("村建て不可能です");
		}
	%>
	<%
		if (villagerCardCount + werewolfCardCount + thiefCardCount + augerCardCount + suiciderCardCount + lunaticCardCount == playerCount + 2 && playerCountOn == true && villageCreated == false && villageDeleted == false && loggedIn == false && loggedIn == false) { %>
	<form action="index.jsp#village" method="post">
		<input type="hidden" name="villageCreated" value="true">
		<input type="submit" value="村を建てる">
	</form>
	<% } %>
	<%
		if (!session.isNew() && villageCreatedStr == null && session.getAttribute("villageCreated") != null) {
			villageCreated = (boolean) session.getAttribute("villageCreated");
		}
		request.setCharacterEncoding("UTF-8");
		String villageDeletedStr = request.getParameter("villageDeleted");
		villageDeleted = Boolean.parseBoolean(villageDeletedStr);
		boolean villageReCreated = false;
		if (villageDeleted == false && session.getAttribute("villageDeleted") != null) {
			villageDeleted = (boolean) session.getAttribute("villageDeleted");
		}
		int playerCountDecided = 0;
		boolean firstVillager = false;
		int createdPlayerMax = 0;
		if (villageCreated == true) {
			createdPlayerMax = playerCount;
		}
		if (villageCreated == true && villageDeleted == false && loggedIn == false) {
			out.println("村が建ちました");
	%>
	<form action="index.jsp" method="post">
		<input type="hidden" name="villageDeleted" value="true">
		<input type="submit" value="村を解散する">
	</form>
	<%
	} else if (villagerCardCount + werewolfCardCount + thiefCardCount + augerCardCount + suiciderCardCount == playerCount + 2 && playerCountOn == true && villageDeleted == true) {
		out.println("村を解散しました");
		villageCreated = false;
		loggedIn = false;
		session.setAttribute("yourVillageId", null);
	%>
	<form action="index.jsp" method="post">
		<input type="hidden" name="villageReCreated" value="true">
		<input type="submit" value="村建てに戻る">
	</form>
	<%
			request.setCharacterEncoding("UTF-8");
			villageCreatedStr = request.getParameter("villageReCreated");
			if (request.getParameter("villageReCreated") != null) {
				villageReCreated = Boolean.parseBoolean(request.getParameter("villageReCreated"));
			}
			villageCreated = Boolean.parseBoolean(villageCreatedStr);
		}
		boolean villageDeletedFlag = false;
		if (villageDeleted == true) {
			villageDeleted = false;
			villageDeletedFlag = true;
			for (byte i = 0; i < playerMax + 1; i++) {
				playerArray[yourVillageId][i] = null;
				application.setAttribute("playerArray" + yourVillageId + "_" + i, playerArray[yourVillageId][i]);
			}
		}
		if (villageCreated == true) {
			villageDeleted = false;
		}
	%>
	<%!
		int villageId = 0;
		int villageCreatedCount = 0;
		
		synchronized int getVillageIdPlus() {
			return villageId++;
		}
		
		synchronized int getVillageCreatedCountPlus() {
			return villageCreatedCount++;
		}
	%>
	<%
		int yourVillageId = 0;
		String newPassword = "anonymous", loginPassword = "anonymous";
		if (villageId == 2147483647 || villageId < 0) {
			villageId = 0;
		}
		if (villageDeletedFlag == true || villageCreated == false) {
			session.setAttribute("yourVillageId", null);
		}
		if (villageCreated == true && session.getAttribute("yourVillageId") == null) {
			yourVillageId = getVillageIdPlus();
			if (villageCreatedCount < 2147483647) {
				getVillageCreatedCountPlus();
			}
			out.println("あなたの村IDは" + yourVillageId + "です<br>");
			session.setAttribute("yourVillageId", yourVillageId);
			firstVillager = true;
			session.setAttribute("firstVillagerCount", firstVillagerCount);
		} else if (villageCreated == true && session.getAttribute("yourVillageId") != null) {
			yourVillageId = (int) session.getAttribute("yourVillageId");
			out.println("あなたの村IDは" + yourVillageId + "です<br>");
			session.setAttribute("yourVillageId", yourVillageId);
		} else {
			session.setAttribute("yourVillageId", null);
		}
		if (loggedinPlayerMax.length > yourVillageId && yourVillageId >= 0) {
			if (createdPlayerMax >= 3 && playerMaxDecided[yourVillageId] == false) {
				loggedinPlayerMax[yourVillageId] = createdPlayerMax;
				application.setAttribute("loggedinPlayerMax" + yourVillageId, loggedinPlayerMax[yourVillageId]);
				playerMaxDecided[yourVillageId] = true;
			} else if (application.getAttribute("loggedinPlayerMax" + yourVillageId) != null) {
				loggedinPlayerMax[yourVillageId] = (int) application.getAttribute("loggedinPlayerMax" + yourVillageId);
			}
		}
		villagerCardCountArray = new byte[villageCreatedCount];
		werewolfCardCountArray = new byte[villageCreatedCount];
		thiefCardCountArray = new byte[villageCreatedCount];
		augerCardCountArray = new byte[villageCreatedCount];
		suiciderCardCountArray = new byte[villageCreatedCount];
		lunaticCardCountArray = new byte[villageCreatedCount];
		gameStartRequestCount = new byte[villageCreatedCount];
		if (villageCreated == true && villageCreatedFirst == false) {
			villagerCardCountArray[yourVillageId] = (byte) villagerCardCount;
			werewolfCardCountArray[yourVillageId] = (byte) werewolfCardCount;
			thiefCardCountArray[yourVillageId] = (byte) thiefCardCount;
			augerCardCountArray[yourVillageId] = (byte) augerCardCount;
			suiciderCardCountArray[yourVillageId] = (byte) suiciderCardCount;
			lunaticCardCountArray[yourVillageId] = (byte) lunaticCardCount;
			application.setAttribute("villagerCardCountArray" + yourVillageId, villagerCardCountArray[yourVillageId]);
			application.setAttribute("werewolfCardCountArray" + yourVillageId, werewolfCardCountArray[yourVillageId]);
			application.setAttribute("thiefCardCountArray" + yourVillageId, thiefCardCountArray[yourVillageId]);
			application.setAttribute("augerCardCountArray" + yourVillageId, augerCardCountArray[yourVillageId]);
			application.setAttribute("suiciderCardCountArray" + yourVillageId, suiciderCardCountArray[yourVillageId]);
			application.setAttribute("lunaticCardCountArray" + yourVillageId, lunaticCardCountArray[yourVillageId]);
		}
		if (villageCreated == true && loggedIn == false) { %>
	<form action="index.jsp#village" method="post">
		<label>村パスワード:<input type="password" name="newPassword" size="10" maxlength="20">
			<input type="submit" value="設定">
		</label></form>
	<%
		}
		request.setCharacterEncoding("UTF-8");
		newPassword = request.getParameter("newPassword");
	%>
	<%!
		String[][] playerArray;
		int yourVillageId = 0;
		byte[] playerArrayNullCountArray;
		
		synchronized void playerArrayWrite(int loggedInNumberWrote, byte iWrote, String screnNameWrote) {
			playerArray[loggedInNumberWrote][iWrote] = screnNameWrote;
			return;
		}
	%>
	<%
		playerArrayNullCountArray = new byte[villageCreatedCount];
		playerArray = new String[villageCreatedCount][playerMax + 1];
		for (int i = 0; i < villageId; i++) {
			if (playerArray[i][0] == null) {
				playerArray[i][0] = null;
			}
		}
		for (int i = 0; i < villageCreatedCount; i++) {
			playerArrayNullCountArray[i] = playerMax;
		}
		if (session.getAttribute("yourVillageId") != null) {
			yourVillageId = (int) session.getAttribute("yourVillageId");
		}
		if ((request.getParameter("yourVillageId") != null && request.getParameter("yourVillageId") != "") && request.getParameter("yourVillageId") != "-1") {
			yourVillageId = Integer.getInteger(request.getParameter("yourVillageId"));
			if (newPassword != null && newPassword != "") {
				playerArray[yourVillageId][0] = newPassword;
			}
		}
		if (playerArray.length > yourVillageId && session.getAttribute("newPassword") != null) {
			newPassword = request.getParameter("newPassword");
			playerArray[yourVillageId][0] = newPassword;
		} else if (request.getParameter("newPassword") != null && request.getParameter("newPassword") != "") {
			newPassword = request.getParameter("newPassword");
			session.setAttribute("newPassword", newPassword);
		} else {
			newPassword = (String) session.getAttribute("newPassword");
		}
		if (newPassword != null && newPassword != "" && playerArray.length > yourVillageId) {
			playerArray[yourVillageId][0] = newPassword;
		}
		if (session.getAttribute("newPassword") != null && playerArray.length > yourVillageId) {
			playerArray[yourVillageId][0] = (String) session.getAttribute("newPassword");
		}
		if (session.getAttribute("yourVillageId") != null && session.getAttribute("newPassword") != null && session.getAttribute("newPassword") != "") {
			application.setAttribute("playerArrayPassword" + yourVillageId, newPassword);
		}
		if (application.getAttribute("playerArrayPassword" + yourVillageId) != null && playerArray.length > yourVillageId) {
			playerArray[yourVillageId][0] = (String) application.getAttribute("playerArrayPassword" + yourVillageId);
		}
		if (newPassword != null && newPassword != "" && playerArray.length > yourVillageId) {
			playerArray[yourVillageId][0] = newPassword;
		}
		if (playerArray.length > yourVillageId && playerArray[yourVillageId][0] == null && application.getAttribute("playerArrayPassword") != null && application.getAttribute("playerArrayPassword") != "anonymous") {
			playerArray[yourVillageId][0] = (String) application.getAttribute("playerArrayPassword");
		}
		if (playerArray.length > yourVillageId && session.getAttribute("newPassword") != null) {
			application.setAttribute("playerArrayPassword" + yourVillageId, session.getAttribute("newPassword"));
		} else if (playerArray.length > yourVillageId && request.getAttribute("newPassword") != null) {
			application.setAttribute("playerArrayPassword" + yourVillageId, request.getAttribute("newPassword"));
		}
		if (playerArray.length > yourVillageId && application.getAttribute("playerArrayPassword" + yourVillageId) != null) {
			playerArray[yourVillageId][0] = (String) application.getAttribute("playerArrayPassword" + yourVillageId);
		}
		if (playerArray.length > yourVillageId && playerArray[yourVillageId][0] != null && !(playerArray[yourVillageId][0].equals("")) && !(playerArray[yourVillageId][0].equals("anonymous")) && villageCreated == true) {
			out.println("パスワードが設定されています");
			String qrCodeUrl = "http://www.hogehoge.com/one/web/index.jsp?id=" + String.valueOf(yourVillageId) + "&password=" + playerArray[yourVillageId][0] + "#login";
	%>
	<br><a href="<%=qrCodeUrl%>">入力済みURL </a><input value="<%=qrCodeUrl%>"
	                                                onclick="this.select(); clipboardData.setData('text',this.value)">
	<br>QRコードはこちら<br>
	<div id="qrcode"></div>
	<script>
        $(function () {
            $('#qrcode').qrcode({
                text: '<%=qrCodeUrl%>'
            });
        });
	</script>
	<%
		} else if (villageCreated == true) {
			out.println("パスワードを設定してください");
		}
	%>
	<h2 id="login">入退村</h2>
	<form action="index.jsp#gameStart" method="post" accept-charset="utf-8">
		<label>村ID:<input type="number" name="loginVillageId" size="20" max="2147483647" min="0" id="id"
		                  required></label>
		<label>パスワード:<input type="password" name="loginPassword" size="10" id="password" maxlength="20"><br></label>
		<label>ハンドルネーム:<input type="text" name="screenName" size="28" maxlength="20" required></label>
		<input type="submit" value="入村">
	</form>
	<%
		if (request.getParameter("id") != null) {
	%>
	<SCRIPT LANGUAGE="JavaScript">
        <!--
        var QS = [], item;
        var str = location.search;
        if (str.indexOf('?', 0) > -1) str = str.split('?')[1];
        str = str.split('&');
        for (var i = 0; str.length > i; i++) {
            item = str[i].split("=");
            QS[item[0]] = item[1];
        }
        document.getElementById('id').value = QS['id'];
        <%
            if(request.getParameter("password") != null){
        %>
        document.getElementById('password').value = QS['password'];
        <%
            }
        %>
        //-->
	</SCRIPT>
	<%
		}
		request.setCharacterEncoding("UTF-8");
		String screenName = request.getParameter("screenName");
		if (screenName != null) {
			screenName = new String(screenName.getBytes("ISO8859-1"), "UTF-8");
		}
		loginPassword = request.getParameter("loginPassword");
		byte playerArrayCommonName = 0;
		boolean playerArrayCommonNameDetected = false;
		if (loginPassword == null) {
			loginPassword = (String) session.getAttribute("loginPassword");
		}
		int loginVillageId = -1;
		request.setCharacterEncoding("UTF-8");
		String loginVillageIdStr = request.getParameter("loginVillageId");
		if (loginVillageIdStr != null && loginVillageIdStr != "") {
			long loginVillageIdLong = -1;
			loginVillageIdLong = Long.parseLong(loginVillageIdStr);
			if (loginVillageIdLong >= -2147483648 && loginVillageIdLong <= 2147483647) {
				loginVillageId = (int) loginVillageIdLong;
			} else {
				loginVillageId = -1;
				out.print("村IDが大きすぎます");
			}
			session.setAttribute("loginVillageId", loginVillageId);
		} else if (loggedIn == false) {
			out.print("村IDを入力してください<br>");
		}
		if (request.getParameter("loginVillageId") != null && request.getParameter("loginVillageId") != "") {
			loginVillageId = Integer.parseInt(request.getParameter("loginVillageId"));
		}
		if ((String) application.getAttribute("playerArrayPassword" + loginVillageId) != null && playerArray.length > loginVillageId) {
			playerArray[loginVillageId][0] = (String) application.getAttribute("playerArrayPassword" + loginVillageId);
		}
		if (loginPassword == "") {
			loginPassword = "anonymous";
		} else if (loginPassword == "anonymous") {
			loginPassword = "";
		}
		if (loggedInCount.length >= loggedInNumber && loggedInNumber >= 0 && application.getAttribute("loggedInCount" + loggedInNumber) != null) {
			loggedInCount[loggedInNumber] = (byte) application.getAttribute("loggedInCount" + loggedInNumber);
		}
		if (playerArray.length > loginVillageId && loginVillageId >= 0 && playerArray[loginVillageId][0] == null) {
			playerArray[loginVillageId][0] = (String) application.getAttribute("playerArrayPassword" + loginVillageId);
		}
		boolean multpleLogin = false;
		if (playerArray.length > loginVillageId && loggedInNumber >= 0 && loggedinPlayerMax.length > loggedInNumber && screenName != null && loginVillageId >= 0) {
			for (byte i = 0; i <= loggedinPlayerMax[loggedInNumber] && playerArrayCommonNameDetected == false; i++) {
				if (playerArray[loginVillageId][i] == screenName) {
					playerArrayCommonName = i;
					playerArrayCommonNameDetected = true;
				}
			}
		}
		if (loginVillageId >= 0) {
			if (playerArrayNullCountArray.length > loginVillageId && loginVillageId >= 0 && application.getAttribute("playerArrayNullCountArray" + loginVillageId) != null) {
				playerArrayNullCountArray[loginVillageId] = (byte) application.getAttribute("playerArrayNullCountArray" + loginVillageId);
			}
			if (playerArray.length > loginVillageId && loginVillageId >= 0) {
				if (playerArray[loginVillageId][0] == null) {
					playerArray[loginVillageId][0] = (String) application.getAttribute("playerArrayPassword" + loginVillageId);
				}
				if (playerArray[loginVillageId][0] != null && !playerArray[loginVillageId][0].equals(loginPassword) && request.getParameter("loginPassword") != null) {
					loginPassword = request.getParameter("loginPassword");
				}
				if (playerArray[loginVillageId][0] != null && playerArray[loginVillageId][0].equals(loginPassword) && loggedIn == false && playerArrayNullCountArray[loginVillageId] >= 1) {
					out.println("ログインに成功しました<br>");
					loggedIn = true;
					loggedInNumber = loginVillageId;
					if (loggedinPlayerMax.length > loggedInNumber && loggedinPlayerMax[loggedInNumber] <= 0 && application.getAttribute("loggedinPlayerMax" + loggedInNumber) != null) {
						loggedinPlayerMax[loggedInNumber] = (int) application.getAttribute("loggedinPlayerMax" + loggedInNumber);
					}
					loggedInCount[loggedInNumber]++;
					application.setAttribute("loggedInCount" + loggedInNumber, loggedInCount[loggedInNumber]);
					firstVillagerCount++;
					if (playerCountDecided < 3 && playerMaxDecided.length > loggedInNumber && playerMaxDecided[loggedInNumber] == false) {
						playerCountDecided = playerCount;
						playerMaxDecided[loggedInNumber] = true;
					}
				} else if (playerArrayNullCountArray[loginVillageId] == 0) {
					out.println("ログインに失敗しました (この村は満員です)");
				} else if (playerArrayNullCountArray[loginVillageId] < 0) {
					out.println("ログインに失敗しました (この村は定員オーバーです)");
				} else if (loggedIn == false) {
					out.println("ログインに失敗しました (パスワードが不正です)");
				} else {
					out.println("ログインが解除されました (多重ログインです)");
					loggedIn = false;
					playerArray[loggedInNumber][loggedInVillagerNumber] = null;
					application.removeAttribute("playerArray" + loggedInNumber + "_" + loggedInVillagerNumber);
					loggedInNumber = -1;
					loggedInVillagerNumber = 0;
				}
			} else if (loginVillageId < 0 || playerArray.length <= loginVillageId) {
				out.println("ログインに失敗しました (村IDが不正です)");
				loggedIn = false;
			} else {
				out.println("ログインしていません");
			}
		}
		if (loggedIn == false && session.getAttribute("loggedIn") != null && session.getAttribute("loggedIn").equals("true")) {
			loggedIn = (Boolean) session.getAttribute("loggedIn");
			loggedInNumber = (int) session.getAttribute("loggedInNumber");
		}
		if (screenName == null) {
			screenName = (String) session.getAttribute("screenName");
			if (screenName == null) {
				screenName = "noname";
			}
		}
		String yourName = "";
		byte playerArrayFirstNull = 0;
		boolean playerArrayFirstNullDetected = false;
		if (session.getAttribute("loggedInVillagerNumber") != null) {
			loggedInVillagerNumber = (byte) session.getAttribute("loggedInVillagerNumber");
		}
		if (loggedInNumber >= 0 && application.getAttribute("loggedinPlayerMax" + loggedInNumber) != null && loggedinPlayerMax.length > loggedInNumber) {
			loggedinPlayerMax[loggedInNumber] = (int) application.getAttribute("loggedinPlayerMax" + loggedInNumber);
		}
		if (loggedIn == true && loggedInNumber >= 0 && playerArray.length > loggedInNumber) {
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (application.getAttribute("playerArray" + loggedInNumber + "_" + i) != null && playerArray[loggedInNumber][i] == null) {
					playerArray[loggedInNumber][i] = (String) application.getAttribute("playerArray" + loggedInNumber + "_" + i);
				}
			}
			for (byte i = 1; playerArrayFirstNullDetected == false && i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (playerArray[loggedInNumber][i] == null) {
					playerArrayFirstNull = i;
					playerArrayFirstNullDetected = true;
				}
			}
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (application.getAttribute("playerArray" + loggedInNumber + "_" + i) != null && playerArray[loggedInNumber][i] == null) {
					playerArray[loggedInNumber][i] = (String) application.getAttribute("playerArray" + loggedInNumber + "_" + i);
				}
				if (i == playerArrayFirstNull && loggedInBefore == false && playerArrayCommonNameDetected == false) {
					playerArray[loggedInNumber][i] = screenName;
					playerArrayWrite(loggedInNumber, i, screenName);
					out.print("あなたのハンドルネームは");
					yourName = playerArray[loggedInNumber][i];
					if (session.getAttribute("yourName") == null) {
						session.setAttribute("yourName", yourName);
						application.setAttribute("playerArray" + loggedInNumber + "_" + i, yourName);
					}
					if (request.getParameter("yourName") != null && request.getParameter("yourName") != yourName) {
						yourName = request.getParameter("yourName");
					}
					if (playerArray.length >= loggedInNumber && loggedInNumber > 0 && yourName != null) {
						application.setAttribute("playerArray" + loggedInNumber + "_" + i, yourName);
					}
					if (yourName != null) {
						playerArray[loggedInNumber][i] = yourName;
					}
					out.print(yourName);
					session.setAttribute("yourName", yourName);
					out.println("です<br>");
					loggedInVillagerNumber = i;
				} else if (loggedInVillagerNumber == i) {
					if (yourName == null || yourName == "") {
						yourName = (String) session.getAttribute("yourName");
						if (yourName != null) {
							out.print("あなたのハンドルネームは");
							out.print(yourName);
							out.println("です<br>");
						} else {
							out.println(playerArray[loggedInNumber][i] + "がログインしています<br>");
						}
					}
				} else {
					if (application.getAttribute("playerArray" + loggedInNumber + "_" + i) != null) {
						playerArray[loggedInNumber][i] = (String) application.getAttribute("playerArray" + loggedInNumber + "_" + i);
					}
					if (playerArray[loggedInNumber][i] != null) {
						out.println(playerArray[loggedInNumber][i] + "がログインしています<br>");
					}
				}
			}
		} else if (session.getAttribute("loggedInNumber") != null) {
			loggedInNumber = (int) session.getAttribute("loggedInNumber");
		}
		if (request.getParameter("yourName") != null && request.getParameter("yourName") != yourName) {
			yourName = request.getParameter("yourName");
		}
		if (yourName == "" || yourName == null) {
			yourName = (String) session.getAttribute("yourName");
		}
		if (loggedIn == true && loggedInNumber >= 0 && loggedInCount.length > loggedInNumber && application.getAttribute("loggedInNumber" + loggedInNumber) != null) {
			loggedInCount[loggedInNumber] = (byte) application.getAttribute("loggedInCount" + loggedInNumber);
		}
		if (villageLeft == true && loggedInCount.length >= loggedInNumber) {
			if (loggedInCount.length >= loggedInNumber && loggedInNumber >= 0) {
				application.setAttribute("loggedInCount" + loggedInNumber, --loggedInCount[loggedInNumber]);
			}
			if (playerArray.length > loggedInNumber && playerArray.length > loggedInVillagerNumber) {
				playerArray[loggedInNumber][loggedInVillagerNumber] = null;
				application.setAttribute("playerArray" + loggedInNumber + "_" + loggedInVillagerNumber, null);
			}
			loggedInNumber = -1;
			loggedInVillagerNumber = 0;
		}
		for (byte i = 1; playerArray.length >= loggedInNumber && loggedInNumber >= 0 && i <= loggedinPlayerMax[loggedInNumber]; i++) {
			if (playerArray[loggedInNumber][i] == null) {
				playerArrayNullCount++;
			}
		}
		if (loggedIn == true && loggedInNumber >= 0 && playerArray.length >= loggedInNumber && playerArrayNullCount > 0) {
			out.println(playerArrayNullCount + "人不足しています");
		}
		if (loggedInNumber >= 0 && loggedInVillagerNumber >= 1 && playerArrayNullCountArray.length >= loggedInNumber && loggedIn == true) {
			application.setAttribute("playerArrayNullCountArray" + loggedInNumber, playerArrayNullCount);
		}
		if (loggedIn == true) {
	%>
	<form action="index.jsp" method="post" style="display: inline">
		<input type="hidden" name="villageLeft" value="true">
		<input type="submit" value="退村">
	</form>
	<form action="index.jsp#login" method="post">
		<input type="hidden" name="dummy" value="">
		<input type="submit" value="リロード">
	</form>
	<%
		}
	%>
	<h2 id="gameStart">ゲーム開始</h2>
	<%
		if (loggedIn == true) {
	%>
	<form action="index.jsp#gameStart" method="post">
		<input type="hidden" name="dummy" value="">
		<input type="submit" value="リロード">
	</form>
	<%
		}
		if (loggedIn == true) {
			villagerCardCountArray[loggedInNumber] = (byte) application.getAttribute("villagerCardCountArray" + loggedInNumber);
			werewolfCardCountArray[loggedInNumber] = (byte) application.getAttribute("werewolfCardCountArray" + loggedInNumber);
			thiefCardCountArray[loggedInNumber] = (byte) application.getAttribute("thiefCardCountArray" + loggedInNumber);
			augerCardCountArray[loggedInNumber] = (byte) application.getAttribute("augerCardCountArray" + loggedInNumber);
			suiciderCardCountArray[loggedInNumber] = (byte) application.getAttribute("suiciderCardCountArray" + loggedInNumber);
			lunaticCardCountArray[loggedInNumber] = (byte) application.getAttribute("lunaticCardCountArray" + loggedInNumber);
			if (playerArrayNullCount == 0) {
				readyToGameStart = true;
				out.println("ゲームを開始可能です<br>");
			}
		}
		if (session.getAttribute("gameStartRequested") != null) {
			gameStartRequested = (boolean) session.getAttribute("gameStartRequested");
		}
		if (readyToGameStart == true && gameStartRequested == false && request.getParameter("GameStartRequest") == null) {
	%>
	<form action="index.jsp#playing" method="post" accept-charset="utf-8">
		<input type="hidden" name="GameStartRequest" value="true">
		<input type="submit" value="ゲームを開始に一票">
	</form>
	<%
		}
		if (application.getAttribute("gameStartRequestCount" + loggedInNumber) != null) {
			gameStartRequestCount[loggedInNumber] = (byte) application.getAttribute("gameStartRequestCount" + loggedInNumber);
		}
		if (request.getParameter("GameStartRequest") != null && request.getParameter("GameStartRequest").equals("true")) {
			gameStartRequestCount[loggedInNumber]++;
			application.setAttribute("gameStartRequestCount" + loggedInNumber, gameStartRequestCount[loggedInNumber]);
			gameStartRequested = true;
		}
		if (loggedinPlayerMax.length > loggedInNumber && loggedInNumber >= 0 && readyToGameStart == true) {
			if (gameStartRequestCount[loggedInNumber] >= ((loggedinPlayerMax[loggedInNumber] / 2) + (loggedinPlayerMax[loggedInNumber] % 2))) {
				gameStarted = true;
				out.println("ゲームは開始されています<br>");
			} else {
				out.println("あと" + (((loggedinPlayerMax[loggedInNumber] / 2) + (loggedinPlayerMax[loggedInNumber] % 2)) - gameStartRequestCount[loggedInNumber]) + "票で開始します<br>");
				application.setAttribute("gameStartRequestCount" + loggedInNumber, gameStartRequestCount[loggedInNumber]);
			}
		} else {
			out.println("ゲームは開始されていません<br>");
		}
	%>
	<h2 id="playing">ゲームプレイ</h2>
	<form action="index.jsp#playing" method="post">
		<input type="hidden" name="dummy" value="">
		<input type="submit" value="リロード">
	</form>
	<%
		String[][] playingArray;
		String[][] afterArray;
		byte[][] votedArray;
		String[][] remainderCardArray;
		boolean[] roleDecided;
		boolean[] gameFinished;
		byte cardCountSum = 0;
		if (loggedIn == true) {
			roleDecided = new boolean[villageCreatedCount];
			remainderCardArray = new String[villageCreatedCount][2];
			if (application.getAttribute("roleDecided" + loggedInNumber) != null) {
				roleDecided[loggedInNumber] = (boolean) application.getAttribute("roleDecided" + loggedInNumber);
			}
			out.print("カード構成は<br>村" + villagerCardCountArray[loggedInNumber] + " ");
			out.print("狼" + werewolfCardCountArray[loggedInNumber] + " ");
			out.print("怪" + thiefCardCountArray[loggedInNumber] + " ");
			out.print("占" + augerCardCountArray[loggedInNumber] + " ");
			out.print("吊" + suiciderCardCountArray[loggedInNumber] + " ");
			out.println("狂" + lunaticCardCountArray[loggedInNumber] + "です<br>");
			cardCountSum = (byte) (villagerCardCountArray[loggedInNumber] + werewolfCardCountArray[loggedInNumber] + thiefCardCountArray[loggedInNumber] + augerCardCountArray[loggedInNumber] + suiciderCardCountArray[loggedInNumber] + lunaticCardCountArray[loggedInNumber]);
			if (gameStarted == true) {
				long[] startTime;
				startTime = new long[villageCreatedCount];
				boolean[] daytime;
				daytime = new boolean[villageCreatedCount];
				if (application.getAttribute("startTime" + loggedInNumber) == null) {
					startTime[loggedInNumber] = System.currentTimeMillis();
					application.setAttribute("startTime" + loggedInNumber, startTime[loggedInNumber]);
				} else {
					startTime[loggedInNumber] = (long) application.getAttribute("startTime" + loggedInNumber);
				}
				if (application.getAttribute("daytime" + loggedInNumber) != null) {
					daytime[loggedInNumber] = (boolean) application.getAttribute("daytime" + loggedInNumber);
				}
				playingArray = new String[villageCreatedCount][cardCountSum];
				afterArray = new String[villageCreatedCount][cardCountSum];
				votedArray = new byte[villageCreatedCount][cardCountSum];
				gameFinished = new boolean[villageCreatedCount];
				byte villagerCount = villagerCardCountArray[loggedInNumber];
				byte werewolfCount = werewolfCardCountArray[loggedInNumber];
				byte thiefCount = thiefCardCountArray[loggedInNumber];
				byte augerCount = augerCardCountArray[loggedInNumber];
				byte suiciderCount = suiciderCardCountArray[loggedInNumber];
				byte lunaticCount = lunaticCardCountArray[loggedInNumber];
				if (request.getParameter("gameFinish") != null) {
					gameFinished[loggedInNumber] = Boolean.parseBoolean(request.getParameter("gameFinish"));
					application.setAttribute("gameFinished" + loggedInNumber, gameFinished[loggedInNumber]);
				} else if (application.getAttribute("gameFinished" + loggedInNumber) != null) {
					gameFinished[loggedInNumber] = (boolean) application.getAttribute("gameFinished" + loggedInNumber);
				}
				while (roleDecided[loggedInNumber] == false) {
					byte randomNumber = (byte) (Math.random() * (cardCountSum));
					if (playingArray[loggedInNumber][randomNumber] == null) {
						if (villagerCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "村人";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							villagerCount--;
						} else if (werewolfCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "人狼";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							werewolfCount--;
						} else if (thiefCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "怪盗";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							thiefCount--;
						} else if (augerCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "占い師";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							augerCount--;
						} else if (suiciderCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "吊人";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							suiciderCount--;
						} else if (lunaticCount > 0) {
							playingArray[loggedInNumber][randomNumber] = "狂人";
							application.setAttribute("playingArray" + loggedInNumber + "_" + randomNumber, playingArray[loggedInNumber][randomNumber]);
							lunaticCount--;
						} else {
							roleDecided[loggedInNumber] = true;
							application.setAttribute("roleDecided" + loggedInNumber, roleDecided[loggedInNumber]);
							break;
						}
					} else if (villagerCount == 0 && werewolfCount == 0 && thiefCount == 0 && augerCount == 0 && suiciderCount == 0 && lunaticCount == 0) {
						roleDecided[loggedInNumber] = true;
						application.setAttribute("roleDecided" + loggedInNumber, roleDecided[loggedInNumber]);
						break;
					}
				}
				for (byte i = 0; i < cardCountSum; i++) {
					afterArray[loggedInNumber][i] = playingArray[loggedInNumber][i];
				}
				for (byte i = 0; i < afterArray[loggedInNumber].length; i++) {
					if (afterArray[loggedInNumber][i] == null) {
						afterArray[loggedInNumber][i] = "";
					}
				}
				for (byte i = 0; i < (cardCountSum); i++) {
					playingArray[loggedInNumber][i] = (String) application.getAttribute("playingArray" + loggedInNumber + "_" + i);
					if (loggedInVillagerNumber == i) {
						out.print("あなたは" + playingArray[loggedInNumber][i] + "です<br>");
					}
				}
				remainderCardArray[loggedInNumber][0] = playingArray[loggedInNumber][0];
				remainderCardArray[loggedInNumber][1] = playingArray[loggedInNumber][(cardCountSum - 1)];
				boolean finishedForecast = false;
				if (session.getAttribute("finishedForecast") != null) {
					finishedForecast = (boolean) session.getAttribute("finishedForecast");
				}
				boolean nothingForecast = false;
				boolean remainderCardForecast = false;
				byte stealNumber = 0;
				boolean finishedSteal = false;
				boolean nothingSteal = false;
				byte forecastNumber = 0;
				if (playingArray[loggedInNumber][loggedInVillagerNumber].equals("占い師")) {
					request.setCharacterEncoding("UTF-8");
					if (finishedForecast == false && request.getParameter("forecastList") == null && daytime[loggedInNumber] == false && gameFinished[loggedInNumber] == false) {
	%>
	<form action="./index.jsp#playing" method="post">
		<label for="forecastList">誰を占いますか? :</label>
		<select id="forecastList" name="forecastList" size="<%=loggedinPlayerMax[loggedInNumber] + 1%>">
			<option value="0">残りの2枚のカード</option>
			<%
				for (byte i = 1; i <= (loggedinPlayerMax[loggedInNumber]); i++) {
					if (i != loggedInVillagerNumber) {
			%>
			<option value="<%=i%>"><%=playerArray[loggedInNumber][i]%>
			</option>
			<%
					}
				}
			%>
			<option value="<%=loggedinPlayerMax[loggedInNumber] + 1%>">誰も占わない</option>
		</select>
		<input type="submit" value="占う">
	</form>
	<%
		}
		request.setCharacterEncoding("UTF-8");
		if (finishedForecast == false && request.getParameter("forecastList") != null && request.getParameter("forecastList") != "") {
			if (Byte.parseByte(request.getParameter("forecastList")) >= 0) {
				forecastNumber = Byte.parseByte(request.getParameter("forecastList"));
				session.setAttribute("forecastNumber", forecastNumber);
				finishedForecast = true;
				if (forecastNumber == 0) {
					remainderCardForecast = true;
				} else if (forecastNumber > loggedinPlayerMax[loggedInNumber]) {
					nothingForecast = true;
				}
			}
		}
		session.setAttribute("remainderCardForecast", remainderCardForecast);
		session.setAttribute("nothingForecast", nothingForecast);
		if (finishedForecast == true) {
			if (session.getAttribute("nothingForecast") != null) {
				nothingForecast = (boolean) session.getAttribute("nothingForecast");
			}
			if (session.getAttribute("remainderCardForecast") != null) {
				remainderCardForecast = (boolean) session.getAttribute("remainderCardForecast");
			}
			if (session.getAttribute("forecastNumber") != null) {
				forecastNumber = (byte) session.getAttribute("forecastNumber");
			}
			if (forecastNumber == 0) {
				remainderCardForecast = true;
			} else if (forecastNumber > loggedinPlayerMax[loggedInNumber]) {
				nothingForecast = true;
			}
			if (nothingForecast == true) {
				out.println("誰も占いませんでした<br>");
			} else if (remainderCardForecast == true) {
				out.println("残りの二枚は" + remainderCardArray[loggedInNumber][0] + "と" + remainderCardArray[loggedInNumber][1] + "でした<br>");
			} else if (forecastNumber > 0) {
				out.println(playerArray[loggedInNumber][forecastNumber] + "は" + playingArray[loggedInNumber][forecastNumber] + "でした<br>");
			}
		}
		session.setAttribute("finishedForecast", finishedForecast);
	} else if (playingArray[loggedInNumber][loggedInVillagerNumber].equals("怪盗")) {
		if (session.getAttribute("finishedSteal") != null) {
			finishedSteal = (boolean) session.getAttribute("finishedSteal");
		}
		if (finishedSteal == false && request.getParameter("stealList") == null && daytime[loggedInNumber] == false && gameFinished[loggedInNumber] == false && gameFinished[loggedInNumber] == false) {
	%>
	<form action="./index.jsp#playing" method="post">
		<label for="stealList">誰と交換しますか? :</label>
		<select id="stealList" name="stealList" size="<%=loggedinPlayerMax[loggedInNumber]%>">
			<%
				for (byte i = 1; i <= (loggedinPlayerMax[loggedInNumber]); i++) {
					if (i != loggedInVillagerNumber) {
			%>
			<option value="<%=i%>"><%=playerArray[loggedInNumber][i]%>
			</option>
			<%
					}
				}
			%>
			<option value="0">誰とも交換しない</option>
		</select>
		<input type="submit" value="交換">
	</form>
	<%
			}
			if (finishedSteal == false && request.getParameter("stealList") != null && request.getParameter("stealList") != "") {
				stealNumber = Byte.parseByte(request.getParameter("stealList"));
				session.setAttribute("stealNumber", stealNumber);
				finishedSteal = true;
				session.setAttribute("finishedSteal", finishedSteal);
				if (stealNumber <= 0) {
					nothingSteal = true;
				}
			}
			session.setAttribute("nothingSteal", nothingSteal);
			boolean changed = false;
			if (session.getAttribute("changed") != null) {
				changed = (boolean) session.getAttribute("changed");
			}
			if (finishedSteal == true) {
				if (session.getAttribute("stealNumber") != null) {
					stealNumber = (byte) session.getAttribute("stealNumber");
				}
				if (session.getAttribute("nothingSteal") != null) {
					nothingSteal = (boolean) session.getAttribute("nothingSteal");
				}
				if (nothingSteal == true) {
					out.println("誰とも交換しませんでした<br>");
					changed = true;
					session.setAttribute("changed", changed);
				} else if (stealNumber > 0 && stealNumber <= loggedinPlayerMax[loggedInNumber] && stealNumber != loggedInVillagerNumber) {
					afterArray[loggedInNumber][loggedInVillagerNumber] = playingArray[loggedInNumber][stealNumber];
					afterArray[loggedInNumber][stealNumber] = playingArray[loggedInNumber][loggedInVillagerNumber];
					application.setAttribute("afterArray" + loggedInNumber + "_" + stealNumber, afterArray[loggedInNumber][stealNumber]);
					application.setAttribute("afterArray" + loggedInNumber + "_" + loggedInVillagerNumber, afterArray[loggedInNumber][loggedInVillagerNumber]);
					changed = true;
					session.setAttribute("changed", changed);
					out.println(playerArray[loggedInNumber][stealNumber] + "と交換して" + afterArray[loggedInNumber][loggedInVillagerNumber] + "になりました<br>");
					out.println(playerArray[loggedInNumber][stealNumber] + "は" + afterArray[loggedInNumber][stealNumber] + "になりましたが本人は気付いていません<br>");
				}
			}
		} else if (playingArray[loggedInNumber][loggedInVillagerNumber].equals("人狼")) {
			boolean werewolfDetected = false;
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (i != loggedInVillagerNumber && playingArray[loggedInNumber][i].equals("人狼")) {
					out.println(playerArray[loggedInNumber][i] + "は人狼です<br>");
					werewolfDetected = true;
				}
			}
			if (werewolfDetected == false) {
				out.println("他に人狼は居ません<br>");
			}
		}
		long currentTime = System.currentTimeMillis();
		if (currentTime - startTime[loggedInNumber] >= 30000 && daytime[loggedInNumber] == false && request.getParameter("daytimeStart") == null && gameFinished[loggedInNumber] == false) {
	%>
	<form action="index.jsp#playing" method="post">
		<input type="hidden" name="daytimeStart" value="true">
		<input type="submit" value="夜を明ける">
	</form>
	<%
		} else if (daytime[loggedInNumber] == false && request.getParameter("daytimeStart") == null) {
			out.println("あと" + ((30000 - (currentTime - startTime[loggedInNumber])) / 1000) + "秒間お待ち下さい");
		} else if (request.getParameter("daytimeStart") != null) {
			daytime[loggedInNumber] = Boolean.parseBoolean(request.getParameter("daytimeStart"));
			application.setAttribute("daytime" + loggedInNumber, daytime[loggedInNumber]);
		}
		boolean voted = false;
		if (session.getAttribute("voted") != null) {
			voted = (boolean) session.getAttribute("voted");
		}
		for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
			if (application.getAttribute("votedArray" + loggedInNumber + "_" + i) != null) {
				votedArray[loggedInNumber][i] = (byte) application.getAttribute("votedArray" + loggedInNumber + "_" + i);
			}
		}
		if (request.getParameter("voteList") != null && voted == false) {
			votedArray[loggedInNumber][Integer.parseInt(request.getParameter("voteList"))]++;
			voted = true;
			application.setAttribute("votedArray" + loggedInNumber + "_" + request.getParameter("voteList"), votedArray[loggedInNumber][Integer.parseInt(request.getParameter("voteList"))]);
			session.setAttribute("voted", voted);
			session.setAttribute("voteList", request.getParameter("voteList"));
		}
		if (voted == true) {
			if (request.getParameter("voteList") != null) {
				out.println(playerArray[loggedInNumber][Integer.parseInt(request.getParameter("voteList"))] + "に投票しました<br>");
			} else if (session.getAttribute("voteList") != null) {
				out.println(playerArray[loggedInNumber][Byte.parseByte((String) session.getAttribute("voteList"))] + "に投票しました<br>");
			}
		}
		if ((daytime[loggedInNumber] == true || request.getParameter("daytimeStart") != null && gameFinished[loggedInNumber] == false) && voted == false) {
	%>
	<form action="./index.jsp#playing" method="post">
		<label for="voteList">誰に投票しますか? :</label>
		<select id="voteList" name="voteList" size="<%=loggedinPlayerMax[loggedInNumber] - 1%>">
			<%
				for (byte i = 1; i <= (loggedinPlayerMax[loggedInNumber]); i++) {
					if (i != loggedInVillagerNumber) {
			%>
			<option value="<%=i%>"><%=playerArray[loggedInNumber][i]%>
			</option>
			<%
					}
				}
			%>
		</select>
		<input type="submit" value="投票">
	</form>
	<%
		}
		byte voteSum = 0;
		if (voted == true) {
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				voteSum += votedArray[loggedInNumber][i];
			}
		}
		if (voteSum == loggedinPlayerMax[loggedInNumber] && gameFinished[loggedInNumber] == false) {
	%>
	全員が投票しました<br>
	<form action="index.jsp#playing" method="post">
		<input type="hidden" name="gameFinish" value="true">
		<input type="submit" value="結果を見る">
	</form>
	<%
		}
		if (gameFinished[loggedInNumber] == true) {
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (votedArray[loggedInNumber][i] > 0) {
					out.println(playerArray[loggedInNumber][i] + "に" + votedArray[loggedInNumber][i] + "票入りました<br>");
				}
			}
			byte obtainedMax = 0;
			byte obtainedMaxCount = 0;
			boolean werewolfWon = false;
			boolean suiciderWon = false;
			boolean villagerWon = false;
			boolean peaceful = false;
			for (byte i = 1; i < loggedinPlayerMax[loggedInNumber]; i++) {
				if (votedArray[loggedInNumber][i] > obtainedMax) {
					obtainedMax = votedArray[loggedInNumber][i];
				}
			}
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (votedArray[loggedInNumber][i] == obtainedMax) {
					obtainedMaxCount++;
				}
			}
			byte hangedFirstNumber = 0;
			byte hangedSecondNumber = 0;
			boolean afterWerewolfDetected = false;
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (application.getAttribute("afterArray" + loggedInNumber + "_" + i) != null) {
					afterArray[loggedInNumber][i] = (String) application.getAttribute("afterArray" + loggedInNumber + "_" + i);
				} else {
					afterArray[loggedInNumber][i] = playingArray[loggedInNumber][i];
				}
			}
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				if (afterArray[loggedInNumber][i].equals("人狼")) {
					afterWerewolfDetected = true;
					break;
				}
			}
			if (obtainedMaxCount >= 1 && obtainedMaxCount <= 2) {
				for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
					if (votedArray[loggedInNumber][i] == obtainedMax) {
						hangedFirstNumber = i;
						break;
					}
				}
				for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
					if (votedArray[loggedInNumber][i] == obtainedMax && i != hangedFirstNumber) {
						hangedSecondNumber = i;
						break;
					}
				}
				if (hangedFirstNumber != loggedInVillagerNumber) {
					out.println("投票の結果" + playerArray[loggedInNumber][hangedFirstNumber] + "が吊られました<br>");
					out.println(playerArray[loggedInNumber][hangedFirstNumber] + "は" + afterArray[loggedInNumber][hangedFirstNumber] + "でした<br>");
				} else {
					out.println("投票の結果あなたは吊られました<br>");
				}
				if (obtainedMaxCount == 2) {
					if (hangedSecondNumber != loggedInVillagerNumber) {
						out.println("投票の結果" + playerArray[loggedInNumber][hangedSecondNumber] + "が吊られました<br>");
						out.println(playerArray[loggedInNumber][hangedSecondNumber] + "は" + afterArray[loggedInNumber][hangedSecondNumber] + "でした<br>");
					} else {
						out.println("投票の結果あなたは吊られました<br>");
					}
				}
			} else {
				out.println("投票の結果誰も吊られませんでした<br>");
			}
			if (obtainedMaxCount == 1) {
				if (afterArray[loggedInNumber][hangedFirstNumber].equals("吊人")) {
					suiciderWon = true;
				} else if (!afterArray[loggedInNumber][hangedFirstNumber].equals("人狼")) {
					if (afterWerewolfDetected == true) {
						werewolfWon = true;
					} else {
						peaceful = true;
					}
				} else {
					villagerWon = true;
				}
			} else if (obtainedMaxCount == 2) {
				if (afterArray[loggedInNumber][hangedFirstNumber].equals("吊人") || afterArray[loggedInNumber][hangedSecondNumber].equals("吊人")) {
					suiciderWon = true;
				} else if (!afterArray[loggedInNumber][hangedFirstNumber].equals("人狼") && !afterArray[loggedInNumber][hangedSecondNumber].equals("人狼")) {
					if (afterWerewolfDetected == true) {
						werewolfWon = true;
					} else {
						peaceful = true;
					}
				} else {
					villagerWon = true;
				}
			} else {
				if (afterWerewolfDetected == true) {
					werewolfWon = true;
				} else {
					villagerWon = true;
					peaceful = true;
				}
			}
			if (afterWerewolfDetected == false && obtainedMaxCount >= 1 && obtainedMaxCount <= 2) {
				villagerWon = false;
			}
			if (peaceful == true) {
				out.println("この村は平和村でした<br>");
			}
			if (suiciderWon == true) {
				out.println("吊人の勝利です<br>");
				if (afterArray[loggedInNumber][loggedInVillagerNumber].equals("吊人")) {
					out.println("あなたは勝利しました<br>");
				} else {
					out.println("あなたは敗北しました<br>");
				}
			} else if (werewolfWon == true) {
				out.println("人狼陣営の勝利です<br>");
				if (afterArray[loggedInNumber][loggedInVillagerNumber].equals("人狼") || afterArray[loggedInNumber][loggedInVillagerNumber].equals("狂人")) {
					out.println("あなたは勝利しました<br>");
				} else {
					out.println("あなたは敗北しました<br>");
				}
			} else if (villagerWon == true) {
				out.println("村人陣営の勝利です<br>");
				if (!afterArray[loggedInNumber][loggedInVillagerNumber].equals("人狼") && !afterArray[loggedInNumber][loggedInVillagerNumber].equals("狂人") && !afterArray[loggedInNumber][loggedInVillagerNumber].equals("吊人")) {
					out.println("あなたは勝利しました<br>");
				} else {
					out.println("あなたは敗北しました<br>");
				}
			} else {
				out.println("あなたは敗北しました<br>");
			}
	%>
	<table>
		<tbody>
		<tr>
			<th>名前</th>
			<th>夜</th>
			<th>昼</th>
		</tr>
		<%
			for (byte i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
				out.print("<tr><td>" + playerArray[loggedInNumber][i] + "</td>");
				out.print("<td>" + playingArray[loggedInNumber][i] + "</td>");
				out.println("<td>" + afterArray[loggedInNumber][i] + "</td></tr>");
			}
		%>
		</tbody>
	</table>
	<form action="index.jsp" method="post">
		<input type="hidden" name="clean" value="true">
		<input type="submit" value="ゲームを終了する">
	</form>
	<%
				}
			}
		}
	%>
	<h2 id="trash">セッション破棄</h2>
	不具合発生時に押下してください
	<br>(データは破棄されます)<br>
	<form action="index.jsp" method="post">
		<input type="hidden" name="clean" value="true">
		<input type="submit" value="セッションを破棄する" onclick="return confirm('本当によろしいですか?');">
	</form>
</div>
<footer>
</footer>
</body>
<%
	session.setAttribute("playerCount", playerCount);
	session.setAttribute("villagerCardCount", villagerCardCount);
	session.setAttribute("werewolfCardCount", werewolfCardCount);
	session.setAttribute("thiefCardCount", thiefCardCount);
	session.setAttribute("augerCardCount", augerCardCount);
	session.setAttribute("suiciderCardCount", suiciderCardCount);
	session.setAttribute("lunaticCardCount", lunaticCardCount);
	session.setAttribute("villageCreated", villageCreated);
	session.setAttribute("villageDeleted", villageDeleted);
	session.setAttribute("loginPassword", loginPassword);
	session.setAttribute("newPassword", newPassword);
	session.setAttribute("gameStartRequested", gameStartRequested);
	if (loggedIn == true) {
		session.setAttribute("loggedInVillagerNumber", loggedInVillagerNumber);
	}
	session.setAttribute("loggedIn", loggedIn);
	session.setAttribute("loggedInNumber", loggedInNumber);
	session.setAttribute("screenName", screenName);
	session.setAttribute("yourName", yourName);
	boolean loggedInAfter = false;
	if (session.getAttribute("loggedIn") != null) {
		loggedInAfter = (boolean) session.getAttribute("loggedIn");
	}
	if (loggedInCount.length >= loggedInNumber && loggedInNumber >= 0) {
		application.setAttribute("loggedInCount" + loggedInNumber, loggedInCount[loggedInNumber]);
	}
	if (loggedinPlayerMax.length >= loggedInNumber && loggedInNumber > 0) {
		application.setAttribute("loggedinPlayerMax" + loggedInNumber, loggedinPlayerMax[loggedInNumber]);
	}
	if (firstVillagerCount > 2) {
		firstVillager = false;
	} else {
		firstVillager = true;
	}
	if (playerCountDecided < 3 || playerCountDecided > playerMax) {
		playerCountDecided = playerCount;
		if (loggedInNumber >= 0 && loggedinPlayerMax.length >= loggedInNumber && yourVillageId >= 0 && loggedIn == true && firstVillager == true) {
			application.setAttribute("loggedinPlayerMax" + loggedInNumber, loggedinPlayerMax[loggedInNumber]);
			session.setAttribute("firstVillagerCount", firstVillagerCount);
		}
	}
	if (playerMaxDecided.length >= loggedInNumber && loggedInNumber > 0) {
		application.setAttribute("playerMaxDecided" + loggedInNumber, playerMaxDecided[loggedInNumber]);
	}
	if (playerArray.length >= loggedInNumber && loggedInNumber >= 0 && loggedInVillagerNumber >= 1) {
		for (int i = 1; i <= loggedinPlayerMax[loggedInNumber]; i++) {
			if (playerArray[loggedInNumber][i] != null) {
				application.setAttribute("playerArray" + loggedInNumber + "_" + i, playerArray[loggedInNumber][i]);
			}
		}
	}
	if (loggedInNumber >= 0 && loggedInVillagerNumber >= 1 && playerArrayNullCountArray.length >= loggedInNumber && loggedIn == true) {
		application.setAttribute("playerArrayNullCountArray" + loggedInNumber, playerArrayNullCount);
	}
	if (session.getAttribute("yourVillageId") != null) {
		application.setAttribute("playerArrayPassword" + yourVillageId, newPassword);
	}
	if (playerArray.length > loggedInNumber && loggedInNumber >= 0 && playerArray[loggedInNumber][0] != null) {
		application.setAttribute("playerArrayPassword" + loggedInNumber, playerArray[loggedInNumber][0]);
	}
	if (loggedInNumber >= 0 && gameStartRequestCount.length > loggedInNumber) {
		application.setAttribute("gameStartRequestCount" + loggedInNumber, gameStartRequestCount[loggedInNumber]);
	}
	session.setMaxInactiveInterval(1800);
	if (request.getParameter("villageReCreated") != null) {
		session.invalidate();
%>
<script type="text/javascript" language="javascript">
    <!--
    window.location.replace('./');
    // -->
</script>
<%
	}
	if (request.getParameter("clean") != null || request.getParameter("villageLeft") != null) {
		session.invalidate();
%>
<script type="text/javascript" language="javascript">
    <!--
    window.location.replace('./');
    // -->
</script>
<%
	}
%>
</html>