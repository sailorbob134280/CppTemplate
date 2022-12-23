# Add test sources to this list
test_sources = ['Sample_test.cpp']

test_sources += 'TestMain.cpp'

testexe = executable('TestMain', test_sources, dependencies : doctest_dep, include_directories : inc)

test_base_name = ''.join([meson.project_name(), 'Tests'])

# List test targets here, organized by suite
test(test_base_name, testexe)
