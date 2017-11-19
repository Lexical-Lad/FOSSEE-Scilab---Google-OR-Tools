// This file is released under the 3-clause BSD license. See COPYING-BSD.

// This macro compiles the files

function builder_cpp()

    src_cpp_path = get_absolute_file_path("builder_cpp.sce");

    CFLAGS = ilib_include_flag(src_cpp_path);

    // tbx_build_src(names, files, flag, [src_path [, libs [, ldflags [, cflags [, fflags [, cc [, libname [, loadername [, makename]]]]]]]]])

endfunction

builder_cpp();
clear builder_cpp; // remove builder_c on stack
