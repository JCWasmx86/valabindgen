namespace ValaBindGen {
	class SourceFileGenerator {
		internal static string generate (Configuration config) throws Error {
			var sb = new StringBuilder ();
			foreach (var header in config.header_files) {
				sb.append ("#include<").append (header).append (">\n");
			}
			FileIOStream fio;
			var file = File.new_tmp("vbg-XXXXXX.c", out fio);
			size_t written;
			fio.output_stream.write_all(sb.str.data, out written);
			fio.output_stream.flush ();
			var args = new string[]{"gcc", "-E", "-P", file.get_path ()};
			foreach (var path in config.include_paths) {
				args += "-I";
				args += path;
			}
			foreach (var option in config.compiler_options) {
				args += option;
			}
			var sout = "";
			var serr = "";
			var status = 0;
			Process.spawn_sync(".", args, Environ.get (), SpawnFlags.SEARCH_PATH, null, out sout, out serr, out status);
			if (status != 0) {
				throw new GLib.IOError.FAILED("Failed to create preprocessed file:\nStderr:\n%s".printf (serr));
			}
			file.delete();
			var output_file = File.new_tmp("vbg-output-XXXXXX.c", out fio);
			fio.output_stream.write_all(sout.data, out written);
			fio.output_stream.flush ();
			return output_file.get_path ();
		}
	}
}
