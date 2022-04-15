using Clang;

namespace ValaBindGen {
	class Type : GLib.Object {
		internal bool equals (Type other) {
			return false;
		}
	}
	class BasicType : Type {
		internal string vala_string;
	}
	class PointerType : Type {
		internal Type pointee;
	}
	class ArrayType : Type {
		internal Type element_type;
		internal size_t len;
	}
	class FunctionPointerType : Type {
		internal Gee.List<Type> parameter_types;
		internal Gee.List<string> parameter_names;
		internal string name;
		internal Type type;
	}
	class TypeRef : Type {
		string name;
		bool is_enum;

		internal TypeRef (string str) {
			this.name = str;
			this.is_enum = str.has_prefix ("enum ");
		}
	}

	class TypeDef : Type {
		string name;

		internal TypeDef (string str) {
			this.name = str;
		}
	}

	class TypeBuilder {
		internal Type? build(CXType cxt) {
			switch (cxt.kind) {
				case TypeKind.TYPEDEF:
					return new TypeDef (cxt.spelling ().str.dup ());
				case TypeKind.ENUM:
					return new TypeRef (cxt.spelling ().str.dup ());
				case TypeKind.RECORD:
					return new TypeRef (cxt.spelling ().str.dup ());
				default:
					info ("%s %s", cxt.kind.spelling ().str, cxt.spelling ().str);
					break;
			}
			return null;
		}
	}
}
