[CCode (cheader_filename = "clang-c/Index.h")]
namespace Clang {
	[Compact]
	[CCode (cname = "CXCursor", free_function = "clang_disposeIndex", has_type_id = false)]
	public class Index {
		[CCode (cname = "clang_createIndex")]
		public Index (bool exclude_declarations_from_pch = false, bool display_diagnostics = true);
		[CCode (cname = "clang_parseTranslationUnit")]
		public TranslationUnit parse_translation_unit (string source_filename, string[] args, UnsavedFile[] ? files, uint options);
	}

	[SimpleType]
	[CCode (cname = "struct CXUnsavedFile", has_type_id = false)]
	public struct UnsavedFile {
		[CCode (cname = "Filename")]
		char* file;
		[CCode (cname = "Contents")]
		char* contents;
		[CCode (cname = "Length")]
		ulong length;
	}

	[Compact]
	[CCode (cname = "CXTranslationUnit", free_function = "clang_disposeTranslationUnit", has_type_id = false)]
	public class TranslationUnit {
		[CCode (cname = "clang_getTranslationUnitCursor")]
		public Cursor get_translation_unit_cursor ();
	}

	[CCode (cname = "enum CXChildVisitResult")]
	public enum ChildVisitResult {
		[CCode (cname = "CXChildVisit_Break")]
		BREAK,
		[CCode (cname = "CXChildVisit_Continue")]
		CONTINUE,
		[CCode (cname = "CXChildVisit_Recurse")]
		RECURSE
	}
	public delegate ChildVisitResult CursorVisitor (Cursor self, Cursor parent);

	[SimpleType]
	[CCode (cname = "CXCursor")]
	public struct Cursor {
		public CursorKind kind;
		[CCode (cname = "clang_visitChildren")]
		public bool visit_children (CursorVisitor visitor);

		[CCode (cname = "clang_getCursorSpelling")]
		public String spelling ();

		[CCode (cname = "clang_getCanonicalCursor")]
		public Cursor canonical ();

		[CCode (cname = "clang_equalCursors")]
		public bool equals (Cursor other);

		[CCode (cname = "clang_getTypedefDeclUnderlyingType")]
		public CXType underlying_type () requires (this.kind == CursorKind.TYPEDEF_DECL);

		[CCode (cname = "clang_getCursorType")]
		public CXType cursor_type ();
	}

	[SimpleType]
	[CCode (cname = "CXType")]
	public struct CXType {
		public TypeKind kind;
		[CCode (cname = "clang_getTypeSpelling")]
		public String spelling ();

		[CCode (cname = "clang_getResultType")]
		public CXType result ();

		[CCode (cname = "clang_getPointeeType")]
		public CXType pointee ();

		[CCode (cname = "clang_getNumArgTypes")]
		public uint num_arg_types ();

		[CCode (cname = "clang_getArgType")]
		public CXType arg_type (uint i);

		[CCode (cname = "clang_getArraySize")]
		public long array_size ();

		[CCode (cname = "clang_getArrayElementType")]
		public CXType array_type ();
	}

	[CCode (cname = "enum CXTypeKind")]
	public enum TypeKind {
		[CCode (cname = "CXType_Invalid")]
		INVALID,
		[CCode (cname = "CXType_Unexposed")]
		UNEXPOSED,
		[CCode (cname = "CXType_Void")]
		VOID,
		[CCode (cname = "CXType_Bool")]
		BOOL,
		[CCode (cname = "CXType_Char_U")]
		CHAR_U,
		[CCode (cname = "CXType_UChar")]
		UCHAR,
		[CCode (cname = "CXType_Char16")]
		CHAR16,
		[CCode (cname = "CXType_Char32")]
		CHAR32,
		[CCode (cname = "CXType_UShort")]
		USHORT,
		[CCode (cname = "CXType_UInt")]
		UINT,
		[CCode (cname = "CXType_ULong")]
		ULONG,
		[CCode (cname = "CXType_ULongLong")]
		ULONG_LONG,
		[CCode (cname = "CXType_UInt128")]
		UINT128,
		[CCode (cname = "CXType_Char_S")]
		CHAR_S,
		[CCode (cname = "CXType_SChar")]
		SCHAR,
		[CCode (cname = "CXType_WChar")]
		WCHAR,
		[CCode (cname = "CXType_Short")]
		SHORT,
		[CCode (cname = "CXType_Int")]
		INT,
		[CCode (cname = "CXType_Long")]
		LONG,
		[CCode (cname = "CXType_LongLong")]
		LONG_LONG,
		[CCode (cname = "CXType_Int128")]
		INT128,
		[CCode (cname = "CXType_Float")]
		FLOAT,
		[CCode (cname = "CXType_Double")]
		DOUBLE,
		[CCode (cname = "CXType_LongDouble")]
		LONG_DOUBLE,
		[CCode (cname = "CXType_NullPtr")]
		NULL_PTR,
		[CCode (cname = "CXType_Overload")]
		OVERLOAD,
		[CCode (cname = "CXType_Dependent")]
		DEPENDENT,
		[CCode (cname = "CXType_ObjCId")]
		OBJ_CID,
		[CCode (cname = "CXType_ObjCClass")]
		OBJ_CCLASS,
		[CCode (cname = "CXType_ObjCSel")]
		OBJ_CSEL,
		[CCode (cname = "CXType_Float128")]
		FLOAT128,
		[CCode (cname = "CXType_Half")]
		HALF,
		[CCode (cname = "CXType_Float16")]
		FLOAT16,
		[CCode (cname = "CXType_ShortAccum")]
		SHORT_ACCUM,
		[CCode (cname = "CXType_Accum")]
		ACCUM,
		[CCode (cname = "CXType_LongAccum")]
		LONG_ACCUM,
		[CCode (cname = "CXType_UShortAccum")]
		USHORT_ACCUM,
		[CCode (cname = "CXType_UAccum")]
		UACCUM,
		[CCode (cname = "CXType_ULongAccum")]
		ULONG_ACCUM,
		[CCode (cname = "CXType_BFloat16")]
		BFLOAT16,
		[CCode (cname = "CXType_Ibm128")]
		IBM128,
		[CCode (cname = "CXType_FirstBuiltin")]
		FIRST_BUILTIN,
		[CCode (cname = "CXType_LastBuiltin")]
		LAST_BUILTIN,
		[CCode (cname = "CXType_Complex")]
		COMPLEX,
		[CCode (cname = "CXType_Pointer")]
		POINTER,
		[CCode (cname = "CXType_BlockPointer")]
		BLOCK_POINTER,
		[CCode (cname = "CXType_LValueReference")]
		LVALUE_REFERENCE,
		[CCode (cname = "CXType_RValueReference")]
		RVALUE_REFERENCE,
		[CCode (cname = "CXType_Record")]
		RECORD,
		[CCode (cname = "CXType_Enum")]
		ENUM,
		[CCode (cname = "CXType_Typedef")]
		TYPEDEF,
		[CCode (cname = "CXType_ObjCInterface")]
		OBJ_CINTERFACE,
		[CCode (cname = "CXType_ObjCObjectPointer")]
		OBJ_COBJECT_POINTER,
		[CCode (cname = "CXType_FunctionNoProto")]
		FUNCTION_NO_PROTO,
		[CCode (cname = "CXType_FunctionProto")]
		FUNCTION_PROTO,
		[CCode (cname = "CXType_ConstantArray")]
		CONSTANT_ARRAY,
		[CCode (cname = "CXType_Vector")]
		VECTOR,
		[CCode (cname = "CXType_IncompleteArray")]
		INCOMPLETE_ARRAY,
		[CCode (cname = "CXType_VariableArray")]
		VARIABLE_ARRAY,
		[CCode (cname = "CXType_DependentSizedArray")]
		DEPENDENT_SIZED_ARRAY,
		[CCode (cname = "CXType_MemberPointer")]
		MEMBER_POINTER,
		[CCode (cname = "CXType_Auto")]
		AUTO,
		[CCode (cname = "CXType_Elaborated")]
		ELABORATED,
		[CCode (cname = "CXType_Pipe")]
		PIPE,
		[CCode (cname = "CXType_OCLImage1dRO")]
		OCLIMAGE1D_RO,
		[CCode (cname = "CXType_OCLImage1dArrayRO")]
		OCLIMAGE1D_ARRAY_RO,
		[CCode (cname = "CXType_OCLImage1dBufferRO")]
		OCLIMAGE1D_BUFFER_RO,
		[CCode (cname = "CXType_OCLImage2dRO")]
		OCLIMAGE2D_RO,
		[CCode (cname = "CXType_OCLImage2dArrayRO")]
		OCLIMAGE2D_ARRAY_RO,
		[CCode (cname = "CXType_OCLImage2dDepthRO")]
		OCLIMAGE2D_DEPTH_RO,
		[CCode (cname = "CXType_OCLImage2dArrayDepthRO")]
		OCLIMAGE2D_ARRAY_DEPTH_RO,
		[CCode (cname = "CXType_OCLImage2dMSAARO")]
		OCLIMAGE2D_MSAARO,
		[CCode (cname = "CXType_OCLImage2dArrayMSAARO")]
		OCLIMAGE2D_ARRAY_MSAARO,
		[CCode (cname = "CXType_OCLImage2dMSAADepthRO")]
		OCLIMAGE2D_MSAADEPTH_RO,
		[CCode (cname = "CXType_OCLImage2dArrayMSAADepthRO")]
		OCLIMAGE2D_ARRAY_MSAADEPTH_RO,
		[CCode (cname = "CXType_OCLImage3dRO")]
		OCLIMAGE3D_RO,
		[CCode (cname = "CXType_OCLImage1dWO")]
		OCLIMAGE1D_WO,
		[CCode (cname = "CXType_OCLImage1dArrayWO")]
		OCLIMAGE1D_ARRAY_WO,
		[CCode (cname = "CXType_OCLImage1dBufferWO")]
		OCLIMAGE1D_BUFFER_WO,
		[CCode (cname = "CXType_OCLImage2dWO")]
		OCLIMAGE2D_WO,
		[CCode (cname = "CXType_OCLImage2dArrayWO")]
		OCLIMAGE2D_ARRAY_WO,
		[CCode (cname = "CXType_OCLImage2dDepthWO")]
		OCLIMAGE2D_DEPTH_WO,
		[CCode (cname = "CXType_OCLImage2dArrayDepthWO")]
		OCLIMAGE2D_ARRAY_DEPTH_WO,
		[CCode (cname = "CXType_OCLImage2dMSAAWO")]
		OCLIMAGE2D_MSAAWO,
		[CCode (cname = "CXType_OCLImage2dArrayMSAAWO")]
		OCLIMAGE2D_ARRAY_MSAAWO,
		[CCode (cname = "CXType_OCLImage2dMSAADepthWO")]
		OCLIMAGE2D_MSAADEPTH_WO,
		[CCode (cname = "CXType_OCLImage2dArrayMSAADepthWO")]
		OCLIMAGE2D_ARRAY_MSAADEPTH_WO,
		[CCode (cname = "CXType_OCLImage3dWO")]
		OCLIMAGE3D_WO,
		[CCode (cname = "CXType_OCLImage1dRW")]
		OCLIMAGE1D_RW,
		[CCode (cname = "CXType_OCLImage1dArrayRW")]
		OCLIMAGE1D_ARRAY_RW,
		[CCode (cname = "CXType_OCLImage1dBufferRW")]
		OCLIMAGE1D_BUFFER_RW,
		[CCode (cname = "CXType_OCLImage2dRW")]
		OCLIMAGE2D_RW,
		[CCode (cname = "CXType_OCLImage2dArrayRW")]
		OCLIMAGE2D_ARRAY_RW,
		[CCode (cname = "CXType_OCLImage2dDepthRW")]
		OCLIMAGE2D_DEPTH_RW,
		[CCode (cname = "CXType_OCLImage2dArrayDepthRW")]
		OCLIMAGE2D_ARRAY_DEPTH_RW,
		[CCode (cname = "CXType_OCLImage2dMSAARW")]
		OCLIMAGE2D_MSAARW,
		[CCode (cname = "CXType_OCLImage2dArrayMSAARW")]
		OCLIMAGE2D_ARRAY_MSAARW,
		[CCode (cname = "CXType_OCLImage2dMSAADepthRW")]
		OCLIMAGE2D_MSAADEPTH_RW,
		[CCode (cname = "CXType_OCLImage2dArrayMSAADepthRW")]
		OCLIMAGE2D_ARRAY_MSAADEPTH_RW,
		[CCode (cname = "CXType_OCLImage3dRW")]
		OCLIMAGE3D_RW,
		[CCode (cname = "CXType_OCLSampler")]
		OCLSAMPLER,
		[CCode (cname = "CXType_OCLEvent")]
		OCLEVENT,
		[CCode (cname = "CXType_OCLQueue")]
		OCLQUEUE,
		[CCode (cname = "CXType_OCLReserveID")]
		OCLRESERVE_ID,
		[CCode (cname = "CXType_ObjCObject")]
		OBJ_COBJECT,
		[CCode (cname = "CXType_ObjCTypeParam")]
		OBJ_CTYPE_PARAM,
		[CCode (cname = "CXType_Attributed")]
		ATTRIBUTED,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCMcePayload")]
		OCLINTEL_SUBGROUP_AVCMCE_PAYLOAD,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImePayload")]
		OCLINTEL_SUBGROUP_AVCIME_PAYLOAD,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCRefPayload")]
		OCLINTEL_SUBGROUP_AVCREF_PAYLOAD,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCSicPayload")]
		OCLINTEL_SUBGROUP_AVCSIC_PAYLOAD,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCMceResult")]
		OCLINTEL_SUBGROUP_AVCMCE_RESULT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImeResult")]
		OCLINTEL_SUBGROUP_AVCIME_RESULT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCRefResult")]
		OCLINTEL_SUBGROUP_AVCREF_RESULT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCSicResult")]
		OCLINTEL_SUBGROUP_AVCSIC_RESULT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImeResultSingleRefStreamout")]
		OCLINTEL_SUBGROUP_AVCIME_RESULT_SINGLE_REF_STREAMOUT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImeResultDualRefStreamout")]
		OCLINTEL_SUBGROUP_AVCIME_RESULT_DUAL_REF_STREAMOUT,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImeSingleRefStreamin")]
		OCLINTEL_SUBGROUP_AVCIME_SINGLE_REF_STREAMIN,
		[CCode (cname = "CXType_OCLIntelSubgroupAVCImeDualRefStreamin")]
		OCLINTEL_SUBGROUP_AVCIME_DUAL_REF_STREAMIN,
		[CCode (cname = "CXType_ExtVector")]
		EXT_VECTOR,
		[CCode (cname = "CXType_Atomic")]
		ATOMIC;

		[CCode (cname = "clang_getTypeKindSpelling")]
		public String spelling ();
	}

	[CCode (cname = "enum CXCursorKind")]
	public enum CursorKind {
		[CCode (cname = "CXCursor_UnexposedDecl")]
		UNEXPOSED_DECL,
		[CCode (cname = "CXCursor_StructDecl")]
		STRUCT_DECL,
		[CCode (cname = "CXCursor_UnionDecl")]
		UNION_DECL,
		[CCode (cname = "CXCursor_ClassDecl")]
		CLASS_DECL,
		[CCode (cname = "CXCursor_EnumDecl")]
		ENUM_DECL,
		[CCode (cname = "CXCursor_FieldDecl")]
		FIELD_DECL,
		[CCode (cname = "CXCursor_EnumConstantDecl")]
		ENUM_CONSTANT_DECL,
		[CCode (cname = "CXCursor_FunctionDecl")]
		FUNCTION_DECL,
		[CCode (cname = "CXCursor_VarDecl")]
		VAR_DECL,
		[CCode (cname = "CXCursor_ParmDecl")]
		PARM_DECL,
		[CCode (cname = "CXCursor_ObjCInterfaceDecl")]
		OBJ_CINTERFACE_DECL,
		[CCode (cname = "CXCursor_ObjCCategoryDecl")]
		OBJ_CCATEGORY_DECL,
		[CCode (cname = "CXCursor_ObjCProtocolDecl")]
		OBJ_CPROTOCOL_DECL,
		[CCode (cname = "CXCursor_ObjCPropertyDecl")]
		OBJ_CPROPERTY_DECL,
		[CCode (cname = "CXCursor_ObjCIvarDecl")]
		OBJ_CIVAR_DECL,
		[CCode (cname = "CXCursor_ObjCInstanceMethodDecl")]
		OBJ_CINSTANCE_METHOD_DECL,
		[CCode (cname = "CXCursor_ObjCClassMethodDecl")]
		OBJ_CCLASS_METHOD_DECL,
		[CCode (cname = "CXCursor_ObjCImplementationDecl")]
		OBJ_CIMPLEMENTATION_DECL,
		[CCode (cname = "CXCursor_ObjCCategoryImplDecl")]
		OBJ_CCATEGORY_IMPL_DECL,
		[CCode (cname = "CXCursor_TypedefDecl")]
		TYPEDEF_DECL,
		[CCode (cname = "CXCursor_CXXMethod")]
		CXXMETHOD,
		[CCode (cname = "CXCursor_Namespace")]
		NAMESPACE,
		[CCode (cname = "CXCursor_LinkageSpec")]
		LINKAGE_SPEC,
		[CCode (cname = "CXCursor_Constructor")]
		CONSTRUCTOR,
		[CCode (cname = "CXCursor_Destructor")]
		DESTRUCTOR,
		[CCode (cname = "CXCursor_ConversionFunction")]
		CONVERSION_FUNCTION,
		[CCode (cname = "CXCursor_TemplateTypeParameter")]
		TEMPLATE_TYPE_PARAMETER,
		[CCode (cname = "CXCursor_NonTypeTemplateParameter")]
		NON_TYPE_TEMPLATE_PARAMETER,
		[CCode (cname = "CXCursor_TemplateTemplateParameter")]
		TEMPLATE_TEMPLATE_PARAMETER,
		[CCode (cname = "CXCursor_FunctionTemplate")]
		FUNCTION_TEMPLATE,
		[CCode (cname = "CXCursor_ClassTemplate")]
		CLASS_TEMPLATE,
		[CCode (cname = "CXCursor_ClassTemplatePartialSpecialization")]
		CLASS_TEMPLATE_PARTIAL_SPECIALIZATION,
		[CCode (cname = "CXCursor_NamespaceAlias")]
		NAMESPACE_ALIAS,
		[CCode (cname = "CXCursor_UsingDirective")]
		USING_DIRECTIVE,
		[CCode (cname = "CXCursor_UsingDeclaration")]
		USING_DECLARATION,
		[CCode (cname = "CXCursor_TypeAliasDecl")]
		TYPE_ALIAS_DECL,
		[CCode (cname = "CXCursor_ObjCSynthesizeDecl")]
		OBJ_CSYNTHESIZE_DECL,
		[CCode (cname = "CXCursor_ObjCDynamicDecl")]
		OBJ_CDYNAMIC_DECL,
		[CCode (cname = "CXCursor_CXXAccessSpecifier")]
		CXXACCESS_SPECIFIER,
		[CCode (cname = "CXCursor_FirstDecl")]
		FIRST_DECL,
		[CCode (cname = "CXCursor_LastDecl")]
		LAST_DECL,
		[CCode (cname = "CXCursor_FirstRef")]
		FIRST_REF,
		[CCode (cname = "CXCursor_ObjCSuperClassRef")]
		OBJ_CSUPER_CLASS_REF,
		[CCode (cname = "CXCursor_ObjCProtocolRef")]
		OBJ_CPROTOCOL_REF,
		[CCode (cname = "CXCursor_ObjCClassRef")]
		OBJ_CCLASS_REF,
		[CCode (cname = "CXCursor_TypeRef")]
		TYPE_REF,
		[CCode (cname = "CXCursor_CXXBaseSpecifier")]
		CXXBASE_SPECIFIER,
		[CCode (cname = "CXCursor_TemplateRef")]
		TEMPLATE_REF,
		[CCode (cname = "CXCursor_NamespaceRef")]
		NAMESPACE_REF,
		[CCode (cname = "CXCursor_MemberRef")]
		MEMBER_REF,
		[CCode (cname = "CXCursor_LabelRef")]
		LABEL_REF,
		[CCode (cname = "CXCursor_OverloadedDeclRef")]
		OVERLOADED_DECL_REF,
		[CCode (cname = "CXCursor_VariableRef")]
		VARIABLE_REF,
		[CCode (cname = "CXCursor_LastRef")]
		LAST_REF,
		[CCode (cname = "CXCursor_FirstInvalid")]
		FIRST_INVALID,
		[CCode (cname = "CXCursor_InvalidFile")]
		INVALID_FILE,
		[CCode (cname = "CXCursor_NoDeclFound")]
		NO_DECL_FOUND,
		[CCode (cname = "CXCursor_NotImplemented")]
		NOT_IMPLEMENTED,
		[CCode (cname = "CXCursor_InvalidCode")]
		INVALID_CODE,
		[CCode (cname = "CXCursor_LastInvalid")]
		LAST_INVALID,
		[CCode (cname = "CXCursor_FirstExpr")]
		FIRST_EXPR,
		[CCode (cname = "CXCursor_UnexposedExpr")]
		UNEXPOSED_EXPR,
		[CCode (cname = "CXCursor_DeclRefExpr")]
		DECL_REF_EXPR,
		[CCode (cname = "CXCursor_MemberRefExpr")]
		MEMBER_REF_EXPR,
		[CCode (cname = "CXCursor_CallExpr")]
		CALL_EXPR,
		[CCode (cname = "CXCursor_ObjCMessageExpr")]
		OBJ_CMESSAGE_EXPR,
		[CCode (cname = "CXCursor_BlockExpr")]
		BLOCK_EXPR,
		[CCode (cname = "CXCursor_IntegerLiteral")]
		INTEGER_LITERAL,
		[CCode (cname = "CXCursor_FloatingLiteral")]
		FLOATING_LITERAL,
		[CCode (cname = "CXCursor_ImaginaryLiteral")]
		IMAGINARY_LITERAL,
		[CCode (cname = "CXCursor_StringLiteral")]
		STRING_LITERAL,
		[CCode (cname = "CXCursor_CharacterLiteral")]
		CHARACTER_LITERAL,
		[CCode (cname = "CXCursor_ParenExpr")]
		PAREN_EXPR,
		[CCode (cname = "CXCursor_UnaryOperator")]
		UNARY_OPERATOR,
		[CCode (cname = "CXCursor_ArraySubscriptExpr")]
		ARRAY_SUBSCRIPT_EXPR,
		[CCode (cname = "CXCursor_BinaryOperator")]
		BINARY_OPERATOR,
		[CCode (cname = "CXCursor_CompoundAssignOperator")]
		COMPOUND_ASSIGN_OPERATOR,
		[CCode (cname = "CXCursor_ConditionalOperator")]
		CONDITIONAL_OPERATOR,
		[CCode (cname = "CXCursor_CStyleCastExpr")]
		CSTYLE_CAST_EXPR,
		[CCode (cname = "CXCursor_CompoundLiteralExpr")]
		COMPOUND_LITERAL_EXPR,
		[CCode (cname = "CXCursor_InitListExpr")]
		INIT_LIST_EXPR,
		[CCode (cname = "CXCursor_AddrLabelExpr")]
		ADDR_LABEL_EXPR,
		[CCode (cname = "CXCursor_StmtExpr")]
		STMT_EXPR,
		[CCode (cname = "CXCursor_GenericSelectionExpr")]
		GENERIC_SELECTION_EXPR,
		[CCode (cname = "CXCursor_GNUNullExpr")]
		GNUNULL_EXPR,
		[CCode (cname = "CXCursor_CXXStaticCastExpr")]
		CXXSTATIC_CAST_EXPR,
		[CCode (cname = "CXCursor_CXXDynamicCastExpr")]
		CXXDYNAMIC_CAST_EXPR,
		[CCode (cname = "CXCursor_CXXReinterpretCastExpr")]
		CXXREINTERPRET_CAST_EXPR,
		[CCode (cname = "CXCursor_CXXConstCastExpr")]
		CXXCONST_CAST_EXPR,
		[CCode (cname = "CXCursor_CXXFunctionalCastExpr")]
		CXXFUNCTIONAL_CAST_EXPR,
		[CCode (cname = "CXCursor_CXXTypeidExpr")]
		CXXTYPEID_EXPR,
		[CCode (cname = "CXCursor_CXXBoolLiteralExpr")]
		CXXBOOL_LITERAL_EXPR,
		[CCode (cname = "CXCursor_CXXNullPtrLiteralExpr")]
		CXXNULL_PTR_LITERAL_EXPR,
		[CCode (cname = "CXCursor_CXXThisExpr")]
		CXXTHIS_EXPR,
		[CCode (cname = "CXCursor_CXXThrowExpr")]
		CXXTHROW_EXPR,
		[CCode (cname = "CXCursor_CXXNewExpr")]
		CXXNEW_EXPR,
		[CCode (cname = "CXCursor_CXXDeleteExpr")]
		CXXDELETE_EXPR,
		[CCode (cname = "CXCursor_UnaryExpr")]
		UNARY_EXPR,
		[CCode (cname = "CXCursor_ObjCStringLiteral")]
		OBJ_CSTRING_LITERAL,
		[CCode (cname = "CXCursor_ObjCEncodeExpr")]
		OBJ_CENCODE_EXPR,
		[CCode (cname = "CXCursor_ObjCSelectorExpr")]
		OBJ_CSELECTOR_EXPR,
		[CCode (cname = "CXCursor_ObjCProtocolExpr")]
		OBJ_CPROTOCOL_EXPR,
		[CCode (cname = "CXCursor_ObjCBridgedCastExpr")]
		OBJ_CBRIDGED_CAST_EXPR,
		[CCode (cname = "CXCursor_PackExpansionExpr")]
		PACK_EXPANSION_EXPR,
		[CCode (cname = "CXCursor_SizeOfPackExpr")]
		SIZE_OF_PACK_EXPR,
		[CCode (cname = "CXCursor_LambdaExpr")]
		LAMBDA_EXPR,
		[CCode (cname = "CXCursor_ObjCBoolLiteralExpr")]
		OBJ_CBOOL_LITERAL_EXPR,
		[CCode (cname = "CXCursor_ObjCSelfExpr")]
		OBJ_CSELF_EXPR,
		[CCode (cname = "CXCursor_OMPArraySectionExpr")]
		OMPARRAY_SECTION_EXPR,
		[CCode (cname = "CXCursor_ObjCAvailabilityCheckExpr")]
		OBJ_CAVAILABILITY_CHECK_EXPR,
		[CCode (cname = "CXCursor_FixedPointLiteral")]
		FIXED_POINT_LITERAL,
		[CCode (cname = "CXCursor_OMPArrayShapingExpr")]
		OMPARRAY_SHAPING_EXPR,
		[CCode (cname = "CXCursor_OMPIteratorExpr")]
		OMPITERATOR_EXPR,
		[CCode (cname = "CXCursor_CXXAddrspaceCastExpr")]
		CXXADDRSPACE_CAST_EXPR,
		[CCode (cname = "CXCursor_LastExpr")]
		LAST_EXPR,
		[CCode (cname = "CXCursor_FirstStmt")]
		FIRST_STMT,
		[CCode (cname = "CXCursor_UnexposedStmt")]
		UNEXPOSED_STMT,
		[CCode (cname = "CXCursor_LabelStmt")]
		LABEL_STMT,
		[CCode (cname = "CXCursor_CompoundStmt")]
		COMPOUND_STMT,
		[CCode (cname = "CXCursor_CaseStmt")]
		CASE_STMT,
		[CCode (cname = "CXCursor_DefaultStmt")]
		DEFAULT_STMT,
		[CCode (cname = "CXCursor_IfStmt")]
		IF_STMT,
		[CCode (cname = "CXCursor_SwitchStmt")]
		SWITCH_STMT,
		[CCode (cname = "CXCursor_WhileStmt")]
		WHILE_STMT,
		[CCode (cname = "CXCursor_DoStmt")]
		DO_STMT,
		[CCode (cname = "CXCursor_ForStmt")]
		FOR_STMT,
		[CCode (cname = "CXCursor_GotoStmt")]
		GOTO_STMT,
		[CCode (cname = "CXCursor_IndirectGotoStmt")]
		INDIRECT_GOTO_STMT,
		[CCode (cname = "CXCursor_ContinueStmt")]
		CONTINUE_STMT,
		[CCode (cname = "CXCursor_BreakStmt")]
		BREAK_STMT,
		[CCode (cname = "CXCursor_ReturnStmt")]
		RETURN_STMT,
		[CCode (cname = "CXCursor_GCCAsmStmt")]
		GCCASM_STMT,
		[CCode (cname = "CXCursor_AsmStmt")]
		ASM_STMT,
		[CCode (cname = "CXCursor_ObjCAtTryStmt")]
		OBJ_CAT_TRY_STMT,
		[CCode (cname = "CXCursor_ObjCAtCatchStmt")]
		OBJ_CAT_CATCH_STMT,
		[CCode (cname = "CXCursor_ObjCAtFinallyStmt")]
		OBJ_CAT_FINALLY_STMT,
		[CCode (cname = "CXCursor_ObjCAtThrowStmt")]
		OBJ_CAT_THROW_STMT,
		[CCode (cname = "CXCursor_ObjCAtSynchronizedStmt")]
		OBJ_CAT_SYNCHRONIZED_STMT,
		[CCode (cname = "CXCursor_ObjCAutoreleasePoolStmt")]
		OBJ_CAUTORELEASE_POOL_STMT,
		[CCode (cname = "CXCursor_ObjCForCollectionStmt")]
		OBJ_CFOR_COLLECTION_STMT,
		[CCode (cname = "CXCursor_CXXCatchStmt")]
		CXXCATCH_STMT,
		[CCode (cname = "CXCursor_CXXTryStmt")]
		CXXTRY_STMT,
		[CCode (cname = "CXCursor_CXXForRangeStmt")]
		CXXFOR_RANGE_STMT,
		[CCode (cname = "CXCursor_SEHTryStmt")]
		SEHTRY_STMT,
		[CCode (cname = "CXCursor_SEHExceptStmt")]
		SEHEXCEPT_STMT,
		[CCode (cname = "CXCursor_SEHFinallyStmt")]
		SEHFINALLY_STMT,
		[CCode (cname = "CXCursor_MSAsmStmt")]
		MSASM_STMT,
		[CCode (cname = "CXCursor_NullStmt")]
		NULL_STMT,
		[CCode (cname = "CXCursor_DeclStmt")]
		DECL_STMT,
		[CCode (cname = "CXCursor_OMPParallelDirective")]
		OMPPARALLEL_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPSimdDirective")]
		OMPSIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPForDirective")]
		OMPFOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPSectionsDirective")]
		OMPSECTIONS_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPSectionDirective")]
		OMPSECTION_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPSingleDirective")]
		OMPSINGLE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelForDirective")]
		OMPPARALLEL_FOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelSectionsDirective")]
		OMPPARALLEL_SECTIONS_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskDirective")]
		OMPTASK_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPMasterDirective")]
		OMPMASTER_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPCriticalDirective")]
		OMPCRITICAL_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskyieldDirective")]
		OMPTASKYIELD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPBarrierDirective")]
		OMPBARRIER_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskwaitDirective")]
		OMPTASKWAIT_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPFlushDirective")]
		OMPFLUSH_DIRECTIVE,
		[CCode (cname = "CXCursor_SEHLeaveStmt")]
		SEHLEAVE_STMT,
		[CCode (cname = "CXCursor_OMPOrderedDirective")]
		OMPORDERED_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPAtomicDirective")]
		OMPATOMIC_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPForSimdDirective")]
		OMPFOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelForSimdDirective")]
		OMPPARALLEL_FOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetDirective")]
		OMPTARGET_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTeamsDirective")]
		OMPTEAMS_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskgroupDirective")]
		OMPTASKGROUP_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPCancellationPointDirective")]
		OMPCANCELLATION_POINT_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPCancelDirective")]
		OMPCANCEL_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetDataDirective")]
		OMPTARGET_DATA_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskLoopDirective")]
		OMPTASK_LOOP_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTaskLoopSimdDirective")]
		OMPTASK_LOOP_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDistributeDirective")]
		OMPDISTRIBUTE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetEnterDataDirective")]
		OMPTARGET_ENTER_DATA_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetExitDataDirective")]
		OMPTARGET_EXIT_DATA_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetParallelDirective")]
		OMPTARGET_PARALLEL_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetParallelForDirective")]
		OMPTARGET_PARALLEL_FOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetUpdateDirective")]
		OMPTARGET_UPDATE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDistributeParallelForDirective")]
		OMPDISTRIBUTE_PARALLEL_FOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDistributeParallelForSimdDirective")]
		OMPDISTRIBUTE_PARALLEL_FOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDistributeSimdDirective")]
		OMPDISTRIBUTE_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetParallelForSimdDirective")]
		OMPTARGET_PARALLEL_FOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetSimdDirective")]
		OMPTARGET_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTeamsDistributeDirective")]
		OMPTEAMS_DISTRIBUTE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTeamsDistributeSimdDirective")]
		OMPTEAMS_DISTRIBUTE_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTeamsDistributeParallelForSimdDirective")]
		OMPTEAMS_DISTRIBUTE_PARALLEL_FOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTeamsDistributeParallelForDirective")]
		OMPTEAMS_DISTRIBUTE_PARALLEL_FOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetTeamsDirective")]
		OMPTARGET_TEAMS_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetTeamsDistributeDirective")]
		OMPTARGET_TEAMS_DISTRIBUTE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetTeamsDistributeParallelForDirective")]
		OMPTARGET_TEAMS_DISTRIBUTE_PARALLEL_FOR_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetTeamsDistributeParallelForSimdDirective")]
		OMPTARGET_TEAMS_DISTRIBUTE_PARALLEL_FOR_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTargetTeamsDistributeSimdDirective")]
		OMPTARGET_TEAMS_DISTRIBUTE_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_BuiltinBitCastExpr")]
		BUILTIN_BIT_CAST_EXPR,
		[CCode (cname = "CXCursor_OMPMasterTaskLoopDirective")]
		OMPMASTER_TASK_LOOP_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelMasterTaskLoopDirective")]
		OMPPARALLEL_MASTER_TASK_LOOP_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPMasterTaskLoopSimdDirective")]
		OMPMASTER_TASK_LOOP_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelMasterTaskLoopSimdDirective")]
		OMPPARALLEL_MASTER_TASK_LOOP_SIMD_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPParallelMasterDirective")]
		OMPPARALLEL_MASTER_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDepobjDirective")]
		OMPDEPOBJ_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPScanDirective")]
		OMPSCAN_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPTileDirective")]
		OMPTILE_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPCanonicalLoop")]
		OMPCANONICAL_LOOP,
		[CCode (cname = "CXCursor_OMPInteropDirective")]
		OMPINTEROP_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPDispatchDirective")]
		OMPDISPATCH_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPMaskedDirective")]
		OMPMASKED_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPUnrollDirective")]
		OMPUNROLL_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPMetaDirective")]
		OMPMETA_DIRECTIVE,
		[CCode (cname = "CXCursor_OMPGenericLoopDirective")]
		OMPGENERIC_LOOP_DIRECTIVE,
		[CCode (cname = "CXCursor_LastStmt")]
		LAST_STMT,
		[CCode (cname = "CXCursor_TranslationUnit")]
		TRANSLATION_UNIT,
		[CCode (cname = "CXCursor_FirstAttr")]
		FIRST_ATTR,
		[CCode (cname = "CXCursor_UnexposedAttr")]
		UNEXPOSED_ATTR,
		[CCode (cname = "CXCursor_IBActionAttr")]
		IBACTION_ATTR,
		[CCode (cname = "CXCursor_IBOutletAttr")]
		IBOUTLET_ATTR,
		[CCode (cname = "CXCursor_IBOutletCollectionAttr")]
		IBOUTLET_COLLECTION_ATTR,
		[CCode (cname = "CXCursor_CXXFinalAttr")]
		CXXFINAL_ATTR,
		[CCode (cname = "CXCursor_CXXOverrideAttr")]
		CXXOVERRIDE_ATTR,
		[CCode (cname = "CXCursor_AnnotateAttr")]
		ANNOTATE_ATTR,
		[CCode (cname = "CXCursor_AsmLabelAttr")]
		ASM_LABEL_ATTR,
		[CCode (cname = "CXCursor_PackedAttr")]
		PACKED_ATTR,
		[CCode (cname = "CXCursor_PureAttr")]
		PURE_ATTR,
		[CCode (cname = "CXCursor_ConstAttr")]
		CONST_ATTR,
		[CCode (cname = "CXCursor_NoDuplicateAttr")]
		NO_DUPLICATE_ATTR,
		[CCode (cname = "CXCursor_CUDAConstantAttr")]
		CUDACONSTANT_ATTR,
		[CCode (cname = "CXCursor_CUDADeviceAttr")]
		CUDADEVICE_ATTR,
		[CCode (cname = "CXCursor_CUDAGlobalAttr")]
		CUDAGLOBAL_ATTR,
		[CCode (cname = "CXCursor_CUDAHostAttr")]
		CUDAHOST_ATTR,
		[CCode (cname = "CXCursor_CUDASharedAttr")]
		CUDASHARED_ATTR,
		[CCode (cname = "CXCursor_VisibilityAttr")]
		VISIBILITY_ATTR,
		[CCode (cname = "CXCursor_DLLExport")]
		DLLEXPORT,
		[CCode (cname = "CXCursor_DLLImport")]
		DLLIMPORT,
		[CCode (cname = "CXCursor_NSReturnsRetained")]
		NSRETURNS_RETAINED,
		[CCode (cname = "CXCursor_NSReturnsNotRetained")]
		NSRETURNS_NOT_RETAINED,
		[CCode (cname = "CXCursor_NSReturnsAutoreleased")]
		NSRETURNS_AUTORELEASED,
		[CCode (cname = "CXCursor_NSConsumesSelf")]
		NSCONSUMES_SELF,
		[CCode (cname = "CXCursor_NSConsumed")]
		NSCONSUMED,
		[CCode (cname = "CXCursor_ObjCException")]
		OBJ_CEXCEPTION,
		[CCode (cname = "CXCursor_ObjCNSObject")]
		OBJ_CNSOBJECT,
		[CCode (cname = "CXCursor_ObjCIndependentClass")]
		OBJ_CINDEPENDENT_CLASS,
		[CCode (cname = "CXCursor_ObjCPreciseLifetime")]
		OBJ_CPRECISE_LIFETIME,
		[CCode (cname = "CXCursor_ObjCReturnsInnerPointer")]
		OBJ_CRETURNS_INNER_POINTER,
		[CCode (cname = "CXCursor_ObjCRequiresSuper")]
		OBJ_CREQUIRES_SUPER,
		[CCode (cname = "CXCursor_ObjCRootClass")]
		OBJ_CROOT_CLASS,
		[CCode (cname = "CXCursor_ObjCSubclassingRestricted")]
		OBJ_CSUBCLASSING_RESTRICTED,
		[CCode (cname = "CXCursor_ObjCExplicitProtocolImpl")]
		OBJ_CEXPLICIT_PROTOCOL_IMPL,
		[CCode (cname = "CXCursor_ObjCDesignatedInitializer")]
		OBJ_CDESIGNATED_INITIALIZER,
		[CCode (cname = "CXCursor_ObjCRuntimeVisible")]
		OBJ_CRUNTIME_VISIBLE,
		[CCode (cname = "CXCursor_ObjCBoxable")]
		OBJ_CBOXABLE,
		[CCode (cname = "CXCursor_FlagEnum")]
		FLAG_ENUM,
		[CCode (cname = "CXCursor_ConvergentAttr")]
		CONVERGENT_ATTR,
		[CCode (cname = "CXCursor_WarnUnusedAttr")]
		WARN_UNUSED_ATTR,
		[CCode (cname = "CXCursor_WarnUnusedResultAttr")]
		WARN_UNUSED_RESULT_ATTR,
		[CCode (cname = "CXCursor_AlignedAttr")]
		ALIGNED_ATTR,
		[CCode (cname = "CXCursor_LastAttr")]
		LAST_ATTR,
		[CCode (cname = "CXCursor_PreprocessingDirective")]
		PREPROCESSING_DIRECTIVE,
		[CCode (cname = "CXCursor_MacroDefinition")]
		MACRO_DEFINITION,
		[CCode (cname = "CXCursor_MacroExpansion")]
		MACRO_EXPANSION,
		[CCode (cname = "CXCursor_MacroInstantiation")]
		MACRO_INSTANTIATION,
		[CCode (cname = "CXCursor_InclusionDirective")]
		INCLUSION_DIRECTIVE,
		[CCode (cname = "CXCursor_FirstPreprocessing")]
		FIRST_PREPROCESSING,
		[CCode (cname = "CXCursor_LastPreprocessing")]
		LAST_PREPROCESSING,
		[CCode (cname = "CXCursor_ModuleImportDecl")]
		MODULE_IMPORT_DECL,
		[CCode (cname = "CXCursor_TypeAliasTemplateDecl")]
		TYPE_ALIAS_TEMPLATE_DECL,
		[CCode (cname = "CXCursor_StaticAssert")]
		STATIC_ASSERT,
		[CCode (cname = "CXCursor_FriendDecl")]
		FRIEND_DECL,
		[CCode (cname = "CXCursor_FirstExtraDecl")]
		FIRST_EXTRA_DECL,
		[CCode (cname = "CXCursor_LastExtraDecl")]
		LAST_EXTRA_DECL,
		[CCode (cname = "CXCursor_OverloadCandidate")]
		OVERLOAD_CANDIDATE;

		[CCode (cname = "clang_isDeclaration")]
		public bool is_declaration ();

		[CCode (cname = "clang_getCursorKindSpelling")]
		public String spelling ();
	}

	[SimpleType]
	[CCode (cname = "CXString", free_function = "clang_disposeString", has_type_id = false)]
	public struct String {
		public unowned string str {
			[CCode (cname = "clang_getCString")]
			get;
		}
	}
}
