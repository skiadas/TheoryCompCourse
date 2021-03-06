# List of topics to be covered

- Introduction to Theory of Computation
    - What is it all about? Some key problems/questions?
    - What can we compute with computers?
    - Are there things that we cannot compute?
- Math basics
    - Instill a sense of what constitutes a "proof"
    - Set: subsets, union, intersection, complement
    - Sequences and Tuples. Cartesian products
    - Functions as mathematical objects. Relations
- Logic
    - Predicates
    - Boolean operations
    - Implication
    - Laws
    - Proof examples: DeMorgan's rules
- Alphabets
    - Alphabet as a set
    - Strings. Length. Equality. Substrings. Empty string.
    - Lexicographic ordering.
    - Languages. Provide numerous examples.
    - Union, Concatenation, star
- Deterministic Finite Automata
    - Start states, accept states, state diagrams
    - Formal definition
    - Language accepted by an automaton
    - Equivalent automata
    - Example automata: Recognizing integers, identifiers, fractions
    - Regular languages
    - Union of regular languages is regular
    - What about concatenation? What about star?
- Nondeterministic Finite Automata
    - Examples
    - Definition
    - Example NFAs that recognize same language as a DFA
    - An NFA has an equivalent DFA
    - Language regular if and only if a NFA recognizes it
    - Regular languages closed under union
    - Regular languages closed under concatenation
    - Regular languages closed under star
- Regular Expressions
    - Definition
    - Examples
    - Language regular if and only if regular expression describes it ("if" direction optional?)
    - Generalized NFAs?
- Nonregular languages
    - Intuitively: Why must there be nonregular languages
    - Pumping lemma for regular languages
    - Examples
- Context-Free Languages/Grammars
    - Examples
    - Formal Definition
    - What does "context-free" mean?
    - Terminals, productions, variables
    - Derivation in a CFG, Parse Trees
    - Examples of CFGs that are nonregular
    - Ambiguity. What it means programming-wise
    - Chomsky Normal Forms
    - Every CFG has a corresponding CNF
- PushDown Automata
    - Definition
    - Examples
    - State diagrams for PDAs
    - Every CFG has a PDA recongizing it
    - If a PDA recognizes a language, then it is a CFL
- Non-context free languages
    - Pumping Lemma
    - Examples
- Turing Machines
    - Definition
    - Examples?
    - Turing Recognizable vs Turing Decidable languages
    - Multitape and nondeterministic Turing machines
    - The Church-Turing thesis
- Decidability
    - Decidable problems for regular languages, DFAs, NFAs
    - The Halting Problem
    - Diagonalization argument, undecidability of Halting Problem
    - Unrecognizable languages
- Reducibility
    - Reduction of one problem to another
    - Regularity of languages is undecidable
- Optional
    - Optional? Computation Histories
    - Mapping reducibility formally? (Optional?)
    - Computable functions?
    - Recursion Theorem?
    - Minimal descriptions, information theory
- Time Complexity
    - Asymptotic Notation
    - Time Complexity Classes
    - Class P and examples
    - Class NP and examples
    - NP-completeness
    - The P vs NP question
    - Standard NP-complete problems
