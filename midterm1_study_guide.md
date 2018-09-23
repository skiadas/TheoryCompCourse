# Midterm 1 Study Guides

The test covers all the material discussed so far up to and including section 5.1 and homeworks 1 through 3. The following set of questions is meant to help guide your study and is not meant to be exhaustive of all the possibilities.

1. Be able to write a SISO Python program that performs simple prescribed tasks (the `isPrime` and `lengthGreaterThan10` kinds of programs).
2. Describe the intented behavior of the programs named `yesOnString`, `notYesOnSelf`. Then:
    - Prove that the program `notYesOnSelf` cannot exist.
    - Show how we can write the program `notYesOnSelf` by using `yesOnString` as a helper.
    - Explain why `yesOnString` cannot exist.
3. Describe reasonable ways to encode each of the following as a single string. Explain both the encoding and the decoding process.
    - A pair of strings of arbitrary length
    - A arbitrary-length list of positive integers
    - A graph, and a weighted graph (page 48)
    - An arbitrary number of strings of arbitrary length
4. Provide precise definitions for each of the following, as well as at least two examples for each:
    - An *alphabet* $\Sigma$.
    - A *string* over an alphabet $\Sigma$.
    - A *language* over an alphabet $\Sigma$ (hint: lots of good examples on page 51).
    - The language $L^*$ for a given language $L$.
    - The language $LM$ for given languages $LM$.
    - The language $\bar L$ for a given language $L$ over an alphabet $\Sigma$.
    - A *computational problem* over an alphabet $\Sigma$.
    - What it means for a program $P$ to *solve* a given computational problem $F$.
    - A *decision problem* over an alphabet $\Sigma$.
    - The language $L_D$ for a decision problem $D$.
    - *positive* and *negative* instances of a decision problem.
    - The problem `isMEMBER(L)` for a given language $L$ over an alphabet $\Sigma$.
5. Define what it means for a language to be *decidable*, and what it means for it to be *recognizable*.
6. Prove that if a language $L$ is decidable, then:
    - The complement language $\bar L$ is also decidable
    - If another language $M$ is decidable then the intersection and union languages $L\cap M$, $L\cup M$ are both decidable.
7. Prove that if L is decidable then L is also recognizable.
8. Provide a precise definition of a *Turing Machine* over an alphabet $\Sigma$.
9. Be able to describe the computation of a Turing Machine based on its state diagram (see p. 76).
10. Be able to write the state diagrams for Turing Machines that accomplish simple tasks.
11. Explain the difference between *accepters* and *transducers* and provide examples of each.
12. Can a problem "loop"? What does that mean? What about a Turing Machine? What about a Python program?
