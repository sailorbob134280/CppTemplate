cdata = configuration_data()
cdata.set('VERSION', meson.project_version())
cdata.set('PROJECTNAME', meson.project_name())
cdata.set('TOP_SRCDIR', meson.project_source_root())
cdata.set('TOP_BUILDDIR', meson.project_build_root())
cdata.set('DOXYGEN_AWESOME', join_paths(meson.current_source_dir(), 'doxygen-awesome.css'))
cdata.set('DOC_OUTPUT_DIR', meson.current_build_dir())

message('project source root: ' + meson.project_source_root())

if find_program('dot', required : false).found()
  cdata.set('HAVE_DOT', 'YES')
else
  cdata.set('HAVE_DOT', 'NO')
endif

doxyfile = configure_file(input: 'Doxyfile.in',
			  output: 'Doxyfile',
			  configuration: cdata,
			  install: false)

html_target = custom_target('docs',
			    input: doxyfile,
			    output: 'html',
			    command: [doxygen, doxyfile],
			    install: false)
