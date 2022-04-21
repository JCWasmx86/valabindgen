using Clang;

namespace ValaBindGen {
	class Type : GLib.Object {
		internal bool equals (Type other) {
			return false;
		}

		internal virtual string to_string () {
			return "<<UNDEFINED>>";
		}

		internal virtual string to_param_string () {
			return "<<EMPTY>>" + this.get_type ().name ();
		}
	}
	class BasicType : Type {
		internal string vala_string;

		internal BasicType (TypeKind tk) {
			switch (tk) {
			case TypeKind.VOID:
				this.vala_string = "void";
				break;
			case TypeKind.BOOL:
				this.vala_string = "bool";
				break;
			case TypeKind.CHAR_U:
			case TypeKind.UCHAR:
				this.vala_string = "uchar";
				break;
			case TypeKind.CHAR16:
			case TypeKind.CHAR32:
				this.vala_string = "unichar";
				break;
			case TypeKind.USHORT:
				this.vala_string = "ushort";
				break;
			case TypeKind.UINT:
				this.vala_string = "uint";
				break;
			case TypeKind.ULONG:
			case TypeKind.ULONG_LONG:
				this.vala_string = "ulong";
				break;
			case TypeKind.CHAR_S:
			case TypeKind.SCHAR:
				this.vala_string = "char";
				break;
			case TypeKind.WCHAR:
				this.vala_string = "unichar";
				break;
			case TypeKind.SHORT:
				this.vala_string = "short";
				break;
			case TypeKind.INT:
				this.vala_string = "int";
				break;
			case TypeKind.LONG:
			case TypeKind.LONG_LONG:
				this.vala_string = "long";
				break;
			case TypeKind.FLOAT:
				this.vala_string = "float";
				break;
			case TypeKind.DOUBLE:
			case TypeKind.LONG_DOUBLE:
				this.vala_string = "double";
				break;
			default:
				warning ("Unhandled: %s", tk.spelling ().str);
				assert_not_reached ();
			}
		}

		internal override string to_string () {
			return this.vala_string;
		}

		internal override string to_param_string () {
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

		internal override string to_param_string () {
			return this.pointee.to_param_string () + "*";
		}
	}
	class ArrayType : Type {
		internal Type element_type;
		internal size_t len;

		internal ArrayType (long len, Type t) {
			this.len = len;
			this.element_type = t;
		}

		internal override string to_string () {
			return this.element_type.to_string () + "*/*[%u]*/".printf ((uint)this.len);
		}

		internal override string to_param_string () {
			return this.element_type.to_param_string () + "*/*[%u]*/".printf ((uint)this.len);
		}
	}
	class FunctionPointerType : Type {
		internal Gee.List<Type> parameter_types { get; set; default = new Gee.ArrayList<Type>(); }
		internal Gee.List<string> parameter_names { get; set; default = new Gee.ArrayList<string>(); }
		internal string name;
		internal Type return_type;

		internal FunctionPointerType (CXType c) {
			this.name = "<<UNKNOWN>>";
			this.return_type = new TypeBuilder ().build (c.result ());
			var len = c.num_arg_types ();
			for (var i = 0; i < len; i++) {
				var arg = c.arg_type (i);
				this.parameter_types.add (new TypeBuilder ().build (arg));
				this.parameter_names.add ("arg%u".printf (i));
			}
		}
	}
	class ElaboratedType : Type {
		internal string representation;
		internal ElaboratedType (string repr) {
			this.representation = repr;
		}

		internal override string to_string () {
			return "Elaborated(%s)".printf (this.representation);
		}

		internal override string to_param_string () {
			return this.representation;
		}
	}
	class TypeRef : Type {
		internal string name;
		internal bool is_enum;

		internal TypeRef (string str) {
			this.name = str;
			this.is_enum = str.has_prefix ("enum ");
		}

		internal override string to_string () {
			return "TypeRef(%s)".printf (this.name);
		}

		internal override string to_param_string () {
			return this.name;
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

		internal override string to_param_string () {
			return this.name;
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
			case TypeKind.ELABORATED:
				return new ElaboratedType (cxt.spelling ().str.dup ());
			case TypeKind.FUNCTION_NO_PROTO:
			case TypeKind.FUNCTION_PROTO:
				return new FunctionPointerType (cxt);
			case TypeKind.CONSTANT_ARRAY:
				return new ArrayType (cxt.array_size (), this.build (cxt.array_type ()));
			default:
				info ("%s %s", cxt.kind.spelling ().str, cxt.spelling ().str);
				break;
			}
			return null;
		}
	}
}
