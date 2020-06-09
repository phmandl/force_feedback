if not(libisloaded('FF_UWP_WIN32_dll'))
    [notfound,warnings] = loadlibrary('FF_UWP_WIN32_dll');
end
libfunctions('FF_UWP_WIN32_dll','-full')

libfunctionsview FF_UWP_WIN32_dll

calllib('FF_UWP_WIN32_dll','initRacingWheel')
calllib('FF_UWP_WIN32_dll','initForceFeedback',3000000)

% calllib('FF_UWP_WIN32_dll','readingButton');

% while true

% end

% unloadlibrary FF_UWP_WIN32_dll

% clibgen.generateLibraryDefinition("FF_UWP_WIN32_dll.h","Libraries","FF_UWP_WIN32_dll.lib")