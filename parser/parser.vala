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
			internal Type? return_type;

			internal ModelFunction to_model () {
				var ret = new ModelFunction ();
				ret.name = this.name;
				var idx = 0;
				foreach (var p in this.parameters) {
					var arg_name = "arg%u".printf (idx);
					idx++;
					var type = new TypeBuilder ().build (p.cursor.cursor_type ());
					if (p.cursor.spelling ().str != "")
						arg_name = p.cursor.spelling ().str.dup ();
					p.cursor.visit_children ((c, p_) => {
						return ChildVisitResult.CONTINUE;
					});
					ret.parameters.add (new ModelParameter (arg_name, type));
				}
				ret.return_type = this.return_type;
				return ret;
			}
		}
		class TmpEnum : Tmp {
			internal string name;
			internal bool from_typedef;
			internal Gee.List<string> names { get; set; default = new Gee.ArrayList<string>(); }

			internal ModelEnum to_model () {
				var me = new ModelEnum ();
				me.name = this.name;
				me.from_typedef = this.from_typedef;
				me.names.add_all (this.names);
				return me;
			}
		}
		class TmpStruct : Tmp {
			internal string name;
			internal bool from_typedef;
			internal Gee.List<CursorWrapper> members { get; set; default = new Gee.ArrayList<CursorWrapper>(); }

			internal ModelStruct to_model () {
				var ms = new ModelStruct ();
				ms.name = this.name;
				ms.from_typedef = this.from_typedef;
				foreach (var cw in this.members) {
					var c = cw.cursor;
					info("Member: %s is a %s", c.spelling ().str, c.cursor_type ().spelling ().str);
				}
				return ms;
			}
		}
		class TmpTypedef : Tmp {
			internal string name;
			internal TypeWrapper underlying_type;
			internal Gee.List<CursorWrapper> nondirect_typedefs { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
		}
		Gee.List<CursorWrapper> cursors { get; set; default = new Gee.ArrayList<CursorWrapper>(); }
		internal Model parse (string file) {
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
							tf.return_type = new TypeBuilder ().build (a.cursor_type ());
						}
						return ChildVisitResult.CONTINUE;
					});
					if (tf.return_type == null)
						tf.return_type = new TypeBuilder ().build (cc.cursor_type ().result ());
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
			foreach (var cw in this.cursors) {
				if (cw.cursor.kind == CursorKind.TYPEDEF_DECL) {
					var is_enum = false;
					var is_struct = false;
					var te = new TmpEnum ();
					te.name = cw.cursor.spelling ().str.dup ();
					te.from_typedef = true;
					var ts = new TmpStruct ();
					ts.name = cw.cursor.spelling ().str.dup ();
					ts.from_typedef = true;
					cw.cursor.visit_children ((ccc, unused2) => {
						ccc.visit_children ((c, p) => {
							switch (c.kind) {
								case CursorKind.ENUM_CONSTANT_DECL:
									te.names.add (c.spelling ().str.dup ());
									is_enum = true;
									break;
								case CursorKind.FIELD_DECL:
									ts.members.add (new CursorWrapper (c));
									is_struct = true;
									break;
								default:
									info ("Unknown thing: %s (%s)", c.spelling ().str, c.kind.spelling ().str);
									break;
							}
							return ChildVisitResult.CONTINUE;
						});
						return ChildVisitResult.CONTINUE;
					});
					if (is_enum)
						list.add (te);
					if (is_struct)
						list.add (ts);
				}
			}
			var m = new Model ();
			foreach (var l in list) {
				if (l is TmpEnum) {
					var te = (TmpEnum) l;
					if (te.name != "")
						m.enums.add (te.to_model ());
				} else if (l is TmpFunction) {
					var tf = (TmpFunction) l;
					m.functions.add (tf.to_model ());
				} else if (l is TmpStruct) {
					var ts = (TmpStruct) l;
					ts.to_model ();
				} else if (l is TmpTypedef) {
					var tt = (TmpTypedef)l;
					m.typedefs.set(tt.name, new TypeBuilder ().build (tt.underlying_type.type));
				}
			}
			return m;
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
