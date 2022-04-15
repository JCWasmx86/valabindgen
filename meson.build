project('valabindgen', ['c', 'vala'])
vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

dependencies = [
	dependency('json-glib-1.0'),
	dependency('gee-0.8'),
	meson.get_compiler('c').find_library('clang'),
	meson.get_compiler('vala').find_library('clang', dirs: vapi_dir),
]
subdir('app')
subdir('backend')
subdir('parser')

executable('valabindgen', app_sources + backend_sources + parser_sources, dependencies: dependencies)
