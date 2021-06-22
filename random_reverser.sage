def main():
    a = 25214903917 # lcg multiplier
    c = 11	        # lcg increment
    m = 2^48	    # lcg modulus
    bound = 2^6	    # nextInt() bound

    # load rng outputs into a vector
    with open('rng_outputs.txt', 'r') as f:
        data = vector(QQ(i.strip()) for i in f)
    dim = data.degree()
    bounds = vector(QQ(bound) for i in range(0, dim))

    # setup lattice basis and offset
    A = lcg_lattice_basis(a, c, m, dim)
    A_inv = A.inverse()
    offset = lcg_lattice_offset(a, c, m, dim)

    # search for seeds consistent with the data
    min, max = find_search_bounds(A_inv, offset, m, dim, data, bounds)
    seeds = search(A, offset, m, dim, min, max, data, bounds)

    for s in seeds:
        print('Reversed seed:', s)

# returns a matrix whose column vectors form a basis for the lcg lattice
# parameters:
#   a:	    lcg multiplier
#   c:	    lcg increment
#   m:	    lcg modulus
#   dim:    dimension of the lattice
def lcg_lattice_basis(a, c, m, dim):
    # create diagonal portion
    D = m*identity_matrix(QQ, dim)

    # create leftmost column and augment with diagonal portion
    A = matrix(QQ, dim, 1, 0)
    R = IntegerModRing(m)
    a_m = R(a)
    for i in range(0, dim):
	    A[i, 0] = a_m^i
    A = A.augment(D)

    # reduce
    A = A.transpose().LLL().transpose()

    # remove empty columns
    rm = []
    for i in range(0, A.ncols()):
	    if A.column(i).norm() == 0: rm.append(i)
    A = A.delete_columns(rm)

    return A

# returns a vector of the offset of the lcg lattice from the origin
# parameters:
#   a:	    lcg multiplier
#   c:	    lcg increment
#   m:	    lcg modulus
#   dim:    dimension of the lattice
def lcg_lattice_offset(a, c, m, dim):
    R = IntegerModRing(m)
    offset = zero_vector(QQ, dim)
    for i in range(1, dim):
	    offset[i] = R(a*offset[i-1]+c)

    return offset

# yeilds (in order) the minimum and maximum vectors to search between
# parameters:
#   T:	    transformation matrix
#   o:	    offset of the lattice from the origin
#   m:	    lcg modulus
#   dim:    dimension of the lattice
#   data:   ordered outputs of nextInt(int bound)
#   bounds: ordered values of bound for each call to nextInt(int bound)
def find_search_bounds(T, o, m, dim, data, bounds):
    min = zero_vector(QQ, dim)
    max = zero_vector(QQ, dim)

    # determine each minimum and maximum component
    for i in range(0, dim):
        component_min = (m/bounds[i])*data
        component_max = (m/bounds[i])*(data + vector(QQ(1) for i in range(0, dim)))
        row = T.row(i)

        # switch entries if T[i, j] is negative
        for j in range(0, dim):
            if row[j] < 0:
                temp = component_min[j]
                component_min[j] = component_max[j]
                component_max[j] = temp
        
        # transform min and max to integer coordinates
        component_min -= o
        component_max -= o
        min[i] = ceil(row.dot_product(component_min))
        max[i] = floor(row.dot_product(component_max))

    yield min
    yield max

# returns a list of all seeds whose past outputs are consistent with the data
# parameters:
#   A:	    matrix whose columns form a basis for the lattice
#   o:	    offset of the lattice from the origin
#   m:	    lcg modulus
#   dim:    dimension of the lattice
#   min:    minimum vector to search from
#   max:    maximum vector to search to
#   data:   ordered outputs of nextInt(int bound)
#   bounds: ordered values of bound for each call to nextInt(int bound)
def search(A, o, m, dim, min, max, data, bounds):
    transformed_seed = min
    seeds = []
    done = False

    while not done:
        # get outputs from transformed seed candidate
        candidate = A*transformed_seed + o
        outputs = vector(floor((bounds[i]/m)*candidate[i]) for i in range(0, dim))
        if outputs == data:
            seeds.append(candidate[dim-1])
        
        # get next transformed seed candidate
        for i in range(0, dim):
            transformed_seed[i] += 1
            if transformed_seed[i] > max[i]:
                transformed_seed[i] = min[i]
                if i == dim-1:
                    done = True
            else:
                break
    
    return seeds

if __name__ == '__main__': main()
