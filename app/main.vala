namespace ValaBindGen {
	int main (string[] argv) {
		if (argv.length == 1) {
			warning ("No argument given, usage: %s <config.json>", argv[0]);
			return -1;
		}
		if (argv[1] == "--help") {
			stdout.printf ("Usage: %s <config.json>\n", argv[0]);
			return 0;
		} else if (argv[1] == "--version") {
			stdout.printf ("0.0.1.alpha\n");
			return 0;
		}
		try {
			var config = Configuration.load (argv[1]);
			var file = SourceFileGenerator.generate (config);
			var p = new Parser ();
			var m = p.parse (file);
			m.generate (config);
			info ("%s", file);
		} catch (Error e) {
			critical ("%s", e.message);
			return 1;
		}
		var te = 0;
		return te;
	}
}
