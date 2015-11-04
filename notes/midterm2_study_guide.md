# Midterm 2 Study Guide

This is not meant to be an exhaustive list of everything you need to know, but it is a good starting place.

1. Define what a Context-Free Grammar is, and what a Context-Free Language is.
2. Define what a "derivation" in a CFG is, and provide an example.
3. What is a leftmost derivation, and what is a rightmost derivation? Give examples. Do they represent the same parse tree?
4. When is a grammar called "ambiguous"? Give an example. When is a language called ambiguous?
5. When do we say that a CFG is in Chomsky Normal Form? How do we convert a CFG into an equivalent CFG in CNF? Perform the conversions for all the grammars we have encountered so far (arithmetic, polish notation, two more in HW7, and others).
6. Define what a pushdown automaton is. How do we define the language recognized by a pushdown automaton?
7. Given a CFG, there are two pushdown automata associated with it, that recognize the same language. Describe those automata and their transitions (The first automaton was described in the proof that every CFG has an equivalent PDA, and we saw it again in the section on LL parsers, the other is related to LR parsers).
8. Explain how for any pushdown automaton there is an equivalent automaton that has only one accept state and that empties its stack before accepting.
9. Describe, preferably in more than one way, how a regular language has to also be a CFL.
10. True or False: Union of CFLs is CFL.
11. True or False: Intersection of CFLs is CFL.
12. True or False: Complement of CFL is CFL.
13. True or False: Concatenation of CFLs is CFL.
14. True or False: Kleene Star of CFL is CFL.
15. State the pumping lemma, sketch its proof.
16. Use the pumping lemma to provide numerous examples of languages that are not context-free. (Look at the book's problems for examples)
17. True or False: If a CFL is ambiguous then there is no PDA that recognizes it.
18. Describe the rules that we use to find first and follow sets, and how they make sense.
19. Describe how an LL-parser uses the PDA's stack.
20. Describe how an LR-parser uses the PDA's stack.
21. What is an "item"? What is an "item set"?  (LR-parser related) Describe how we build the DFA with states corresponding to the item sets.
22. Demonstrate by an example how an LL-parser traces a leftmost derivation while an LR-parser traces a rightmost derivation.
23. Describe what shift/reduce conflicts are in the context of an LR-parser, and how they can often be automatically resolved.
24. What grammars always cause problems for an LL-parser? Why?
