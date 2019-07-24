.. _developer:

Developer Guide
###############

.. _clang:

Style
=====

**Velociraptor** is written in C++11. We suggest that code be written in ... Packages such as `clang-format <https://clang.llvm.org/docs/ClangFormat.html>`_ and `clang-tidy <https://clang.llvm.org/extra/clang-tidy/>`_ (linter tool) can be used to ensure new code conforms to the current formatting style.

.. _usecases:

Use Cases
=========

**Velociraptor** can be compiled as a stand alone executable (with the executable named stf (or STructure Finder for historical reasons)) or as a library to be called from within a N-Body/Hydrodnamical code for one-the-fly halo finding. Currently the code can be called from within `SWIFTSIM <https://github.com/SWIFTSIM/swiftsim/>`_. It can be run in serial, with OpenMP, or MPI APIs.

The typical mode of operation is to run the code with several MPI threads that roughly split the input N-body/Hydrodnamical simulation into subvolumes which are individually processed. Once each MPI domain has been searched for field halos (the first stage of clustering that it searches for), the clusters are then localised to an individual MPI domain if they span multiple MPI domains. This is done to minimise the amount of communication that takes place at the later stages of the code since the particles in a given object will be iterated over multiple times. Once individual objects are localised to a single MPI domain, the code makes use of OpenMP for parallelisation. The code attempts to split the task balance in such a fashion as to: parallelise over particles for objects composed of many particles and parallelise over objects for those composed of few particles.

The code can in principle be started using an arbitrary number of mpi threads, but the mpi decomposition is most efficient for powers of 2 (this may be subject to change as different MPI decompositions are implemented).

.. note:: The code assumes that a single structure can fit onto the memory local to the mpi thread. If larger field objects (haloes) are to be analyzed such that they are unlikely to fit into local memory, we suggest that the breakdown between MPI and OpenMP be revised to allow an MPI domain to have the available memory. Revision is in the works to use the Singlehalo_search option after field halos have been identified.

.. _updating:

Updating VR
===========

The code makes use of `GitHub <https://github.com/>`_ for version control and `Travis-CI <https://travis-ci.org/>`_ for continuous integration.

Ideally, a developer should fork from the main branch (or any desired branch) and proceed to begin making edits to the source code. The code makes use of two submodules: `NBodylib <https://github.com/pelahi/NBodylib>`_ and `Velociraptor_Python_Tools <https://github.com/pelahi/Velociraptor_Python_Tools>`_. The critical library of interest for developers is **NBodylib**, which is a C++ library that contains classes used by **VELOCIraptor**.


.. _compilationtests:

Testing Compilation
-------------------

As the code makes extensive use of **MPI**, **OpenMP**, and **HDF5**, we strongly suggest you test the code locally against several builds invoking these routines. Some of these compilation cases are account for in the Travis tests but not all cases are covered. For completeness we suggest the following compilation options

.. topic:: Compilation Options for Testing

    +----------------------+----------------------------------------------------------------------------------------------------+
    | **Type**             | **CMAKE commands**                                                                                 |
    +======================+====================================================================================================+
    | Default              |                                                                                                    |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | No MPI               | ``-DVR_MPI=OFF``                                                                                   |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | No OpenMP            | ``-DVR_OPENMP=OFF``                                                                                |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Serial               | ``-DVR_MPI=OFF -DVR_OPENMP=OFF``                                                                   |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | SWIFTSIM Integration | ``-DVR_USE_SWIFT_INTERFACE=ON``                                                                    |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Gas                  | ``-DVR_USE_GAS=ON``                                                                                |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Gas+Stars            | ``-DVR_USE_GAS=ON -DVR_USE_STAR=ON``                                                               |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Gas+Stars+BH         | ``-DVR_USE_GAS=ON -DVR_USE_STAR=ON -DVR_USE_BH=ON``                                                |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Zoom Simulation      | ``-DVR_ZOOM_SIM=ON``                                                                               |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Zoom Hydro           | ``-DVR_USE_GAS=ON -DVR_USE_STAR=ON -DVR_USE_BH=ON -DVR_ZOOM_SIM=ON``                               |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Particle Precision   | ``-DNBODY_SINGLE_PARTICLE_PRECISION=ON``                                                           |
    +----------------------+----------------------------------------------------------------------------------------------------+
    | Single Precision     | ``-DVR_SINGLE_PRECISION=ON``                                                                       |
    +----------------------+----------------------------------------------------------------------------------------------------+

The different parallel cmake's can be combined with those related to particle types and precision. The list of Travis tests will increase as options are added. By default the options enabled are MPI, OpenMP, HDF5. 
