# Finite Automata

In this section we start our formal investigations into various models of computation, starting with one of the simplest forms: finite automata.

## Reading

Sections 1.1

Practice problems (page 83): 1.1, 1.3, 1.4, 1.6, 1.36, 1.37

## Finite Automata

### Examples and State Diagrams

The idea of a finite automaton is simple:

- You have some number of "states" that you can be in.
- There is some state you start from.
- Then on each input there's a specific state you go to. And you forget everything about what happened before.
- When you run out of input, you look at the state you are in, and see if it is one of the select few states that would be considered "final".

We usually represent finite automata via a **state diagram**:

> In the **state diagram for a finite automaton, you have:
> - One "circle" for each state.
> - For each state arrows going out to other states, with a label on the arrows indicating the inputs for which they are applicable.
> - An arrow coming from nowhere indicates the *start state*.
> - An extra circle around a state indicates it is an *accept state*.

As an example, let us think of inputs being binary numbers (only $0$ and $1$ as digits), and we want a finite automaton that detects if the number is divisible by $3$. Recall that a number is divisible by $3$ if and only if the sum of its digits are. Since we see the digits one at a time, we will keep track of the remainder on division by $3$ at each stage. So:

- We will have 3 states, one for remainder $0$, one for remainder $1$ and one for remainder $2$.
- The $0$ state is the start state.
- The $0$ state is also the only accept state.
- From each state we have an arrow to itself, for input `0`.
- For input `1` we have arrows from state $0$ to state $1$, from state $1$ to state $2$ and from state $2$ to state $0$.

Now as practice for you: Suppose we want a finite automaton that detects division by $7$. We can still do it by keeping track of the remainder, but some changes would need to be made:

- We now have $7$ states, corresponding to the remainders $0$ through $6$.
- If we are at a state $k$, meaning the remainder of our current number when divided by $7$ is $k$, then we need to figure out what happens when we add one more digit. This is easy to do because of the properties of modular arithmetic, and because we can describe the effect of adding one more digit to the number: The number is doubled, and increased by the digit we are adding.
- So for example if we are at state $3$, meaning the remainder is now $3$, then on an input `0` we got to state $6$ and on input `1` we go to state $0$.
- Similarly if we are at state $5$, then because $2\times 5 = 3 \mod 7$ we would be going to state $3$ on input `0` and to state `4` on input `1`.

Exercise 1.37 asks you to generalize this idea.

### Formal Definitions

Eventually we want to have clear unambiguous definitions, so here is a more precise definition of finite automata:

> A **(Deterministic) Finite Automaton** (DFA) is a $5$-tuple $(Q, \Sigma, \delta, q_0, F)$, where:
> - $Q$ is a finite set, called the *states*,
> - $\Sigma$ is a finite set, called the *alphabet*,
> - $\delta\colon Q\times \Sigma \to Q$ is the *transition function*,
> - $q_0\in Q$ is the *start state*, (in particular $Q$ must be nonempty)
> - $F\subset Q$ is the set of *accept or final states* (possibly empty)

Question 1: What happens if $F$ is the empty set? What if $F = S$?

Question 2: Use this formal definition to describe the automaton for division by $3$ that we described earlier.

Question 3: Do the same for the automaton for division by $2$.

We now discuss the meaning of computation in this setting. Informally we compute as follows:

- We start at the start state.
- We also have a string from $\Sigma$. We want to see if the DFA will accept it.
- We go through each letter in the string in order, and use the $\delta$ function to transition to a new state each time.
- When we run out of input, we see if we are at an accept/final state. If so then we "accept" the string.

More formally:

> Suppose $M = (Q, \Sigma, \delta, q_0, F)$ is a DFA.
> - If $w=w_1w_2\cdots w_n$ is a string, where each $w_i\in\Sigma$, then we say that the DFA $M$ **accepts** the string $w$ if there is a sequence of states $r_0,\ldots,r_n$ such that:
>     - $r_0 = q_0$ is the start state
>     - $\delta(r_i, w_{i+1}) = r_{i+1}$, i.e. each new input moves us to the next state
>     - $r_n\in F$, i.e. the last state is in the special subset of accept states.
> - We say that the DFA $M$ **recognizes** the language $L$, and we write $L(M) = L$, if $M$ accepts exactly those strings that are in $L$.
> - A language is called a **regular language** if there is a DFA that recognizes it.

Note that there might be many DFAs all recognizing the same language. But for a given DFA there is exactly one language it recognizes, namely the language of all strings in $\Sigma$ that the DFA accepts.
