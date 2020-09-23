# -*- coding: utf8 -*-
# cython: profile=True
cimport numpy as np
import numpy as np
cimport cython

# Regular, boundary, and max vertex valences. These need tp be
DEF VALENCE = 6
DEF BOUNDARY_VALENCE = 4

cdef extern from 'triangle_mesh_utils.h':
    const int NEIGHBORSIZE  # Note this must match NEIGHBORSIZE in triangle_mesh_utils.h
    const int VECTORSIZE
    
    cdef struct halfedge_t:
        np.int32_t vertex
        np.int32_t face
        np.int32_t twin
        np.int32_t next
        np.int32_t prev
        np.float32_t length
        np.int32_t component
        
    cdef struct face_t:
        np.int32_t halfedge
        float normal[VECTORSIZE]
        float area
        np.int32_t component
        
    cdef struct face_d:
        np.int32_t halfedge
        np.float32_t normal0
        np.float32_t normal1
        np.float32_t normal2
        np.float32_t area
        np.int32_t component
        
    cdef struct vertex_t:
        float position[VECTORSIZE];
        float normal[VECTORSIZE];
        np.int32_t halfedge;
        np.int32_t valence;
        np.int32_t neighbors[NEIGHBORSIZE];
        np.int32_t component;
        np.int32_t locally_manifold
        
    cdef struct vertex_d:
        np.float32_t position0
        np.float32_t position1
        np.float32_t position2
        np.float32_t normal0
        np.float32_t normal1
        np.float32_t normal2
        np.int32_t halfedge
        np.int32_t valence
        np.int32_t neighbor0
        np.int32_t neighbor1
        np.int32_t neighbor2
        np.int32_t neighbor3
        np.int32_t neighbor4
        np.int32_t neighbor5
        np.int32_t neighbor6
        np.int32_t neighbor7
        np.int32_t neighbor8
        np.int32_t neighbor9
        np.int32_t neighbor10
        np.int32_t neighbor11
        np.int32_t neighbor12
        np.int32_t neighbor13
        np.int32_t neighbor14
        np.int32_t neighbor15
        np.int32_t neighbor16
        np.int32_t neighbor17
        np.int32_t neighbor18
        np.int32_t neighbor19
        np.int32_t component
        np.int32_t locally_manifold
        

from PYME.experimental import triangle_mesh_utils

DEF MAX_VERTEX_COUNT = 2**31

HALFEDGE_DTYPE = np.dtype([('vertex', 'i4'), ('face', 'i4'), ('twin', 'i4'), ('next', 'i4'), ('prev', 'i4'), ('length', 'f4'), ('component', 'i4')], align=True)
FACE_DTYPE = np.dtype([('halfedge', 'i4'), ('normal', '3f4'), ('area', 'f4'), ('component', 'i4')], align=True)
FACE_DTYPE2 = np.dtype([('halfedge', 'i4'), ('normal0', 'f4'), ('normal1', 'f4'), ('normal2', 'f4'), ('area', 'f4'), ('component', 'i4')], align=True)
# Note that VERTEX_DTYPE neighbors size must match NEIGHBORSIZE
VERTEX_DTYPE = np.dtype([('position', '3f4'), ('normal', '3f4'), ('halfedge', 'i4'), ('valence', 'i4'), ('neighbors', '20i4'), ('component', 'i4'),('locally_manifold', 'i4')], align=True)
VERTEX_DTYPE2 = np.dtype([('position0', 'f4'), 
                          ('position1', 'f4'), 
                          ('position2', 'f4'), 
                          ('normal0', 'f4'), 
                          ('normal1', 'f4'), 
                          ('normal2', 'f4'), 
                          ('halfedge', 'i4'), 
                          ('valence', 'i4'), 
                          ('neighbor0', 'i4'),
                          ('neighbor1', 'i4'), 
                          ('neighbor2', 'i4'), 
                          ('neighbor3', 'i4'), 
                          ('neighbor4', 'i4'), 
                          ('neighbor5', 'i4'), 
                          ('neighbor6', 'i4'), 
                          ('neighbor7', 'i4'), 
                          ('neighbor8', 'i4'), 
                          ('neighbor9', 'i4'), 
                          ('neighbor10', 'i4'), 
                          ('neighbor11', 'i4'), 
                          ('neighbor12', 'i4'), 
                          ('neighbor13', 'i4'), 
                          ('neighbor14', 'i4'), 
                          ('neighbor15', 'i4'), 
                          ('neighbor16', 'i4'), 
                          ('neighbor17', 'i4'), 
                          ('neighbor18', 'i4'), 
                          ('neighbor19', 'i4'), 
                          ('component', 'i4'),
                          ('locally_manifold', 'i4')], align=True)

# cdef packed struct halfedge_d:
#     np.int32_t vertex
#     np.int32_t face
#     np.int32_t twin
#     np.int32_t next
#     np.int32_t prev
#     np.float32_t length
#     np.int32_t component
#
# cdef packed struct face_d:
#     np.int32_t halfedge
#     np.float32_t normal0
#     np.float32_t normal1
#     np.float32_t normal2
#     np.float32_t area
#     np.int32_t component
    
# cdef packed struct face_t: #non flattened type from triangle_mesh_utils.h
#     np.int32_t halfedge
#     float normal[VECTORSIZE]
#     float area
#     np.int32_t component

# cdef packed struct vertex_d:
#     np.float32_t position0
#     np.float32_t position1
#     np.float32_t position2
#     np.float32_t normal0
#     np.float32_t normal1
#     np.float32_t normal2
#     np.int32_t halfedge
#     np.int32_t valence
#     np.int32_t neighbor0
#     np.int32_t neighbor1
#     np.int32_t neighbor2
#     np.int32_t neighbor3
#     np.int32_t neighbor4
#     np.int32_t neighbor5
#     np.int32_t neighbor6
#     np.int32_t neighbor7
#     np.int32_t neighbor8
#     np.int32_t neighbor9
#     np.int32_t neighbor10
#     np.int32_t neighbor11
#     np.int32_t neighbor12
#     np.int32_t neighbor13
#     np.int32_t neighbor14
#     np.int32_t neighbor15
#     np.int32_t neighbor16
#     np.int32_t neighbor17
#     np.int32_t neighbor18
#     np.int32_t neighbor19
#     np.int32_t component

# cdef packed struct vertex_t:  # non-flattened version from triangle_mesh_utils.c
#     float position[VECTORSIZE];
#     float normal[VECTORSIZE];
#     np.int32_t halfedge;
#     np.int32_t valence;
#     np.int32_t neighbors[NEIGHBORSIZE];
#     np.int32_t component;

#cdef union halfedge_d:
#ctypedef halfedge_t halfedge_d
#ctypedef face_t face_d
#ctypedef vertex_t vertex_d

    
cdef extern from "triangle_mesh_utils.c":
    void _update_face_normals(np.int32_t *f_idxs, halfedge_t *halfedges, vertex_d *vertices, face_d *faces, signed int n_idxs)
    
    void update_face_normal(int f_idx, halfedge_t *halfedges, vertex_d *vertices, face_d *faces)
    void update_single_vertex_neighbours(int v_idx, halfedge_t *halfedges, vertex_d *vertices, face_d *faces)

LOOP_ALPHA_FACTOR = (np.log(13)-np.log(3))/12


# string key arguments incur a lot of overhead - use index / enums
__insertion_keys = ['vertex', 'halfedge']

DEF INSERTION_KEY_VERTEX = 0
DEF INSERTION_KEY_HALFEDGE = 1

cdef class TrianglesBase(object):
    """
    Base class to let VisGUI layers detect objects which are a bunch of triangles
    
    a derived class should provide suitable attributes/properties for vertices, faces, face_normals,
    and vertex_normals.
    
    See Also: Tesselation class in PYME.recipes.pointcloud
    
    TODO - move me out of here?
    TODO - provide default implementations for face_normals and vertex_normals?
    
    """
    vertices=None
    faces=None
    face_normals=None
    vertex_normals = None
    
    def keys(self):
        """
        returns the names of possible vertex attributes
        """
        raise NotImplementedError('Over-ride in derived class')
    
    def __getitem__(self, item):
        """
        returns a given vertex attribute
        """
        raise NotImplementedError('Over-ride in derived class')

cdef class TriangleMesh(TrianglesBase):

    cdef public object _vertices
    cdef public object _faces
    cdef public object _halfedges
    cdef public object _vertex_vacancies
    cdef public object _face_vacancies
    cdef public object _halfedge_vacancies
    #cdef object _flat_halfedges
    #cdef object _flat_faces
    #cdef object _flat_vertices
    cdef halfedge_t * _chalfedges
    cdef face_d * _cfaces
    cdef vertex_d * _cvertices

    cdef object _faces_by_vertex
    cdef object _loop_subdivision_flip_edges
    cdef object _loop_subdivision_new_vertices

    cdef object _singular_edges
    cdef object _singular_vertices

    cdef public object vertex_properties
    cdef public object extra_vertex_data
    cdef object fix_boundary
    cdef object _manifold

    cdef object _H
    cdef object _K
    

    def __init__(self, vertices=None, faces=None, mesh=None, **kwargs):
        """
        Base class for triangle meshes stored using halfedge data structure. 
        Expects STL-like input.

        Parameters
        ----------
            vertices : np.array
                N x 3 array of Euclidean points.
            faces : np .array
                M x 3 array of vertex indices indicating triangle connectivity.
                Expects STL redundancy.
        """
        if mesh is not None:
            import copy
            
            self._vertices = np.copy(mesh._vertices)
            # Flatten to address cython view problem
            _flat_vertices = self._vertices.view(VERTEX_DTYPE2)
            # Set up c views to arrays
            self._set_cvertices(_flat_vertices)
            self._vertex_vacancies = copy.copy(mesh._vertex_vacancies)

            self._faces = np.copy(mesh._faces)
            _flat_faces = self._faces.view(FACE_DTYPE2)
            # Set up c views to arrays
            self._set_cfaces(_flat_faces)
            self._face_vacancies = copy.copy(mesh._face_vacancies)

            self._halfedges = np.copy(mesh._halfedges)
            self._set_chalfedges(self._halfedges)
            self._halfedge_vacancies = copy.copy(mesh._halfedge_vacancies)
        else:
            self._vertices = np.zeros(vertices.shape[0], dtype=VERTEX_DTYPE)
            # Flatten to address cython view problem
            _flat_vertices = self._vertices.view(VERTEX_DTYPE2)
            # Set up c views to arrays
            #print self._flat_vertices.shape
            self._set_cvertices(_flat_vertices)
            self._vertices[:] = -1  # initialize everything to -1 to start with
            self._vertices['position'] = vertices
            self._vertex_vacancies = []

            self._faces = None  # Contains a pointer to one halfedge associated with each face
            self._face_vacancies = []

            # Halfedges
            self._halfedges = None
            self._halfedge_vacancies = []
            
            print('initializing halfedges ...')
            print('vertices.shape = %s, faces.shape = %s' % (vertices.shape, faces.shape))
            if vertices.shape[0] >= MAX_VERTEX_COUNT:
                raise RuntimeError('Maximum vertex count is %d, mesh has %d' % (MAX_VERTEX_COUNT, vertices.shape[0]))
            self._initialize_halfedges(vertices, faces)
            print('done initializing halfedges')

        # Representation of faces by triplets of vertices
        self._faces_by_vertex = None
        self._H = None
        self._K = None

        # loop subdivision vars
        self._loop_subdivision_flip_edges = []
        self._loop_subdivision_new_vertices = []

        # Singular edges
        self._singular_edges = None
        self._singular_vertices = None

        # Populate the normals
        #print('populating face normals')
        self.face_normals
        #print('populating vertex normals')
        self.vertex_normals
        #print('done populating normals')

        # Properties we can visualize
        self.vertex_properties = ['x', 'y', 'z', 'component', 'boundary', 'singular', 'curvature_mean', 'curvature_gaussian']
        
        self.extra_vertex_data = {}

        self.fix_boundary = True  # Hold boundary edges in place

        # Is the mesh manifold?
        self._manifold = None

        # Curvatures
        self._H = None
        self._K = None

        # Set fix_boundary, etc.
        for key, value in kwargs.items():
            setattr(self, key, value)

    def __getitem__(self, k):
        # this defers evaluation of the properties until we actually access them, 
        # as opposed to the mappings which stored the values on class creation.
        try:
            res = getattr(self, k)
        except AttributeError:
            try:
                res = self.extra_vertex_data[k]
            except KeyError:
                raise KeyError('Key %s not defined' % k)
        
        return res

    def __copy__(self):
        return type(self)(mesh=self)

    @classmethod
    def from_stl(cls, filename, **kwargs):
        """
        Read from an STL file.
        """
        from PYME.IO.FileUtils import stl

        # Load an STL from file
        triangles_stl = stl.load_stl_binary(filename)

        # Call from_np_stl on the file stream
        return cls.from_np_stl(triangles_stl, **kwargs)

    @classmethod
    def from_ply(cls, filename, **kwargs):
        """
        Read from PLY file.
        """
        from PYME.IO.FileUtils import ply

        # Load a PLY from file
        vertices, faces, _ = ply.load_ply(filename)

        return cls(vertices, faces, **kwargs)

    @classmethod
    def from_np_stl(cls, triangles_stl, **kwargs):
        """
        Read from an already-loaded STL stream.
        """
        vertices_raw = np.vstack((triangles_stl['vertex0'], 
                                  triangles_stl['vertex1'], 
                                  triangles_stl['vertex2']))
        vertices, faces_raw = np.unique(vertices_raw, 
                                        return_inverse=True, 
                                        axis=0)
        faces = faces_raw.reshape(faces_raw.shape[0] // 3, 3, order='F')

        print('Data munged to vertices, faces')
        return cls(vertices, faces, **kwargs)

    @property
    def x(self):
        return self.vertices[:,0]
        
    @property
    def y(self):
        return self.vertices[:,1]
        
    @property
    def z(self):
        return self.vertices[:,2]

    @property
    def curvature_mean(self):
        if self._H is None:
            self.calculate_curvatures()
        return self._H
    
    @property
    def curvature_gaussian(self):
        if self._K is None:
            self.calculate_curvatures()
        return self._K

    @property
    def component(self):
        # if np.all(self._vertices['component'] == -1):
        self.find_connected_components()
        return self._vertices['component']

    @property
    def vertices(self):
        return self._vertices['position']

    @property
    def faces(self):
        """
        Returns faces by vertex for rendering and STL applications.
        """
        if self._faces_by_vertex is None:
            faces = self._faces['halfedge'][self._faces['halfedge'] != -1]
            v0 = self._halfedges['vertex'][self._halfedges['prev'][faces]]
            v1 = self._halfedges['vertex'][faces]
            v2 = self._halfedges['vertex'][self._halfedges['next'][faces]]
            self._faces_by_vertex = np.vstack([v0, v1, v2]).T
        return self._faces_by_vertex

    @property
    def boundary(self):
        nn = self._vertices['neighbors']
        nn_mask = (nn!=-1)
        return np.any((self._halfedges['twin'][nn] == -1)*nn_mask, axis=1)

    @property
    def singular(self):
        self._singular_edges = None
        self._singular_vertices = None
        singular_vertices = np.zeros_like(self._vertices['halfedge'])
        if len(self.singular_vertices) > 0:
            singular_vertices[np.array(self.singular_vertices)] = 1
        return singular_vertices

    @property
    def singular_edges(self):
        """
        Get a list of singular edges. A singular edge is any edge shared by
        more than two faces.
        """
        if self._singular_edges is None:
            edges = np.vstack([self._halfedges['vertex'], self._halfedges[self._halfedges['prev']]['vertex']]).T
            edges = edges[edges[:,0] != -1]  # Drop non-edges
            # packed_edges = pack_edges(edges)
            packed_edges = np.sort(edges, axis=1)
            e, c = np.unique(packed_edges, return_counts=True, axis=0)
            singular_packed_edges = e[c>2]
            singular_edges = []
            for singular_packed_edge in singular_packed_edges:
                singular_edges.extend(list(np.where(packed_edges[:, None] == singular_packed_edge)[0]))

            singular_edges.extend(self._halfedges['twin'][singular_edges])
            self._singular_edges = list(set(singular_edges) - set([-1]))

        return self._singular_edges

    @property
    def singular_vertices(self):
        """
        Get a list of singular vertices. This includes endpoints of singular 
        edges, and isolated singular vertices. Isolated singular vertices
        have more than one 1-neighbor ring.
        """
        cdef int _vertex, n_incident, n_neighbors, n_vertices, n_halfedges, j, v
        cdef int [:] n_incident_v
        
        if self._singular_vertices is None:
            # Mark vertices that are endpoints of these edges
            singular_vertices = list(set(list(np.hstack([self._halfedges['vertex'][self.singular_edges], self._halfedges['vertex'][self._halfedges['twin'][self.singular_edges]]]))))
            
            # Mark isolated singular vertices
            
            # run through all the halfedges and compute a vertex incidence table
            n_halfedges = self._halfedges.shape[0]
            n_vertices = self._vertices.shape[0]
            n_incident_v = np.zeros(n_vertices, 'i')
            
            for j in range(n_halfedges):
                v = self._chalfedges[j].vertex
                if v != -1:
                    n_incident_v[v] += 1
            
            for _vertex in range(n_vertices):
                if self._cvertices[_vertex].halfedge == -1:
                    continue

                # If the number of elements in the 1-neighbor ring does not match 
                # the number of halfedges pointing to a vertex, we have an isolated
                # singular vertex (note this requires the C code version of
                # update_vertex_neighbors, which reverses direction upon hitting
                # an edge to ensure a more accurate neighborhood)
                n_incident = n_incident_v[_vertex]
                n_neighbors = np.count_nonzero(self._vertices['neighbors'][_vertex] != -1)
                if n_neighbors != n_incident:
                    singular_vertices.append(_vertex)

            # Remove duplicates
            self._singular_vertices = list(set(singular_vertices) - set([-1]))

        return self._singular_vertices

    @property
    def face_normals(self):
        """
        Return the normal of each triangular face.
        """
        if np.all(self._faces['normal'] == -1):
            triangle_mesh_utils.c_update_face_normals(list(np.arange(len(self._faces)).astype(np.int32)), self._halfedges, self._vertices, self._faces)
        return self._faces['normal'][self._faces['halfedge'] != -1]

    @property
    def face_areas(self):
        """
        Return the area of each triangular face.
        """
        if np.all(self._faces['area'] == -1):
            self._faces['normal'][:] = -1
            self.face_normals
        return self._faces['area']
    
    @property
    def vertex_neighbors(self):
        """
        Return the up to NEIGHBORSIZE neighbors of each vertex.
        """
        if np.all(self._vertices['neighbors'] == -1):
            triangle_mesh_utils.c_update_vertex_neighbors(list(np.arange(len(self._vertices)).astype(np.int32)), self._halfedges, self._vertices, self._faces)

        return self._vertices['neighbors']

    @property
    def vertex_normals(self):
        """
        Return the normal of each vertex.
        """
        if np.all(self._vertices['normal'] == -1):
            self._vertices['neighbors'][:] = -1
            self.vertex_neighbors
        return self._vertices['normal']

    @property
    def valences(self):
        """
        Return the valence of each vertex.
        """
        if np.all(self._vertices['valence'] == -1):
            self._vertices['neighbors'][:] = -1
            self.vertex_neighbors
        return self._vertices['valence']

    @property
    def manifold(self):
        """
        Checks if the mesh is manifold: Is every edge is shared by exactly two 
        triangles?

        TODO: Check that we don't have any isolated singular vertices, which 
        also make the mesh non-manifold.
        """

        if self._manifold is None:
            self._singular_edges = None
            self._singular_vertices = None
            vertex_mask = (self._halfedges['vertex'] != -1)
            twin_mask = (self._halfedges['twin'] == -1)
            boundary_check = ((np.flatnonzero(vertex_mask & twin_mask).size) == 0)
            self._manifold = (len(self.singular_vertices) == 0) & boundary_check

        return self._manifold

    def keys(self):
        return list(self.vertex_properties) + list(self.extra_vertex_data.keys())

    
    @cython.boundscheck(False)  # Deactivate bounds checking
    @cython.wraparound(False)
    cdef _set_chalfedges(self, halfedge_t[:] halfedges):
        self._chalfedges = &halfedges[0]

    @cython.boundscheck(False)  # Deactivate bounds checking
    @cython.wraparound(False)
    cdef _set_cfaces(self, face_d[:] faces):
        self._cfaces = &faces[0]

    @cython.boundscheck(False)  # Deactivate bounds checking
    @cython.wraparound(False)
    cdef _set_cvertices(self, vertex_d[:] vertices):
        #print vertices.shape
        self._cvertices = &vertices[0]

    def _initialize_halfedges(self, vertices, faces):
        """
        Accepts unordered vertices, indices parameterization of a triangular 
        mesh from an STL file and converts to topologically-connected halfedge
        representation.

        Parameters
        ----------
            vertices : np.array
                N x 3 array of Euclidean points.
            faces : np .array
                M x 3 array of vertex indices indicating triangle connectivity. 
                Expects STL redundancy.
        """
        if vertices is not None and faces is not None:
            # Unordered halfedges
            edges = np.vstack([faces[:,[0,1]], faces[:,[1,2]], faces[:,[2,0]]])

            # Now order them...
            n_faces = len(faces)
            n_edges = len(edges)
            j = np.arange(n_faces)
            
            self._halfedges = np.zeros(n_edges, dtype=HALFEDGE_DTYPE)
            self._set_chalfedges(self._halfedges)

            self._halfedges[:] = -1  # initialize everything to -1 to start with

            self._halfedges['vertex'] = edges[:, 1]
            
            self._faces = np.zeros(n_faces, dtype=FACE_DTYPE)
            # Flatten to address cython view problem
            _flat_faces = self._faces.view(FACE_DTYPE2)
            # Set up c views to arrays
            self._set_cfaces(_flat_faces)
            self._faces[:] = -1  # initialize everything to -1 to start with

            # Sort the edges lo->hi so we can arrange them uniquely
            # Convert to list of tuples for use with dictionary
            edges_packed = [tuple(e) for e in np.sort(edges, axis=1)]


            print('iterating edges')
            # Use a dictionary to keep track of which edges are already assigned twins
            d = {}
            for i, e in enumerate(edges_packed):
                if e in d:
                    idx = d.pop(e)
                    if self._halfedges['vertex'][idx] == self._halfedges['vertex'][i]:
                        # Don't assign a halfedge to multivalent edges
                        continue
                        
                    self._halfedges['twin'][idx] = i
                    self._halfedges['twin'][i] = idx
                else:
                    d[e] = i

            self._halfedges['face'] = np.hstack([j, j, j])
            self._halfedges['next'] = np.hstack([j+n_faces, j+2*n_faces, j])
            self._halfedges['prev'] = np.hstack([j+2*n_faces, j, j+n_faces])
            self._halfedges['length'] = np.linalg.norm(self._vertices['position'][self._halfedges['vertex']] - self._vertices['position'][self._halfedges['vertex'][self._halfedges['prev']]], axis=1)
            
            # Set the vertex halfedges (multiassignment, but should be fine)
            self._vertices['halfedge'][self._halfedges['vertex']] = self._halfedges['next']

            self._faces['halfedge'] = j  # Faces are defined by associated halfedges
        else:
            raise ValueError('Mesh does not contain vertices and faces.')

    @cython.boundscheck(False)  # Deactivate bounds checking
    @cython.wraparound(False)
    def _update_face_normals(self, f_idxs):
        """
        Recompute len(f_idxs) face normals.

        Parameters
        ----------
        f_idxs : list or np.array
            List of face indices to recompute.
        """

        if isinstance(f_idxs, list):
            f_idxs = np.int32(f_idxs)
        #triangle_mesh_utils.c_update_face_normals(f_idxs, self._halfedges, self._vertices, self._faces)
        cdef np.int32_t [:] idxs = f_idxs
        
        _update_face_normals(&(idxs[0]), self._chalfedges, self._cvertices, self._cfaces, idxs.shape[0])

    def _update_vertex_neighbors(self, v_idxs):
        """
        Recalculate len(v_idxs) vertex neighbors/normals.

        Parameters
        ----------
            v_idxs : list or np.array
                List of vertex indicies indicating which vertices to update.
        """

        if isinstance(v_idxs, list):
            v_idxs = np.int32(v_idxs)
        triangle_mesh_utils.c_update_vertex_neighbors(v_idxs, self._halfedges, self._vertices, self._faces)

    def _resize(self, vec, axis=0, return_orig=False, skip_entries=False, key=None):
        """
        Increase the size of an input vector 1.5x, keeping all active data.

        Parameters
        ---------
            vec : np.array
                Vector to expand, -1 stored in unused entries.
            axis : int
                Axis (0 or 1) along which to resize vector (only works for 2D 
                arrays).
            return_orig : bool
                Return indices of non-negative-one entries in the array prior 
                to resize.
            key : string
                Optional array key on which to check for -1 value.
        """

        if (axis > 1) or (len(vec.shape) > 2):
            raise NotImplementedError('This function only works for 2D arrays along axes 0 and 1.')

        # Increase the size 1.5x along the axis.
        dt = vec.dtype
        new_size = np.array(vec.shape)
        new_size[axis] = int(1.5*new_size[axis] + 0.5)
        new_size = tuple(new_size)
        
        # Allocate memory for new array
        new_vec = np.empty(new_size, dtype=dt)

        # Assign values to the new array
        new_vec[:] = -1

        if skip_entries:
            # Check for invalid entries
            if key:
                copy_mask = (vec[key] != 1)
            else:
                copy_mask = (vec != -1)
            
            if len(copy_mask.shape) > 1:
                copy_mask = np.any(copy_mask, axis=(1-axis))
                copy_size = np.flatnonzero(copy_mask).size
            else:
                copy_size = np.flatnonzero(copy_mask).size

            if axis:
                new_vec[:,:copy_size] = vec[:, copy_mask]
            else:
                new_vec[:copy_size] = vec[copy_mask]

            # Return positions of non-negative-1 entries prior to re-ordering
            if return_orig:
                _orig = np.where(copy_mask)[0]
                # Return empty list if original values are all at the same place
                if np.all(_orig == np.arange(len(_orig))):
                    _orig = []
                return new_vec, _orig

            return new_vec
        else:
            # We're not skipping entries
            if axis:
                copy_size = vec.shape[1]
                new_vec[:,:copy_size] = vec
            else:
                copy_size = vec.shape[0]
                new_vec[:copy_size] = vec
                
            if return_orig:
                return new_vec, []
    
            # Update array
            return new_vec

    def calculate_curvatures(self):
        dN = 0.1
        self._H = np.zeros(self._vertices.shape[0])
        self._K = np.zeros(self._vertices.shape[0])
        I = np.eye(3)
        areas = np.zeros(self._vertices.shape[0])
        for iv in range(self._vertices.shape[0]):
            if self._vertices['halfedge'][iv] == -1:
                continue

            # Vertex and its normal
            vi = self._vertices['position'][iv,:]
            Nvi = self._vertices['normal'][iv,:]

            p = I - Nvi[:,None]*Nvi[None,:] # np.outer(Nvi, Nvi)
                
            # vertex nearest neighbors
            neighbors = self._vertices['neighbors'][iv]
            neighbor_mask = (neighbors != -1)
            neighbor_vertices = self._halfedges['vertex'][neighbors]
            vjs = self._vertices['position'][neighbor_vertices[neighbor_mask]]

            # Neighbor vectors & displaced neighbor tangents
            dvs = vjs - vi[None,:]

            # radial weighting
            r_sum = np.sum(1./np.sqrt((dvs*dvs).sum(1)))

            # Norms
            dvs_norm = np.sqrt((dvs*dvs).sum(1))

            # Hats
            dvs_hat = dvs/dvs_norm[:,None]

            # Tangents
            T_thetas = np.dot(p,-dvs.T).T
            Tijs = T_thetas/np.sqrt((T_thetas*T_thetas).sum(1)[:,None])
            Tijs[np.sum(T_thetas,axis=1) == 0, :] = 0

            # Edge normals subtracted from vertex normals
            Ni_diffs = np.sqrt(2. - 2.*np.sqrt(1.-((Nvi[None,:]*dvs_hat).sum(1))**2))

            k = 2.*np.sign((Nvi[None,:]*dvs).sum(1))*Ni_diffs/dvs_norm
            w = (1./dvs_norm)/r_sum

            Mvi = (w[None,:,None]*k[None,:,None]*Tijs.T[:,:,None]*Tijs[None,:,:]).sum(axis=1)

            # Solve the eigenproblem in closed form
            m00 = Mvi[0,0]
            m01 = Mvi[0,1]
            m02 = Mvi[0,2]
            m11 = Mvi[1,1]
            m12 = Mvi[1,2]
            m22 = Mvi[2,2]

            # Here we use the fact that Mvi is symnmetric and we know
            # one of the eigenvalues must be 0
            p = -m00*m11 - m00*m22 + m01*m01 + m02*m02 - m11*m22 + m12*m12
            q = m00 + m11 + m22
            r = np.sqrt(4*p + q*q)
            
            # Eigenvalues
            l1 = 0.5*(q-r)
            l2 = 0.5*(q+r)

            k_1 = 3.*l1 - l2 #e[0] - e[1]
            k_2 = 3.*l2 - l1 #e[1] - e[0]
            self._H[iv] = 0.5*(k_1 + k_2)
            self._K[iv] = k_1*k_2
            
        #self._H = self.smooth_per_vertex_data(self._H)
        #self._K = self.smooth_per_vertex_data(self._K)
        
    def smooth_per_vertex_data(self, data):
        # replace a vertex value with the average of that value and it's neighbours. TODO - add some form of weighting
        out = np.zeros_like(data)
        for iv in range(self._vertices.shape[0]):
            # Vertex position
            #vi = self._vertices['position'][iv,:]
                
            # vertex nearest neighbors
            neighbors = self._vertices['neighbors'][iv]
            neighbor_vertices = self._halfedges['vertex'][neighbors[neighbors != -1]]
            
            #vjs = self._vertices['position'][neighbor_vertices]
            
            #TODO add weightings ...
            out[iv] = (data[iv] + data[neighbor_vertices].sum())/float(1 + len(neighbor_vertices))
            
        return out
            

    cdef bint _check_neighbour_twins(self, int vertex_id):
        cdef int i
        cdef np.int32_t *neighbours = &(self._cvertices[vertex_id].neighbor0)
        for i in range(NEIGHBORSIZE):
            nn = neighbours[i]
            if (nn != -1) and (self._chalfedges[nn].twin == -1):
                return 0
            
        return 1
    
    cdef bint _check_collapse_fast(self, int _live_vertex, int _dead_vertex):
        cdef int i, j, ln, dn, lv
        cdef np.int32_t *live_neighbours = &(self._cvertices[_live_vertex].neighbor0)
        cdef np.int32_t *dead_neighbours = &(self._cvertices[_dead_vertex].neighbor0)
        
        cdef np.int32_t dead_vertex_neighbours[NEIGHBORSIZE]
        cdef np.int32_t dead_halfedges[NEIGHBORSIZE]
        
        for i in range(NEIGHBORSIZE):
            dn = dead_neighbours[i]
                
            if (dn != -1):
                dead_halfedges[i] = dn
                dead_vertex_neighbours[i] = self._chalfedges[dn].vertex
                
        cdef int shared_vertex_count = 0
        
        for i in range(NEIGHBORSIZE):
            ln = live_neighbours[i]
            lv =  self._chalfedges[ln].vertex
            for j in range(NEIGHBORSIZE):
                if (lv == dead_vertex_neighbours[j]):
                    shared_vertex_count +=1
                
        if shared_vertex_count !=2:
            return 0
                
        for dn in dead_halfedges:
            self._chalfedges[dn].vertex = _live_vertex
        
        return 1
    
    cdef bint _check_collapse_slow(self, int _live_vertex, int _dead_vertex):
        cdef int i, ln, dn, n_edges
        #cdef np.int32_t *live_neighbours = &(self._cvertices[_live_vertex].neighbor0)
        #cdef np.int32_t *dead_neighbours = &(self._cvertices[_dead_vertex].neighbor0)
        
        n_edges = self._halfedges.shape[0]
        
        dead_vertex_neighbours = []
        dead_halfedges = []
        
        for i in range(n_edges):
            if (self._chalfedges[i].vertex == _dead_vertex):
                dead_halfedges.append(i)
                if (self._chalfedges[i].twin != -1):
                    dead_vertex_neighbours.append(self._chalfedges[i].twin)
                
        cdef int shared_vertex_count = 0
        
        for i in range(n_edges):
            if (self._chalfedges[i].vertex == _live_vertex) and (self._chalfedges[i].twin != -1):
                ln = self._chalfedges[self._chalfedges[i].twin].vertex
                
                if ln in dead_vertex_neighbours:
                    shared_vertex_count +=1
                
                
        if shared_vertex_count !=2:
            return 0
                
        for dn in dead_halfedges:
            self._chalfedges[dn].vertex = _live_vertex
        
        return 1
    
    def edge_collapse(self, np.int32_t _curr, bint live_update=1):
        """
        A.k.a. delete two triangles. Remove an edge, defined by halfedge _curr,
        and its associated triangles, while keeping mesh connectivity.

        Parameters
        ----------
            _curr: int
                Pointer to halfedge defining edge to collapse.
            live_update : bool
                Update associated faces and vertices after collapse. Set to 
                False to handle this externally (useful if operating on 
                multiple, disjoint edges).
        """

        cdef halfedge_t *curr_halfedge
        cdef halfedge_t *twin_halfedge
        cdef np.int32_t _prev, _twin, _next, _prev_twin, _prev_twin_vertex, _next_prev_twin, _next_prev_twin_vertex, _twin_next_vertex, _next_twin_twin_next, _next_twin_twin_next_vertex, vl, vd, _dead_vertex, _live_vertex, vn, vtn, face0, face1, face2, face3
        cdef bint fast_collapse_bool, interior

        if _curr == -1:
            return

        # Create the pointers we need
        curr_halfedge = &self._chalfedges[_curr]
        _prev = curr_halfedge.prev
        _next = curr_halfedge.next
        _twin = curr_halfedge.twin

        if (self._chalfedges[_next].twin == -1) or (self._chalfedges[_prev].twin == -1):
            # Collapsing this edge will create another free edge
            return

        interior = (_twin != -1)  # Are we on a boundary?

        if interior:
            #nn = self._vertices['neighbors'][curr_halfedge.vertex]
            #nn_mask = (nn != -1)
            #if (-1 in self._halfedges['twin'][nn]*nn_mask):
            #    return
            
            if not self._check_neighbour_twins(curr_halfedge.vertex):
                return

            #nn = self._vertices['neighbors'][self._halfedges['vertex'][_twin]]
            #nn_mask = (nn != -1)
            #if (-1 in self._halfedges['twin'][nn]*nn_mask):
            #    return
            
            if not self._check_neighbour_twins(self._chalfedges[_twin].vertex):
                return

            twin_halfedge = &self._chalfedges[_twin]
            _twin_prev = twin_halfedge.prev
            _twin_next = twin_halfedge.next

            if (self._chalfedges[_twin_prev].twin == -1) or (self._chalfedges[_twin_next].twin == -1):
                # Collapsing this edge will create another free edge
                return 

        _dead_vertex = self._chalfedges[_prev].vertex
        _live_vertex = curr_halfedge.vertex

        # Grab the valences of the 4 points near the edge
        if interior:
            vn, vtn = self._cvertices[self._chalfedges[_next].vertex].valence, self._cvertices[self._chalfedges[_twin_next].vertex].valence

            # Make sure we create no vertices of valence <3 (manifoldness)
            # ((vl + vd - 3) < 4) or 
            if (vn < 4) or (vtn < 4):
                return

        vl, vd = self._cvertices[_live_vertex].valence, self._cvertices[_dead_vertex].valence
        
        if ((vl + vd - 3) < 4):
            return
        
        cdef bint locally_manifold = self._cvertices[_live_vertex].locally_manifold and self._cvertices[_dead_vertex].locally_manifold

        # Check for creation of multivalent edges and prevent this (manifoldness)
        fast_collapse_bool = (locally_manifold and (vl < NEIGHBORSIZE) and (vd < NEIGHBORSIZE))
        if fast_collapse_bool:
            # Do it the fast way if we can
            live_nn = self._vertices['neighbors'][_live_vertex]
            dead_nn =  self._vertices['neighbors'][_dead_vertex]
            live_mask = (live_nn != -1)
            dead_mask = (dead_nn != -1)
            live_list = self._halfedges['vertex'][live_nn[live_mask]]
            dead_list = self._halfedges['vertex'][dead_nn[dead_mask]]
        else:
            twin_mask = (self._halfedges['twin'] != -1)
            dead_mask = (self._halfedges['vertex'] == _dead_vertex)
            dead_list = self._halfedges['vertex'][self._halfedges['twin'][dead_mask & twin_mask]]
            live_list = self._halfedges['vertex'][self._halfedges['twin'][(self._halfedges['vertex'] == _live_vertex) & twin_mask]]

        twin_list = list((set(dead_list) & set(live_list)) - set([-1]))
        if len(twin_list) != 2:
            return

        # Collapse to the midpoint of the original edge vertices
        if fast_collapse_bool:
            self._halfedges['vertex'][self._halfedges['twin'][dead_nn[dead_mask]]] = _live_vertex
        else:
            self._halfedges['vertex'][dead_mask] = _live_vertex
        
        # if fast_collapse_bool:
        #     if not self._check_collapse_fast(_live_vertex, _dead_vertex):
        #         return
        # else:
        #     if not self._check_collapse_slow(_live_vertex, _dead_vertex):
        #         return
        
        _live_pos = self._vertices['position'][_live_vertex]
        _dead_pos = self._vertices['position'][_dead_vertex]
        self._vertices['position'][_live_vertex] = 0.5*(_live_pos + _dead_pos)
        
        # update valence of vertex we keep
        self._cvertices[_live_vertex].valence = vl + vd - 3
        
        # delete dead vertex
        self._vertices[_dead_vertex] = -1
        self._vertex_vacancies.append(_dead_vertex)

        # Zipper the remaining triangles
        self._zipper(_next, _prev)
        if interior:
            self._zipper(_twin_next, _twin_prev)
        # We need some more pointers
        # TODO: make these safer
        _prev_twin = self._chalfedges[_prev].twin
        _prev_twin_vertex = self._chalfedges[_prev_twin].vertex
        _next_prev_twin = self._chalfedges[_prev_twin].next
        _next_prev_twin_vertex = self._chalfedges[_next_prev_twin].vertex
        if interior:
            _twin_next_vertex = self._chalfedges[_twin_next].vertex
            _next_twin_twin_next = self._chalfedges[self._chalfedges[_twin_next].twin].next
            _next_twin_twin_next_vertex = self._chalfedges[_next_twin_twin_next].vertex
            
        # Make sure we have good _vertex_halfedges references
        self._cvertices[_live_vertex].halfedge = _prev_twin
        self._cvertices[_prev_twin_vertex].halfedge = _next_prev_twin
        if interior:
            self._cvertices[_twin_next_vertex].halfedge = self._chalfedges[_twin_next].twin
            self._cvertices[_next_twin_twin_next_vertex].halfedge = self._chalfedges[_next_twin_twin_next].next

        # Grab faces to update
        face0 = self._chalfedges[self._chalfedges[_next].twin].face
        face1 = self._chalfedges[self._chalfedges[_prev].twin].face
        if interior:
            face2 = self._chalfedges[self._chalfedges[_twin_next].twin].face
            face3 = self._chalfedges[self._chalfedges[_twin_prev].twin].face

        # Delete the inner triangles
        self._face_delete(_curr)
        if interior:
            self._face_delete(_twin)

        try:
            if live_update:
                if interior:
                    # Update faces
                    #self._update_face_normals([face0, face1, face2, face3])
                    #self._update_vertex_neighbors([_live_vertex, _prev_twin_vertex, _next_prev_twin_vertex, _twin_next_vertex])
                    
                    update_face_normal(face0, self._chalfedges, self._cvertices, self._cfaces)
                    update_face_normal(face1, self._chalfedges, self._cvertices, self._cfaces)
                    update_face_normal(face2, self._chalfedges, self._cvertices, self._cfaces)
                    update_face_normal(face3, self._chalfedges, self._cvertices, self._cfaces)
                    
                    update_single_vertex_neighbours(_live_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    update_single_vertex_neighbours(_prev_twin_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    update_single_vertex_neighbours(_next_prev_twin_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    update_single_vertex_neighbours(_twin_next_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    
                else:
                    #self._update_face_normals([face0, face1])
                    #self._update_vertex_neighbors([_live_vertex, _prev_twin_vertex, _next_prev_twin_vertex])
                    
                    update_face_normal(face0, self._chalfedges, self._cvertices, self._cfaces)
                    update_face_normal(face1, self._chalfedges, self._cvertices, self._cfaces)
                    
                    update_single_vertex_neighbours(_live_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    update_single_vertex_neighbours(_prev_twin_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    update_single_vertex_neighbours(_next_prev_twin_vertex, self._chalfedges, self._cvertices, self._cfaces)
                    
                self._faces_by_vertex = None
                self._H = None
                self._K = None
        
        except RuntimeError as e:
            print(_curr, _twin, _next, _prev, _twin_next, _twin_prev, _next_prev_twin, _next_twin_twin_next, _prev_twin)
            print([_live_vertex, _prev_twin_vertex, _next_prev_twin_vertex, _twin_next_vertex])
            raise e

    cdef _face_delete(self, np.int32_t _edge):
        """
        Delete a face defined by the halfedge _edge.

        Note that this does not account for adjusting halfedges, twins.

        Parameters
        ----------
            edge : int
                One self._halfedge index of the edge defining a face to delete.
        """
        cdef halfedge_t *curr_edge
        
        if _edge == -1:
            return -1
        
        curr_edge = &self._chalfedges[_edge]
        if curr_edge.vertex == -1:
            return -1
        
        self._cfaces[curr_edge.face].halfedge = -1
        self._cfaces[curr_edge.face].normal0 = -1
        self._cfaces[curr_edge.face].normal1 = -1
        self._cfaces[curr_edge.face].normal2 = -1
        self._cfaces[curr_edge.face].area = -1
        self._cfaces[curr_edge.face].component = -1

        self._face_vacancies.append(curr_edge.face)
        
        self._edge_delete(curr_edge.next)
        self._edge_delete(curr_edge.prev)
        self._edge_delete(_edge)

    cdef _edge_delete(self, np.int32_t _edge):
        """
        Delete edge _edge in place from self._halfedges.

        Note that this does not account for adjusting halfedges, twins.

        Parameters
        ----------
            edge : int
                One self._halfedge index of the edge to delete.
        """
        if (_edge == -1):
            return -1
        
        self._chalfedges[_edge].vertex = -1
        self._chalfedges[_edge].face = -1
        self._chalfedges[_edge].twin = -1
        self._chalfedges[_edge].next = -1
        self._chalfedges[_edge].prev = -1
        self._chalfedges[_edge].length = -1
        self._chalfedges[_edge].component = -1

        self._halfedge_vacancies.append(_edge)

        self._faces_by_vertex = None
        self._H = None
        self._K = None

    def _get_insertion_slot(self, el_arr, el_vacancies, key_idx, compact=False):
        """ get an empty slot to insert into, resizing if needed"""
        cdef int idx
        
        try:
            idx = el_vacancies.pop(-1)
        except IndexError:
            # no vacant slot, resize
            key = __insertion_keys[key_idx]
            el_arr = self._resize(el_arr, skip_entries=compact, key=key)
            #TODO - invalidate neighbours, vertex_halfedges etc ???
            
            # NOTE: If we search by a different key next time, el_vacancies will
            # still contain the vacant positions when searching on the previous key.
            if len(el_arr[key].shape) > 1:
                # NOTE: If we search on self._vertices['position'] and one position is [-1,-1,-1],
                # which is not unreasonable, this will replace that vertex. Hence we provide the
                # option to search and insert on different keys.
                el_vacancies = [int(x) for x in np.argwhere(np.all(el_arr[key] == -1, axis=1))]
            else:
                # el_vacancies = [int(x) for x in np.flatnonzero(el_arr[key] == -1)]
                el_vacancies = np.flatnonzero(el_arr[key] == -1).tolist()

            idx = el_vacancies.pop(-1)

        if idx == -1:
            raise ValueError('Index cannot be -1.')
        
        return idx, el_arr, el_vacancies
    
    def _insert(self, el, el_arr, el_vacancies, int key, bint compact=False, insert_key=None, **kwargs):
        """
        Insert an element into an array at the position of the smallest empty 
        entry when searching the array by key.

        Parameters
        ----------
            el 
                Element to add to the array. Must be one of the dtypes in the 
                structured dtype of el_arr.
            el_arr : np.array
                Array where we add the element
            el_vacancies : list
                External list where we keep empty positions of el_arr.
            key : string
                Key on which to search the array
            insert_key : string
                Key on which to insert element el. This is by default the 
                search key.
            compact : bool
                Do we copy -1 values in the resize of el_arr?
            kwargs 
                List of dtype parameters to additionally define el.

        Returns
        -------
            ed
                Element added, includes el stored in full structured dtype of
                el_arr.
            idx : int
                Index of el_arr where ed is stored.
            el_arr : np.array
                Modified array containing ed.
            el_vacancies : list
                Modified list of el_arr vacancies.
        """
        
        idx, el_arr, el_vacancies = self._get_insertion_slot(el_arr, el_vacancies, key, compact)

        if insert_key is None:
            # Default to searching and inserting on the same key
            insert_key = __insertion_keys[key]

        # Put el in el_arr
        ed = el_arr[idx]
        ed[insert_key] = el
        # Define additional structured dtype values for el
        for k, v in kwargs.items():
            ed[k] = v
            
        return ed, idx, el_arr, el_vacancies
 
    def _insert_new_edge(self, int vertex, int prev=-1, int next=-1, int face=-1, int twin=-1):
        cdef int idx
        idx, self._halfedges, self._halfedge_vacancies = self._get_insertion_slot(self._halfedges, self._halfedge_vacancies, key_idx=INSERTION_KEY_VERTEX)
        self._set_chalfedges(self._halfedges)
        
        self._chalfedges[idx].vertex = vertex
        self._chalfedges[idx].prev = prev
        self._chalfedges[idx].next = next
        self._chalfedges[idx].face = face
        self._chalfedges[idx].twin = twin
        
        return idx
 
    def _new_edge(self, int vertex, compact=False, **kwargs):
        """
        Create a new edge.

        Parameters
        ----------
            vertex : idx
                self._vertices index which this halfedge points to
            compact : bool
                Do we copy -1 values in the resize of _halfedges?
            kwargs 
                List of _halfedge dtype parameters (e.g. prev=10, next=2) to 
                define halfedge via more than just its vertex.

        Returns
        -------
            ed : HALFEDGE_DTYPE
                Halfedge created
            idx : int
                Index of the halfedge in self._halfedges.
        """

        #ed, idx, self._halfedges, self._halfedge_vacancies = self._insert(vertex, self._halfedges, self._halfedge_vacancies, 'vertex', compact, None, **kwargs)
        #self._set_chalfedges(self._halfedges)
        
        cdef int idx
        
        idx = self._insert_new_edge(vertex, compact, **kwargs)
        
        ed = self._halfedges[idx]
        return ed, idx

    def _new_face(self, int _edge, bint compact=False, **kwargs):
        """
        Create a new face based on edge _edge.

        Parameters
        ----------
            _edge : idx
                self._halfedges index of a single halfedge on this face
            compact : bool
                Do we copy -1 values in the resize of _faces?
            kwargs 
                List of _faces dtype parameters (e.g. area=13.556) to define 
                face via more than just one of its halfedges.

        Returns
        -------
            fa : FACE_DTYPE
                Face created
            idx : int
                Index of the face in self._faces.
        """
        cdef int idx
        
        fa, idx, self._faces, self._face_vacancies = self._insert(_edge, self._faces, self._face_vacancies, key=INSERTION_KEY_HALFEDGE, compact=compact, **kwargs)
        _flat_faces = self._faces.view(FACE_DTYPE2)
        self._set_cfaces(_flat_faces)

        return fa, idx

    def _new_vertex(self, _vertex, bint compact=False, **kwargs):
        """
        Insert a new vertex into the mesh.

        Parameters
        ----------
            _vertex : np.array
                1D array of x, y, z coordinates of the new vertex.
            compact : bool
                Do we copy -1 values in the resize of _vertices?
            kwargs 
                List of _vertices dtype parameters (e.g. valence=2) to define 
                vertex via more than just its position.

        Returns
        -------
            vx : VERTEX_DTYPE
                Vertex created
            idx : int
                Index of the vertex in self._vertices.
        """
        cdef int idx
        
        vx, idx, self._vertices, self._vertex_vacancies = self._insert(_vertex, self._vertices, self._vertex_vacancies, key=INSERTION_KEY_HALFEDGE, compact=compact, insert_key='position', **kwargs)
        _flat_vertices = self._vertices.view(VERTEX_DTYPE2)
        self._set_cvertices(_flat_vertices)

        self._faces_by_vertex = None  # Reset
        self._H = None
        self._K = None

        return vx, idx

    def edge_split(self, np.int32_t _curr, bint live_update=1, bint upsample=0):
        """
        Split triangles evenly along an edge specified by halfedge index _curr.

        Parameters
        ----------
            _curr : int
                Pointer to halfedge defining edge to split.
            live_update : bool
                Update associated faces and vertices after split. Set to False
                to handle this externally (useful if operating on multiple, 
                disjoint edges).
            upsample: bool
                Are we doing loop subdivision? If so, keep track of all edges
                incident on both a new vertex and an old verex that do not
                split an existing edge.
        """
        cdef halfedge_t *curr_edge
        cdef halfedge_t *twin_edge
        cdef np.int32_t _prev, _twin, _next, _twin_prev, _twin_next, _face_1_idx, _face_2_idx, _he_0_idx, _he_1_idx, _he_2_idx, _he_3_idx, _he_4_idx, _he_5_idx, _vertex_idx
        cdef bint interior

        if _curr == -1:
            return
        
        curr_edge = &self._chalfedges[_curr]
        _prev = curr_edge.prev
        _next = curr_edge.next

        # Grab the new vertex position
        # _vertex = 0.5*(self._vertices['position'][curr_edge.vertex, :] + self._vertices['position'][self._chalfedges[_prev].vertex, :])
        x0 = self._vertices['position'][curr_edge.vertex, :]
        x1 = self._vertices['position'][self._chalfedges[_prev].vertex, :]
        n0 = self._vertices['normal'][curr_edge.vertex, :]
        n1 = self._vertices['normal'][self._chalfedges[_prev].vertex, :]
        
        # x0 = self._cvertices['position'][curr_edge.vertex, :]
        # x1 = self._vertices['position'][self._chalfedges[_prev].vertex, :]
        # n0 = self._vertices['normal'][curr_edge.vertex, :]
        # n1 = self._vertices['normal'][self._chalfedges[_prev].vertex, :]
        
        _vertex = 0.5*(x0+x1) + 0.125*(n0-n1)
        _, _vertex_idx = self._new_vertex(_vertex)

        _twin = curr_edge.twin
        interior = (_twin != -1)  # Are we on a boundary?
        
        if interior:
            twin_edge = &self._chalfedges[_twin]
            _twin_prev = twin_edge.prev
            _twin_next = twin_edge.next
        
        # Ensure the original faces have the correct pointers and add two new faces
        self._cfaces[curr_edge.face].halfedge = _curr
        if interior:
            self._cfaces[twin_edge.face].halfedge = _twin
            _, _face_1_idx = self._new_face(_twin_prev)
            self._chalfedges[_twin_prev].face = _face_1_idx
        _, _face_2_idx = self._new_face(_next)
        self._chalfedges[_next].face = _face_2_idx

        # Insert the new faces
        _he_0_idx = self._insert_new_edge(self._chalfedges[_next].vertex, prev=_curr, next=_prev, face=self._chalfedges[_curr].face)
        if interior:
            _he_1_idx = self._insert_new_edge(_vertex_idx, prev=_twin_next, next=_twin, face=self._chalfedges[_twin].face)
        
            _he_2_idx = self._insert_new_edge(self._chalfedges[_twin_next].vertex, next=_twin_prev, face=_face_1_idx)
            _he_3_idx = self._insert_new_edge(_vertex_idx, prev=_twin_prev, next=_he_2_idx, face=_face_1_idx)
            self._chalfedges[_he_2_idx].prev = _he_3_idx

        _he_4_idx = self._insert_new_edge(self._chalfedges[_curr].vertex, next=_next, face=_face_2_idx, twin=-1)
        _he_5_idx = self._insert_new_edge(_vertex_idx, prev=_next, next=_he_4_idx, face=_face_2_idx)
        self._chalfedges[_he_4_idx].prev = _he_5_idx

        self._chalfedges[_he_0_idx].twin = _he_5_idx
        self._chalfedges[_he_5_idx].twin = _he_0_idx

        if interior:
            self._chalfedges[_he_1_idx].twin = _he_2_idx
            self._chalfedges[_he_2_idx].twin = _he_1_idx

            self._chalfedges[_he_3_idx].twin = _he_4_idx
            self._chalfedges[_he_4_idx].twin = _he_3_idx

        # Update _prev, next
        self._chalfedges[_prev].prev = _he_0_idx
        self._chalfedges[_next].prev = _he_4_idx
        self._chalfedges[_next].next = _he_5_idx

        if interior:
            # Update _twin_next, _twin_prev
            self._chalfedges[_twin_next].next = _he_1_idx
            self._chalfedges[_twin_prev].prev = _he_2_idx
            self._chalfedges[_twin_prev].next = _he_3_idx

            self._chalfedges[_twin].prev = _he_1_idx
        # Update _curr and _twin
        self._chalfedges[_curr].vertex = _vertex_idx
        self._chalfedges[_curr].next = _he_0_idx

        # Update halfedges
        if interior:
            self._cvertices[self._chalfedges[_he_2_idx].vertex].halfedge = _he_1_idx
        self._cvertices[self._chalfedges[_prev].vertex].halfedge = _curr
        self._cvertices[self._chalfedges[_he_4_idx].vertex].halfedge = _next
        self._cvertices[_vertex_idx].halfedge = _he_4_idx
        self._cvertices[self._chalfedges[_he_0_idx].vertex].halfedge = _he_5_idx

        if upsample:
            # Make sure these edges emanate from the new vertex stored at _vertex_idx
            if interior:
                self._loop_subdivision_flip_edges.extend([_he_2_idx])
            
            self._loop_subdivision_flip_edges.extend([_he_0_idx])
            self._loop_subdivision_new_vertices.extend([_vertex_idx])

        if live_update:
            if interior:
                #self._update_face_normals([self._chalfedges[_he_0_idx].face, self._chalfedges[_he_1_idx].face, self._chalfedges[_he_2_idx].face, self._chalfedges[_he_4_idx].face])
                #self._update_vertex_neighbors([self._chalfedges[_curr].vertex, self._chalfedges[_twin].vertex, self._chalfedges[_he_0_idx].vertex, self._chalfedges[_he_2_idx].vertex, self._chalfedges[_he_4_idx].vertex])
            
                update_face_normal(self._chalfedges[_he_0_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                update_face_normal(self._chalfedges[_he_1_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                update_face_normal(self._chalfedges[_he_2_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                update_face_normal(self._chalfedges[_he_4_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                
                update_single_vertex_neighbours(self._chalfedges[_curr].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_twin].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_he_0_idx].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_he_2_idx].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_he_4_idx].vertex, self._chalfedges, self._cvertices, self._cfaces)
            
            else:
                #self._update_face_normals([self._chalfedges[_he_0_idx].face, self._chalfedges[_he_4_idx].face])
                #self._update_vertex_neighbors([self._chalfedges[_curr].vertex, self._chalfedges[_prev].vertex, self._chalfedges[_he_0_idx].vertex, self._chalfedges[_he_4_idx].vertex])
                
                update_face_normal(self._chalfedges[_he_0_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                update_face_normal(self._chalfedges[_he_4_idx].face, self._chalfedges, self._cvertices, self._cfaces)
                
                update_single_vertex_neighbours(self._chalfedges[_curr].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_prev].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_he_0_idx].vertex, self._chalfedges, self._cvertices, self._cfaces)
                update_single_vertex_neighbours(self._chalfedges[_he_4_idx].vertex, self._chalfedges, self._cvertices, self._cfaces)
            
            
            self._faces_by_vertex = None
            self._H = None
            self._K = None
    
    cdef edge_flip(self, np.int32_t _curr, bint live_update=1):
        """
        Flip an edge specified by halfedge index _curr.

        Parameters
        ----------
            _curr : int
                Pointer to halfedge defining edge to flip.
            live_update : bool
                Update associated faces and vertices after flip. Set to False
                to handle this externally (useful if operating on multiple, 
                disjoint edges).
        """

        cdef halfedge_t *curr_edge, *twin_edge
        cdef np.int32_t _prev, _twin, _next, _twin_prev, _twin_next, vc, vt, new_v0, new_v1
        cdef bint fast_collapse_bool
        cdef float flipped_dot, fmx, fmy, fmz, pmx, pmy, pmz
        cdef int i
        cdef np.int32_t * neighbours

        if (_curr == -1):
            return -1

        curr_edge = &self._chalfedges[_curr]
        _twin = curr_edge.twin
        if (_twin == -1):
            # This is a boundary edge
            return -1
        _prev = curr_edge.prev
        _next = curr_edge.next

        twin_edge = &self._chalfedges[_twin]
        _twin_prev = twin_edge.prev
        _twin_next = twin_edge.next

        # Make sure both vertices have valence > 3 (preserve manifoldness)
        vc, vt = self._cvertices[curr_edge.vertex].valence, self._cvertices[twin_edge.vertex].valence
        if (vc < 4) or (vt < 4):
            return -1

        # Calculate adjustments to the halfedges we're flipping
        new_v0 = self._chalfedges[_next].vertex
        new_v1 = self._chalfedges[_twin_next].vertex

        # If there's already an edge between these two vertices, don't flip (preserve manifoldness)
        # NOTE: This is potentially a problem if we start with a high-valence mesh. In that case, swap this
        # check with the more expensive commented one below.

        # Check for creation of multivalent edges and prevent this (manifoldness)
        cdef bint locally_manifold = self._cvertices[curr_edge.vertex].locally_manifold and self._cvertices[twin_edge.vertex].locally_manifold and self._cvertices[new_v0].locally_manifold and self._cvertices[new_v1].locally_manifold
        fast_collapse_bool = (locally_manifold and (vc < NEIGHBORSIZE) and (vt < NEIGHBORSIZE))
        if fast_collapse_bool:
            #if new_v1 in self._vertices['neighbors'][new_v0]:
            #    return -1
            
            neighbours = &self._cvertices[new_v0].neighbor0
            for i in range(NEIGHBORSIZE):
                if neighbours[i] == new_v1:
                    return -1
        else:
            if new_v1 in self._halfedges['vertex'][self._halfedges['twin'][self._halfedges['vertex'] == new_v0]]:
                return -1

        # Convexity check: Let's see if the midpoint of the flipped edge will be above or below the plane of the 
        # current edge
        #flip_midpoint = 0.5*(self._vertices['position'][new_v0] + self._vertices['position'][new_v1])
        #plane_midpoint = (1./3)*(self._vertices['position'][curr_edge.vertex] + self._vertices['position'][self._chalfedges[curr_edge.next].vertex] + self._vertices['position'][self._chalfedges[curr_edge.prev].vertex])
        #flipped_dot = ((self._faces['normal'][curr_edge.face])*(flip_midpoint - plane_midpoint)).sum()

        fmx = 0.5*(self._cvertices[new_v0].position0 + self._cvertices[new_v1].position0)
        fmy = 0.5*(self._cvertices[new_v0].position1 + self._cvertices[new_v1].position1)
        fmz = 0.5*(self._cvertices[new_v0].position2 + self._cvertices[new_v1].position2)
        
        pmx = 0.3333333333*(self._cvertices[curr_edge.vertex].position0 + self._cvertices[self._chalfedges[curr_edge.next].vertex].position0 + self._cvertices[self._chalfedges[curr_edge.prev].vertex].position0)
        pmy = 0.3333333333*(self._cvertices[curr_edge.vertex].position1 + self._cvertices[self._chalfedges[curr_edge.next].vertex].position1 + self._cvertices[self._chalfedges[curr_edge.prev].vertex].position1)
        pmz = 0.3333333333*(self._cvertices[curr_edge.vertex].position2 + self._cvertices[self._chalfedges[curr_edge.next].vertex].position2 + self._cvertices[self._chalfedges[curr_edge.prev].vertex].position2)
        
        flipped_dot = self._cfaces[curr_edge.face].normal0*(fmx - pmx) + \
                      self._cfaces[curr_edge.face].normal1*(fmy - pmy) + \
                      self._cfaces[curr_edge.face].normal2*(fmz - pmz)
        
        
        if flipped_dot < 0:
            # If flipping moves the midpoint of the edge below the original triangle's plane, this introduces
            # concavity, so don't flip.
            return -1
        
        #if we were not locally manifold, conservatively flag all vertices we touch as non-manifold
        if not locally_manifold:
            self._cvertices[curr_edge.vertex].locally_manifold = 0
            self._cvertices[twin_edge.vertex].locally_manifold = 0
            self._cvertices[new_v0].locally_manifold = 0
            self._cvertices[new_v1].locally_manifold = 0

        # _next's next and prev must be adjusted
        self._chalfedges[_next].prev = _twin_prev
        self._chalfedges[_next].next = _twin

        # _twin_next's next and prev must be adjusted
        self._chalfedges[_twin_next].prev = _prev
        self._chalfedges[_twin_next].next = _curr

        # _prev's next and prev must be updated
        self._chalfedges[_prev].prev = _curr
        self._chalfedges[_prev].next = _twin_next

        # _twin_prev's next and prev must be updated
        self._chalfedges[_twin_prev].prev = _twin
        self._chalfedges[_twin_prev].next = _next

        # Don't even bother with checking, just make sure to update the
        # vertex_halfedges references to halfedges we know work
        self._cvertices[curr_edge.vertex].halfedge = _next
        self._cvertices[twin_edge.vertex].halfedge = _twin_next

        # Apply adjustments to the the halfedges we're flipping
        curr_edge.vertex = new_v0
        twin_edge.vertex = new_v1
        curr_edge.next = _prev
        twin_edge.next = _twin_prev
        curr_edge.prev = _twin_next
        twin_edge.prev = _next

        # Update pointers
        _prev = curr_edge.prev
        _next = curr_edge.next
        _twin_prev = twin_edge.prev
        _twin_next = twin_edge.next

        # Set faces
        self._chalfedges[_next].face = curr_edge.face
        self._chalfedges[_prev].face = curr_edge.face
        self._chalfedges[_twin_next].face = twin_edge.face
        self._chalfedges[_twin_prev].face = twin_edge.face

        # Finish updating vertex_halfedges references, update face references
        self._cvertices[curr_edge.vertex].halfedge = _twin
        self._cvertices[twin_edge.vertex].halfedge = _curr
        self._cfaces[curr_edge.face].halfedge = _curr
        self._cfaces[twin_edge.face].halfedge = _twin

        if live_update:
            # Update face and vertex normals
            #self._update_face_normals([curr_edge.face, twin_edge.face])
            #self._update_vertex_neighbors([curr_edge.vertex, twin_edge.vertex, self._chalfedges[_next].vertex, self._chalfedges[_twin_next].vertex])
            
            update_face_normal(curr_edge.face, self._chalfedges, self._cvertices, self._cfaces)
            update_face_normal(twin_edge.face, self._chalfedges, self._cvertices, self._cfaces)
            
            update_single_vertex_neighbours(curr_edge.vertex, self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(twin_edge.vertex, self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._chalfedges[_next].vertex, self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._chalfedges[_twin_next].vertex, self._chalfedges, self._cvertices, self._cfaces)
            
            self._faces_by_vertex = None
            self._H = None
            self._K = None

    def _snap_faces(self, np.int32_t _h0, np.int32_t _h3):
        """
        Snap faces defined b halfedges _h0 and _h3 to each other.

        Parameters
        ----------
            _h0, _h3 : int
                Indices of halfedges defining opposing faces we wish to connect
                via puncture.
        """

        cdef np.int32_t _h1, _h2, _h4, _h5, _v0, _v1, _v2, _v3, _v4, _v5

        # Get remaining halfedges
        _h1 = self._chalfedges[_h0].next
        _h2 = self._chalfedges[_h0].prev
        _h4 = self._chalfedges[_h3].next
        _h5 = self._chalfedges[_h3].prev

        # Get vertex indices
        _v0 = self._chalfedges[_h0].vertex
        _v1 = self._chalfedges[_h1].vertex
        _v2 = self._chalfedges[_h2].vertex
        _v3 = self._chalfedges[_h3].vertex
        _v4 = self._chalfedges[_h4].vertex
        _v5 = self._chalfedges[_h5].vertex

        # Average new positions
        print('Averaging new positions...')
        print('v0: {}'.format(self._vertices['position'][_v0]))
        print('v1: {}'.format(self._vertices['position'][_v1]))
        print('v2: {}'.format(self._vertices['position'][_v2]))
        print('v3: {}'.format(self._vertices['position'][_v3]))
        print('v4: {}'.format(self._vertices['position'][_v4]))
        print('v5: {}'.format(self._vertices['position'][_v5]))
        self._vertices['position'][_v0] = 0.5*(self._vertices['position'][_v0]+self._vertices['position'][_v3])
        self._vertices['position'][_v1] = 0.5*(self._vertices['position'][_v1]+self._vertices['position'][_v5])
        self._vertices['position'][_v2] = 0.5*(self._vertices['position'][_v2]+self._vertices['position'][_v4])

        # Set the dead vertices to the live ones
        if self._manifold:
            v3n = self._vertices['neighbors'][_v3]
            v3n = v3n[v3n!=-1]
            v4n = self._vertices['neighbors'][_v4]
            v4n = v4n[v4n!=-1]
            v5n = self._vertices['neighbors'][_v5]
            v5n = v5n[v5n!=-1]
            self._halfedges['vertex'][self._halfedges['twin'][v3n]] = _v0
            self._halfedges['vertex'][self._halfedges['twin'][v4n]] = _v2
            self._halfedges['vertex'][self._halfedges['twin'][v5n]] = _v1
        else:
            self._halfedges['vertex'][self._halfedges['vertex'] == _v3] = _v0
            self._halfedges['vertex'][self._halfedges['vertex'] == _v4] = _v2
            self._halfedges['vertex'][self._halfedges['vertex'] == _v5] = _v1


        # Update vertex valences
        self._cvertices[_v0].valence += self._cvertices[_v3].valence-2
        self._cvertices[_v1].valence += self._cvertices[_v5].valence-2
        self._cvertices[_v2].valence += self._cvertices[_v4].valence-2

        # Delete the dead vertices
        self._vertices[_v3] = -1
        self._vertices[_v4] = -1
        self._vertices[_v5] = -1
        self._vertex_vacancies.extend([_v3,_v4,_v5])

        # Twins
        _t0 = self._chalfedges[_h0].twin
        _t1 = self._chalfedges[_h1].twin
        _t2 = self._chalfedges[_h2].twin

        # Stitch boundaries of faces _h0, _h1
        self._zipper(_h0, _h4)
        self._zipper(_h1, _h3)
        self._zipper(_h2, _h5)

        # Delete the dead faces
        self._face_delete(_h0)
        self._face_delete(_h3)
        
        # Update halfedges
        self._cvertices[_v0].halfedge = _t0
        self._cvertices[_v1].halfedge = _t1
        self._cvertices[_v2].halfedge = _t2

        # self._update_face_normals([self._chalfedges[_t0].face,self._chalfedges[self._chalfedges[_t0].twin].face,
        #                            self._chalfedges[_t1].face,self._chalfedges[self._chalfedges[_t1].twin].face,
        #                            self._chalfedges[_t2].face,self._chalfedges[self._chalfedges[_t2].twin].face])
        # self._update_vertex_neighbors([_v0,_v1,_v2])
        
        update_face_normal(self._chalfedges[_t0].face, self._chalfedges, self._cvertices, self._cfaces)
        update_face_normal(self._chalfedges[self._chalfedges[_t0].twin].face, self._chalfedges, self._cvertices, self._cfaces)
        update_face_normal(self._chalfedges[_t1].face, self._chalfedges, self._cvertices, self._cfaces)
        update_face_normal(self._chalfedges[self._chalfedges[_t1].twin].face, self._chalfedges, self._cvertices, self._cfaces)
        update_face_normal(self._chalfedges[_t2].face, self._chalfedges, self._cvertices, self._cfaces)
        update_face_normal(self._chalfedges[self._chalfedges[_t2].twin].face, self._chalfedges, self._cvertices, self._cfaces)
        
        update_single_vertex_neighbours(_v0, self._chalfedges, self._cvertices, self._cfaces)
        update_single_vertex_neighbours(_v1, self._chalfedges, self._cvertices, self._cfaces)
        update_single_vertex_neighbours(_v2, self._chalfedges, self._cvertices, self._cfaces)
        
        self._faces_by_vertex = None

    cdef _zipper(self, np.int32_t edge1, np.int32_t edge2):
        cdef np.int32_t t1, t2

        t1 = -1 if edge1 == -1 else self._chalfedges[edge1].twin
        t2 = -1 if edge2 == -1 else self._chalfedges[edge2].twin

        if (t1 != -1):
            self._chalfedges[t1].twin = t2
            
        if (t2 != -1):
            self._chalfedges[t2].twin = t1

    def regularize(self):
        """
        Adjust vertices so they tend toward valence VALENCE 
        (or BOUNDARY_VALENCE for boundaries).
        """

        cdef int i, flip_count, target_valence
        cdef halfedge_t *curr_edge, *twin_edge
        cdef np.int32_t _twin, v1, v2, v3, v4, score_post, score_pre

        flip_count = 0

        # Do a single pass over all active edges and flip them if the flip minimizes the deviation of vertex valences
        # for i in np.arange(len(self._halfedges['vertex'])):
        #    if (self._halfedges['vertex'][i] < 0):
        #        continue
        for i in range(self._halfedges.shape[0]):# np.flatnonzero(self._halfedges['vertex'] != -1).astype(np.int32):
            curr_edge = &self._chalfedges[i]
            
            if curr_edge.vertex == -1:
                continue
            
            _twin = curr_edge.twin
            twin_edge = &self._chalfedges[_twin]

            target_valence = VALENCE
            if _twin == -1:
                # boundary
                target_valence = BOUNDARY_VALENCE

            # Pre-flip vertices
            v1 = self._cvertices[curr_edge.vertex].valence - target_valence
            v2 = self._cvertices[twin_edge.vertex].valence - target_valence

            # Post-flip vertices
            v3 = self._cvertices[self._chalfedges[curr_edge.next].vertex].valence - target_valence
            v4 = self._cvertices[self._chalfedges[twin_edge.next].vertex].valence - target_valence

            # Check valence deviation from VALENCE (or
            # BOUNDARY_VALENCE for boundaries) pre- and post-flip
            #score_pre = abs([v1,v2,v3,v4]).sum()
            #score_post = np.abs([v1-1,v2-1,v3+1,v4+1]).sum()
            
            score_pre = abs(v1) + abs(v2) + abs(v3) + abs(v4)
            score_post = abs(v1-1) + abs(v2-1) + abs(v3+1) + abs(v4+1)

            if score_post < score_pre:
                # Flip minimizes deviation of vertex valences from VALENCE (or
                # BOUNDARY_VALENCE for boundaries)
                self.edge_flip(i)
                flip_count += 1

        print('Flip count: %d' % (flip_count))

    @cython.cdivision(True)
    @cython.boundscheck(False)
    def relax(self, float l=1, int n=1):
        """
        Perform n iterations of Lloyd relaxation on the mesh.

        Parameters
        ----------
            l : float
                Regularization (damping) term, used to avoid oscillations.
            n : int
                Number of iterations to apply.
        """
        cdef int k, i, j, v, n_vertices, n_idx
        cdef float weight_sum, w, dx, dy, dz
        cdef np.int32_t *neighbours
        cdef bint fix_boundary = self.fix_boundary
        cdef vertex_t *verts = <vertex_t*> self._cvertices
        cdef float [3] centroid = [0,0,0]
        cdef float *pos
        cdef float * normal
        
        n_vertices = self._vertices.shape[0]
        
        # Get vertex neighbors
        nn = self._vertices['neighbors']
        nn_mask = (self._vertices['neighbors'] != -1)
        #print
        #nn = nn[nn_mask]
        vn_idx = self._halfedges['vertex'][nn]
        
        if self.fix_boundary:
            # Don't move vertices on a boundary
            boundary = self._halfedges[(self._halfedges['twin'] == -1)]
            tn = np.hstack([boundary['vertex'], self._halfedges['vertex'][boundary['prev']]])
        
        bverts = np.zeros(n_vertices, 'i')
        bverts[tn] = 1
        cdef bint [:] boundary_mask = bverts

        
        # for k in range(n):
        #     # Get vertex neighbor positions
        #     vn = self._vertices['position'][vn_idx]
        #
        #     # Weight by distance to neighors
        #     an = (1./self._halfedges['length'][nn])*nn_mask
        #     an[self._halfedges['length'][nn] == 0] = 0
        #
        #     # Calculate gravity-weighted centroids
        #     A = np.sum(an, axis=1)
        #     c = 1./(A[...,None])*np.sum(an[...,None]*vn, axis=1)
        #     # Don't get messed up by slivers. NOTE: This is a hack in case
        #     # edge split/collapse don't do their jobs.
        #     A_mask = (A == 0)
        #     c[A_mask] = self._vertices['position'][A_mask]
        #     if self.fix_boundary:
        #         # Don't move vertices on a boundary
        #         c[tn] = self._vertices['position'][tn]
        #
        #     # Construct projection vector into tangent plane
        #     pn = self._vertices['normal'][...,None]*self._vertices['normal'][:,None,:]
        #     p = np.eye(3)[None,:] - pn
        #
        #     # Update vertex positions
        #     self._vertices['position'] = self._vertices['position'] + l*np.sum(p*((c-self._vertices['position'])[...,None]),axis=1)
            
        # First steps towards a non-vectorised version of the above. Currently much slower (needs vector operations ported to c rather than calling numpy functions).
        for k in range(n):
            for v in range(n_vertices):
                if fix_boundary and boundary_mask[v]:
                    # Don't move vertices on a boundary
                    continue

                #neighbours = verts[v].neighbours
                weight_sum = 0
                pos = &self._cvertices[v].position0
                normal = &self._cvertices[v].normal0
                centroid[:] = [0,0,0]
                
                for j in range(NEIGHBORSIZE):
                    n_idx = verts[v].neighbors[j]
                    if (n_idx != -1) and (self._chalfedges[n_idx].length !=0):
                        # Get vertex neighbor positions
                        vn = self._cvertices[self._chalfedges[n_idx].vertex]

                        # Weight by distance to neighbors
                        w = (1./self._chalfedges[n_idx].length)
                        weight_sum += w
                        
                        centroid[0] += vn.position0*w
                        centroid[1] += vn.position1*w
                        centroid[2] += vn.position2*w

                if (weight_sum == 0):
                    continue

                centroid[0] /= weight_sum
                centroid[1] /= weight_sum
                centroid[2] /= weight_sum


                # Construct projection vector into tangent plane
                #pn = self._vertices['normal'][v][:,None]*self._vertices['normal'][v][None,:]
                #p = np.eye(3)[None,:] - pn
                
                dx = centroid[0] - pos[0]
                dy = centroid[1] - pos[1]
                dz = centroid[2] - pos[2]

                # Update vertex positions
                self._cvertices[v].position0 = pos[0] + l*( (1.0 - normal[0]*normal[0])*dx - normal[0]*normal[1]*dy - normal[0]*normal[2]*dz)
                self._cvertices[v].position1 = pos[1] + l*( -normal[0]*normal[1]*dx + (1.0 - normal[1]*normal[1])*dy - normal[1]*normal[2]*dz)
                self._cvertices[v].position2 = pos[2] + l*( -normal[0]*normal[2]*dx - normal[1]*normal[2]*dy + (1.0 - normal[2]*normal[2])*dz)

        # Now we gotta recalculate the normals
        self._faces['normal'][:] = -1
        self._vertices['normal'][:] = -1
        self.face_normals
        self.vertex_normals

    def remesh(self, int n=5, float target_edge_length=-1, float l=0.5, int n_relax=10):
        """
        Produce a higher-quality mesh.

        Follows procedure in Botsch and Kobbelt, A Remeshing Approach to 
        Multiresoluton Modeling, Eurographics Symposium on Geometry Processing,
        2004.

        Parameters
        ----------
            n : int
                Number of remeshing iterations to apply.
            target_edge_length : float
                Target edge length for all edges in the mesh.
            l : float
                Relaxation regularization term, used to avoid oscillations.
            n_relax : int 
                Number of Lloyd relaxation (relax()) iterations to apply 
                per remeshing iteration.
        """
        cdef int k, i, split_count, collapse_count
        #cdef float target_edge_length
        
        cdef int n_halfedges = self._halfedges.shape[0]
        cdef int n_vertices = self._vertices.shape[0]

        if (target_edge_length < 0):
            # Guess edge_length
            target_edge_length = np.mean(self._halfedges['length'][self._halfedges['length'] != -1])
            
        cdef float split_threshold = 1.33*target_edge_length
        cdef float collapse_threshold = 0.8*target_edge_length
        
        # modify cutoffs so we don't constantly undo ourselves ...
        # TOD - should we regularize between split and collapse?
        #cdef float split_threshold = 1.41*target_edge_length
        #cdef float collapse_threshold = 0.7*target_edge_length
        
        #self.regularize()

        for k in range(n):
            # 1. Split all edges longer than (4/3)*target_edge_length at their midpoint.
            split_count = 0
            for i in range(n_halfedges):
                if (self._chalfedges[i].vertex != -1) and (self._chalfedges[i].length > split_threshold):
                    self.edge_split(i)
                    split_count += 1
            print('Split count: %d' % (split_count))
            
            # 2. Collapse all edges shorter than (4/5)*target_edge_length to their midpoint.
            collapse_count = 0
            
            #find which vertices are locally manifold
            # TODO - move this to a helper function
            self._vertices['locally_manifold'] = 1
            self._vertices['locally_manifold'][self._halfedges['vertex'][self._halfedges['twin'] == -1]] = 0
            
            for i in range(n_halfedges):
                if (self._chalfedges[i].vertex != -1) and (self._chalfedges[i].length < collapse_threshold):
                    self.edge_collapse(i)
                    collapse_count += 1
            print('Collapse count: ' + str(collapse_count))

            # 3. Flip edges in order to minimize deviation from VALENCE.
            
            # find which vertices are locally manifold
            # TODO - move this to a helper function / make collapse update this so we don't need to recompute
            self._vertices['locally_manifold'] = 1
            self._vertices['locally_manifold'][self._halfedges['vertex'][(self._halfedges['twin'] == -1) & (self._halfedges['vertex'] != -1)]] = 0
            
            self.regularize()

            # 4. Relocate vertices on the surface by tangential smoothing.
            self.relax(l=l, n=n_relax)

        # Let's double-check the mesh manifoldness
        self._manifold = None
        self.manifold

    def upsample(self, n=1):
        """
        Upsample the mesh by a factor of 4 (factor of 2 along each axis in the
        plane of the mesh) and smooth meshes by Loop's 5/8 and 3/8 rule.

        References:
            1. C. T. Loop, "Smooth Subdivision surfaces Based on Triangles," 
               University of Utah, 1987
            2. http://462cmu.github.io/asst2_meshedit/, task 4

        Parameters
        ----------
            n : int
                Number of upsampling operations to perform.
        """

        for k in range(n):
            # Reset
            split_edges = {}
            self._loop_subdivision_new_vertices = []
            self._loop_subdivision_flip_edges = []
            new_vertex_idxs = []

            # Mark the current edges as old
            edges_to_split = np.where(self._halfedges['length'] != -1)[0]
            split_halfedges = self._halfedges[edges_to_split]

            # Compute new vertex positions for old vertices
            old_vertex_idxs = split_halfedges['vertex']
            old_vertices = self._vertices[old_vertex_idxs]
            old_neighbors = old_vertices['neighbors']
            neg_mask = (old_neighbors != -1)
            # alpha is a function of vertex order N that satisifies constraints on equation 3.4 of Loop's thesis
            alpha = np.tanh(LOOP_ALPHA_FACTOR*old_vertices['valence'])
            old_vertex_positions = (alpha[:,None])*old_vertices['position'] + ((1-alpha)[:,None])*((1./old_vertices['valence'])[:,None])*np.sum(self._vertices['position'][self._halfedges['vertex'][old_neighbors]]*neg_mask[...,None],axis=1)
            
            # Compute new vertex positions for new vertices
            p0 = 0.375*(old_vertices['position'] + self._vertices['position'][self._halfedges['vertex'][split_halfedges['twin']]])
            p1 = 0.125*(self._vertices['position'][self._halfedges['vertex'][split_halfedges['next']]] + self._vertices['position'][self._halfedges['vertex'][self._halfedges['next'][split_halfedges['twin']]]])
            new_vertex_positions = p0 + p1

            # 1. Split every edge in the mesh
            for j, i in enumerate(edges_to_split):
                if i in split_edges:
                    continue
                
                split_edges[self._halfedges['twin'][i]] = i
                new_vertex_idxs.append(j)
                self.edge_split(i, upsample=True)
            
            # 2. Flip any new edge that touches an old vertex and a new vertex
            edges_to_flip = list(set(self._halfedges['vertex'][self._loop_subdivision_flip_edges]) - set(self._loop_subdivision_new_vertices))
            for e in edges_to_flip:
                self.edge_flip(e)

            # Get any boundary vertices
            boundary_vertex_idxs = self._halfedges['vertex'][(self._halfedges['twin'] == -1)]
            boundary_vertex_positions = self._vertices['position'][boundary_vertex_idxs]

            # Copy new position values into self._vertices['position']
            self._vertices['position'][old_vertex_idxs] = old_vertex_positions
            self._vertices['position'][self._loop_subdivision_new_vertices] = new_vertex_positions[new_vertex_idxs]

            # Restore boundary vertex positions
            self._vertices['position'][boundary_vertex_idxs] = boundary_vertex_positions

        self._manifold = None

    def downsample(self, n_triangles=None):
        """
        Mesh downsampling via quadratic error metrics.

        Follows procedure in Garland and Heckbert, Surface Simplification Using
        Quadtratic Error Metrics.

        Parameters
        ----------
            n_triangles : int
                Target number of triangles in the downsampled mesh.
        """

        import PYME.experimental._treap as treap

        # 1. Compute quadratic matrices for all initial vertices
        v = self._vertices['position']
        n = self._vertices['normal']
        d = (-n*v).sum(1)
        p = np.vstack([n.T, d]).T  # plane
        vn = self._vertices['neighbors']
        vn_mask = (vn != -1)
        pp = p[self._halfedges['vertex'][vn]]*vn_mask[...,None]  # neighbor planes
        Q = (pp[...,None]*pp[:,:,None,:]).sum(1)  # per-vertex quadratic

        # 2. Select all valid pairs
        #   For now, operate on edges. In the future we can also operate on any
        #   pair of vertex positions such that || v_1 - v_2 || < t, where v_1,
        #   v_2 \in R^3, and t \in R is a threshold.

        # 3. Compute optimal contraction target and cost of each contraction
        # NOTE: we do this for all halfedges, empty or not. This saves us from having to search for
        # unique halfedges later in step 5. Instead, we just ignore -1 values.
        edges_mask = (self._halfedges['vertex'] != -1)
        edges = np.vstack([self._halfedges['vertex'], self._halfedges['vertex'][self._halfedges['prev']]]).T
        # Mask and shift to avoid a copy operation on Q
        Q_mask = np.ones((4,4))
        Q_mask[3,:] = 0
        Q_shift = np.zeros((4,4))
        Q_shift[3,3] = 1
        # h is the solution vector for least squares
        h = np.array([0,0,0,1])
        # 3a. Compute the optimal contraction target for each valid pair
        Q_edge = (Q[edges]).sum(1)  # Q paired
        try:
            vp = (np.linalg.inv(Q_edge*Q_mask[None,...] + Q_shift[None,...])*h).sum(2)
        except(np.linalg.LinAlgError):
            vp = 0.5*np.sum(self._vertices['position'][edges],axis=1)
            vp = np.vstack([vp.T, np.ones(vp.shape[0])]).T

        # 3b. Compute cost of contractions
        err = ((vp[:,None,:]*Q_edge).sum(2)*vp).sum(1)

        # 4. Place all the pairs in a heap keyed on cost with the minimum cost pair on top
        cost_heap = treap.Treap()
        for i in (np.arange(len(edges))[edges_mask]):
            cost_heap.insert(np.float32(err[i]), np.int32(i))
            
        # 5. Iteratively remove the pair of least cost from the heap, 
        #    contract this pair, and update the costs of all valid 
        #    pairs involving the remaining live vertex.
        n_faces = np.sum(self._faces['halfedge'] != -1)
        if n_triangles is None:
            # Assume we want to downsample by a factor of 4
            n_triangles = int(0.25*n_faces)
        collapse_tries = int(0.125*(n_faces - n_triangles))
        while True:
            if n_faces <= n_triangles:
                # Sometimes edge_collapse does not collapse the edge
                # because it would affect the manifoldness of the mesh,
                # so we need to see how far off we are from the desired
                # number of triangles n_triangles.
                tmp = np.sum(self._faces['halfedge'] != -1)
                if (n_faces == tmp) or (collapse_tries == 0):
                    # We don't want to double check ourselves forever
                    break
                # Update our estimate and keep refining the mesh
                n_faces = tmp
                collapse_tries -= 1
            
            # Grab the edge with minimum cost
            _, _edge = cost_heap.pop()

            if _edge == -1:
                print('Edge was -1???')
                continue

            # Compute the new quadratic
            edge = self._halfedges[_edge]
            # Grab the live and dead vertex
            _live_vertex = edge['vertex']
            _dead_vertex = self._halfedges['vertex'][edge['prev']]
            Q_edge[_edge] = Q[_live_vertex] + Q[_dead_vertex]

            if (_live_vertex == -1) or (_dead_vertex == -1):
                print('Vertex was -1???')
                continue

            # Grab all neighboring halfedges
            nn_live = self._vertices['neighbors'][_live_vertex]
            nn_live_mask = (nn_live != -1)
            nn_live_twin = self._halfedges['twin'][nn_live[nn_live_mask]]
            nn_live_twin_mask = (nn_live_twin != -1)
            nn_dead = self._vertices['neighbors'][_dead_vertex]
            nn_dead_mask = (nn_dead != -1)
            nn_dead_twin = self._halfedges['twin'][nn_dead[nn_dead_mask]]
            nn_dead_twin_mask = (nn_dead_twin != -1)
            neighbors = np.hstack([nn_live[nn_live_mask], nn_live_twin[nn_live_twin_mask], nn_dead[nn_dead_mask], nn_dead_twin[nn_dead_twin_mask]])

            # Eliminate edges touching either vertex from the cost heap
            for neighbor in neighbors:
                cost_heap.delete(np.int32(neighbor))
                            
            # Collapse the edge
            self.edge_collapse(_edge)
            
            # Decrement the estimate of the number of triangles in the 
            # mesh accordingly
            n_faces -= 2

            # Set the quadratic of _live_vertex to the edge quadratic
            Q[_live_vertex] = Q_edge[_edge] 
            # self._vertices['position'][_live_vertex] = vp[_edge,:3]

            # Grab the new neighbors
            nn_live = self._vertices['neighbors'][_live_vertex]
            nn_live_mask = (nn_live != -1)
            nn_live_twin = self._halfedges['twin'][nn_live[nn_live_mask]]
            nn_live_twin_mask = (nn_live_twin != -1)
            neighbors = np.hstack([nn_live[nn_live_mask], nn_live_twin[nn_live_twin_mask]])

            # Update the costs and positions of each of these neighbors and re-insert them into the queue
            new_edges = np.vstack([self._halfedges['vertex'][neighbors], self._halfedges['vertex'][self._halfedges['prev'][neighbors]]]).T
            Q_edge[neighbors] = (Q[new_edges]).sum(1)

            try:
                vp[neighbors] = (np.linalg.inv(Q_edge[neighbors]*Q_mask[None,...] + Q_shift[None,...])*h).sum(2)
            except(np.linalg.LinAlgError):
                vp_temp = 0.5*np.sum(self._vertices['position'][new_edges],axis=1)
                vp[neighbors] = np.vstack([vp_temp.T, np.ones(vp_temp.shape[0])]).T

            err[neighbors] = ((vp[neighbors,None,:]*Q_edge[neighbors]).sum(2)*vp[neighbors]).sum(1)

            for n in neighbors:
                cost_heap.insert(np.float32(err[n]), np.int32(n))

        self._manifold = None

    def find_connected_components(self):
        """
        Label connected components of the mesh.
        """ 

        # Set all components to -1 (background)
        self._halfedges['component'] = -1
        self._vertices['component'] = -1
        self._faces['component'] = -1

        # Connect component by vertex
        component = 0
        for _vertex in np.arange(self._vertices.shape[0]):
            curr_vertex = self._vertices[_vertex]
            if (curr_vertex['halfedge'] == -1) or (curr_vertex['component'] != -1):
                # We only want to deal with valid, unassigned vertices
                continue

            # Search vertices contains vertices connected to this vertex.
            # We want to see if there are other vertices connected to the
            # search vertices.
            search_vertices = []
            self._vertices[_vertex]['component'] = component
            search_vertices.append(_vertex)

            # Find vertices connected to the search vertices
            while search_vertices:
                # Grab the latest search vertex neighbors
                _v = search_vertices.pop()
                nn = self._vertices['neighbors'][_v]
                # Loop over the neighbors
                for _edge in nn:
                    if _edge == -1:
                        continue
                    # Assign the vertex component label to halfedges and faces
                    # emanating from this vertex
                    curr_edge = self._halfedges[_edge]
                    self._halfedges['component'][_edge] = component
                    self._halfedges['component'][curr_edge['prev']] = component
                    self._halfedges['component'][curr_edge['next']] = component
                    self._faces['component'][curr_edge['face']] = component
                    
                    # If the vertex is assigned, we've already visited it and
                    # don't need to do so again.
                    if self._vertices['component'][curr_edge['vertex']] != -1:
                        continue
                    self._vertices['component'][curr_edge['vertex']] = component
                    search_vertices.append(curr_edge['vertex'])
            
            # Increment the label as any vertices not included in this
            # iteration's search will be part of another component.
            component += 1

    def keep_largest_connected_component(self):
        # Find the connected components
        self.find_connected_components()

        # Which connected component is largest? 
        com, counts = np.unique(self._vertices['component'][self._vertices['component']!=-1], return_counts=True)
        max_count = np.argmax(counts)
        max_com = com[max_count]

        # Remove the smaller components
        _vertices = np.where((self._vertices['component'] != max_com))[0]
        _edges = np.where((self._halfedges['component'] != max_com))[0]
        _edges_with_twins = _edges[self._halfedges['twin'][_edges] != -1]
        _faces = np.where((self._faces['component'] != max_com))[0]
        # Delete vertices
        self._vertices[_vertices] = -1
        _kept_edges = self._halfedges['twin'][_edges_with_twins]
        self._halfedges['twin'][_kept_edges] = -1
        self._halfedges[_edges] = -1
        self._faces[_faces] = -1

        # Mark deleted faces as available
        self._vertex_vacancies = list(set(self._vertex_vacancies).union(set(_vertices)))
        self._halfedge_vacancies = list(set(self._halfedge_vacancies).union(set(_edges)))
        self._face_vacancies = list(set(self._face_vacancies).union(set(_faces)))

        # Update newly orphaned edges
        self._update_face_normals(list(set(self._halfedges['face'][_kept_edges])))
        self._update_vertex_neighbors(list(set(self._halfedges['vertex'][_kept_edges])))
        
        self._faces_by_vertex = None
        self._H = None
        self._K = None

    def _find_boundary_polygons(self):
        """
        Return a list of closed polygons, each defined by a list of halfedges,
        where each polygon defines a boundary in the mesh.
        """
        boundary_polygons = []

        # 1. Construct an initial list of boundary edges
        boundary_edges = list(np.where((self._halfedges['twin'] == -1) & (self._halfedges['vertex'] != -1))[0])

        # 2. Get the boundary polygons
        while len(boundary_edges) > 0:
            _root = boundary_edges[-1]  # initial halfedge defining the polygon
            curr_polygon = [_root]
            # Step next-twin-next to move around the boundary
            _next = self._halfedges['next'][_root]
            _twin = self._halfedges['twin'][_next]
            _curr = self._halfedges['next'][_twin]
            if self._halfedges['twin'][_next] == -1:
                _curr = _next
            if self._halfedges['twin'][_twin] == -1:
                _curr = _twin
            
            # We check open_chain instead of _curr != root since open_chain accounts for closed polygons
            # ending at an isolated singular vertex (two boundaries emit from a single vertex)
            open_chain = (self._halfedges['vertex'][self._halfedges['prev'][_root]] != self._halfedges['vertex'][curr_polygon[-1]])
            
            # Loop around the boundary until we return the initial halfedge
            max_polygon_size = 100  # Put an upper limit on the polygon sizes so we don't look forever
            while open_chain and (max_polygon_size > 0):
                # We're not always guaranteed to hit the boundary again right 
                # away doing next-twin-next, so wait until we do
                twin_next_attemps = 2*BOUNDARY_VALENCE
                while (twin_next_attemps > 0) and (self._halfedges['twin'][_curr] != -1):
                    
                    # Need to do twin next in between boundary edges
                    _twin = self._halfedges['twin'][_curr]
                    _curr = self._halfedges['next'][_twin]
                    if _curr == -1:
                        # We hit a isolated singular vertex
                        break
                    twin_next_attemps -= 1
                
                if _curr == -1:
                    break
                
                curr_polygon.append(_curr)

                _next = self._halfedges['next'][_curr]
                _twin = self._halfedges['twin'][_next]
                _curr = self._halfedges['next'][_twin]

                if self._halfedges['twin'][_next] == -1:
                    _curr = _next
                if self._halfedges['twin'][_twin] == -1:
                    _curr = _twin

                open_chain = (self._halfedges['vertex'][self._halfedges['prev'][_root]] != self._halfedges['vertex'][curr_polygon[-1]])
                max_polygon_size -= 1

            if max_polygon_size == 0:
                print('Polygon search took too long. Canceled.')

            if ((_curr == -1) and (open_chain)) or (max_polygon_size == 0):
                # We failed to find a boundary polygon
                boundary_edges.pop()
                continue
            else:
                # We found a boundary polygon!
                boundary_polygons.append(curr_polygon)
                # Delete the polygon from the potential polygon list
                for edge in curr_polygon:
                    if edge in boundary_edges:
                        boundary_edges.remove(edge)

        return boundary_polygons

    def _fill_triangle(self, h0, h1, h2):
        """
        Create a triangle inside three halfedges.

        Note that this does not update the vertices or faces.
        """

        _h0_twin_vertex = self._halfedges['vertex'][h2]
        _h0_twin = self._insert_new_edge(_h0_twin_vertex, twin=h0)
        _, _face = self._new_face(_h0_twin)
        _h1_twin_vertex = self._halfedges['vertex'][h0]
        _h1_twin = self._insert_new_edge(_h1_twin_vertex, twin=h1, face=_face, next=_h0_twin)
        self._halfedges['face'][_h0_twin] = _face
        self._halfedges['prev'][_h0_twin] = _h1_twin
        _h2_twin_vertex = self._halfedges['vertex'][h1]
        _h2_twin = self._insert_new_edge(_h2_twin_vertex, twin=h2, face=_face, prev=_h0_twin, next=_h1_twin)
        self._halfedges['next'][_h0_twin] = _h2_twin
        self._halfedges['prev'][_h1_twin] = _h2_twin

        if h0 != -1:
            self._halfedges['twin'][h0] = _h0_twin
        if h1 != -1:
            self._halfedges['twin'][h1] = _h1_twin
        if h2 != -1:
            self._halfedges['twin'][h2] = _h2_twin

    def _fan_triangulation(self, polygon):
        """
        Triangulate a polygon, defined by halfedges in the mesh,
        by creating a fan emanating from a single vertex out to
        the boundary halfedges.

        Parameters
        ----------
            polygon : list
                List of halfedges defining a closed polygon in the mesh.
        """

        if len(polygon) < 3:
            raise ValueError('polygon must be of length >= 3')

        # Reverse order
        polygon = polygon[::-1]

        while len(polygon) > 0:
            h0 = polygon.pop()
            h1 = polygon.pop()
            if (len(polygon) == 1):
                # Base case, make a triangle
                # polygon = polygon[::-1]
                h2 = polygon.pop()
                self._fill_triangle(h0,h1,h2)
                _h0_twin = self._halfedges['twin'][h0]
            else:
                # Create a new triangle with a boundary edge
                self._fill_triangle(h0, h1, -1)
                
                # Due to the way fill_triangle works, we need to set h0's vertex after the fact
                _h0_twin = self._halfedges['twin'][h0]
                self._halfedges['vertex'][_h0_twin] = self._halfedges['vertex'][self._halfedges['prev'][h0]]
                
                # Adjust the boundary
                polygon.append(self._halfedges['next'][_h0_twin])

            # Update faces and vertices
            #self._update_face_normals([self._halfedges['face'][_h0_twin], self._halfedges['face'][h0], self._halfedges['face'][h1]])
            #self._update_vertex_neighbors([self._halfedges['vertex'][_h0_twin], self._halfedges['vertex'][h0], self._halfedges['vertex'][h1]])
            
            update_face_normal(self._chalfedges[_h0_twin].face, self._chalfedges, self._cvertices, self._cfaces)
            update_face_normal(self._chalfedges[h0].face, self._chalfedges, self._cvertices, self._cfaces)
            update_face_normal(self._halfedges[h1].face, self._chalfedges, self._cvertices, self._cfaces)
            
            update_single_vertex_neighbours(self._halfedges['vertex'][_h0_twin], self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._halfedges['vertex'][h0], self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._halfedges['vertex'][h1], self._chalfedges, self._cvertices, self._cfaces)

    def _zig_zag_triangulation(self, polygon):
        """
        Triangulate a polygon, defined by halfedges in the mesh,
        by creating zig-zagging between edges of the boundary.

        Parameters
        ----------
            polygon : list
                List of halfedges defining a closed polygon in the mesh.
        """

        if len(polygon) < 3:
            raise ValueError('polygon must be of length >= 3')

        # Reverse order
        polygon = polygon[::-1]
        odd = True

        while len(polygon) > 0:
            h0 = polygon.pop()
            h1 = polygon.pop()
            if (len(polygon) == 1):
                # Base case, make a triangle
                # polygon = polygon[::-1]
                h2 = polygon.pop()
                self._fill_triangle(h0,h1,h2)
                _h0_twin = self._halfedges['twin'][h0]
            else:
                # Create a new triangle with a boundary edge
                self._fill_triangle(h0, h1, -1)
                
                # Due to the way fill_triangle works, we need to set h0's vertex after the fact
                _h0_twin = self._halfedges['twin'][h0]
                self._halfedges['vertex'][_h0_twin] = self._halfedges['vertex'][self._halfedges['prev'][h0]]
            
                # Adjust the boundary
                polygon = polygon[::-1]  # zig-zag
                if odd:
                    polygon.insert(-1,self._halfedges['next'][_h0_twin])
                else:
                    polygon.append(self._halfedges['next'][_h0_twin])
                odd = (not odd)

            # Update faces and vertices
            #self._update_face_normals([self._halfedges['face'][_h0_twin], self._halfedges['face'][h0], self._halfedges['face'][h1]])
            #self._update_vertex_neighbors([self._halfedges['vertex'][_h0_twin], self._halfedges['vertex'][h0], self._halfedges['vertex'][h1]])
            
            update_face_normal(self._chalfedges[_h0_twin].face, self._chalfedges, self._cvertices, self._cfaces)
            update_face_normal(self._chalfedges[h0].face, self._chalfedges, self._cvertices, self._cfaces)
            update_face_normal(self._chalfedges[h1].face, self._chalfedges, self._cvertices, self._cfaces)
            
            update_single_vertex_neighbours(self._chalfedges[_h0_twin].vertex, self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._chalfedges[h0].vertex, self._chalfedges, self._cvertices, self._cfaces)
            update_single_vertex_neighbours(self._chalfedges[h1].vertex, self._chalfedges, self._cvertices, self._cfaces)

    def _fill_holes(self, method='zig-zag'):
        """
        Fill holes in the mesh.

        Parameters
        ----------
            method : string
                The method to use to patch boundary polygons. A string listed 
                in options. 
        """

        options = ['fan', 'zig-zag']

        if method not in options:
            print('Unknown triangulation method. Using default.')
            method = 'zig-zag'

        boundary_polygons = self._find_boundary_polygons()
        
        # Find length 2 polygons and zipper them ("pinch")
        to_remove = []
        for polygon in boundary_polygons:
            if len(polygon) == 2:
                self._halfedges['twin'][polygon[0]] = polygon[1]
                self._halfedges['twin'][polygon[1]] = polygon[0]
                to_remove.append(polygon)
        
        # Eliminate the length 2 polygons before triangulation
        for polygon in to_remove:
            boundary_polygons.remove(polygon)

        # Triangulate
        if method == 'fan':
            for polygon in boundary_polygons:
                self._fan_triangulation(polygon)
        
        if method == 'zig-zag':
            for polygon in boundary_polygons:
                self._zig_zag_triangulation(polygon)

        # Reset display
        self._faces_by_vertex = None
        self._H = None
        self._K = None

    def _connect_neighbors(self, _nn, starting_component=0):
        """
        Connect the neighbors in the list _nn starting from
        starting_component.

        Parameters
        ----------
            _nn : list
                List of neighbors to connect.
            starting_component : int
                Component numbering to start at.

        Returns
        -------
            component : int
                Maxmimum component number used to group neighbors.
        """
        # Assign components via the 1-neighbors
        component = starting_component
        for _neighbor in _nn:
            singular = (_neighbor in self.singular_edges)
            if singular:
                component += 1
            if self._faces['component'][self._halfedges['face'][_neighbor]] != -1:
                continue
            self._faces['component'][self._halfedges['face'][_neighbor]] = component

            # Extra check in case we're examining the edges out of order
            if singular:
                component += 1

        # Loop through the neighbors again and group connected components
        for _neighbor in _nn:
            if (_neighbor in self.singular_edges):
                continue
    
            _twin_neighbor = self._halfedges['twin'][_neighbor]
            if _twin_neighbor != -1:
                _face = self._halfedges['face'][_neighbor]
                _twin_face = self._halfedges['face'][_twin_neighbor]
                min_component = np.min([self._faces['component'][_face], self._faces['component'][_twin_face]])
                self._faces['component'][_face] = min_component
                self._faces['component'][_twin_face] = min_component

        return component

    def _group_neighbors(self, _vertex):
        """
        Group faces around the 1-neighbor ring of a vertex by reachability. 
        Faces are not reachable if they are separated by a singular edge.

        Parameters
        ----------
            _vertex : int
                Index of vertex at the center of a 1-neighbor ring.
        """

        # Zero out connectivity
        self._vertices['component'][:] = -1
        self._faces['component'][:] = -1
        self._halfedges['component'][:] = -1

        # Grab the neighbors
        _nn = self._vertices[_vertex]['neighbors']
        _nn = _nn[_nn!=-1]

        # Connect the neighbors
        component = self._connect_neighbors(_nn, 0)

        # Don't trust self._vertices['neighbors'] because we're dealing with 
        # singular vertices
        _twin_nn = list(np.where(self._halfedges['vertex'] == _vertex)[0])

        # If there were any incident vertices not included in this list, group them, too
        _remaining = list(set(_twin_nn) - set(self._halfedges['twin'][_nn]) - set([-1]))
        
        if _remaining:
            component += 1  # We're off the original 1-neighbor ring, so disconnect
            self._connect_neighbors(_remaining, component)

    def _remove_singularities(self):
        """
        Excise singularities from the mesh. This essentially unzips multivalent
        edges from the rest of the mesh, creating new, smaller connected 
        components, each of which is free of singularities. This follows the
        local method for cutting outlined in Gueziec et al.

        References
        ----------
            Gueziec et al. Cutting and Stitching: Converting Sets of Polygons
            to Manifold Surfaces, IEEE TRANSACTIONS ON VISUALIZATION AND 
            COMPUTER GRAPHICS, 2001.
        """

        # Make sure we're working with the latest singular edges/vertices
        self._singular_edges = None
        self._singular_vertices = None

        #  For each marked vertex, partition the faces of the 1-neighbor ring
        #    into nc "is reachable" equivalence classes. Faces are reachable if
        #    they share a non-singular edge incident on the marked vertex.
        for _vertex in self.singular_vertices[::-1]:

            _twin_nn = list(np.where(self._halfedges['vertex'] == _vertex)[0])
            _update_vertices = np.hstack([_vertex, self._halfedges['vertex'][self._halfedges['twin'][_twin_nn]]])
            # _update_faces = self._faces[self._halfedges['face'][_twin_nn]]

            self._group_neighbors(_vertex)
            
            # Create nc-1 copies of the vertex and assign each equivalence class 
            #    one of these vertices. (All but one component gets a new vertex).
            components = np.unique(self._faces['component'][self._faces['component'] != -1])
            for c in components[1:]:
                _faces = self._faces[self._faces['component'] == c]
                _edges = np.hstack([self._halfedges['prev'][_faces['halfedge']], _faces['halfedge'], self._halfedges['next'][_faces['halfedge']]])
                _vertices = self._halfedges['vertex'][_edges]
                
                _modified_edges = _edges[_vertices == _vertex] 

                _edge = self._halfedges['next'][_modified_edges[0]]

                _, _new_vertex = self._new_vertex(self._vertices['position'][_vertex], halfedge=_edge)
                # Assign edges in this component connected to _vertex to _new_vertex
                self._halfedges['vertex'][_modified_edges] = _new_vertex

                # Disconnect the boundaries of the components
                # Any edge pointing to the new vertex with a twin in a 
                # different component must be reassigned
                _twin_face_component = self._faces['component'][self._halfedges['face'][self._halfedges['twin'][_modified_edges]]]
                _boundary = (_twin_face_component != c)
                _twin_edges = self._halfedges['twin'][_modified_edges[_boundary]]
                _twin_edges_mask = (_twin_edges != -1)
                _valid_edges = _modified_edges[_boundary][_twin_edges_mask]
                self._halfedges['twin'][_twin_edges[_twin_edges_mask]] = -1
                self._halfedges['twin'][_valid_edges] = -1
                # Any edge emanating from the new vertex with a twin in a
                # different component must be reassigned
                _twin_next_face_component = self._faces['component'][self._halfedges['face'][self._halfedges['twin'][self._halfedges['next'][_modified_edges]]]]
                _boundary = (_twin_next_face_component != c)                
                _twin_next_edges = self._halfedges['twin'][self._halfedges['next'][_modified_edges[_boundary]]]
                _twin_next_edges_mask = (_twin_next_edges != -1)
                _valid_edges = self._halfedges['next'][_modified_edges[_boundary][_twin_next_edges_mask]]
                self._halfedges['twin'][_twin_next_edges[_twin_next_edges_mask]] = -1
                self._halfedges['twin'][_valid_edges] = -1

                # Double check that the original vertex did not have a halfedge 
                # in this component
                _safe_faces_bool = (self._faces['component'][self._halfedges['face']] != c)
                _safe_vertices = np.where((self._halfedges['vertex'] == _vertex) & (_safe_faces_bool))[0]
                _safe_halfedge = self._halfedges['next'][_safe_vertices[0]]
                self._vertices['halfedge'][_vertex] = _safe_halfedge

                # self._update_face_normals(_update_faces)
                self._update_vertex_neighbors(np.hstack([_update_vertices, _new_vertex]))

        # Reset
        self._singular_edges = None
        self._singular_vertices = None

    def repair(self, only_largest_component=False):
        """
        Repair the mesh so it's topologically manifold.

        References
        ----------
            M. Attene, A lightweight approach to repairing digitized polygon
            meshes, The Visual Computer, 2010.
        """
        
        # 1. Remove singularities (singular edges and isolated singular vertices)
        self._remove_singularities()

        # 2. Remove all connected components except the largest
        if only_largest_component:
            self.keep_largest_connected_component()

        # 3. Patch mesh holes with new triangles
        self._fill_holes()

        self._manifold = None

        # Now we gotta recalculate the normals
        self._faces['normal'][:] = -1
        self._vertices['normal'][:] = -1
        self.face_normals
        self.vertex_normals

    def to_stl(self, filename):
        """
        Save list of triangles to binary STL file.

        Parameters
        ----------
            filename : string
                File name to write

        Returns
        -------
            None
        """
        from PYME.IO.FileUtils import stl

        dt = np.dtype([('normal', '3f4'), ('vertex0', '3f4'), ('vertex1', '3f4'), 
                       ('vertex2', '3f4'), ('attrib', 'u2')])

        triangles_stl = np.zeros(self.faces.shape[0], dtype=dt)
        triangles_stl['vertex0'] = self.vertices[self.faces[:, 0]]
        triangles_stl['vertex1'] = self.vertices[self.faces[:, 1]]
        triangles_stl['vertex2'] = self.vertices[self.faces[:, 2]]
        triangles_stl['normal'] = self.face_normals

        stl.save_stl_binary(filename, triangles_stl)

    def to_ply(self, filename, colors=None):
        """
        Save a list of triangles and their vertex colors to a PLY file.
        We assume colors are a Nx3 array where N is the number of vertices.
        """
        from PYME.IO.FileUtils import ply

        # Construct a re-indexing for non-negative vertices
        live_vertices = np.flatnonzero(self._vertices['halfedge'] != -1)
        new_vertex_indices = np.arange(live_vertices.shape[0])
        vertex_lookup = np.zeros(self._vertices.shape[0], dtype=np.int)
        
        vertex_lookup[live_vertices] = new_vertex_indices

        # Grab the faces and vertices we want
        faces = vertex_lookup[self.faces]
        vertices = self._vertices['position'][live_vertices]

        ply.save_ply(filename, vertices, faces, colors)
