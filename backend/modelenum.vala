namespace ValaBindGen {
	internal class ModelEnum {
		internal string name;
		internal bool from_typedef;
		internal Gee.List<string> names { get; set; default = new Gee.ArrayList<string> (); }

		internal string generate (uint common_prefix_len = 0) {
			var vala_name = this.name.substring (common_prefix_len);
			var prefix = Utils.common_prefix (this.names);
			var sb = new StringBuilder ();
			sb.append ("\t[CCode (cname = \"").append (!this.from_typedef ? "enum " : "").append (this.name).append ("\")]\n");
			sb.append ("\tpublic enum ").append (vala_name).append (" {\n");
			foreach (var e in this.names) {
				var v_name = Utils.shouting_case (e.substring (prefix.length));
				sb.append ("\t\t[CCode (cname = \"").append (e).append ("\")]\n");
				sb.append ("\t\t").append (v_name).append (this.names[this.names.size - 1] == e ? ";" : ",").append ("\n");
			}
			sb.append ("\t}\n");
			return sb.str;
		}
	}
}
