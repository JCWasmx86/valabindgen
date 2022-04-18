namespace ValaBindGen {
	class Utils {
		// Copied from https://www.geeksforgeeks.org/longest-common-prefix-using-binary-search/
		internal static string common_prefix (Gee.List<string> strs) {
			if (strs.size <= 1)
				return "";
			var min_len = int.MAX;
			foreach (var s in strs) {
				min_len = int.min (min_len, s.length);
			}
			var prefix = "";
			var low = 0;
			var high = min_len;
			while (low <= high) {
				var mid = low + (high - low) / 2;

				if (all_have_prefix (strs, strs[0], low, mid)) {
					if (low + (mid - low + 1) > strs[0].length)
						return prefix;
					prefix += strs[0].substring (low, mid - low + 1);
					low = mid + 1;
				} else {
					high = mid - 1;
				}
			}
			// To avoid empty enum names
			return prefix.length < min_len ? prefix : "";
		}

		static bool all_have_prefix (Gee.List<string> strs, string first, int low, int mid) {
			foreach (var s in strs) {
				for (var i = low; i <= mid; i++) {
					if (s[i] != first[i])
						return false;
				}
			}
			return true;
		}

		internal static string shouting_case (string s) {
			if (s.contains ("_"))
				return s.up ();
			var sb = new StringBuilder ();
			for (var i = 0; i < s.length; i++) {
				sb.append_c (s[i]);
				if (i < s.length - 1 && s[i + 1].isupper () && ! s[i].isupper ())
					sb.append_c ('_');
			}
			return sb.str.up ();
		}

		internal static string snake_case (string s) {
			var sb = new StringBuilder ();
			for (var i = 0; i < s.length; i++) {
				sb.append_c (s[i]);
				if (i < s.length - 1 && s[i + 1].isupper () && ! s[i].isupper ())
					sb.append_c ('_');
			}
			return sb.str.down ();
		}
	}
}
