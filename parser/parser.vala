using Clang;

namespace ValaBindGen {
	class Parser {
		class CursorWrapper {
			internal Cursor cursor;

			internal CursorWrapper (Cursor c) {
				this.cursor = c;
			}
		}
		class TypeWrapper {
			internal CXType type;

			internal TypeWrapper (CXType t) {
				this.type = t;
			}
		}
		class Tmp : GLib.Object {
		}
		class TmpFunction : Tmp {
			internal string name;
			internal Gee.List<CursorWrapper> parameters { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
			internal CursorWrapper? return_type;
		}
		class TmpEnum : Tmp {
			internal string name;
			internal Gee.List<string> names { get; set; default = new Gee.ArrayList<string>(); }
		}
		class TmpStruct : Tmp {
			internal string name;
			internal Gee.List<CursorWrapper> members { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
		}
		class TmpTypedef : Tmp {
			internal string name;
			internal TypeWrapper underlying_type;
			internal Gee.List<CursorWrapper> nondirect_typedefs { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
		}
		Gee.List<CursorWrapper> cursors { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
		internal void parse (string file) {
			var idx = new Index ();
			var tu = idx.parse_translation_unit (file, new string[0], new UnsavedFile[0], 0);
			var c = tu.get_translation_unit_cursor ();
			c.visit_children ((c, p) => this.visit (c, p));
			var list = new Gee.ArrayList<Tmp>();
			foreach (var cw in this.cursors) {
				var cc = cw.cursor;
				var children = new Gee.ArrayList<CursorWrapper>();
				switch (cc.kind) {
				case CursorKind.TYPEDEF_DECL:
					// typedef <underlyingType> <NAME>
					var tt = new TmpTypedef ();
					tt.name = cc.spelling ().str.dup ();
					tt.underlying_type = new TypeWrapper (cc.underlying_type ());
					cc.visit_children ((a, b) => {
						children.add (new CursorWrapper (a));
						tt.nondirect_typedefs.add (new CursorWrapper (a));
						return ChildVisitResult.CONTINUE;
					});
					list.add (tt);
					break;
				case CursorKind.FUNCTION_DECL:
					var tf = new TmpFunction ();
					tf.name = cc.spelling ().str.dup ();
					cc.visit_children ((a, b) => {
						children.add (new CursorWrapper (a));
						if (a.kind == CursorKind.PARM_DECL) {
							tf.parameters.add (new CursorWrapper (a));
						} else if (a.kind == CursorKind.TYPE_REF) {
							tf.return_type = new CursorWrapper (a);
						}
						return ChildVisitResult.CONTINUE;
					});
					list.add (tf);
					break;
				case CursorKind.STRUCT_DECL:
					var tmp_struct = new TmpStruct ();
					tmp_struct.name = cc.spelling ().str.dup ();
					cc.visit_children ((a, b) => {
						children.add (new CursorWrapper (a));
						tmp_struct.members.add (new CursorWrapper (a));
						return ChildVisitResult.CONTINUE;
					});
					list.add (tmp_struct);
					break;
				case CursorKind.ENUM_DECL:
					var te = new TmpEnum ();
					te.name = cc.spelling ().str.dup ();
					cc.visit_children ((a, b) => {
						children.add (new CursorWrapper (a));
						if (a.kind == CursorKind.ENUM_CONSTANT_DECL) {
							te.names.add (a.spelling ().str.dup ());
						}
						return ChildVisitResult.CONTINUE;
					});
					list.add (te);
					break;
				default:
					error ("Unexpected kind: %s", cc.kind.spelling ().str);
				}
			}
			foreach (var t in list) {
				if (!(t is TmpFunction))
					continue;
				var tf = (TmpFunction) t;
				info ("============%s==========", tf.name);
				if (tf.return_type != null) {
					info ("%s returns a %s", tf.name, tf.return_type.cursor.spelling ().str);
					new TypeBuilder ().build (tf.return_type.cursor.cursor_type ());
				}
				uint cnter = 0;
				foreach (var param in tf.parameters) {
					var param_name = param.cursor.spelling ().str == "" ? "arg%u".printf (cnter) : param.cursor.spelling ().str.dup ();
					param.cursor.visit_children ((a, b) => {
						info ("%s %s", a.cursor_type ().spelling ().str, param_name);
						return ChildVisitResult.CONTINUE;
					});
					info ("//%s %s", param.cursor.cursor_type ().spelling ().str, param.cursor.spelling ().str);
					cnter++;
					info ("%u", cnter);
				}
			}
		}

		ChildVisitResult visit (Cursor c, Cursor parent) {
			if (c.kind == CursorKind.TYPEDEF_DECL
			    || c.kind == CursorKind.FUNCTION_DECL
			    || c.kind == CursorKind.ENUM_DECL
			    || c.kind == CursorKind.STRUCT_DECL) {
				this.cursors.add (new CursorWrapper (c));
			} else {
				info ("%s has %s as a parent", c.kind.spelling ().str, parent.kind.spelling ().str);
			}
			return ChildVisitResult.CONTINUE;
		}
	}
}
