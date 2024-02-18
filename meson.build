project('${REPO_NAME_PASCAL}', 'cpp',
  version : '0.0.1',
  default_options : ['warning_level=3',
                     'cpp_std=c++20',
		                 'b_coverage=true'])

add_global_arguments(language : 'cpp')

inc = include_directories('include')

doxygen = find_program('doxygen', required : false)

doctest = subproject('doctest')
doctest_dep = doctest.get_variable('doctest_dep')

subdir('src')
subdir('test')
if doxygen.found()
  subdir('docs')
endif
