namespace ValaBindGen {
	internal class ModelFunction {
		internal string name;
		internal Gee.List<ModelParameter> parameters { get; set; default = new Gee.ArrayList<ModelParameter> (); }
		// internal Type return_type;
	}


	class ModelParameter {
		internal string name;

		internal ModelParameter (string name) {
			this.name = name;
		}
	}
}
