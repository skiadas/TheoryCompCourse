# Midterm 1 Study Guide

This is not meant to be an exhaustive list of everything you need to know, but it is a good starting place.

1. Define what a DFA and an NFA is.
2. Explain the differences between DFAs and NFAs.
3. Given a description for a language, construct DFAs/NFAs for it.
4. Given a regular expression, construct an NFA from it.
5. Given an NFA, construct an equivalent DFA.
6. Formally describe when we would say that we *accept* a string in a DFA, and in an NFA.
7. Describe the union construction for DFAs and provide an explanation/proof of its correctness (i.e. that the language of the union DFA is the union of the corresponding languages).
8. Do the same for the NFA union (the one with only one extra state).
9. Do the same for the NFA concatenation and the NFA Kleene star.
10. Explain the source of difficulty when trying to perform concatenation for DFAs, and what feature of NFAs helps out.
11. True or false: Every DFA is equivalent to a DFA with exactly one accept state.
12. True or false: Every NFA is equivalent to a NFA with exactly one accept state.
13. Describe the construction of a DFA that is equivalent to a given NFA.
14. One may try to produce the Kleene star without adding a new start state. Show by an example how this may produce the wrong language.
15. State precisely what the pumping lemma says.
16. Sketch the proof of the pumping lemma.
17. Provide examples of languages that are not regular, together with both an intuitive explanation of why they are probably not regular as well as a formal proof using the pumping lemma.
18. True or False: Given two DFAs, we can tell if they recognize the same language.
19. True or False: Given a NFA, we can tell if it recognizes the empty string.
20. True or False: Given an NFA, we can determine if it contains any strings other than the empty string.
