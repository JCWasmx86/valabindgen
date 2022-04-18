namespace ValaBindGen {
	public class Configuration : GLib.Object {

		public string? @namespace { get; set; default = "UnspecifiedNamespace"; }
		public bool verbose { get; set; }
		public bool reproducable { get; set; }
		public bool smart { get; set; default = true; }
		public string[] header_files { get; set; default = new string[0]; }
		public string[] include_paths { get; set; default = new string[0]; }
		public string[] compiler_options { get; set; default = new string[0]; }
		public string[] functions { get; set; default = new string[0]; }

		internal static Configuration load (string file) throws Error {
			var parser = new Json.Parser ();
			parser.load_from_file (file);
			return Json.gobject_deserialize (typeof (Configuration), parser.get_root ()) as Configuration;
		}
	}
}
