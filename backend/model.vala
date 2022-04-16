namespace ValaBindGen {
	internal class Model {
		// Function pointer
		internal Gee.List<ModelDelegate> model_delegates { get; set; default = new Gee.ArrayList<ModelDelegate> (); }

		// Produced by e.g. function pointers without typedefs
		internal Gee.List<ModelDelegate> artificial_delegates { get; set; default = new Gee.ArrayList<ModelDelegate> (); }

		internal Gee.List<ModelEnum> enums { get; set; default = new Gee.ArrayList<ModelEnum> (); }

		internal Gee.List<ModelFunction> functions { get; set; default = new Gee.ArrayList<ModelFunction> (); }

		internal Gee.List<ModelStruct> structs { get; set; default = new Gee.ArrayList<ModelStruct> (); }

		internal void generate (Configuration config) {
			this.filter_unused_functions (config);
			this.filter_unused_data ();
			this.merge ();
			var sb = new StringBuilder ();
			sb.append ("// Autogenerated VAPI-File (").append (new GLib.DateTime.now_local ().format ("%c")).append (")\n");
			sb.append ("namespace ").append (config.@namespace).append (" {\n");
			foreach (var e in this.enums) {
				sb.append (e.generate ()).append ("\n");
			}
			sb.append ("}\n");
			info ("\n%s", sb.str);
		}

		void filter_unused_data () {
			foreach (var f in this.functions) {
				// Set "used" to true, for each parameter and so on
				foreach (var param in f.parameters) {

				}
			}
		}

		void filter_unused_functions (Configuration config) {
			for (var i = 0; i < this.functions.size; i++) {
				var fn = this.functions[i];
				var matches = false;
				foreach (var s in config.functions) {
					matches |= (fn.name == s || Regex.match_simple (s, fn.name));
				}
				if (!matches) {
					info ("Ignoring %s as it does not match", fn.name);
					this.functions.remove_at (i);
					continue;
				}
			}
		}

		void merge () {
		}
	}
}
