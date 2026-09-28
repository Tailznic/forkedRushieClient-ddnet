set(LIVEKIT_LIBDIR "${PROJECT_SOURCE_DIR}/rushie-libs/livekit/${LIB_DIR}")
set(LIVEKIT_INCLUDEDIR_EXPECTED "${PROJECT_SOURCE_DIR}/rushie-libs/livekit/include")

if(PREFER_BUNDLED_LIBS)
  set(LIVEKIT_SEARCH_TYPE HINTS)
else()
  set(LIVEKIT_SEARCH_TYPE PATHS)
endif()

find_library(LIVEKIT_LIBRARY
        NAMES livekit
        ${LIVEKIT_SEARCH_TYPE} "${LIVEKIT_LIBDIR}"
        ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)
find_path(LIVEKIT_INCLUDEDIR livekit/livekit.h
        ${LIVEKIT_SEARCH_TYPE} "${LIVEKIT_INCLUDEDIR_EXPECTED}"
        ${CROSSCOMPILING_NO_CMAKE_SYSTEM_PATH}
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Livekit DEFAULT_MSG LIVEKIT_LIBRARY LIVEKIT_INCLUDEDIR)

mark_as_advanced(LIVEKIT_LIBRARY LIVEKIT_INCLUDEDIR)

if(LIVEKIT_FOUND)
  is_bundled(LIVEKIT_BUNDLED "${LIVEKIT_LIBRARY}")
  set(LIVEKIT_LIBRARIES ${LIVEKIT_LIBRARY})
  set(LIVEKIT_INCLUDE_DIRS ${LIVEKIT_INCLUDEDIR})

  if(LIVEKIT_BUNDLED)
    if(TARGET_OS STREQUAL "windows")
      set(LIVEKIT_COPY_FILES "${LIVEKIT_LIBDIR}/livekit.dll" "${LIVEKIT_LIBDIR}/livekit_ffi.dll")
    elseif(TARGET_OS STREQUAL "linux")
      set(LIVEKIT_COPY_FILES "${LIVEKIT_LIBDIR}/liblivekit.so" "${LIVEKIT_LIBDIR}/liblivekit_ffi.so")
    elseif(TARGET_OS STREQUAL "mac")
      set(LIVEKIT_COPY_FILES "${LIVEKIT_LIBDIR}/liblivekit.dylib" "${LIVEKIT_LIBDIR}/liblivekit_ffi.dylib")
    endif()
  else()
    set(LIVEKIT_COPY_FILES)
  endif()
endif()