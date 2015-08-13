# - Try to find PnetCDF
#
# This can be controlled by setting the PnetCDF_DIR (or, equivalently, the 
# PNETCDF environment variable), or PnetCDF_<lang>_DIR CMake variables, where
# <lang> is the COMPONENT language one needs.
#
# Once done, this will define:
#
#   PnetCDF_<lang>_FOUND        (BOOL) - system has PnetCDF
#   PnetCDF_<lang>_IS_SHARED    (BOOL) - whether library is shared/dynamic
#   PnetCDF_<lang>_INCLUDE_DIR  (PATH) - Location of the C header file
#   PnetCDF_<lang>_INCLUDE_DIRS (LIST) - the PnetCDF include directories
#   PnetCDF_<lang>_LIBRARY      (FILE) - Path to the C library file
#   PnetCDF_<lang>_LIBRARIES    (LIST) - link these to use PnetCDF
#   PnetCDF_<lang>_DEFINITIONS  (LIST) - preprocessor macros to use with PnetCDF
#   PnetCDF_<lang>_OPTIONS      (LIST) - compiler options to use PnetCDF
#
# The available COMPONENTS are: C, Fortran
# If no components are specified, it assumes only C
include (LibFindLibraryMacros)
include (CheckPnetCDF)

# Define PnetCDF C Component
define_package_component (PnetCDF DEFAULT
                          COMPONENT C
                          INCLUDE_NAMES pnetcdf.h
                          LIBRARY_NAMES pnetcdf)

# Define PnetCDF Fortran Component
define_package_component (PnetCDF
                          COMPONENT Fortran
                          INCLUDE_NAMES pnetcdf.mod pnetcdf.inc
                          LIBRARY_NAMES pnetcdf)

# Search for list of valid components requested
find_valid_components (PnetCDF)

#==============================================================================
# SEARCH FOR VALIDATED COMPONENTS
foreach (PnetCDF_comp IN LISTS PnetCDF_FIND_VALID_COMPONENTS)

    # If not found already, search...
    if (NOT PnetCDF_${PnetCDF_comp}_FOUND)

        # Manually add the MPI include and library dirs to search paths
        if (MPI_${PnetCDF_comp}_FOUND)
            set (PnetCDF_${PnetCDF_comp}_INCLUDE_HINTS ${MPI_${PnetCDF_comp}_INCLUDE_PATH})
            set (PnetCDF_${PnetCDF_comp}_LIBRARY_HINTS)
            foreach (lib IN LISTS MPI_${PnetCDF_comp}_LIBRARIES)
                get_filename_component (libdir ${lib} PATH)
                list (APPEND PnetCDF_${PnetCDF_comp}_LIBRARY_HINTS ${libdir})
                unset (libdir)
            endforeach ()
        endif ()
        
        # Search for the package component
        find_package_component(PnetCDF COMPONENT ${PnetCDF_comp}
                               INCLUDE_HINTS ${PnetCDF_${PnetCDF_comp}_INCLUDE_HINTS}
                               LIBRARY_HINTS ${PnetCDF_${PnetCDF_comp}_LIBRARY_HINTS})
                               
    endif ()
    
endforeach ()

#==============================================================================
# CHECKS AND DEPENDENCIES
foreach (PnetCDF_comp IN LISTS PnetCDF_FIND_VALID_COMPONENTS)
    if (PnetCDF_comp STREQUAL C AND PnetCDF_C_FOUND)
        check_PnetCDF_C ()
    elseif (PnetCDF_comp STREQUAL Fortran AND PnetCDF_Fortran_FOUND)
        check_PnetCDF_Fortran ()
    endif ()    
endforeach ()
