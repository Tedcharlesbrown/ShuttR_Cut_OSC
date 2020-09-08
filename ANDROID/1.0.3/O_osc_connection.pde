//--------------------------------------------------------------
// O_osc_connection.mm
//--------------------------------------------------------------

void connect(boolean connectTCP, boolean connectEOS, boolean log) {
	if (log) {
		consoleLog(log_Connecting + inputIP);
		saveXML();
	}

	if (connectTCP) {
		Socket socket = new Socket();
		try {
			sockaddr = new InetSocketAddress(inputIP, 3032);
			socket.connect(sockaddr, 2000); //Time out = 2000
		} catch (SocketTimeoutException e) {
			println("socket connect fail", e);
		} catch (IOException e) {
			println("socket connect fail", e);
		} finally {
			try {
				socket.close();
			} catch (Exception e) {
				println("socket close fail", e);
			}
		}

		try {
			eosIn.tcpServer().dispose();
			eos.tcpClient().dispose();
		} catch (Exception e) {

		}


		if (socket.isConnected()) {
			connectRequest = true;
			pingSent = false;
		} else {
			isConnected = false;
			connectEOS = false;
			if (!console_log.get(0).equals(log_NoConnect) && !console_log.get(0).equals(log_lostConnect)) {
				consoleLog(log_NoConnect);
			}
		}
	}

	if (connectEOS) {
		try {
			eosIn.tcpServer().dispose();
			eos.tcpClient().dispose();
			eosIn = new OscP5(this, 3032, OscP5.TCP);
			eos = new OscP5(this, inputIP, 3032, OscP5.TCP);
		} catch (Exception e) {
			eosIn = new OscP5(this, 3032, OscP5.TCP);
			eos = new OscP5(this, inputIP, 3032, OscP5.TCP);
		}
	}
}

//--------------------------------------------------------------

void checkConnection() {

	if (receivedPingTime > sentPingTime || millis() > sentPingTime + 3000) { //IF GOT NEW PING OR TIME OUT

		if (sentPingTime > receivedPingTime && !hasOSC) { //IF CURRENT TIME IS > NEW PING TIME + BUFFER
			isConnected = false;
			if (console_log.get(0).indexOf(log_Connecting) != -1) { //IF LAST IS CONNECTING
				consoleLog(log_CheckOSC);
			} else if (console_log.get(0) == log_YesConnect) {  //IF LAST IS SUCCESFULL CONNECT
				consoleLog(log_lostConnect);
			}
			if (!isConnected) {
				connect(true, true, false);
			}
		}

		connectRequest = false; //RESET
		pingSent = false;       //RESET
	}
}

//--------------------------------------------------------------

void heartBeat() {
	checkTime = 30 * 1000; //30*1000

	if (!hasWifi || !isConnected) {
		checkTime = 3000;
	}

	deltaTime = millis() - sentPingTime;

	try {
		if ((deltaTime > checkTime || connectRequest) && !eos.ip().equals(null)) { //IF TIMED PING OR CONNECT REQUEST
			if (!pingSent) {
				hasOSC = false; //RESET OSC CONNECTION
				// ofSleepMillis(20); //not proud of this //20
				IPAddress = getIPAddress();
				sendPing();
				pingSent = true;
			}

			if (!hasWifi) {
				IPAddress = getIPAddress();
			}

			//        fineEncoder(0);

			checkConnection();

		}
	} catch (Exception e) {

	}
}

//--------------------------------------------------------------

