using Clang;

namespace ValaBindGen {
	class Type : GLib.Object {
		internal bool equals (Type other) {
			return false;
		}

		internal virtual string to_string () {
			return "<<UNDEFINED>>";
		}
	}
	class BasicType : Type {
		internal string vala_string;

		internal BasicType (TypeKind tk) {
			this.vala_string = tk.spelling().str.dup();
		}

		internal override string to_string () {
			return this.vala_string;
		}
	}
	class PointerType : Type {
		internal Type pointee;

		internal PointerType (Type t) {
			this.pointee = t;
		}

		internal override string to_string () {
			return "Pointer(%s)".printf (this.pointee.to_string ());
		}
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

		internal override string to_string () {
			return "TypeRef(%s)".printf (this.name);
		}
	}

	class TypeDef : Type {
		string name;

		internal TypeDef (string str) {
			this.name = str;
		}

		internal override string to_string () {
			return "TypeDef(%s)".printf (this.name);
		}
	}

	class TypeBuilder {
		internal Type? build (CXType cxt) {
			switch (cxt.kind) {
			case TypeKind.VOID:
			case TypeKind.BOOL:
			case TypeKind.CHAR_U:
			case TypeKind.UCHAR:
			case TypeKind.CHAR16:
			case TypeKind.CHAR32:
			case TypeKind.USHORT:
			case TypeKind.UINT:
			case TypeKind.ULONG:
			case TypeKind.ULONG_LONG:
			case TypeKind.CHAR_S:
			case TypeKind.SCHAR:
			case TypeKind.WCHAR:
			case TypeKind.SHORT:
			case TypeKind.INT:
			case TypeKind.LONG:
			case TypeKind.LONG_LONG:
			case TypeKind.FLOAT:
			case TypeKind.DOUBLE:
			case TypeKind.LONG_DOUBLE:
				return new BasicType (cxt.kind);
			case TypeKind.TYPEDEF:
				return new TypeDef (cxt.spelling ().str.dup ());
			case TypeKind.ENUM:
				return new TypeRef (cxt.spelling ().str.dup ());
			case TypeKind.RECORD:
				return new TypeRef (cxt.spelling ().str.dup ());
			case TypeKind.POINTER:
				return new PointerType (this.build (cxt.pointee ()));
			default:
				info ("%s %s", cxt.kind.spelling ().str, cxt.spelling ().str);
				break;
			}
			return null;
		}
	}
}
