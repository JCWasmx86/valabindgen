namespace ValaBindGen {
	internal class ModelFunction {
		internal string name;
		internal Gee.List<ModelParameter> parameters { get; set; default = new Gee.ArrayList<ModelParameter> (); }
		internal Type return_type;

		internal string generate (uint prefix_len = 0) {
			var sb = new StringBuilder ();
			sb.append ("\t[CCode (cname = \"").append (this.name).append ("\")]\n");
			sb.append ("\tpublic static ")
			 .append ("XXX").append (" ").append (Utils.snake_case (this.name.substring (prefix_len))).append (" (");
			for (var i = 0; i < this.parameters.size; i++)
				sb.append (this.parameters[i].type.to_param_string ()).append (" ").append (this.parameters[i].name).append (i != this.parameters.size - 1 ? ", " : ");\n");
			if (this.parameters.size == 0)
				sb.append (");\n");
			return sb.str;
		}
	}


	class ModelParameter {
		internal string name;
		internal Type type;

		internal ModelParameter (string name, ValaBindGen.Type t) {
			this.name = name;
			this.type = t;
		}
	}
}
