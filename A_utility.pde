//--------------------------------------------------------------
// A_utility.mm
//--------------------------------------------------------------
//--------------------------------------------------------------
// MARK: ---------- XML----------
//--------------------------------------------------------------

void saveXML() {
	try {
		TableRow row = table.getRow(0);
		row.setString("IP", inputIP);
		row.setString("ID", inputID);
		saveTable(table, "ShuttRData.csv");
	} catch (NullPointerException e) {

	}
}

//--------------------------------------------------------------

void getXML() {
	try {
		table = loadTable("ShuttRData.csv", "header");
		TableRow row = table.getRow(0);
		userInputIP = row.getString("IP");
		userInputID = row.getString("ID");
		inputIP = userInputIP;
		inputID = userInputID;
	} catch (NullPointerException e) {
		table = new Table();
		table.addColumn("IP");
		table.addColumn("ID");
		TableRow newRow = table.addRow();
		newRow.setString("IP", "");
		newRow.setString("ID", "1");
		saveTable(table, "ShuttRData.csv");
		inputIP = "";
		inputID = "1";
	}
}

//--------------------------------------------------------------
// MARK: ---------- IP ADDRESS ----------
//--------------------------------------------------------------

String getIPAddress() {
	String ip = "";

	try {
		ip = InetAddress.getLocalHost().toString();
		ip = KetaiNet.getIP();
		hasWifi = true;
		return ip;
	} catch (UnknownHostException e) {
		e.printStackTrace();
		hasWifi = false;
		return "CHECK WIFI";
	}
}

//--------------------------------------------------------------
// MARK: ---------- ANDROID NOTCH HEIGHT ----------
//--------------------------------------------------------------

void getNotchHeight() {

	notchHeight = height / 40;

}
