function one(arg1) {
	console.log(
		"one.length: " + one.length,
		"arguments.length: " + arguments.length
	);
	console.log("arg1:" + arg1);
	console.log("arguments[0]:" + arguments[0]);
	console.log("arguments[1]:" + arguments[1]);
	
}

one("val1", "val2");
