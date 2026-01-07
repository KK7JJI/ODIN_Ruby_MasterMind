# Source - https://stackoverflow.com/a
# Posted by Ben Ruijl, modified by community. See post 'Timeline' for change history
# Retrieved 2026-01-05, License - CC BY-SA 3.0

def permutation(s):
   if len(s) == 1:
     return [s]

   perm_list = [] # resulting list
   for a in s:
     remaining_elements = [x for x in s if x != a]
     z = permutation(remaining_elements) # permutations of sublist

     for t in z:
       perm_list.append([a] + t)

   return perm_list

print(permutation("cat"))