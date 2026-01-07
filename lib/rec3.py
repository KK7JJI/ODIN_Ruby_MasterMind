def permutations(s, num_pos):
    perm_list = []
    if num_pos == 1:
        for elem in s:
            perm_list.append([elem])
        return perm_list
    else:
        z = permutations(s, num_pos - 1)
        for elem in s:
            for list in z:
                perm_list.append([elem] + list)

        return perm_list

s = "STEVE"
for line in permutations(s, 7):
    print(line)
