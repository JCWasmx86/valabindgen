namespace ValaBindGen {
	internal class Model {
		// Function pointer
		internal Gee.List<ModelDelegate> model_delegates { get; set; default = new Gee.ArrayList<ModelDelegate> (); }

		// Produced by e.g. function pointers without typedefs
		internal Gee.List<ModelDelegate> artificial_delegates { get; set; default = new Gee.ArrayList<ModelDelegate> (); }

		internal Gee.List<ModelEnum> enums { get; set; default = new Gee.ArrayList<ModelEnum> (); }

		internal Gee.List<ModelFunction> functions { get; set; default = new Gee.ArrayList<ModelFunction> (); }

		internal Gee.List<ModelStruct> structs { get; set; default = new Gee.ArrayList<ModelStruct> (); }

		internal Gee.Map<string, Type> typedefs { get; set; default = new Gee.HashMap<string, Type> (); }

		internal void generate (Configuration config) {
			this.filter_unused_functions (config);
			this.filter_unused_data ();
			this.merge ();
			var sb = new StringBuilder ();
			var attrib = "[CCode (cheader_filename = \"%s\")]\n";
			var s = "";
			for (var i = 0; i < config.header_files.length - 1; i++)
				s += config.header_files[i] + ",";
			s += config.header_files[config.header_files.length - 1];

			sb.append ("// Autogenerated VAPI-File (").append (config.reproducable ? "<REPROD>" : new GLib.DateTime.now_local ().format ("%c")).append (")\n");
			sb.append (attrib.printf (s)).append ("\n");
			sb.append ("namespace ").append (config.@namespace).append (" {\n");
			var f_names = new Gee.ArrayList<string>();
			foreach (var f in this.functions) {
				f_names.add (f.name);
			}
			foreach (var e in this.enums) {
				sb.append (e.generate ()).append ("\n");
			}
			var prefix = Utils.common_prefix (f_names);
			foreach (var f in this.functions) {
				sb.append (f.generate (this, prefix.length)).append ("\n");
			}
			foreach (var f in this.typedefs.entries) {
				var name = f.key;
				var t = f.value;
				if (t is BasicType) {
					this.emit_basic_type (sb, name, (BasicType) t);
				} else if (t is TypeRef) {
					var t1 = t;
					while (true) {
						t1 = this.typedefs[((TypeRef) t1).name];
						if (t1 == null) {
							break;
						}
						if (t1 is BasicType) {
							this.emit_basic_type (sb, name, (BasicType) t);
						}
					}
				}
			}
			sb.append ("}\n");
			stderr.printf ("%s\n", sb.str);
		}

		void emit_basic_type (StringBuilder sb, string name, BasicType t) {
			if (t.vala_string == "void")
				return;
			sb.append ("\t[SimpleType]\n").append ("\t[CCode (cname = \"").append(name).append("\")]\n");
			sb.append ("\tpublic struct ").append (name).append (" : ").append (t.vala_string).append (" {\n\t}\n");
		}

		void filter_unused_data () {
			// Only emit used types
		}

		void filter_unused_functions (Configuration config) {
			var new_list = new Gee.ArrayList<ModelFunction>();
			for (var i = 0; i < this.functions.size; i++) {
				var fn = this.functions[i];
				var matches = false;
				foreach (var s in config.functions) {
					matches |= (fn.name == s || Regex.match_simple (s, fn.name));
				}
				if (!matches) {
					info ("Ignoring %s as it does not match", fn.name);
					continue;
				}
				new_list.add (fn);
			}
			this.functions = new_list;
		}

		void merge () {
		}

		internal string derive_parameter (Type t) {
			if (t is BasicType) {
				var b = (BasicType) t;
				if (b.vala_string == "void")
					return "void";
				return b.vala_string;
			} else if (t is TypeRef) {
				var t1 = t;
				while (true) {
					t1 = this.typedefs[((TypeRef) t1).name];
					if (t1 == null) {
						break;
					}
					if (t1 is BasicType) {
						if (((BasicType)t1).vala_string == "void")
							return "void";
						return t.to_string ();
					}
				}
			} else if (t is PointerType) {
				var pp = t.pointee;
				if (pp is BasicType && ((BasicType)pp).vala_string == "void")
					return "void*";
				else if (pp is TypeRef && this.typedefs[((TypeRef)pp).to_param_string ()].to_string () == "void")
					return "void*";
				else if (pp is TypeDef) {
					var tt = this.typedefs[((TypeDef)pp).to_param_string ().replace ("const ", "")];
					if (tt != null && tt.to_string () == "void")
						return "void*";
				} else if (pp is PointerType) {
					var ppp = ((PointerType)pp).pointee;
					if (ppp is BasicType && ((BasicType)ppp).vala_string == "void")
					return "void**";
					else if (ppp is TypeRef && this.typedefs[((TypeRef)ppp).to_param_string ()].to_string () == "void")
						return "void**";
					else if (ppp is TypeDef) {
						var tt = this.typedefs[((TypeDef)ppp).to_param_string ().replace ("const ", "")];
						if (tt != null && tt.to_string () == "void")
							return "void**";
					}
				}
			}
			return t.to_param_string ();
		}
	}
}
