Require Import Unicode.Utf8.
Require Import Classical_Prop.
Require Import ClassicalFacts.
Require Import PropExtensionality.

Module No1.

Import Unicode.Utf8.
Import ClassicalFacts.
Import Classical_Prop.
Import PropExtensionality.

  (*We first give the axioms of Principia in *1.*)

Theorem Impl1_01 : ∀ P Q : Prop, 

  (P → Q) = (¬P ∨ Q). 
  Proof. intros P Q.
  apply propositional_extensionality.
  split.
  apply imply_to_or.
  apply or_to_imply.
Qed.
  (*This is a notational definition in Principia: 
    It is used to switch between "∨" and "→".*)
  
Theorem MP1_1 : ∀  P Q : Prop,
  (P → Q) → P → Q. (*Modus ponens*)
  Proof. intros P Q.
  intros iff_refl.
  apply iff_refl.
Qed.
  (*1.11 ommitted: it is MP for propositions 
      containing variables. Likewise, ommitted 
      the well-formedness rules 1.7, 1.71, 1.72*)

Theorem Taut1_2 : ∀ P : Prop, 
  P ∨ P → P. (*Tautology*)
  Proof. intros P.
  apply imply_and_or.
  apply iff_refl.
Qed.

Theorem Add1_3 : ∀ P Q : Prop, 
  Q → P ∨ Q. (*Addition*)
  Proof. intros P Q.
  apply or_intror.
Qed.

Theorem Perm1_4 : ∀ P Q : Prop, 
  P ∨ Q → Q ∨ P. (*Permutation*)
Proof. intros P Q.
  apply or_comm.
Qed.

(* Reference: https://softwarefoundations.cis.upenn.edu/lf-current/Logic.html#or_assoc *)
Theorem Assoc1_5: ∀ P Q R : Prop,
  P ∨ (Q ∨ R) → Q ∨ (P ∨ R).
Proof.
  intros P Q R.
  intros [H | [H | H]].
  - right. left. apply H.
  - left. apply H.
  - right. right. apply H.
Qed.

(* Theorem Assoc1_5 : ∀ P Q R : Prop,
  P ∨ (Q ∨ R) → Q ∨ (P ∨ R). (*Association*)
Proof. intros P Q R.
  specialize or_assoc with P Q R.
  intros or_assoc1.
  replace (P∨Q∨R) with ((P∨Q)∨R).
  specialize or_comm with P Q.
  intros or_comm1.
  replace (P∨Q) with (Q∨P).
  specialize or_assoc with Q P R.
  intros or_assoc2.
  replace ((Q∨P)∨R) with (Q∨P∨R).
  apply iff_refl.
  apply propositional_extensionality.
  apply iff_sym.
  apply or_assoc2.
  apply propositional_extensionality.
  apply or_comm.
  apply propositional_extensionality.
  apply or_assoc.
Qed. *)

Theorem Sum1_6 : ∀ P Q R : Prop, 
  (Q → R) → (P ∨ Q → P ∨ R). (*Summation*)
Proof. intros P Q R.
  intros QR [HP | HQ].
  - left. apply HP.
  - right. apply QR in HQ. apply HQ.
Qed.


(* Theorem Sum1_6 : ∀ P Q R : Prop, 
  (Q → R) → (P ∨ Q → P ∨ R). (*Summation*)
Proof. intros P Q R.
  specialize imply_and_or2 with Q R P.
  intros imply_and_or2a.
  replace (P∨Q) with (Q∨P).
  replace (P∨R) with (R∨P).
  apply imply_and_or2a.
  apply propositional_extensionality.
  apply or_comm.
  apply propositional_extensionality.
  apply or_comm.
Qed. *)

Ltac MP H1 H2 :=
  match goal with 
    | [ H1 : ?P → ?Q, H2 : ?P |- _ ] => 
      specialize (H1 H2)
  end.
 (*We give this Ltac "MP" to make proofs 
  more human-readable and to more 
  closely mirror Principia's style.*)

End No1.

Module No2.

Import No1.

(*We proceed to the deductions of of Principia.*)

Theorem Abs2_01 : ∀ P : Prop,
  (P → ¬P) → ¬P.
Proof. intros P.
  specialize Taut1_2 with (¬P).
  intros Taut1_2.
  replace (¬P ∨ ¬P) with (P → ¬P) in Taut1_2
    by now rewrite Impl1_01.
  exact Taut1_2.
Qed.

Theorem Simp2_02 : ∀ P Q : Prop, 
  Q → (P → Q).
Proof. intros P Q.
  specialize Add1_3 with (¬P) Q.
  intros Add1_3.
  replace (¬P ∨ Q) with (P → Q) in Add1_3
    by now rewrite Impl1_01.
  exact Add1_3.
Qed.

Theorem Transp2_03 : ∀ P Q : Prop,
  (P → ¬Q) → (Q → ¬P).
Proof. intros P Q.
  specialize Perm1_4 with (¬P) (¬Q).
  intros Perm1_4.
  replace (¬P ∨ ¬Q) with (P → ¬Q) in Perm1_4
    by now rewrite Impl1_01. 
  replace (¬Q ∨ ¬P) with (Q → ¬P) in Perm1_4
    by now rewrite Impl1_01.
  exact Perm1_4.
Qed.

Theorem Comm2_04 : ∀ P Q R : Prop,
  (P → (Q → R)) → (Q → (P → R)).
Proof. intros P Q R.
  specialize Assoc1_5 with (¬P) (¬Q) R.
  intros Assoc1_5.
  replace (¬Q ∨ R) with (Q → R) in Assoc1_5
    by now rewrite Impl1_01. 
  replace (¬P ∨ (Q → R)) with (P → (Q → R)) in Assoc1_5
    by now rewrite Impl1_01. 
  replace (¬P ∨ R) with (P → R) in Assoc1_5
    by now rewrite Impl1_01. 
  replace (¬Q ∨ (P → R)) with (Q → (P → R)) in Assoc1_5
    by now rewrite Impl1_01. 
  exact Assoc1_5.
Qed.

Theorem Syll2_05 : ∀ P Q R : Prop,
  (Q → R) → ((P  → Q) → (P → R)).
Proof. intros P Q R.
  specialize Sum1_6 with (¬P) Q R.
  intros Sum1_6.
  replace (¬P ∨ Q) with (P → Q) in Sum1_6
    by now rewrite Impl1_01.  
  replace (¬P ∨ R) with (P → R) in Sum1_6
    by now rewrite Impl1_01.
  exact Sum1_6.
Qed.

Theorem Syll2_06 : ∀ P Q R : Prop,
  (P → Q) → ((Q → R) → (P → R)).
Proof. intros P Q R. 
  specialize Comm2_04 with (Q → R) (P → Q) (P → R). 
  intros Comm2_04.
  specialize Syll2_05 with P Q R. 
  intros Syll2_05.
  MP Comm2_04 Syll2_05.
  exact Comm2_04.
Qed.

Theorem n2_07 : ∀ P : Prop,
  P → (P ∨ P).
Proof. intros P.
  specialize Add1_3 with P P.
  intros Add1_3.
  exact Add1_3.
Qed.

Theorem Id2_08 : ∀ P : Prop,
  P → P.
Proof. intros P.
  specialize Syll2_05 with P (P ∨ P) P. 
  intros Syll2_05.
  specialize Taut1_2 with P. 
  intros Taut1_2.
  MP Syll2_05 Taut1_2.
  specialize n2_07 with P.
  intros n2_07.
  MP Syll2_05 n2_07.
  exact Syll2_05.
Qed.

Theorem n2_1 : ∀ P : Prop,
  (¬P) ∨ P.
Proof. intros P.
  specialize Id2_08 with P. 
  intros Id2_08.
  replace (P → P) with (¬P ∨ P) in Id2_08
    by now rewrite Impl1_01. 
  exact Id2_08.
Qed.

Theorem n2_11 : ∀ P : Prop,
  P ∨ ¬P.
Proof. intros P.
  specialize Perm1_4 with (¬P) P. 
  intros Perm1_4.
  specialize n2_1 with P. 
  intros n2_1.
  MP Perm1_4 n2_1.
  exact Perm1_4.
Qed.

Theorem n2_12 : ∀ P : Prop,
  P → ¬¬P.
Proof. intros P.
  specialize n2_11 with (¬P). 
  intros n2_11.
  replace (¬P ∨ ¬¬P) with (P → ¬¬P) in n2_11
    by now rewrite Impl1_01.
  exact n2_11.
Qed.

Theorem n2_13 : ∀ P : Prop,
  P ∨ ¬¬¬P.
Proof. intros P.
  specialize Sum1_6 with P (¬P) (¬¬¬P). 
  intros Sum1_6.
  specialize n2_12 with (¬P). 
  intros n2_12.
  MP Sum1_6 n2_12.
  specialize n2_11 with P.
  intros n2_11.
  MP Sum1_6 n2_11.
  exact Sum1_6.
Qed.

Theorem n2_14 : ∀ P : Prop,
  ¬¬P → P.
Proof. intros P.
  specialize Perm1_4 with P (¬¬¬P). 
  intros Perm1_4.
  specialize n2_13 with P. 
  intros n2_13.
  MP Perm1_4 n2_13.
  replace (¬¬¬P ∨ P) with (¬¬P → P) in Perm1_4
    by now rewrite Impl1_01.
  exact Perm1_4.
Qed.

Theorem Transp2_15 : ∀ P Q : Prop,
  (¬P → Q) → (¬Q → P).
Proof. intros P Q.
  specialize Syll2_05 with (¬P) Q (¬¬Q). 
  intros Syll2_05a.
  specialize n2_12 with Q. 
  intros n2_12.
  MP Syll2_05a n2_12.
  specialize Transp2_03 with (¬P) (¬Q). 
  intros Transp2_03.
  specialize Syll2_05 with (¬Q) (¬¬P) P. 
  intros Syll2_05b.
  specialize n2_14 with P.
  intros n2_14.
  MP Syll2_05b n2_14.
  specialize Syll2_05 with (¬P → Q) (¬P → ¬¬Q) (¬Q → ¬¬P). 
  intros Syll2_05c.
  MP Syll2_05c Transp2_03.
  MP Syll2_05c Syll2_05a.
  specialize Syll2_05 with (¬P → Q) (¬Q → ¬¬P) (¬Q → P). 
  intros Syll2_05d.
  MP Syll2_05d Syll2_05b.
  MP Syll2_05d Syll2_05c.
  exact Syll2_05d.
Qed.

Ltac Syll H1 H2 S :=
  let S := fresh S in match goal with 
    | [ H1 : ?P → ?Q, H2 : ?Q → ?R |- _ ] =>
       assert (S : P → R) by (intros p; exact (H2 (H1 p)))
end. 

Theorem Transp2_16 : ∀ P Q : Prop,
  (P → Q) → (¬Q → ¬P).
Proof. intros P Q.
  specialize n2_12 with Q. 
  intros n2_12a.
  specialize Syll2_05 with P Q (¬¬Q). 
  intros Syll2_05a.
  specialize Transp2_03 with P (¬Q). 
  intros Transp2_03a.
  MP n2_12a Syll2_05a.
  Syll Syll2_05a Transp2_03a S.
  exact S.
Qed.

Theorem Transp2_17 : ∀ P Q : Prop,
  (¬Q → ¬P) → (P → Q).
Proof. intros P Q.
  specialize Transp2_03 with (¬Q) P. 
  intros Transp2_03a.
  specialize n2_14 with Q. 
  intros n2_14a.
  specialize Syll2_05 with P (¬¬Q) Q. 
  intros Syll2_05a.
  MP n2_14a Syll2_05a.
  Syll Transp2_03a Syll2_05a S.
  exact S.
Qed.

Theorem n2_18 : ∀ P : Prop,
  (¬P → P) → P.
Proof. intros P.
  specialize n2_12 with P.
  intro n2_12a.
  specialize Syll2_05 with (¬P) P (¬¬P). 
  intro Syll2_05a.
  MP Syll2_05a n2_12.
  specialize Abs2_01 with (¬P). 
  intros Abs2_01a.
  Syll Syll2_05a Abs2_01a Sa.
  specialize n2_14 with P. 
  intros n2_14a.
  Syll H n2_14a Sb.
  exact Sb.
Qed.

Theorem n2_2 : ∀ P Q : Prop,
  P → (P ∨ Q).
Proof. intros P Q.
  specialize Add1_3 with Q P. 
  intros Add1_3a.
  specialize Perm1_4 with Q P. 
  intros Perm1_4a.
  Syll Add1_3a Perm1_4a S.
  exact S.
Qed.

Theorem n2_21 : ∀ P Q : Prop,
  ¬P → (P → Q).
Proof. intros P Q.
  specialize n2_2 with (¬P) Q. 
  intros n2_2a.
  replace (¬P∨Q) with (P→Q) in n2_2a
    by now rewrite Impl1_01.
  exact n2_2a.
Qed.

Theorem n2_24 : ∀ P Q : Prop,
  P → (¬P → Q).
Proof. intros P Q.
  specialize n2_21 with P Q. 
  intros n2_21a.
  specialize Comm2_04 with (¬P) P Q. 
  intros Comm2_04a.
  MP Comm2_04a n2_21a.
  exact Comm2_04a.
Qed.

Theorem n2_25 : ∀ P Q : Prop,
  P ∨ ((P ∨ Q) → Q).
Proof. intros P Q.
  specialize n2_1 with (P ∨ Q).
  intros n2_1a.
  specialize Assoc1_5 with (¬(P∨Q)) P Q. 
  intros Assoc1_5a.
  MP Assoc1_5a n2_1a.
  replace (¬(P∨Q)∨Q) with (P∨Q→Q) in Assoc1_5a
    by now rewrite Impl1_01.
  exact Assoc1_5a.
Qed.

Theorem n2_26 : ∀ P Q : Prop,
  ¬P ∨ ((P → Q) → Q).
Proof. intros P Q.
  specialize n2_25 with (¬P) Q. 
  intros n2_25a.
  replace (¬P∨Q) with (P→Q) in n2_25a
    by now rewrite Impl1_01.
  exact n2_25a.
Qed.

Theorem n2_27 : ∀ P Q : Prop,
  P → ((P → Q) → Q).
Proof. intros P Q.
  specialize n2_26 with P Q. 
  intros n2_26a.
  replace (¬P∨((P→Q)→Q)) with (P→(P→Q)→Q) 
    in n2_26a by now rewrite Impl1_01. 
  exact n2_26a.
Qed.

Theorem n2_3 : ∀ P Q R : Prop,
  (P ∨ (Q ∨ R)) → (P ∨ (R ∨ Q)).
Proof. intros P Q R.
  specialize Perm1_4 with Q R. 
  intros Perm1_4a.
  specialize Sum1_6 with P (Q∨R) (R∨Q). 
  intros Sum1_6a.
  MP Sum1_6a Perm1_4a.
  exact Sum1_6a.
Qed.

Theorem n2_31 : ∀ P Q R : Prop,
  (P ∨ (Q ∨ R)) → ((P ∨ Q) ∨ R).
Proof. intros P Q R.
  specialize n2_3 with P Q R. 
  intros n2_3a.
  specialize Assoc1_5 with P R Q. 
  intros Assoc1_5a.
  specialize Perm1_4 with R (P∨Q). 
  intros Perm1_4a.
  Syll Assoc1_5a Perm1_4a Sa.
  Syll n2_3a Sa Sb.
  exact Sb.
Qed.

Theorem n2_32 : ∀ P Q R : Prop,
  ((P ∨ Q) ∨ R) → (P ∨ (Q ∨ R)).
Proof. intros P Q R.
  specialize Perm1_4 with (P∨Q) R. 
  intros Perm1_4a.
  specialize Assoc1_5 with R P Q. 
  intros Assoc1_5a.
  specialize n2_3 with P R Q. 
  intros n2_3a.
  specialize Syll2_06 with ((P∨Q)∨R) (R∨P∨Q) (P∨R∨Q). 
  intros Syll2_06a.
  MP Syll2_06a Perm1_4a.
  MP Syll2_06a Assoc1_5a.
  specialize Syll2_06 with ((P∨Q)∨R) (P∨R∨Q) (P∨Q∨R). 
  intros Syll2_06b.
  MP Syll2_06b Syll2_06a.
  MP Syll2_06b n2_3a.
  exact Syll2_06b.
Qed.

(* Theorem Abb2_33 : ∀ P Q R : Prop,
  (P ∨ Q ∨ R) = ((P ∨ Q) ∨ R). 
Proof. intros P Q R. rewrite -> n2_32. *)

Theorem Abb2_33 : ∀ P Q R : Prop,
  (P ∨ Q ∨ R) = ((P ∨ Q) ∨ R). 
Proof. intros P Q R.
  apply propositional_extensionality.
  split.
  specialize n2_31 with P Q R.
  intros n2_31.
  exact n2_31.
  specialize n2_32 with P Q R.
  intros n2_32.
  exact n2_32.
Qed.
  (*The default in Coq is right association.*)

Theorem n2_36 : ∀ P Q R : Prop,
  (Q → R) → ((P ∨ Q) → (R ∨ P)).
Proof. intros P Q R.
  specialize Perm1_4 with P R. 
  intros Perm1_4a.
  specialize Syll2_05 with (P∨Q) (P∨R) (R∨P). 
  intros Syll2_05a.
  MP Syll2_05a Perm1_4a.
  specialize Sum1_6 with P Q R. 
  intros Sum1_6a.
  Syll Sum1_6a Syll2_05a S.
  exact S.
Qed.

Theorem n2_37 : ∀ P Q R : Prop,
  (Q → R) → ((Q ∨ P) → (P ∨ R)).
Proof. intros P Q R.
  specialize Perm1_4 with Q P. 
  intros Perm1_4a.
  specialize Syll2_06 with (Q∨P) (P∨Q) (P∨R). 
  intros Syll2_06a.
  MP Syll2_06a Perm1_4a.
  specialize Sum1_6 with P Q R. 
  intros Sum1_6a.
  Syll Sum1_6a Syll2_06a S.
  exact S.
Qed.

Theorem n2_38 : ∀ P Q R : Prop,
  (Q → R) → ((Q ∨ P) → (R ∨ P)).
Proof. intros P Q R.
  specialize Perm1_4 with P R. 
  intros Perm1_4a.
  specialize Syll2_05 with (Q∨P) (P∨R) (R∨P). 
  intros Syll2_05a.
  MP Syll2_05a Perm1_4a.
  specialize Perm1_4 with Q P. 
  intros Perm1_4b.
  specialize Syll2_06 with (Q∨P) (P∨Q) (P∨R). 
  intros Syll2_06a.
  MP Syll2_06a Perm1_4b.
  Syll Syll2_06a Syll2_05a H.
  specialize Sum1_6 with P Q R. 
  intros Sum1_6a.
  Syll Sum1_6a H S.
  exact S.
Qed.

Theorem n2_4 : ∀ P Q : Prop,
  (P ∨ (P ∨ Q)) → (P ∨ Q).
Proof. intros P Q.
  specialize n2_31 with P P Q. 
  intros n2_31a.
  specialize Taut1_2 with P. 
  intros Taut1_2a.
  specialize n2_38 with Q (P∨P) P. 
  intros n2_38a.
  MP n2_38a Taut1_2a.
  Syll n2_31a n2_38a S.
  exact S.
Qed.

Theorem n2_41 : ∀ P Q : Prop,
  (Q ∨ (P ∨ Q)) → (P ∨ Q).
Proof. intros P Q.
  specialize Assoc1_5 with Q P Q. 
  intros Assoc1_5a.
  specialize Taut1_2 with Q. 
  intros Taut1_2a.
  specialize Sum1_6 with P (Q∨Q) Q. 
  intros Sum1_6a.
  MP Sum1_6a Taut1_2a.
  Syll Assoc1_5a Sum1_6a S.
  exact S.
Qed.

Theorem n2_42 : ∀ P Q : Prop,
  (¬P ∨ (P → Q)) → (P → Q).
Proof. intros P Q.
  specialize n2_4 with (¬P) Q. 
  intros n2_4a.
  replace (¬P∨Q) with (P→Q) in n2_4a
    by now rewrite Impl1_01.
  exact n2_4a. 
Qed.

Theorem n2_43 : ∀ P Q : Prop,
  (P → (P → Q)) → (P → Q).
Proof. intros P Q.
  specialize n2_42 with P Q. 
  intros n2_42a.
  replace (¬P ∨ (P→Q)) with (P→(P→Q)) 
    in n2_42a by now rewrite Impl1_01. 
  exact n2_42a. 
Qed.

Theorem n2_45 : ∀ P Q : Prop,
  ¬(P ∨ Q) → ¬P.
Proof. intros P Q.
  specialize n2_2 with P Q. 
  intros n2_2a.
  specialize Transp2_16 with P (P∨Q). 
  intros Transp2_16a.
  MP n2_2 Transp2_16a.
  exact Transp2_16a.
Qed.

Theorem n2_46 : ∀ P Q : Prop,
  ¬(P ∨ Q) → ¬Q.
Proof. intros P Q.
  specialize Add1_3 with P Q. 
  intros Add1_3a.
  specialize Transp2_16 with Q (P∨Q). 
  intros Transp2_16a.
  MP Add1_3a Transp2_16a.
  exact Transp2_16a.
Qed.

Theorem n2_47 : ∀ P Q : Prop,
  ¬(P ∨ Q) → (¬P ∨ Q).
Proof. intros P Q.
  specialize n2_45 with P Q. 
  intros n2_45a.
  specialize n2_2 with (¬P) Q. 
  intros n2_2a.
  Syll n2_45a n2_2a S.
  exact S.
Qed.

Theorem n2_48 : ∀ P Q : Prop,
  ¬(P ∨ Q) → (P ∨ ¬Q).
Proof. intros P Q.
  specialize n2_46 with P Q. 
  intros n2_46a.
  specialize Add1_3 with P (¬Q). 
  intros Add1_3a.
  Syll n2_46a Add1_3a S.
  exact S.
Qed.

Theorem n2_49 : ∀ P Q : Prop,
  ¬(P ∨ Q) → (¬P ∨ ¬Q).
Proof. intros P Q.
  specialize n2_45 with P Q. 
  intros n2_45a.
  specialize n2_2 with (¬P) (¬Q). 
  intros n2_2a.
  Syll n2_45a n2_2a S.
  exact S.
Qed.

Theorem n2_5 : ∀ P Q : Prop,
  ¬(P → Q) → (¬P → Q).
Proof. intros P Q.
  specialize n2_47 with (¬P) Q. 
  intros n2_47a.
  replace (¬P∨Q) with (P→Q) in n2_47a
    by now rewrite Impl1_01.
  replace (¬¬P∨Q) with (¬P→Q) in n2_47a
    by now rewrite Impl1_01.
  exact n2_47a.
Qed.

Theorem n2_51 : ∀ P Q : Prop,
  ¬(P → Q) → (P → ¬Q).
Proof. intros P Q.
  specialize n2_48 with (¬P) Q. 
  intros n2_48a.
  replace (¬P∨Q) with (P→Q) in n2_48a
    by now rewrite Impl1_01.
  replace (¬P∨¬Q) with (P→¬Q) in n2_48a
    by now rewrite Impl1_01.
  exact n2_48a.
Qed.

Theorem n2_52 : ∀ P Q : Prop,
  ¬(P → Q) → (¬P → ¬Q).
Proof. intros P Q.
  specialize n2_49 with (¬P) Q. 
  intros n2_49a.
  replace (¬P∨Q) with (P→Q) in n2_49a
   by now rewrite Impl1_01.
  replace (¬¬P∨¬Q) with (¬P→¬Q) in n2_49a
    by now rewrite Impl1_01.
  exact n2_49a.
Qed.

Theorem n2_521 : ∀ P Q : Prop,
  ¬(P→Q)→(Q→P).
Proof. intros P Q.
  specialize n2_52 with P Q. 
  intros n2_52a.
  specialize Transp2_17 with Q P. 
  intros Transp2_17a.
  Syll n2_52a Transp2_17a S.
  exact S.
Qed.

Theorem n2_53 : ∀ P Q : Prop,
  (P ∨ Q) → (¬P → Q).
Proof. intros P Q.
  specialize n2_12 with P. 
  intros n2_12a.
  specialize n2_38 with Q P (¬¬P). 
  intros n2_38a.
  MP n2_38a n2_12a.
  replace (¬¬P∨Q) with (¬P→Q) in n2_38a
    by now rewrite Impl1_01.
  exact n2_38a. 
Qed.

Theorem n2_54 : ∀ P Q : Prop,
  (¬P → Q) → (P ∨ Q).
Proof. intros P Q.
  specialize n2_14 with P. 
  intros n2_14a.
  specialize n2_38 with Q (¬¬P) P. 
  intros n2_38a.
  MP n2_38a n2_12a.
  replace (¬¬P∨Q) with (¬P→Q) in n2_38a
    by now rewrite Impl1_01.
  exact n2_38a. 
Qed.

Theorem n2_55 : ∀ P Q : Prop,
  ¬P → ((P ∨ Q) → Q).
Proof. intros P Q.
  specialize n2_53 with P Q.
  intros n2_53a.
  specialize Comm2_04 with (P∨Q) (¬P) Q. 
  intros Comm2_04a.
  MP n2_53a Comm2_04a.
  exact Comm2_04a.
Qed.

Theorem n2_56 : ∀ P Q : Prop,
  ¬Q → ((P ∨ Q) → P).
Proof. intros P Q.
  specialize n2_55 with Q P. 
  intros n2_55a.
  specialize Perm1_4 with P Q. 
  intros Perm1_4a.
  specialize Syll2_06 with (P∨Q) (Q∨P) P. 
  intros Syll2_06a.
  MP Syll2_06a Perm1_4a.
  Syll n2_55a Syll2_06a Sa.
  exact Sa.
Qed.

Theorem n2_6 : ∀ P Q : Prop,
  (¬P→Q) → ((P → Q) → Q).
Proof. intros P Q.
  specialize n2_38 with Q (¬P) Q. 
  intros n2_38a.
  specialize Taut1_2 with Q. 
  intros Taut1_2a.
  specialize Syll2_05 with (¬P∨Q) (Q∨Q) Q. 
  intros Syll2_05a.
  MP Syll2_05a Taut1_2a.
  Syll n2_38a Syll2_05a S.
  replace (¬P∨Q) with (P→Q) in S
    by now rewrite Impl1_01.
  exact S.
Qed.

Theorem n2_61 : ∀ P Q : Prop,
  (P → Q) → ((¬P → Q) → Q).
Proof. intros P Q.
  specialize n2_6 with P Q. 
  intros n2_6a.
  specialize Comm2_04 with (¬P→Q) (P→Q) Q. 
  intros Comm2_04a.
  MP Comm2_04a n2_6a.
  exact Comm2_04a.
Qed.

Theorem n2_62 : ∀ P Q : Prop,
  (P ∨ Q) → ((P → Q) → Q).
Proof. intros P Q.
  specialize n2_53 with P Q. 
  intros n2_53a.
  specialize n2_6 with P Q. 
  intros n2_6a.
  Syll n2_53a n2_6a S.
  exact S.
Qed.

Theorem n2_621 : ∀ P Q : Prop,
  (P → Q) → ((P ∨ Q) → Q).
Proof. intros P Q.
  specialize n2_62 with P Q. 
  intros n2_62a.
  specialize Comm2_04 with (P ∨ Q) (P→Q) Q. 
  intros Comm2_04a.
  MP Comm2_04a n2_62a. 
  exact Comm2_04a.
Qed.

Theorem n2_63 : ∀ P Q : Prop,
  (P ∨ Q) → ((¬P ∨ Q) → Q).
Proof. intros P Q.
  specialize n2_62 with P Q. 
  intros n2_62a.
  replace (P→Q) with (¬P∨Q) in n2_62a
    by now rewrite Impl1_01.
  exact n2_62a.
Qed.

Theorem n2_64 : ∀ P Q : Prop,
  (P ∨ Q) → ((P ∨ ¬Q) → P).
Proof. intros P Q.
  specialize n2_63 with Q P. 
  intros n2_63a.
  specialize Perm1_4 with P Q. 
  intros Perm1_4a.
  Syll n2_63a Perm1_4a Ha.
  specialize Syll2_06 with (P∨¬Q) (¬Q∨P) P.
  intros Syll2_06a.
  specialize Perm1_4 with P (¬Q).
  intros Perm1_4b.
  MP Syll2_06a Perm1_4b.
  Syll Syll2_06a Ha S.
  exact S.
Qed.

Theorem n2_65 : ∀ P Q : Prop,
  (P → Q) → ((P → ¬Q) → ¬P).
Proof. intros P Q.
  specialize n2_64 with (¬P) Q. 
  intros n2_64a.
  replace (¬P∨Q) with (P→Q) in n2_64a
    by now rewrite Impl1_01.
  replace (¬P∨¬Q) with (P→¬Q) in n2_64a
    by now rewrite Impl1_01.
  exact n2_64a.
Qed.

Theorem n2_67 : ∀ P Q : Prop,
  ((P ∨ Q) → Q) → (P → Q).
Proof. intros P Q.
  specialize n2_54 with P Q. 
  intros n2_54a.
  specialize Syll2_06 with (¬P→Q) (P∨Q) Q. 
  intros Syll2_06a.
  MP Syll2_06a n2_54a.
  specialize n2_24 with  P Q. 
  intros n2_24.
  specialize Syll2_06 with P (¬P→Q) Q. 
  intros Syll2_06b.
  MP Syll2_06b n2_24a.
  Syll Syll2_06b Syll2_06a S.
  exact S.
Qed.

Theorem n2_68 : ∀ P Q : Prop,
  ((P → Q) → Q) → (P ∨ Q).
Proof. intros P Q.
  specialize n2_67 with (¬P) Q. 
  intros n2_67a.
  replace (¬P∨Q) with (P→Q) in n2_67a
    by now rewrite Impl1_01.
  specialize n2_54 with P Q. 
  intros n2_54a.
  Syll n2_67a n2_54a S.
  exact S.
Qed.

Theorem n2_69 : ∀ P Q : Prop,
  ((P → Q) → Q) → ((Q → P) → P).
Proof. intros P Q.
  specialize n2_68 with P Q. 
  intros n2_68a.
  specialize Perm1_4 with P Q. 
  intros Perm1_4a.
  Syll n2_68a Perm1_4a Sa.
  specialize n2_62 with Q P. 
  intros n2_62a.
  Syll Sa n2_62a Sb.
  exact Sb.
Qed.

Theorem n2_73 : ∀ P Q R : Prop,
  (P → Q) → (((P ∨ Q) ∨ R) → (Q ∨ R)).
Proof. intros P Q R.
  specialize n2_621 with P Q. 
  intros n2_621a.
  specialize n2_38 with R (P∨Q) Q. 
  intros n2_38a.
  Syll n2_621a n2_38a S.
  exact S.
Qed.

Theorem n2_74 : ∀ P Q R : Prop,
  (Q → P) → ((P ∨ Q) ∨ R) → (P ∨ R).
Proof. intros P Q R.
  specialize n2_73 with Q P R. 
  intros n2_73a.
  specialize Assoc1_5 with P Q R. 
  intros Assoc1_5a.
  specialize n2_31 with Q P R. 
  intros n2_31a. (*not cited*)
  Syll Assoc1_5a n2_31a Sa. 
  specialize n2_32 with P Q R. 
  intros n2_32a. (*not cited*)
  Syll n2_32a Sa Sb.
  specialize Syll2_06 with ((P∨Q)∨R) ((Q∨P)∨R) (P∨R). 
  intros Syll2_06a.
  MP Syll2_06a Sb.
  Syll n2_73a Syll2_05a H.
  exact H.
Qed.

Theorem n2_75 : ∀ P Q R : Prop,
  (P ∨ Q) → ((P ∨ (Q → R)) → (P ∨ R)).
Proof. intros P Q R.
  specialize n2_74 with P (¬Q) R. 
  intros n2_74a.
  specialize n2_53 with Q P. 
  intros n2_53a.
  Syll n2_53a n2_74a Sa.
  specialize n2_31 with P (¬Q) R. 
  intros n2_31a.
  specialize Syll2_06 with (P∨(¬Q)∨R)((P∨(¬Q))∨R) (P∨R). 
  intros Syll2_06a.
  MP Syll2_06a n2_31a.
  Syll Sa Syll2_06a Sb.
  specialize Perm1_4 with P Q. 
  intros Perm1_4a. (*not cited*)
  Syll Perm1_4a Sb Sc.
  replace (¬Q∨R) with (Q→R) in Sc
    by now rewrite Impl1_01.
  exact Sc.
Qed.

Theorem n2_76 : ∀ P Q R : Prop,
  (P ∨ (Q → R)) → ((P ∨ Q) → (P ∨ R)).
Proof. intros P Q R.
  specialize n2_75 with P Q R. 
  intros n2_75a.
  specialize Comm2_04 with (P∨Q) (P∨(Q→R)) (P∨R). 
  intros Comm2_04a.
  MP Comm2_04a n2_75a.
  exact Comm2_04a. 
Qed.

Theorem n2_77 : ∀ P Q R : Prop,
  (P → (Q → R)) → ((P → Q) → (P → R)).
Proof. intros P Q R.
  specialize n2_76 with (¬P) Q R. 
  intros n2_76a.
  replace (¬P∨(Q→R)) with (P→Q→R) in n2_76a
    by now rewrite Impl1_01.
  replace (¬P∨Q) with (P→Q) in n2_76a
    by now rewrite Impl1_01.
  replace (¬P∨R) with (P→R) in n2_76a
    by now rewrite Impl1_01.
  exact n2_76a.
Qed.

Theorem n2_8 : ∀ Q R S : Prop,
  (Q ∨ R) → ((¬R ∨ S) → (Q ∨ S)).
Proof. intros Q R S.
  specialize n2_53 with R Q. 
  intros n2_53a.
  specialize Perm1_4 with Q R. 
  intros Perm1_4a.
  Syll Perm1_4a n2_53a Ha.
  specialize n2_38 with S (¬R) Q. 
  intros n2_38a.
  Syll H n2_38a Hb.
  exact Hb.
Qed.

Theorem n2_81 : ∀ P Q R S : Prop,
  (Q → (R → S)) → ((P ∨ Q) → ((P ∨ R) → (P ∨ S))).
Proof. intros P Q R S.
  specialize Sum1_6 with P Q (R→S). 
  intros Sum1_6a.
  specialize n2_76 with P R S. 
  intros n2_76a.
  specialize Syll2_05 with (P∨Q) (P∨(R→S)) ((P∨R)→(P∨S)). 
  intros Syll2_05a.
  MP Syll2_05a n2_76a.
  Syll Sum1_6a Syll2_05a H.
  exact H.
Qed.

Theorem n2_82 : ∀ P Q R S : Prop,
  (P ∨ Q ∨ R)→((P ∨ ¬R ∨ S)→(P ∨ Q ∨ S)).
Proof. intros P Q R S.
  specialize n2_8 with Q R S. 
  intros n2_8a.
  specialize n2_81 with P (Q∨R) (¬R∨S) (Q∨S). 
  intros n2_81a.
  MP n2_81a n2_8a.
  exact n2_81a.
Qed.

Theorem n2_83 : ∀ P Q R S : Prop,
  (P→(Q→R))→((P→(R→S))→(P→(Q→S))).
Proof. intros P Q R S.
  specialize n2_82 with (¬P) (¬Q) R S. 
  intros n2_82a.
  replace (¬Q∨R) with (Q→R) in n2_82a
    by now rewrite Impl1_01.
  replace (¬P∨(Q→R)) with (P→Q→R) in n2_82a
    by now rewrite Impl1_01.
  replace (¬R∨S) with (R→S) in n2_82a
    by now rewrite Impl1_01.
  replace (¬P∨(R→S)) with (P→R→S) in n2_82a
    by now rewrite Impl1_01.
  replace (¬Q∨S) with (Q→S) in n2_82a
    by now rewrite Impl1_01.
  replace (¬Q∨S) with (Q→S) in n2_82a
    by now rewrite Impl1_01.
  replace (¬P∨(Q→S)) with (P→Q→S) in n2_82a
    by now rewrite Impl1_01.
  exact n2_82a.
Qed.

Theorem n2_85 : ∀ P Q R : Prop,
  ((P ∨ Q) → (P ∨ R)) → (P ∨ (Q → R)).
Proof. intros P Q R.
  specialize Add1_3 with P Q. 
  intros Add1_3a.
  specialize Syll2_06 with Q (P∨Q) R. 
  intros Syll2_06a.
  MP Syll2_06a Add1_3a.
  specialize n2_55 with P R. 
  intros n2_55a.
  specialize Syll2_05 with (P∨Q) (P∨R) R. 
  intros Syll2_05a.
  Syll n2_55a Syll2_05a Ha.
  specialize n2_83 with (¬P) ((P∨Q)→(P∨R)) ((P∨Q)→R) (Q→R). 
  intros n2_83a.
  MP n2_83a Ha.
  specialize Comm2_04 with (¬P) (P∨Q→P∨R) (Q→R). 
  intros Comm2_04a.
  Syll Ha Comm2_04a Hb.
  specialize n2_54 with P (Q→R). 
  intros n2_54a.
  specialize Simp2_02 with (¬P) ((P∨Q→R)→(Q→R)). 
  intros Simp2_02a. (*Not cited*)
      (*Greg's suggestion per the BRS list on June 25, 2017.*)
  MP Syll2_06a Simp2_02a.
  MP Hb Simp2_02a.
  Syll Hb n2_54a Hc.
  exact Hc.
Qed.

Theorem n2_86 : ∀ P Q R : Prop,
  ((P → Q) → (P → R)) → (P → (Q →  R)).
Proof. intros P Q R.
  specialize n2_85 with (¬P) Q R. 
  intros n2_85a.
  replace (¬P∨Q) with (P→Q) in n2_85a
    by now rewrite Impl1_01.
  replace (¬P∨R) with (P→R) in n2_85a
    by now rewrite Impl1_01.
  replace (¬P∨(Q→R)) with (P→Q→R) in n2_85a
    by now rewrite Impl1_01.
  exact n2_85a.
Qed.

End No2.

Module No3.

Import No1.
Import No2.
 

Theorem Prod3_01 : ∀ P Q : Prop, 
  (P ∧ Q) = (¬(¬P ∨ ¬Q)).
Proof. intros P Q. 
  apply propositional_extensionality.
  split.
  specialize or_not_and with (P) (Q).
  intros or_not_and.
  specialize Transp2_03 with (¬P ∨ ¬Q) (P ∧ Q).
  intros Transp2_03.
  MP Transp2_03 or_not_and.
  exact Transp2_03.
  specialize not_and_or with (P) (Q).
  intros not_and_or.
  specialize Transp2_15 with (P ∧ Q) (¬P ∨ ¬Q).
  intros Transp2_15.
  MP Transp2_15 not_and_or.
  exact Transp2_15.
Qed.
(*This is a notational definition in Principia;
  it is used to switch between "∧" and "¬∨¬".*)

(*Axiom Abb3_02 : ∀ P Q R : Prop, 
  (P → Q → R) = ((P → Q) ∧ (Q → R)).*)
  (*Since Coq forbids such strings as ill-formed, or
  else automatically associates to the right,
  we leave this notational axiom commented out.*)

Theorem Conj3_03 : ∀ P Q : Prop, P → Q → (P∧Q). 
Proof. intros P Q.
  specialize n2_11 with (¬P∨¬Q). 
  intros n2_11a.
  specialize n2_32 with (¬P) (¬Q) (¬(¬P ∨ ¬Q)). 
  intros n2_32a.
  MP n2_32a n2_11a.
  replace (¬(¬P∨¬Q)) with (P∧Q) in n2_32a
    by now rewrite Prod3_01.
  replace (¬Q ∨ (P∧Q)) with (Q→(P∧Q)) in n2_32a
    by now rewrite Impl1_01.
  replace (¬P ∨ (Q → (P∧Q))) with (P→Q→(P∧Q)) in n2_32a
    by now rewrite Impl1_01.
  exact n2_32a.
Qed.
(*3.03 is permits the inference from the theoremhood 
    of P and that of Q to the theoremhood of P and Q. So:*)

Ltac Conj H1 H2 C :=
  let C := fresh C in match goal with 
    | [ H1 : ?P, H2 : ?Q |- _ ] =>  
      (specialize Conj3_03 with P Q;
      intros C;
      MP Conj3_03 P; MP Conj3_03 Q)
end. 

Theorem n3_1 : ∀ P Q : Prop,
  (P ∧ Q) → ¬(¬P ∨ ¬Q).
Proof. intros P Q.
  specialize Id2_08 with (P∧Q). 
  intros Id2_08a.
  replace ((P∧Q)→(P∧Q)) with ((P∧Q)→¬(¬P∨¬Q)) 
    in Id2_08a by now rewrite Prod3_01.
  exact Id2_08a.
Qed.

Theorem n3_11 : ∀ P Q : Prop,
  ¬(¬P ∨ ¬Q) → (P ∧ Q).
Proof. intros P Q.
  specialize Id2_08 with (P∧Q). 
  intros Id2_08a.
  replace ((P∧Q)→(P∧Q)) with (¬(¬P∨¬Q)→(P∧Q)) 
    in Id2_08a by now rewrite Prod3_01.
  exact Id2_08a.
Qed.

Theorem n3_12 : ∀ P Q : Prop,
  (¬P ∨ ¬Q) ∨ (P ∧ Q).
Proof. intros P Q.
  specialize n2_11 with (¬P∨¬Q). 
  intros n2_11a.
  replace (¬(¬P∨¬Q)) with (P∧Q) in n2_11a
    by now rewrite Prod3_01.
  exact n2_11a.
Qed.

Theorem n3_13 : ∀ P Q : Prop,
  ¬(P ∧ Q) → (¬P ∨ ¬Q).
Proof. intros P Q.
  specialize n3_11 with P Q. 
  intros n3_11a.
  specialize Transp2_15 with (¬P∨¬Q) (P∧Q). 
  intros Transp2_15a.
  MP Transp2_15a n3_11a.
  exact Transp2_15a.
Qed.

Theorem n3_14 : ∀ P Q : Prop,
  (¬P ∨ ¬Q) → ¬(P ∧ Q).
Proof. intros P Q.
  specialize n3_1 with P Q. 
  intros n3_1a.
  specialize Transp2_16 with (P∧Q) (¬(¬P∨¬Q)). 
  intros Transp2_16a.
  MP Transp2_16a n3_1a.
  specialize n2_12 with (¬P∨¬Q). 
  intros n2_12a.
  Syll n2_12a Transp2_16a S.
  exact S.
Qed.

Theorem n3_2 : ∀ P Q : Prop,
  P → Q → (P ∧ Q).
Proof. intros P Q.
  specialize n3_12 with P Q. 
  intros n3_12a.
  specialize n2_32 with (¬P) (¬Q) (P∧Q). 
  intros n2_32a.
  MP n3_32a n3_12a.
  replace (¬Q ∨ P ∧ Q) with (Q→P∧Q) in n2_32a
    by now rewrite Impl1_01.
  replace (¬P ∨ (Q → P ∧ Q)) with (P→Q→P∧Q) 
  in n2_32a by now rewrite Impl1_01.
  exact n2_32a.
Qed.

Theorem n3_21 : ∀ P Q : Prop,
  Q → P → (P ∧ Q).
Proof. intros P Q.
  specialize n3_2 with P Q.
  intros n3_2a.
  specialize Comm2_04 with P Q (P∧Q). 
  intros Comm2_04a.
  MP Comm2_04a n3_2a.
  exact Comm2_04a.
Qed.

Theorem n3_22 : ∀ P Q : Prop,
  (P ∧ Q) → (Q ∧ P).
Proof. intros P Q.
  specialize n3_13 with Q P. 
  intros n3_13a.
  specialize Perm1_4 with (¬Q) (¬P). 
  intros Perm1_4a.
  Syll n3_13a Perm1_4a Ha.
  specialize n3_14 with P Q. 
  intros n3_14a.
  Syll Ha n3_14a Hb.
  specialize Transp2_17 with (P∧Q) (Q ∧ P). 
  intros Transp2_17a.
  MP Transp2_17a Hb.
  exact Transp2_17a.
Qed.

Theorem n3_24 : ∀ P : Prop,
  ¬(P ∧ ¬P).
Proof. intros P.
  specialize n2_11 with (¬P). 
  intros n2_11a.
  specialize n3_14 with P (¬P). 
  intros n3_14a.
  MP n3_14a n2_11a.
  exact n3_14a.
Qed.

Theorem Simp3_26 : ∀ P Q : Prop,
  (P ∧ Q) → P.
Proof. intros P Q.
  specialize Simp2_02 with Q P. 
  intros Simp2_02a.
  replace (P→(Q→P)) with (¬P∨(Q→P)) in Simp2_02a
    by now rewrite <- Impl1_01.
  replace (Q→P) with (¬Q∨P) in Simp2_02a
    by now rewrite Impl1_01.
  specialize n2_31 with (¬P) (¬Q) P. 
  intros n2_31a.
  MP n2_31a Simp2_02a.
  specialize n2_53 with (¬P∨¬Q) P. 
  intros n2_53a.
  MP n2_53a Simp2_02a.
  replace (¬(¬P∨¬Q)) with (P∧Q) in n2_53a
    by now rewrite Prod3_01.
  exact n2_53a.
Qed.

Theorem Simp3_27 : ∀ P Q : Prop,
  (P ∧ Q) → Q.
Proof. intros P Q.
  specialize n3_22 with P Q. 
  intros n3_22a.
  specialize Simp3_26 with Q P. 
  intros Simp3_26a.
  Syll n3_22a Simp3_26a S.
  exact S.
Qed.

Theorem Exp3_3 : ∀ P Q R : Prop,
  ((P ∧ Q) → R) → (P → (Q → R)).
Proof. intros P Q R.
  specialize Id2_08 with ((P∧Q)→R).
  intros Id2_08a. (*This theorem isn't needed.*)
  replace (((P ∧ Q) → R) → ((P ∧ Q) → R)) with 
    (((P ∧ Q) → R) → (¬(¬P ∨ ¬Q) → R)) in Id2_08a
    by now rewrite Prod3_01.
  specialize Transp2_15 with (¬P∨¬Q) R. 
  intros Transp2_15a.
  Syll Id2_08a Transp2_15a Sa.
  specialize Id2_08 with (¬R → (¬P ∨ ¬Q)).
  intros Id2_08b. (*This theorem isn't needed.*)
  Syll Sa Id2_08b Sb.
  replace (¬P ∨ ¬Q) with (P → ¬Q) in Sb
    by now rewrite Impl1_01.
  specialize Comm2_04 with (¬R) P (¬Q). 
  intros Comm2_04a.
  Syll Sb Comm2_04a Sc.
  specialize Transp2_17 with Q R. 
  intros Transp2_17a.
  specialize Syll2_05 with P (¬R → ¬Q) (Q → R). 
  intros Syll2_05a.
  MP Syll2_05a Transp2_17a.
  Syll Sa Syll2_05a Sd.
  exact Sd.
Qed.

Theorem Imp3_31 : ∀ P Q R : Prop,
  (P → (Q → R)) → (P ∧ Q) → R.
Proof. intros P Q R.
  specialize Id2_08 with (P → (Q → R)).
  intros Id2_08a. 
  replace ((P → (Q → R))→(P → (Q → R))) with
    ((P → (Q → R))→(¬P ∨ (Q → R))) in Id2_08a
    by now rewrite <- Impl1_01.
  replace (¬P ∨ (Q → R)) with 
    (¬P ∨ (¬Q ∨ R)) in Id2_08a
    by now rewrite Impl1_01.
  specialize n2_31 with (¬P) (¬Q) R. 
  intros n2_31a.
  Syll Id2_08a n2_31a Sa.
  specialize n2_53 with (¬P∨¬Q) R. 
  intros n2_53a.
  replace (¬(¬P∨¬Q)) with (P∧Q) in n2_53a
    by now rewrite Prod3_01.
  Syll Sa n2_53a Sb.
  exact Sb.
Qed.

Theorem Syll3_33 : ∀ P Q R : Prop,
  ((P → Q) ∧ (Q → R)) → (P → R).
Proof. intros P Q R.
  specialize Syll2_06 with P Q R. 
  intros Syll2_06a.
  specialize Imp3_31 with (P→Q) (Q→R) (P→R). 
  intros Imp3_31a.
  MP Imp3_31a Syll2_06a.
  exact Imp3_31a.
Qed.

Theorem Syll3_34 : ∀ P Q R : Prop,
  ((Q → R) ∧ (P → Q)) → (P → R).
Proof. intros P Q R.
  specialize Syll2_05 with P Q R. 
  intros Syll2_05a.
  specialize Imp3_31 with (Q→R) (P→Q) (P→R).
  intros Imp3_31a.
  MP Imp3_31a Syll2_05a.
  exact Imp3_31a.
Qed.

Theorem Ass3_35 : ∀ P Q : Prop,
  (P ∧ (P → Q)) → Q.
Proof. intros P Q.
  specialize n2_27 with P Q. 
  intros n2_27a.
  specialize Imp3_31 with P (P→Q) Q. 
  intros Imp3_31a.
  MP Imp3_31a n2_27a.
  exact Imp3_31a.
Qed.

Theorem Transp3_37 : ∀ P Q R : Prop,
  (P ∧ Q → R) → (P ∧ ¬R → ¬Q).
Proof. intros P Q R.
  specialize Transp2_16 with Q R. 
  intros Transp2_16a.
  specialize Syll2_05 with P (Q→R) (¬R→¬Q). 
  intros Syll2_05a.
  MP Syll2_05a Transp2_16a.
  specialize Exp3_3 with P Q R. 
  intros Exp3_3a.
  Syll Exp3_3a Syll2_05a Sa.
  specialize Imp3_31 with P (¬R) (¬Q). 
  intros Imp3_31a.
  Syll Sa Imp3_31a Sb.
  exact Sb.
Qed.

Theorem n3_4 : ∀ P Q : Prop,
  (P ∧ Q) → P → Q.
Proof. intros P Q.
  specialize n2_51 with P Q. 
  intros n2_51a.
  specialize Transp2_15 with (P→Q) (P→¬Q). 
  intros Transp2_15a.
  MP Transp2_15a n2_51a.
  replace (P→¬Q) with (¬P∨¬Q) in Transp2_15a
    by now rewrite Impl1_01.
  replace (¬(¬P∨¬Q)) with (P∧Q) in Transp2_15a
    by now rewrite Prod3_01.
  exact Transp2_15a.
Qed.

Theorem n3_41 : ∀ P Q R : Prop,
  (P → R) → (P ∧ Q → R).
Proof. intros P Q R.
  specialize Simp3_26 with P Q. 
  intros Simp3_26a.
  specialize Syll2_06 with (P∧Q) P R. 
  intros Syll2_06a.
  MP Simp3_26a Syll2_06a.
  exact Syll2_06a.
Qed.

Theorem n3_42 : ∀ P Q R : Prop,
  (Q → R) → (P ∧ Q → R).
Proof. intros P Q R.
  specialize Simp3_27 with P Q. 
  intros Simp3_27a.
  specialize Syll2_06 with (P∧Q) Q R. 
  intros Syll2_06a.
  MP Syll2_06a Simp3_27a.
  exact Syll2_06a.
Qed.

Theorem Comp3_43 : ∀ P Q R : Prop,
  (P → Q) ∧ (P → R) → (P → Q ∧ R).
Proof. intros P Q R.
  specialize n3_2 with Q R. 
  intros n3_2a.
  specialize Syll2_05 with P Q (R→Q∧R). 
  intros Syll2_05a.
  MP Syll2_05a n3_2a.
  specialize n2_77 with P R (Q∧R). 
  intros n2_77a.
  Syll Syll2_05a n2_77a Sa.
  specialize Imp3_31 with (P→Q) (P→R) (P→Q∧R). 
  intros Imp3_31a.
  MP Sa Imp3_31a.
  exact Imp3_31a.
Qed.

Theorem n3_44 : ∀ P Q R : Prop,
  (Q → P) ∧ (R → P) → (Q ∨ R → P).
Proof. intros P Q R.
  specialize Syll3_33 with (¬Q) R P. 
  intros Syll3_33a.
  specialize n2_6 with Q P. 
  intros n2_6a.
  Syll Syll3_33a n2_6a Sa.
  specialize Exp3_3 with (¬Q→R) (R→P) ((Q→P)→P). 
  intros Exp3_3a.
  MP Exp3_3a Sa.
  specialize Comm2_04 with (R→P) (Q→P) P. 
  intros Comm2_04a.
  Syll Exp3_3a Comm2_04a Sb.
  specialize Imp3_31 with (Q→P) (R→P) P. 
  intros Imp3_31a.
  Syll Sb Imp3_31a Sc.
  specialize Comm2_04 with (¬Q→R) ((Q→P)∧(R→P)) P. 
  intros Comm2_04b.
  MP Comm2_04b Sc.
  specialize n2_53 with Q R. 
  intros n2_53a.
  specialize Syll2_06 with (Q∨R) (¬Q→R) P. 
  intros Syll2_06a.
  MP Syll2_06a n2_53a.
  Syll Comm2_04b Syll2_06a Sd.
  exact Sd.
Qed.

Theorem Fact3_45 : ∀ P Q R : Prop,
  (P → Q) → (P ∧ R) → (Q ∧ R).
Proof. intros P Q R.
  specialize Syll2_06 with P Q (¬R). 
  intros Syll2_06a.
  specialize Transp2_16 with (Q→¬R) (P→¬R). 
  intros Transp2_16a.
  Syll Syll2_06a Transp2_16a Sa.
  specialize Id2_08 with (¬(P→R)→¬(Q→¬R)).
  intros Id2_08a.
  Syll Sa Id2_08a Sb.
  replace (P→¬R) with (¬P∨¬R) in Sb
    by now rewrite Impl1_01.
  replace (Q→¬R) with (¬Q∨¬R) in Sb
    by now rewrite Impl1_01.
  replace (¬(¬P∨¬R)) with (P∧R) in Sb
    by now rewrite Prod3_01.
  replace (¬(¬Q∨¬R)) with (Q∧R) in Sb
    by now rewrite Prod3_01.
  exact Sb.
Qed.

Theorem n3_47 : ∀ P Q R S : Prop,
  ((P → R) ∧ (Q → S)) → (P ∧ Q) → R ∧ S.
Proof. intros P Q R S.
  specialize Simp3_26 with (P→R) (Q→S). 
  intros Simp3_26a.
  specialize Fact3_45 with P R Q. 
  intros Fact3_45a.
  Syll Simp3_26a Fact3_45a Sa.
  specialize n3_22 with R Q. 
  intros n3_22a.
  specialize Syll2_05 with (P∧Q) (R∧Q) (Q∧R). 
  intros Syll2_05a.
  MP Syll2_05a n3_22a.
  Syll Sa Syll2_05a Sb.
  specialize Simp3_27 with (P→R) (Q→S).
  intros Simp3_27a.
  specialize Fact3_45 with Q S R. 
  intros Fact3_45b.
  Syll Simp3_27a Fact3_45b Sc.
  specialize n3_22 with S R. 
  intros n3_22b.
  specialize Syll2_05 with (Q∧R) (S∧R) (R∧S). 
  intros Syll2_05b.
  MP Syll2_05b n3_22b.
  Syll Sc Syll2_05b Sd.
  clear Simp3_26a. clear Fact3_45a. clear Sa. 
    clear n3_22a. clear Fact3_45b. 
    clear Syll2_05a. clear Simp3_27a.
    clear Sc. clear n3_22b. clear Syll2_05b.
  Conj Sb Sd C.
  specialize n2_83 with ((P→R)∧(Q→S)) (P∧Q) (Q∧R) (R∧S).
  intros n2_83a. (*This with MP works, but it omits Conj3_03.*)
  specialize Imp3_31 with (((P→R)∧(Q→S))→((P∧Q)→(Q∧R)))
    (((P→R)∧(Q→S))→((Q∧R)→(R∧S))) 
    (((P→R)∧(Q→S))→((P∧Q)→(R∧S))).
  intros Imp3_31a.
  MP Imp3_31a n2_83a.
  MP Imp3_31a C.
  exact Imp3_31a.
Qed.

Theorem n3_48 : ∀ P Q R S : Prop,
  ((P → R) ∧ (Q → S)) → (P ∨ Q) → R ∨ S.
Proof. intros P Q R S.
  specialize Simp3_26 with (P→R) (Q→S). 
  intros Simp3_26a.
  specialize Sum1_6 with Q P R. 
  intros Sum1_6a.
  Syll Simp3_26a Sum1_6a Sa.
  specialize Perm1_4 with P Q. 
  intros Perm1_4a.
  specialize Syll2_06 with (P∨Q) (Q∨P) (Q∨R). 
  intros Syll2_06a.
  MP Syll2_06a Perm1_4a.
  Syll Sa Syll2_06a Sb.
  specialize Simp3_27 with (P→R) (Q→S). 
  intros Simp3_27a.
  specialize Sum1_6 with R Q S. 
  intros Sum1_6b.
  Syll Simp3_27a Sum1_6b Sc.
  specialize Perm1_4 with Q R. 
  intros Perm1_4b.
  specialize Syll2_06 with (Q∨R) (R∨Q) (R∨S). 
  intros Syll2_06b.
  MP Syll2_06b Perm1_4b.
  Syll Sc Syll2_06a Sd.
  specialize n2_83 with ((P→R)∧(Q→S)) (P∨Q) (Q∨R) (R∨S). 
  intros n2_83a.
  MP n2_83a Sb.
  MP n2_83a Sd.
  exact n2_83a. 
Qed.

End No3.

Module No4.

Import No1.
Import No2.
Import No3.

Theorem Equiv4_01 : ∀ P Q : Prop, 
  (P ↔ Q) = ((P → Q) ∧ (Q → P)). 
  Proof. intros. reflexivity. Qed.

(* Theorem Equiv4_01 : ∀ P Q : Prop, 
  (P ↔ Q) = ((P → Q) ∧ (Q → P)). 
  Proof. intros P Q.
  apply propositional_extensionality.
  specialize iff_to_and with P Q.
  intros iff_to_and.
  exact iff_to_and.
  Qed. *)
  (*This is a notational definition in Principia;
  it is used to switch between "↔" and "→∧←".*)

(*Axiom Abb4_02 : ∀ P Q R : Prop,
  (P ↔ Q ↔ R) = ((P ↔ Q) ∧ (Q ↔ R)).*)
  (*Since Coq forbids ill-formed strings, or else 
  automatically associates to the right, we leave 
  this notational axiom commented out.*)

Ltac Equiv H1 :=
  match goal with 
    | [ H1 : (?P→?Q) ∧ (?Q→?P) |- _ ] => 
      replace ((P→Q) ∧ (Q→P)) with (P↔Q) in H1
      by now rewrite Equiv4_01
end. 

Theorem Transp4_1 : ∀ P Q : Prop,
  (P → Q) ↔ (¬Q → ¬P).
Proof. intros P Q.
  specialize Transp2_16 with P Q. 
  intros Transp2_16a.
  specialize Transp2_17 with P Q. 
  intros Transp2_17a.
  Conj Transp2_16a Transp2_17a C.
  Equiv C. 
  exact C.
Qed.

Theorem Transp4_11 : ∀ P Q : Prop,
  (P ↔ Q) ↔ (¬P ↔ ¬Q).
Proof. intros P Q.
  specialize Transp2_16 with P Q. 
  intros Transp2_16a.
  specialize Transp2_16 with Q P. 
  intros Transp2_16b.
  Conj Transp2_16a Transp2_16b Ca.
  specialize n3_47 with (P→Q) (Q→P) (¬Q→¬P) (¬P→¬Q). 
  intros n3_47a.
  MP n3_47 Ca.
  specialize n3_22 with (¬Q → ¬P) (¬P → ¬Q). 
  intros n3_22a.
  Syll n3_47a n3_22a Sa.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) in Sa
    by now rewrite Equiv4_01.
  replace ((¬P → ¬Q) ∧ (¬Q → ¬P)) with (¬P↔¬Q) 
    in Sa by now rewrite Equiv4_01.
  clear Transp2_16a. clear Ca. clear Transp2_16b. 
   clear n3_22a. clear n3_47a.
  specialize Transp2_17 with Q P. 
  intros Transp2_17a.
  specialize Transp2_17 with P Q. 
  intros Transp2_17b.
  Conj Transp2_17a Transp2_17b Cb.
  specialize n3_47 with (¬P→¬Q) (¬Q→¬P) (Q→P) (P→Q).
  intros n3_47a.
  MP n3_47a Cb.
  specialize n3_22 with (Q→P) (P→Q).
  intros n3_22a.
  Syll n3_47a n3_22a Sb.
  clear Transp2_17a. clear Transp2_17b. clear Cb. 
      clear n3_47a. clear n3_22a.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) in Sb
    by now rewrite Equiv4_01.
  replace ((¬P → ¬Q) ∧ (¬Q → ¬P)) with (¬P↔¬Q)
    in Sb by now rewrite Equiv4_01.
  Conj Sa Sb Cc.
  Equiv Cc.
  exact Cc.
Qed.

Theorem n4_12 : ∀ P Q : Prop,
  (P ↔ ¬Q) ↔ (Q ↔ ¬P).
  Proof. intros P Q.
    specialize Transp2_03 with P Q. 
    intros Transp2_03a.
    specialize Transp2_15 with Q P. 
    intros Transp2_15a.
    Conj Transp2_03a Transp2_15a Ca.
    specialize n3_47 with (P→¬Q) (¬Q→P) (Q→¬P) (¬P→Q).
    intros n3_47a.
    MP n3_47a C.
    specialize Transp2_03 with Q P. 
    intros Transp2_03b.
    specialize Transp2_15 with P Q. 
    intros Transp2_15b.
    Conj Transp2_03b Transp2_15b Cb.
    specialize n3_47 with (Q→¬P) (¬P→Q) (P→¬Q) (¬Q→P).
    intros n3_47b.
    MP n3_47b H0.
    clear Transp2_03a. clear Transp2_15a. clear Ca. 
      clear Transp2_03b. clear Transp2_15b. clear Cb.
    Conj n3_47a n3_47b Cc.
    rewrite <- Equiv4_01 in Cc.
    rewrite <- Equiv4_01 in Cc.
    rewrite <- Equiv4_01 in Cc.
    exact Cc.
Qed.

Theorem n4_13 : ∀ P : Prop,
  P ↔ ¬¬P.
  Proof. intros P.
  specialize n2_12 with P. 
  intros n2_12a.
  specialize n2_14 with P. 
  intros n2_14a.
  Conj n2_12a n2_14a C.
  Equiv C. 
  exact C. 
Qed.

Theorem n4_14 : ∀ P Q R : Prop,
  ((P ∧ Q) → R) ↔ ((P ∧ ¬R) → ¬Q).
Proof. intros P Q R.
specialize Transp3_37 with P Q R. 
intros Transp3_37a.
specialize Transp3_37 with P (¬R) (¬Q).
intros Transp3_37b.
Conj Transp3_37a Transp3_37b C.
specialize n4_13 with Q. 
intros n4_13a.
apply propositional_extensionality in n4_13a.
specialize n4_13 with R. 
intros n4_13b.
apply propositional_extensionality in n4_13b.
replace (¬¬Q) with Q in C
  by now apply n4_13a.
replace (¬¬R) with R in C
  by now apply n4_13b.
Equiv C. 
exact C.
Qed.

Theorem n4_15 : ∀ P Q R : Prop,
  ((P ∧ Q) → ¬R) ↔ ((Q ∧ R) → ¬P).
  Proof. intros P Q R.
  specialize n4_14 with Q P (¬R). 
  intros n4_14a.
  specialize n3_22 with Q P. 
  intros n3_22a.
  specialize Syll2_06 with (Q∧P) (P∧Q) (¬R). 
  intros Syll2_06a.
  MP Syll2_06a n3_22a.
  specialize n4_13 with R. 
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬R) with R in n4_14a
    by now apply n4_13a.
  rewrite Equiv4_01 in n4_14a.
  specialize Simp3_26 with ((Q ∧ P → ¬R) → Q ∧ R → ¬P) 
      ((Q ∧ R → ¬P) → Q ∧ P → ¬R). 
  intros Simp3_26a.
  MP Simp3_26a n4_14a.
  Syll Syll2_06a Simp3_26a Sa.
  specialize Simp3_27 with ((Q ∧ P → ¬R) → Q ∧ R → ¬P) 
      ((Q ∧ R → ¬P) → Q ∧ P → ¬R). 
  intros Simp3_27a.
  MP Simp3_27a n4_14a.
  specialize n3_22 with P Q. 
  intros n3_22b.
  specialize Syll2_06 with (P∧Q) (Q∧P) (¬R). 
  intros Syll2_06b.
  MP Syll2_06b n3_22b.
  Syll Syll2_06b Simp3_27a Sb.
  clear n4_14a. clear n3_22a. clear Syll2_06a. 
      clear n4_13a. clear Simp3_26a. clear n3_22b.
      clear Simp3_27a. clear Syll2_06b.
  Conj Sa Sb C.
  Equiv C.
  exact C.
Qed.

Theorem n4_2 : ∀ P : Prop,
  P ↔ P.
  Proof. intros P.
  specialize n3_2 with (P→P) (P→P). 
  intros n3_2a.
  specialize Id2_08 with P. 
  intros Id2_08a.
  MP n3_2a Id2_08a.
  MP n3_2a Id2_08a.
  Equiv n3_2a.
  exact n3_2a.
Qed.

Theorem n4_21 : ∀ P Q : Prop,
  (P ↔ Q) ↔ (Q ↔ P).
  Proof. intros P Q.
  specialize n3_22 with (P→Q) (Q→P). 
  intros n3_22a.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) 
    in n3_22a by now rewrite Equiv4_01.
  replace ((Q → P) ∧ (P → Q)) with (Q↔P)
   in n3_22a by now rewrite Equiv4_01.
  specialize n3_22 with (Q→P) (P→Q). 
  intros n3_22b.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) 
    in n3_22b by now rewrite Equiv4_01.
  replace ((Q → P) ∧ (P → Q)) with (Q↔P) 
    in n3_22b by now rewrite Equiv4_01.
  Conj n3_22a n3_22b C.
  Equiv C.
  exact C.
Qed.

Theorem n4_22 : ∀ P Q R : Prop,
  ((P ↔ Q) ∧ (Q ↔ R)) → (P ↔ R).
Proof. intros P Q R.
  specialize Simp3_26 with (P↔Q) (Q↔R). 
  intros Simp3_26a.
  specialize Simp3_26 with (P→Q) (Q→P). 
  intros Simp3_26b.
  replace ((P→Q) ∧ (Q→P)) with (P↔Q) 
    in Simp3_26b by now rewrite Equiv4_01.
  Syll Simp3_26a Simp3_26b Sa.
  specialize Simp3_27 with (P↔Q) (Q↔R). 
  intros Simp3_27a.
  specialize Simp3_26 with (Q→R) (R→Q). 
  intros Simp3_26c.
  replace ((Q→R) ∧ (R→Q)) with (Q↔R) 
    in Simp3_26c by now rewrite Equiv4_01.
  Syll Simp3_27a Simp3_26c Sb.
  specialize n2_83 with ((P↔Q)∧(Q↔R)) P Q R. 
  intros n2_83a.
  MP n2_83a Sa. 
  MP n2_83a Sb.
  specialize Simp3_27 with (P↔Q) (Q↔R). 
  intros Simp3_27b.
  specialize Simp3_27 with (Q→R) (R→Q). 
  intros Simp3_27c.
  replace ((Q→R) ∧ (R→Q)) with (Q↔R) 
    in Simp3_27c by now rewrite Equiv4_01.
  Syll Simp3_27b Simp3_27c Sc.
  specialize Simp3_26 with (P↔Q) (Q↔R).
  intros Simp3_26d.
  specialize Simp3_27 with (P→Q) (Q→P). 
  intros Simp3_27d.
  replace ((P→Q) ∧ (Q→P)) with (P↔Q) 
    in Simp3_27d by now rewrite Equiv4_01.
  Syll Simp3_26d Simp3_27d Sd.
  specialize n2_83 with ((P↔Q)∧(Q↔R)) R Q P. 
  intros n2_83b.
  MP n2_83b Sc. MP n2_83b Sd.
  clear Sd. clear Sb. clear Sc. clear Sa. clear Simp3_26a. 
      clear Simp3_26b. clear Simp3_26c. clear Simp3_26d. 
      clear Simp3_27a. clear Simp3_27b. clear Simp3_27c. 
      clear Simp3_27d.
  Conj n2_83a n2_83b C. 
  specialize Comp3_43 with ((P↔Q)∧(Q↔R)) (P→R) (R→P).
  intros Comp3_43a.
  MP Comp3_43a C.
  replace ((P→R) ∧ (R→P)) with (P↔R) 
    in Comp3_43a by now rewrite Equiv4_01.
  exact Comp3_43a.
Qed.

Theorem n4_24 : ∀ P : Prop,
  P ↔ (P ∧ P).
  Proof. intros P.
  specialize n3_2 with P P. 
  intros n3_2a.
  specialize n2_43 with P (P ∧ P). 
  intros n2_43a.
  MP n3_2a n2_43a.
  specialize Simp3_26 with P P. 
  intros Simp3_26a.
  Conj n2_43a Simp3_26a C.
  Equiv C.
  exact C.
Qed.

Theorem n4_25 : ∀ P : Prop,
  P ↔ (P ∨ P).
Proof. intros P.
  specialize Add1_3 with P P.
  intros Add1_3a.
  specialize Taut1_2 with P. 
  intros Taut1_2a.
  Conj Add1_3a Taut1_2a C.
  Equiv C. 
  exact C.
Qed.

Theorem n4_3 : ∀ P Q : Prop,
  (P ∧ Q) ↔ (Q ∧ P).
Proof. intros P Q.
  specialize n3_22 with P Q.
  intros n3_22a.
  specialize n3_22 with Q P.
  intros n3_22b.
  Conj n3_22a n3_22b C.
  Equiv C. 
  exact C.
Qed.

Theorem n4_31 : ∀ P Q : Prop,
  (P ∨ Q) ↔ (Q ∨ P).
  Proof. intros P Q.
    specialize Perm1_4 with P Q.
    intros Perm1_4a.
    specialize Perm1_4 with Q P.
    intros Perm1_4b.
    Conj Perm1_4a Perm1_4b C.
    Equiv C. 
    exact C.
Qed.

Theorem n4_32 : ∀ P Q R : Prop,
    ((P ∧ Q) ∧ R) ↔ (P ∧ (Q ∧ R)).
  Proof. intros P Q R.
    specialize n4_15 with P Q R.
    intros n4_15a.
    specialize Transp4_1 with P (¬(Q ∧ R)).
    intros Transp4_1a.
    apply propositional_extensionality in Transp4_1a.
    specialize n4_13 with (Q ∧ R).
    intros n4_13a.
    apply propositional_extensionality in n4_13a.
    specialize n4_21 with (¬(P∧Q→¬R)↔¬(P→¬(Q∧R)))
      ((P∧Q→¬R)↔(P→¬(Q∧R))).
    intros n4_21a.
    apply propositional_extensionality in n4_21a.
    replace (¬¬(Q ∧ R)) with (Q ∧ R) in Transp4_1a
      by now apply n4_13a.
    replace (Q ∧ R→¬P) with (P→¬(Q ∧ R)) in n4_15a
      by now apply Transp4_1a.
    specialize Transp4_11 with (P∧Q→¬R) (P→¬(Q∧R)).
    intros Transp4_11a.
    apply propositional_extensionality in Transp4_11a.
    replace ((P ∧ Q → ¬R) ↔ (P → ¬(Q ∧ R))) with 
        (¬(P ∧ Q → ¬R) ↔ ¬(P → ¬(Q ∧ R))) in n4_15a
        by now apply Transp4_11a.
    replace (P ∧ Q → ¬R) with 
        (¬(P ∧ Q ) ∨ ¬R) in n4_15a
        by now rewrite Impl1_01.
    replace (P → ¬(Q ∧ R)) with 
        (¬P ∨ ¬(Q ∧ R)) in n4_15a
        by now rewrite Impl1_01.
    replace (¬(¬(P ∧ Q) ∨ ¬R)) with 
        ((P ∧ Q) ∧ R) in n4_15a
        by now rewrite Prod3_01.
    replace (¬(¬P ∨ ¬(Q ∧ R))) with 
        (P ∧ (Q ∧ R )) in n4_15a
        by now rewrite Prod3_01.
    exact n4_15a.
Qed. 
    (*Note that the actual proof uses n4_12, but 
        that transposition involves transforming a 
        biconditional into a conditional. This citation
        of the lemma may be a misprint. Using 
        Transp4_1 to transpose a conditional and 
        then applying n4_13 to double negate does 
        secure the desired formula.*)

Theorem n4_33 : ∀ P Q R : Prop,
  (P ∨ (Q ∨ R)) ↔ ((P ∨ Q) ∨ R).
  Proof. intros P Q R.
    specialize n2_31 with P Q R.
    intros n2_31a.
    specialize n2_32 with P Q R.
    intros n2_32a.
    Conj n2_31a n2_32a C.
    Equiv C.
    exact C.
Qed.

Theorem Abb4_34 : ∀ P Q R : Prop,
  (P ∧ Q ∧ R) = ((P ∧ Q) ∧ R).
  Proof. intros P Q R.
  apply propositional_extensionality.
  specialize n4_21 with ((P ∧ Q) ∧ R) (P ∧ Q ∧ R).
  intros n4_21.
  replace (((P ∧ Q) ∧ R ↔ P ∧ Q ∧ R) ↔ (P ∧ Q ∧ R ↔ (P ∧ Q) ∧ R))
    with ((((P ∧ Q) ∧ R ↔ P ∧ Q ∧ R) → (P ∧ Q ∧ R ↔ (P ∧ Q) ∧ R)) 
    ∧ ((P ∧ Q ∧ R ↔ (P ∧ Q) ∧ R) → ((P ∧ Q) ∧ R ↔ P ∧ Q ∧ R))) 
    in n4_21 by now rewrite Equiv4_01.
  specialize Simp3_26 with 
    (((P ∧ Q) ∧ R ↔ P ∧ Q ∧ R) → (P ∧ Q ∧ R ↔ (P ∧ Q) ∧ R))
    ((P ∧ Q ∧ R ↔ (P ∧ Q) ∧ R) → ((P ∧ Q) ∧ R ↔ P ∧ Q ∧ R)).
  intros Simp3_26.
  MP Simp3_26 n4_21.
  specialize n4_32 with P Q R.
  intros n4_32.
  MP Simp3_26 n4_32.
  exact Simp3_26.
Qed.

Theorem n4_36 : ∀ P Q R : Prop,
  (P ↔ Q) → ((P ∧ R) ↔ (Q ∧ R)).
Proof. intros P Q R.
  specialize Fact3_45 with P Q R.
  intros Fact3_45a.
  specialize Fact3_45 with Q P R.
  intros Fact3_45b.
  Conj Fact3_45a Fact3_45b C.
  specialize n3_47 with (P→Q) (Q→P) 
      (P ∧ R → Q ∧ R) (Q ∧ R → P ∧ R).
  intros n3_47a.
  MP n3_47 C.
  replace  ((P → Q) ∧ (Q → P)) with (P↔Q) in n3_47a
   by now rewrite Equiv4_01.
  replace ((P∧R→Q∧R)∧(Q∧R→P∧R)) with (P∧R↔Q∧R) 
      in n3_47a by now rewrite Equiv4_01.
  exact n3_47a.
Qed.

Theorem n4_37 : ∀ P Q R : Prop,
  (P ↔ Q) → ((P ∨ R) ↔ (Q ∨ R)).
Proof. intros P Q R.
  specialize Sum1_6 with R P Q.
  intros Sum1_6a.
  specialize Sum1_6 with R Q P.
  intros Sum1_6b.
  Conj Sum1_6a Sum1_6b C.
  specialize n3_47 with (P → Q) (Q → P) 
      (R ∨ P → R ∨ Q) (R ∨ Q → R ∨ P).
  intros n3_47a.
  MP n3_47 C.
  replace  ((P → Q) ∧ (Q → P)) with (P↔Q) in n3_47a
   by now rewrite Equiv4_01.
  replace ((R∨P→R∨Q)∧(R∨Q→R∨P)) with (R∨P↔R∨Q) 
      in n3_47a by now rewrite Equiv4_01.
  specialize n4_31 with Q R.
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  specialize n4_31 with P R.
  intros n4_31b.
  apply propositional_extensionality in n4_31b.
  replace (R ∨ P) with (P ∨ R) in n3_47a
    by now apply n4_31a.
  replace (R ∨ Q) with (Q ∨ R) in n3_47a
    by now apply n4_31b.
  exact n3_47a.
Qed.

Theorem n4_38 : ∀ P Q R S : Prop,
  ((P ↔ R) ∧ (Q ↔ S)) → ((P ∧ Q) ↔ (R ∧ S)).
Proof. intros P Q R S.
  specialize n3_47 with P Q R S.
  intros n3_47a.
  specialize n3_47 with R S P Q.
  intros n3_47b.
  Conj n3_47a n3_47b Ca.
  specialize n3_47 with ((P→R) ∧ (Q→S)) 
      ((R→P) ∧ (S→Q)) (P ∧ Q → R ∧ S) (R ∧ S → P ∧ Q).
  intros n3_47c.
  MP n3_47c Ca.
  specialize n4_32 with (P→R) (Q→S) ((R→P) ∧ (S → Q)).
  intros n4_32a.
  apply propositional_extensionality in n4_32a.
  replace (((P → R) ∧ (Q → S)) ∧ (R → P) ∧ (S → Q)) with 
      ((P → R) ∧ (Q → S) ∧ (R → P) ∧ (S → Q)) in n3_47c
      by now apply n4_32a.
  specialize n4_32 with (Q→S) (R→P) (S → Q).
  intros n4_32b.
  apply propositional_extensionality in n4_32b.
  replace ((Q → S) ∧ (R → P) ∧ (S → Q)) with 
      (((Q → S) ∧ (R → P)) ∧ (S → Q)) in n3_47c
      by now apply n4_32b.
  specialize n3_22 with (Q→S) (R→P).
  intros n3_22a.
  specialize n3_22 with (R→P) (Q→S).
  intros n3_22b.
  Conj n3_22a n3_22b Cb.
  Equiv Cb.
  specialize n4_3 with (R→P) (Q→S).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace ((Q → S) ∧ (R → P)) with 
      ((R → P) ∧ (Q → S)) in n3_47c
      by now apply n4_3a.
  specialize n4_32 with (R → P) (Q → S) (S → Q).
  intros n4_32c.
  apply propositional_extensionality in n4_32c.
  replace (((R → P) ∧ (Q → S)) ∧ (S → Q)) with 
      ((R → P) ∧ (Q → S) ∧ (S → Q)) in n3_47c
      by now apply n4_32c.
  specialize n4_32 with (P→R) (R → P) ((Q → S)∧(S → Q)).
  intros n4_32d.
  apply propositional_extensionality in n4_32d.
  replace ((P → R) ∧ (R → P) ∧ (Q → S) ∧ (S → Q)) with 
      (((P → R) ∧ (R → P)) ∧ (Q → S) ∧ (S → Q)) in n3_47c
      by now apply n4_32d.
  replace ((P→R) ∧ (R → P)) with (P↔R) in n3_47c
   by now rewrite Equiv4_01.
  replace ((Q → S) ∧ (S → Q)) with (Q↔S) in n3_47c
   by now rewrite Equiv4_01.
  replace ((P∧Q→R∧S)∧(R∧S→P∧Q)) with ((P∧Q)↔(R∧S)) 
      in n3_47c by now rewrite Equiv4_01.
  exact n3_47c.
Qed.

Theorem n4_39 : ∀ P Q R S : Prop,
  ((P ↔ R) ∧ (Q ↔ S)) → ((P ∨ Q) ↔ (R ∨ S)).
Proof.  intros P Q R S.
  specialize n3_48 with P Q R S.
  intros n3_48a.
  specialize n3_48 with R S P Q.
  intros n3_48b.
  Conj n3_48a n3_48b Ca.
  specialize n3_47 with ((P → R) ∧ (Q → S)) 
      ((R → P) ∧ (S → Q)) (P ∨ Q → R ∨ S) (R ∨ S → P ∨ Q).
  intros n3_47a.
  MP n3_47a Ca.
  replace ((P∨Q→R∨S)∧(R∨S→P∨Q)) with ((P∨Q)↔(R∨S)) 
      in n3_47a by now rewrite Equiv4_01.
  specialize n4_32 with ((P → R) ∧ (Q → S)) (R → P) (S → Q).
  intros n4_32a.
  apply propositional_extensionality in n4_32a.
  replace (((P → R) ∧ (Q → S)) ∧ (R → P) ∧ (S → Q)) with 
      ((((P → R) ∧ (Q → S)) ∧ (R → P)) ∧ (S → Q)) in n3_47a
      by now apply n4_32a.
  specialize n4_32 with (P → R) (Q → S) (R → P).
  intros n4_32b.
  apply propositional_extensionality in n4_32b.
  replace (((P → R) ∧ (Q → S)) ∧ (R → P)) with 
      ((P → R) ∧ (Q → S) ∧ (R → P)) in n3_47a
      by now apply n4_32b.
  specialize n3_22 with (Q → S) (R → P).
  intros n3_22a. 
  specialize n3_22 with (R → P) (Q → S).
  intros n3_22b.
  Conj  n3_22a n3_22b Cb.
  Equiv Cb.
  apply propositional_extensionality in Cb.
  replace ((Q → S) ∧ (R → P)) with 
      ((R → P) ∧ (Q → S)) in n3_47a
      by now apply Cb.
  specialize n4_32 with (P → R) (R → P) (Q → S).
  intros n4_32c.
  apply propositional_extensionality in n4_32c.
  replace ((P → R) ∧ (R → P) ∧ (Q → S)) with 
      (((P → R) ∧ (R → P)) ∧ (Q → S)) in n3_47a
      by now apply n4_32c.
  replace ((P → R) ∧ (R → P)) with (P↔R) in n3_47a
    by now rewrite Equiv4_01.
  specialize n4_32 with (P↔R) (Q→S) (S→Q).
  intros n4_32d.
  apply propositional_extensionality in n4_32d.
  replace (((P ↔ R) ∧ (Q → S)) ∧ (S → Q)) with 
      ((P ↔ R) ∧ (Q → S) ∧ (S → Q)) in n3_47a
      by now apply n4_32d.
  replace ((Q → S) ∧ (S → Q)) with (Q ↔ S) in n3_47a
   by now rewrite Equiv4_01.
  exact n3_47a.
Qed.

Theorem n4_4 : ∀ P Q R : Prop,
  (P ∧ (Q ∨ R)) ↔ ((P∧ Q) ∨ (P ∧ R)).
Proof. intros P Q R.
  specialize n3_2 with P Q.
  intros n3_2a.
  specialize n3_2 with P R.
  intros n3_2b.
  Conj n3_2a n3_2b Ca.
  specialize Comp3_43 with P (Q→P∧Q) (R→P∧R).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  specialize n3_48 with Q R (P∧Q) (P∧R).
  intros n3_48a.
  Syll Comp3_43a n3_48a Sa.
  specialize Imp3_31 with P (Q∨R) ((P∧ Q) ∨ (P ∧ R)).
  intros Imp3_31a.
  MP Imp3_31a Sa.
  specialize Simp3_26 with P Q.
  intros Simp3_26a.
  specialize Simp3_26 with P R.
  intros Simp3_26b.
  Conj Simp3_26a Simp3_26b Cb.
  specialize n3_44 with P (P∧Q) (P∧R).
  intros n3_44a.
  MP n3_44a Cb.
  specialize Simp3_27 with P Q.
  intros Simp3_27a.
  specialize Simp3_27 with P R.
  intros Simp3_27b.
  Conj Simp3_27a Simp3_27b Cc.
  specialize n3_48 with (P∧Q) (P∧R) Q R.
  intros n3_48b.
  MP n3_48b Cc.
  clear Cc. clear Simp3_27a. clear Simp3_27b.
  Conj n3_44a n3_48b Cdd. (*Cd is reserved*)
  specialize Comp3_43 with (P ∧ Q ∨ P ∧ R) P (Q∨R).
  intros Comp3_43b.
  MP Comp3_43b Cdd.
  clear Cdd. clear Cb. clear n3_44a. clear n3_48b. 
      clear Simp3_26a. clear Simp3_26b.
  Conj Imp3_31a Comp3_43b Ce.
  Equiv Ce.
  exact Ce.
Qed.

Theorem n4_41 : ∀ P Q R : Prop,
  (P ∨ (Q ∧ R)) ↔ ((P ∨ Q) ∧ (P ∨ R)).
Proof. intros P Q R.
  specialize Simp3_26 with Q R.
  intros Simp3_26a.
  specialize Sum1_6 with P (Q ∧ R) Q.
  intros Sum1_6a.
  MP Simp3_26a Sum1_6a.
  specialize Simp3_27 with Q R.
  intros Simp3_27a.
  specialize Sum1_6 with P (Q ∧ R) R.
  intros Sum1_6b.
  MP Simp3_27a Sum1_6b.
  clear Simp3_26a. clear Simp3_27a.
  Conj Sum1_6a Sum1_6a Ca.
  specialize Comp3_43 with (P ∨ Q ∧ R) (P ∨ Q) (P ∨ R).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  specialize n2_53 with P Q. 
  intros n2_53a.
  specialize n2_53 with P R. 
  intros n2_53b.
  Conj n2_53a n2_53b Cb.
  specialize n3_47 with (P ∨ Q) (P ∨ R) (¬P → Q) (¬P → R).
  intros n3_47a.
  MP n3_47a Cb.
  specialize Comp3_43 with (¬P) Q R.
  intros Comp3_43b.
  Syll n3_47a Comp3_43b Sa.
  specialize n2_54 with P (Q∧R).
  intros n2_54a.
  Syll Sa n2_54a Sb.
  clear Sum1_6a. clear Sum1_6b. clear Ca. clear n2_53a.
      clear n2_53b. clear Cb. clear n3_47a. clear Sa.
      clear Comp3_43b. clear n2_54a.
  Conj Comp3_43a Sb Cc.
  Equiv Cc.
  exact Cc.
Qed.

Theorem n4_42 : ∀ P Q : Prop,
  P ↔ ((P ∧ Q) ∨ (P ∧ ¬Q)).
Proof. intros P Q.
  specialize n3_21 with P (Q ∨ ¬Q).
  intros n3_21a.
  specialize n2_11 with Q.
  intros n2_11a.
  MP n3_21a n2_11a.
  specialize Simp3_26 with P (Q ∨ ¬Q).
  intros Simp3_26a. clear n2_11a.
  Conj n3_21a Simp3_26a C.
  Equiv C.
  specialize n4_4 with P Q (¬Q).
  intros n4_4a.
  apply propositional_extensionality in C.
  replace (P ∧ (Q ∨ ¬Q)) with P in n4_4a
    by now apply C.
  exact n4_4a.
Qed.

Theorem n4_43 : ∀ P Q : Prop,
  P ↔ ((P ∨ Q) ∧ (P ∨ ¬Q)).
Proof. intros P Q.
  specialize n2_2 with P Q.
  intros n2_2a.
  specialize n2_2 with P (¬Q).
  intros n2_2b.
  Conj n2_2a n2_2b Ca.
  specialize Comp3_43 with P (P∨Q) (P∨¬Q).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  specialize n2_53 with P Q.
  intros n2_53a.
  specialize n2_53 with P (¬Q).
  intros n2_53b.
  Conj n2_53a n2_53b Cb.
  specialize n3_47 with (P∨Q) (P∨¬Q) (¬P→Q) (¬P→¬Q).
  intros n3_47a.
  MP n3_47a Cb.
  specialize n2_65 with (¬P) Q. 
  intros n2_65a.
  specialize n4_13 with P.
  intros n4_13a. 
  apply propositional_extensionality in n4_13a.
  replace (¬¬P) with P in n2_65a by now apply n4_13a.
  specialize Imp3_31 with (¬P → Q) (¬P → ¬Q) (P).
  intros Imp3_31a.
  MP Imp3_31a n2_65a.
  Syll n3_47a Imp3_31a Sa.
  clear n2_2a. clear n2_2b. clear Ca. clear n2_53a. 
    clear n2_53b. clear Cb. clear n2_65a. 
    clear n3_47a. clear Imp3_31a. clear n4_13a.
  Conj Comp3_43a Sa Cc.
  Equiv Cc.
  exact Cc.
Qed.

Theorem n4_44 : ∀ P Q : Prop,
  P ↔ (P ∨ (P ∧ Q)).
  Proof. intros P Q.
    specialize n2_2 with P (P∧Q).
    intros n2_2a.
    specialize Id2_08 with P.
    intros Id2_08a.
    specialize Simp3_26 with P Q.
    intros Simp3_26a.
    Conj Id2_08a Simp3_26a Ca.
    specialize n3_44 with P P (P ∧ Q).
    intros n3_44a.
    MP n3_44a Ca.
    clear Ca. clear Id2_08a. clear Simp3_26a.
    Conj n2_2a n3_44a Cb.
    Equiv Cb.
    exact Cb.
Qed.

Theorem n4_45 : ∀ P Q : Prop,
  P ↔ (P ∧ (P ∨ Q)).
  Proof. intros P Q.
  specialize n2_2 with (P ∧ P) (P ∧ Q).
  intros n2_2a.
  specialize n4_4 with P P Q.
  intros n4_4a.
  apply propositional_extensionality in n4_4a.
  replace (P∧P∨P∧Q) with (P∧(P∨Q)) in n2_2a
    by now apply n4_4a.
  specialize n4_24 with P.
  intros n4_24a.
  apply propositional_extensionality in n4_24a.
  replace (P ∧ P) with P in n2_2a 
    by now apply n4_24a.
  specialize Simp3_26 with P (P ∨ Q).
  intros Simp3_26a.
  clear n4_4a. clear n4_24a.
  Conj n2_2a Simp3_26a C.
  Equiv C.
  exact C.
Qed.

Theorem n4_5 : ∀ P Q : Prop,
  P ∧ Q ↔ ¬(¬P ∨ ¬Q).
  Proof. intros P Q.
    specialize n4_2 with (P ∧ Q).
    intros n4_2a.
    replace ((P ∧ Q)↔(P ∧ Q)) with 
      ((P ∧ Q)↔¬(¬P ∨ ¬Q)) in n4_2a 
      by now rewrite Prod3_01.
    exact n4_2a.
Qed.

Theorem n4_51 : ∀ P Q : Prop,
  ¬(P ∧ Q) ↔ (¬P ∨ ¬Q).
  Proof. intros P Q.
    specialize n4_5 with P Q.
    intros n4_5a.
    specialize n4_12 with (P ∧ Q) (¬P ∨ ¬Q).
    intros n4_12a.
    specialize Simp3_26 with 
      ((P ∧ Q ↔ ¬(¬P ∨ ¬Q)) → (¬P ∨ ¬Q ↔ ¬(P ∧ Q)))
      ((¬P ∨ ¬Q ↔ ¬(P ∧ Q)) → ((P ∧ Q ↔ ¬(¬P ∨ ¬Q)))).
    intros Simp3_26a.
    replace ((P ∧ Q ↔ ¬(¬P ∨ ¬Q)) ↔ (¬P ∨ ¬Q ↔ ¬(P ∧ Q)))
      with (((P ∧ Q ↔ ¬(¬P ∨ ¬Q)) → (¬P ∨ ¬Q ↔ ¬(P ∧ Q)))
      ∧ ((¬P ∨ ¬Q ↔ ¬(P ∧ Q)) → ((P ∧ Q ↔ ¬(¬P ∨ ¬Q)))))
      in n4_12a by now rewrite Equiv4_01.
    MP Simp3_26a n4_12a.
    MP Simp3_26a n4_5a.
    specialize n4_21 with (¬(P ∧ Q)) (¬P ∨ ¬Q).
    intros n4_21a.
    specialize Simp3_27 with 
    (((¬(P ∧ Q) ↔ ¬P ∨ ¬Q)) → ((¬P ∨ ¬Q ↔ ¬(P ∧ Q))))
    (((¬P ∨ ¬Q ↔ ¬(P ∧ Q))) → ((¬(P ∧ Q) ↔ ¬P ∨ ¬Q))).
    intros Simp3_27a.
    MP Simp3_27a n4_21a.
    MP Simp3_27a Simp3_26a.
    exact Simp3_27a.
Qed.

Theorem n4_52 : ∀ P Q : Prop,
  (P ∧ ¬Q) ↔ ¬(¬P ∨ Q).
  Proof. intros P Q.
    specialize n4_5 with P (¬Q).
    intros n4_5a.
    specialize n4_13 with Q.
    intros n4_13a.
    apply propositional_extensionality in n4_13a.
    replace (¬¬Q) with Q in n4_5a 
      by now apply n4_13a.
    exact n4_5a.
Qed.

Theorem n4_53 : ∀ P Q : Prop,
  ¬(P ∧ ¬Q) ↔ (¬P ∨ Q).
  Proof. intros P Q.
    specialize n4_52 with P Q.
    intros n4_52a.
    specialize n4_12 with (P ∧ ¬Q) ((¬P ∨ Q)).
    intros n4_12a.
    replace ((P ∧ ¬Q ↔ ¬(¬P ∨ Q)) ↔ (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      with (((P ∧ ¬Q ↔ ¬(¬P ∨ Q)) → (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      ∧ ((¬P ∨ Q ↔ ¬(P ∧ ¬Q)) → (P ∧ ¬Q ↔ ¬(¬P ∨ Q))))
      in n4_12a by now rewrite Equiv4_01.
    specialize Simp3_26 with 
      ((P ∧ ¬Q ↔ ¬(¬P ∨ Q)) → (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      ((¬P ∨ Q ↔ ¬(P ∧ ¬Q)) → (P ∧ ¬Q ↔ ¬(¬P ∨ Q))).
    intros Simp3_26a.
    MP Simp3_26a n4_12a.
    MP Simp3_26a n4_52a.
    specialize n4_21 with (¬(P ∧ ¬Q)) (¬P ∨ Q).
    intros n4_21a.
    replace ((¬(P ∧ ¬ Q) ↔ ¬P ∨ Q) ↔ (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      with (((¬(P ∧ ¬ Q) ↔ ¬P ∨ Q) → (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      ∧ ((¬P ∨ Q ↔ ¬(P ∧ ¬Q)) → (¬(P ∧ ¬ Q) ↔ ¬P ∨ Q)))
      in n4_21a by now rewrite Equiv4_01.
    specialize Simp3_27 with 
      ((¬(P ∧ ¬ Q) ↔ ¬P ∨ Q) → (¬P ∨ Q ↔ ¬(P ∧ ¬Q)))
      ((¬P ∨ Q ↔ ¬(P ∧ ¬Q)) → (¬(P ∧ ¬ Q) ↔ ¬P ∨ Q)).
    intros Simp3_27a.
    MP Simp3_27a n4_21a.
    MP Simp3_27a Simp3_26a.
    exact Simp3_27a.
Qed.

Theorem n4_54 : ∀ P Q : Prop,
  (¬P ∧ Q) ↔ ¬(P ∨ ¬Q).
  Proof. intros P Q.
    specialize n4_5 with (¬P) Q.
    intros n4_5a.
    specialize n4_13 with P.
    intros n4_13a.
    apply propositional_extensionality in n4_13a.
    replace (¬¬P) with P in n4_5a
     by now apply n4_13a.
    exact n4_5a.
Qed.

Theorem n4_55 : ∀ P Q : Prop,
  ¬(¬P ∧ Q) ↔ (P ∨ ¬Q).
  Proof. intros P Q.
    specialize n4_54 with P Q.
    intros n4_54a.
    specialize n4_12 with (¬P ∧ Q) (P ∨ ¬Q).
    intros n4_12a.
    apply propositional_extensionality in n4_12a.
    replace (¬P ∧ Q ↔ ¬(P ∨ ¬Q)) with 
        (P ∨ ¬Q ↔ ¬(¬P ∧ Q)) in n4_54a 
        by now apply n4_12a.
    specialize n4_21 with (¬(¬P ∧ Q)) (P ∨ ¬Q).
    intros n4_21a. (*Not cited*)
    apply propositional_extensionality in n4_21a.
    replace (P ∨ ¬Q ↔ ¬(¬P ∧ Q)) with 
        (¬(¬P ∧ Q) ↔ (P ∨ ¬Q)) in n4_54a
        by now apply n4_21a.
    exact n4_54a.
Qed.

Theorem n4_56 : ∀ P Q : Prop,
  (¬P ∧ ¬Q) ↔ ¬(P ∨ Q).
  Proof. intros P Q.
    specialize n4_54 with P (¬Q).
    intros n4_54a.
    specialize n4_13 with Q.
    intros n4_13a.
    apply propositional_extensionality in n4_13a.
    replace (¬¬Q) with Q in n4_54a 
      by now apply n4_13a.
    exact n4_54a.
Qed.

Theorem n4_57 : ∀ P Q : Prop,
  ¬(¬P ∧ ¬Q) ↔ (P ∨ Q).
  Proof. intros P Q.
    specialize n4_56 with P Q.
    intros n4_56a.
    specialize n4_12 with (¬P ∧ ¬Q) (P ∨ Q).
    intros n4_12a.
    apply propositional_extensionality in n4_12a.
    replace (¬P ∧ ¬Q ↔ ¬(P ∨ Q)) with 
        (P ∨ Q ↔ ¬(¬P ∧ ¬Q)) in n4_56a
        by now apply n4_12a.
    specialize n4_21 with (¬(¬P ∧ ¬Q)) (P ∨ Q).
    intros n4_21a.
    apply propositional_extensionality in n4_21a.
    replace (P ∨ Q ↔ ¬(¬P ∧ ¬Q)) with 
        (¬(¬P ∧ ¬Q) ↔ P ∨ Q) in n4_56a
        by now apply n4_21a.
    exact n4_56a.
Qed.
    
Theorem n4_6 : ∀ P Q : Prop,
  (P → Q) ↔ (¬P ∨ Q).
  Proof. intros P Q.
    specialize n4_2 with (¬P∨ Q).
    intros n4_2a.
    rewrite Impl1_01.
    exact n4_2a.
Qed.

Theorem n4_61 : ∀ P Q : Prop,
  ¬(P → Q) ↔ (P ∧ ¬Q).
  Proof. intros P Q.
  specialize n4_6 with P Q.
  intros n4_6a.
  specialize Transp4_11 with (P→Q) (¬P∨Q).
  intros Transp4_11a.
  apply propositional_extensionality in Transp4_11a.
  replace ((P → Q) ↔ ¬P ∨ Q) with 
      (¬(P → Q) ↔ ¬(¬P ∨ Q)) in n4_6a
      by now apply Transp4_11a.
  specialize n4_52 with P Q.
  intros n4_52a.
  apply propositional_extensionality in n4_52a.
  replace (¬(¬P ∨ Q)) with (P ∧ ¬Q) in n4_6a
    by now apply n4_52a.
  exact n4_6a.
Qed.

Theorem n4_62 : ∀ P Q : Prop,
  (P → ¬Q) ↔ (¬P ∨ ¬Q).
  Proof. intros P Q.
    specialize n4_6 with P (¬Q).
    intros n4_6a.
    exact n4_6a.
Qed.

Theorem n4_63 : ∀ P Q : Prop,
  ¬(P → ¬Q) ↔ (P ∧ Q).
  Proof. intros P Q.
    specialize n4_62 with P Q.
    intros n4_62a.
    specialize Transp4_11 with (P → ¬Q) (¬P ∨ ¬Q).
    intros Transp4_11a.
    specialize n4_5 with P Q.
    intros n4_5a.
    apply propositional_extensionality in n4_5a.
    replace (¬(¬P ∨ ¬Q)) with (P ∧ Q) in Transp4_11a
      by now apply n4_5a.
    apply propositional_extensionality in Transp4_11a.
    replace ((P → ¬Q) ↔ ¬P ∨ ¬Q) with 
        ((¬(P → ¬Q) ↔ P ∧ Q)) in n4_62a
        by now apply Transp4_11a.
    exact n4_62a.
Qed.
  (*One could use Prod3_01 in lieu of n4_5.*)

Theorem n4_64 : ∀ P Q : Prop,
  (¬P → Q) ↔ (P ∨ Q).
  Proof. intros P Q.
    specialize n2_54 with P Q.
    intros n2_54a.
    specialize n2_53 with P Q.
    intros n2_53a.
    Conj n2_54a n2_53a C.
    Equiv C.
    exact C.
Qed.

Theorem n4_65 : ∀ P Q : Prop,
  ¬(¬P → Q) ↔ (¬P ∧ ¬Q).
  Proof. intros P Q.
  specialize n4_64 with P Q.
  intros n4_64a.
  specialize Transp4_11 with(¬P → Q) (P ∨ Q).
  intros Transp4_11a.
  specialize n4_21 with (¬(¬P → Q)↔¬(P ∨ Q))
      ((¬P → Q)↔(P ∨ Q)).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace (((¬P→Q)↔P∨Q)↔(¬(¬P→Q)↔¬(P∨Q))) with 
      ((¬(¬P→Q)↔¬(P∨Q))↔((¬P→Q)↔P∨Q)) in Transp4_11a
      by now apply n4_21a.
  apply propositional_extensionality in Transp4_11a.
  replace ((¬P → Q) ↔ P ∨ Q) with 
      (¬(¬P → Q) ↔ ¬(P ∨ Q)) in n4_64a
      by now apply Transp4_11a.
  specialize n4_56 with P Q.
  intros n4_56a.
  apply propositional_extensionality in n4_56a.
  replace (¬(P ∨ Q)) with (¬P ∧ ¬Q) in n4_64a
    by now apply n4_56a.
  exact n4_64a.
Qed.

Theorem n4_66 : ∀ P Q : Prop,
  (¬P → ¬Q) ↔ (P ∨ ¬Q).
  Proof. intros P Q.
  specialize n4_64 with P (¬Q).
  intros n4_64a.
  exact n4_64a.
Qed.

Theorem n4_67 : ∀ P Q : Prop,
  ¬(¬P → ¬Q) ↔ (¬P ∧ Q).
  Proof. intros P Q.
  specialize n4_66 with P Q.
  intros n4_66a.
  specialize Transp4_11 with (¬P → ¬Q) (P ∨ ¬Q).
  intros Transp4_11a.
  apply propositional_extensionality in Transp4_11a.
  replace ((¬P → ¬Q) ↔ P ∨ ¬Q) with 
      (¬(¬P → ¬Q) ↔ ¬(P ∨ ¬Q)) in n4_66a
      by now apply Transp4_11a.
  specialize n4_54 with P Q.
  intros n4_54a.
  apply propositional_extensionality in n4_54a.
  replace (¬(P ∨ ¬Q)) with (¬P ∧ Q) in n4_66a
    by now apply n4_54a.
  exact n4_66a.
Qed.

Theorem n4_7 : ∀ P Q : Prop,
  (P → Q) ↔ (P → (P ∧ Q)).
  Proof. intros P Q.
  specialize Comp3_43 with P P Q.
  intros Comp3_43a.
  specialize Exp3_3 with 
      (P → P) (P → Q) (P → P ∧ Q).
  intros Exp3_3a.
  MP Exp3_3a Comp3_43a.
  specialize Id2_08 with P.
  intros Id2_08a.
  MP Exp3_3a Id2_08a.
  specialize Simp3_27 with P Q.
  intros Simp3_27a.
  specialize Syll2_05 with P (P ∧ Q) Q.
  intros Syll2_05a.
  MP Syll2_05a Simp3_27a.
  clear Id2_08a. clear Comp3_43a. clear Simp3_27a.
  Conj Syll2_05a Exp3_3a C.
  Equiv C.
  exact C.
Qed.

Theorem n4_71 : ∀ P Q : Prop,
  (P → Q) ↔ (P ↔ (P ∧ Q)).
  Proof. intros P Q.
  specialize n4_7 with P Q.
  intros n4_7a.
  specialize n3_21 with (P→(P∧Q)) ((P∧Q)→P).
  intros n3_21a.
  replace ((P→P∧Q)∧(P∧Q→P)) with (P↔(P∧Q)) 
      in n3_21a by now rewrite Equiv4_01.
  specialize Simp3_26 with P Q.
  intros Simp3_26a.
  MP n3_21a Simp3_26a.
  specialize Simp3_26 with (P→(P∧Q)) ((P∧Q)→P).
  intros Simp3_26b.
  replace ((P→P∧Q)∧(P∧Q→P)) with (P↔(P∧Q)) 
    in Simp3_26b by now rewrite Equiv4_01.
  clear Simp3_26a.
  Conj n3_21a Simp3_26b Ca.
  Equiv Ca.
  clear n3_21a. clear Simp3_26b.
  Conj n4_7a Ca Cb.
  specialize n4_22 with (P → Q) (P → P ∧ Q) (P ↔ P ∧ Q).
  intros n4_22a.
  MP n4_22a Cb.
  exact n4_22a.
Qed.

Theorem n4_72 : ∀ P Q : Prop,
  (P → Q) ↔ (Q ↔ (P ∨ Q)).
  Proof. intros P Q.
  specialize Transp4_1 with P Q.
  intros Transp4_1a.
  specialize n4_71 with (¬Q) (¬P).
  intros n4_71a.
  Conj Transp4_1a n4_71a Ca.
  specialize n4_22 with 
      (P→Q) (¬Q→¬P) (¬Q↔¬Q ∧ ¬P).
  intros n4_22a.
  MP n4_22a Ca.
  specialize n4_21 with (¬Q) (¬Q ∧ ¬P).
  intros n4_21a.
  Conj n4_22a n4_21a Cb.
  specialize n4_22 with 
      (P→Q) (¬Q ↔ ¬Q ∧ ¬P) (¬Q ∧ ¬P ↔ ¬Q).
  intros n4_22b.
  MP n4_22b Cb.
  specialize n4_12 with (¬Q ∧ ¬P) (Q).
  intros n4_12a.
  Conj n4_22b n4_12a Cc.
  specialize n4_22 with 
      (P → Q) ((¬Q ∧ ¬P) ↔ ¬Q) (Q ↔ ¬(¬Q ∧ ¬P)).
  intros n4_22c.
  MP n4_22b Cc.
  specialize n4_57 with Q P.
  intros n4_57a.
  apply propositional_extensionality in n4_57a.
  replace (¬(¬Q ∧ ¬P)) with (Q ∨ P) in n4_22c
    by now apply n4_57a.
  specialize n4_31 with P Q.
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  replace (Q ∨ P) with (P ∨ Q) in n4_22c
    by now apply n4_22c.
  exact n4_22c.
Qed.
(*One could use Prod3_01 in lieu of n4_57.*)

Theorem n4_73 : ∀ P Q : Prop,
  Q → (P ↔ (P ∧ Q)).
  Proof. intros P Q.
  specialize Simp2_02 with P Q.
  intros Simp2_02a.
  specialize n4_71 with P Q.
  intros n4_71a.
  replace ((P → Q) ↔ (P ↔ P ∧ Q)) with 
      (((P→Q)→(P↔P∧Q))∧((P↔P∧Q)→(P→Q))) 
      in n4_71a by now rewrite Equiv4_01.
  specialize Simp3_26 with 
      ((P → Q) → P ↔ P ∧ Q) (P ↔ P ∧ Q → P → Q).
  intros Simp3_26a.
  MP Simp3_26a n4_71a.
  Syll Simp2_02a Simp3_26a Sa.
  exact Sa.
Qed.

Theorem n4_74 : ∀ P Q : Prop,
  ¬P → (Q ↔ (P ∨ Q)).
  Proof. intros P Q.
  specialize n2_21 with P Q.
  intros n2_21a.
  specialize n4_72 with P Q.
  intros n4_72a.
  apply propositional_extensionality in n4_72a.
  replace (P → Q) with (Q ↔ P ∨ Q) in n2_21a
    by now apply n4_72a.
  exact n2_21a.
Qed.

Theorem n4_76 : ∀ P Q R : Prop,
  ((P → Q) ∧ (P → R)) ↔ (P → (Q ∧ R)).
  Proof. intros P Q R.
  specialize n4_41 with (¬P) Q R.
  intros n4_41a.
  replace (¬P ∨ Q) with (P→Q) in n4_41a
    by now rewrite Impl1_01.
  replace (¬P ∨ R) with (P→R) in n4_41a
    by now rewrite Impl1_01.
  replace (¬P ∨ Q ∧ R) with (P → Q ∧ R) in n4_41a
    by now rewrite Impl1_01.
  specialize n4_21 with ((P → Q) ∧ (P → R)) (P → Q ∧ R).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace ((P → Q ∧ R) ↔ (P → Q) ∧ (P → R)) with 
      ((P → Q) ∧ (P → R) ↔ (P → Q ∧ R)) in n4_41a
      by now apply n4_41a.
  exact n4_41a.
Qed.

Theorem n4_77 : ∀ P Q R : Prop,
  ((Q → P) ∧ (R → P)) ↔ ((Q ∨ R) → P).
  Proof. intros P Q R.
  specialize n3_44 with P Q R.
  intros n3_44a.
  specialize n2_2 with Q R.
  intros n2_2a.
  specialize Add1_3 with Q R.
  intros Add1_3a.
  specialize Syll2_06 with Q (Q ∨ R) P.
  intros Syll2_06a.
  MP Syll2_06a n2_2a.
  specialize Syll2_06 with R (Q ∨ R) P.
  intros Syll2_06b.
  MP Syll2_06b Add1_3a.
  Conj Syll2_06a Syll2_06b Ca.
  specialize Comp3_43 with ((Q ∨ R)→P)
    (Q→P) (R→P).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  clear n2_2a. clear Add1_3a. clear Ca.
    clear Syll2_06a. clear Syll2_06b.
  Conj n3_44a Comp3_43a Cb.
  Equiv Cb.
  exact Cb.
Qed. 

Theorem n4_78 : ∀ P Q R : Prop,
  ((P → Q) ∨ (P → R)) ↔ (P → (Q ∨ R)).
  Proof. intros P Q R.
  specialize n4_2 with ((P→Q) ∨ (P → R)).
  intros n4_2a.
  replace (((P→Q)∨(P→R))↔((P→Q)∨(P→R))) with 
      (((P → Q) ∨ (P → R))↔((P → Q) ∨ ¬P ∨ R)) in n4_2a
      by now rewrite <- Impl1_01.
  replace (((P → Q) ∨ (P → R))↔((P → Q) ∨ ¬P ∨ R)) with 
      (((P → Q) ∨ (P → R))↔((¬P ∨ Q) ∨ ¬P ∨ R)) in n4_2a
      by now rewrite <- Impl1_01.
  specialize n4_33 with (¬P) Q (¬P ∨ R).
  intros n4_33a.
  apply propositional_extensionality in n4_33a.
  replace ((¬P ∨ Q) ∨ ¬P ∨ R) with 
      (¬P ∨ Q ∨ ¬P ∨ R) in n4_2a 
      by now apply n4_33a.
  specialize n4_33 with Q (¬P) R.
  intros n4_33b.
  apply propositional_extensionality in n4_33b.
  replace (Q ∨ ¬P ∨ R) with 
      ((Q ∨ ¬P) ∨ R) in n4_2a
      by now apply n4_33b.
  specialize n4_31 with (¬P) Q.
  intros n4_31a.
  specialize n4_37 with (¬P∨Q) (Q ∨ ¬P) R.
  intros n4_37a.
  MP n4_37a n4_31a.
  apply propositional_extensionality in n4_37a.
  replace ((Q ∨ ¬P) ∨ R) with 
      ((¬P ∨ Q) ∨ R) in n4_2a
      by now apply n4_37a.
  specialize n4_33 with (¬P) (¬P∨Q) R.
  intros n4_33c.
  apply propositional_extensionality in n4_33c.
  replace (¬P ∨ (¬P ∨ Q) ∨ R) with 
      ((¬P ∨ (¬P ∨ Q)) ∨ R) in n4_2a
      by now apply n4_33c.
  specialize n4_33 with (¬P) (¬P) Q.
  intros n4_33d.
  apply propositional_extensionality in n4_33d.
  replace (¬P ∨ ¬P ∨ Q) with 
      ((¬P ∨ ¬P) ∨ Q) in n4_2a
      by now apply n4_33d.
  specialize n4_33 with (¬P ∨ ¬P) Q R.
  intros n4_33e.
  apply propositional_extensionality in n4_33e.
  replace (((¬P ∨ ¬P) ∨ Q) ∨ R) with 
      ((¬P ∨ ¬P) ∨ Q ∨ R) in n4_2a
      by now apply n4_33e.
  specialize n4_25 with (¬P).
  intros n4_25a.
  specialize n4_37 with 
      (¬P) (¬P ∨ ¬P) (Q ∨ R).
  intros n4_37b.
  MP n4_37b n4_25a.
  apply propositional_extensionality in n4_25a.
  replace ((¬P ∨ ¬P) ∨ Q ∨ R) with 
      ((¬P) ∨ (Q ∨ R)) in n4_2a
      by now rewrite <- n4_25a.
  replace (¬P ∨ Q ∨ R) with 
      (P → (Q ∨ R)) in n4_2a
      by now rewrite Impl1_01.
  exact n4_2a.
Qed.

Theorem n4_79 : ∀ P Q R : Prop,
  ((Q → P) ∨ (R → P)) ↔ ((Q ∧ R) → P).
  Proof. intros P Q R.
    specialize Transp4_1 with Q P.
    intros Transp4_1a.
    specialize Transp4_1 with R P.
    intros Transp4_1b.
    Conj Transp4_1a Transp4_1b Ca.
    specialize n4_39 with 
        (Q→P) (R→P) (¬P→¬Q) (¬P→¬R).
    intros n4_39a.
    MP n4_39a Ca.
    specialize n4_78 with (¬P) (¬Q) (¬R).
    intros n4_78a.
    rewrite Equiv4_01 in n4_78a.
    specialize Simp3_26 with 
      (((¬P→¬Q)∨(¬P→¬R))→(¬P→(¬Q∨¬R)))
      ((¬P→(¬Q∨¬R))→((¬P→¬Q)∨(¬P→¬R))).
    intros Simp3_26a.
    MP Simp3_26a n4_78a.
    specialize Transp2_15 with P (¬Q∨¬R).
    intros Transp2_15a.
    specialize Simp3_27 with 
      (((¬P→¬Q)∨(¬P→¬R))→(¬P→(¬Q∨¬R)))
      ((¬P→(¬Q∨¬R))→((¬P→¬Q)∨(¬P→¬R))).
    intros Simp3_27a.
    MP Simp3_27a n4_78a.
    specialize Transp2_15 with (¬Q∨¬R) P.
    intros Transp2_15b.
    specialize Syll2_06 with ((¬P→¬Q)∨(¬P→¬R))
      (¬P→(¬Q∨¬R)) (¬(¬Q∨¬R)→P).
    intros Syll2_06a.
    MP Syll2_06a Simp3_26a.
    MP Syll2_06a Transp2_15a.
    specialize Syll2_06 with (¬(¬Q∨¬R)→P)
      (¬P→(¬Q∨¬R)) ((¬P→¬Q)∨(¬P→¬R)).
    intros Syll2_06b.
    MP Syll2_06b Trans2_15b.
    MP Syll2_06b Simp3_27a.
    Conj Syll2_06a Syll2_06b Cb.
    Equiv Cb.
    clear Transp4_1a. clear Transp4_1b. clear Ca.
      clear Simp3_26a. clear Syll2_06b. clear n4_78a.
      clear Transp2_15a. clear Simp3_27a. 
      clear Transp2_15b. clear Syll2_06a.
    Conj n4_39a Cb Cc.
    specialize n4_22 with ((Q→P)∨(R→P))
      ((¬P→¬Q)∨(¬P→¬R)) (¬(¬Q∨¬R)→P).
    intros n4_22a.
    MP n4_22a Cc.
    specialize n4_2 with (¬(¬Q∨¬R)→P).
    intros n4_2a.
    Conj n4_22a n4_2a Cdd.
    specialize n4_22 with ((Q→P)∨(R→P))
    (¬(¬Q∨¬R)→P) (¬(¬Q∨¬R)→P).
    intros n4_22b.
    MP n4_22b Cdd.
    rewrite <- Prod3_01 in n4_22b.
    exact n4_22b.
Qed.

Theorem n4_8 : ∀ P : Prop,
  (P → ¬P) ↔ ¬P.
  Proof. intros P.
    specialize Abs2_01 with P.
    intros Abs2_01a.
    specialize  Simp2_02 with P (¬P).
    intros Simp2_02a.
    Conj Abs2_01a Simp2_02a C.
    Equiv C.
    exact C.
Qed.

Theorem n4_81 : ∀ P : Prop,
  (¬P → P) ↔ P.
  Proof. intros P.
    specialize n2_18 with P.
    intros n2_18a.
    specialize  Simp2_02 with (¬P) P.
    intros Simp2_02a.
    Conj n2_18a Simp2_02a C.
    Equiv C.
    exact C.
Qed.

Theorem n4_82 : ∀ P Q : Prop,
  ((P → Q) ∧ (P → ¬Q)) ↔ ¬P.
  Proof. intros P Q. 
    specialize n2_65 with P Q.
    intros n2_65a.
    specialize Imp3_31 with (P→Q) (P→¬Q) (¬P).
    intros Imp3_31a.
    MP Imp3_31a n2_65a.
    specialize n2_21 with P Q.
    intros n2_21a.
    specialize n2_21 with P (¬Q).
    intros n2_21b.
    Conj n2_21a n2_21b Ca.
    specialize Comp3_43 with (¬P) (P→Q) (P→¬Q).
    intros Comp3_43a.
    MP Comp3_43a Ca.
    clear n2_65a. clear n2_21a. 
      clear n2_21b. clear Ca.
    Conj Imp3_31a Comp3_43a Cb.
    Equiv Cb.
    exact Cb.
Qed.

Theorem n4_83 : ∀ P Q : Prop,
  ((P → Q) ∧ (¬P → Q)) ↔ Q.
  Proof. intros P Q.
  specialize n2_61 with P Q.
  intros n2_61a.
  specialize Imp3_31 with (P→Q) (¬P→Q) (Q).
  intros Imp3_31a.
  MP Imp3_31a n2_61a.
  specialize Simp2_02 with P Q.
  intros Simp2_02a.
  specialize Simp2_02 with (¬P) Q.
  intros Simp2_02b.
  Conj Simp2_02a Simp2_02b Ca.
  specialize Comp3_43 with Q (P→Q) (¬P→Q).
  intros Comp3_43a.
  MP Comp3_43a H.
  clear n2_61a. clear Simp2_02a. 
    clear Simp2_02b. clear Ca.
  Conj Imp3_31a Comp3_43a Cb.
  Equiv Cb.
  exact Cb.
Qed.

Theorem n4_84 : ∀ P Q R : Prop,
  (P ↔ Q) → ((P → R) ↔ (Q → R)).
  Proof. intros P Q R.
    specialize Syll2_06 with P Q R.
    intros Syll2_06a.
    specialize Syll2_06 with Q P R.
    intros Syll2_06b.
    Conj Syll2_06a Syll2_06b Ca.
    specialize n3_47 with 
        (P→Q) (Q→P) ((Q→R)→P→R) ((P→R)→Q→R).
    intros n3_47a.
    MP n3_47a Ca.
    replace ((P→Q) ∧ (Q → P)) with (P↔Q) 
        in n3_47a by now rewrite Equiv4_01.
    replace (((Q→R)→P→R)∧((P→R)→Q→R)) with 
      ((Q→R)↔(P→R)) in n3_47a by 
      now rewrite Equiv4_01.
    specialize n4_21 with (P→R) (Q→R).
    intros n4_21a.
    apply propositional_extensionality in n4_21a.
    replace ((Q → R) ↔ (P → R)) with 
        ((P→ R) ↔ (Q → R)) in n3_47a
        by now apply n4_21a.
    exact n3_47a.
Qed.

Theorem n4_85 : ∀ P Q R : Prop,
  (P ↔ Q) → ((R → P) ↔ (R → Q)).
  Proof. intros P Q R.
  specialize Syll2_05 with R P Q.
  intros Syll2_05a.
  specialize Syll2_05 with R Q P.
  intros Syll2_05b.
  Conj Syll2_05a Syll2_05b Ca.
  specialize n3_47 with 
      (P→Q) (Q→P) ((R→P)→R→Q) ((R→Q)→R→P).
  intros n3_47a.
  MP n3_47a Ca.
  replace ((P→Q) ∧ (Q → P)) with (P↔Q) in n3_47a
  by now rewrite Equiv4_01.
  replace (((R→P)→R→Q)∧((R→Q)→R→P)) with 
    ((R→P)↔(R→Q)) in n3_47a 
    by now rewrite Equiv4_01.
  exact n3_47a.
Qed.

Theorem n4_86 : ∀ P Q R : Prop,
  (P ↔ Q) → ((P ↔ R) ↔ (Q ↔ R)). 
  Proof. intros P Q R.
  specialize n4_22 with  Q P R.
  intros n4_22a.
  specialize Exp3_3 with (Q↔P) (P↔R) (Q↔R).
  intros Exp3_3a. (*Not cited*)
  MP Exp3_3a n4_22a.
  specialize n4_22 with  P Q R.
  intros n4_22b.
  specialize Exp3_3 with (P↔Q) (Q↔R) (P↔R).
  intros Exp3_3b.
  MP Exp3_3b n4_22b.
  specialize n4_21 with P Q.
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace (Q↔P) with (P↔Q) in Exp3_3a
    by now apply n4_21a.
  clear n4_22a. clear n4_22b. clear n4_21a.
  Conj Exp3_3a Exp3_3b Ca.
  specialize Comp3_43 with (P↔Q)
      ((P↔R)→(Q↔R)) ((Q↔R)→(P↔R)).
  intros Comp3_43a. (*Not cited*)
  MP Comp3_43a Ca.
  replace (((P↔R)→(Q↔R))∧((Q↔R)→(P↔R)))
    with ((P↔R)↔(Q↔R)) in Comp3_43a 
    by now rewrite Equiv4_01.
  exact Comp3_43a.
Qed.

Theorem n4_87 : ∀ P Q R : Prop,
  (((P ∧ Q) → R) ↔ (P → Q → R)) ↔ 
      ((Q → (P → R)) ↔ (Q ∧ P → R)).
  Proof. intros P Q R.
  specialize Exp3_3 with P Q R.
  intros Exp3_3a.
  specialize Imp3_31 with P Q R.
  intros Imp3_31a.
  Conj Exp3_3a Imp3_31a Ca.
  Equiv Ca.
  specialize Exp3_3 with Q P R.
  intros Exp3_3b.
  specialize Imp3_31 with Q P R.
  intros Imp3_31b.
  Conj Exp3_3b Imp3_31b Cb.
  Equiv Cb.
  specialize n4_21 with (Q→P→R) (Q∧P→R).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace ((Q∧P→R)↔(Q→P→R)) with 
    ((Q→P→R)↔(Q∧P→R)) in Cb
    by now apply n4_21a.
  specialize Simp2_02 with ((P∧Q→R)↔(P→Q→R))
    ((Q→P→R)↔(Q∧P→R)).
  intros Simp2_02a.
  MP Simp2_02a Cb.
  specialize Simp2_02 with ((Q→P→R)↔(Q∧P→R)) 
    ((P∧Q→R)↔(P→Q→R)).
  intros Simp2_02b.
  MP Simp2_02b Ca.
  Conj Simp2_02a Simp2_02b Cc.
  Equiv Cc.
  exact Cc.
Qed.
  (*The proof sketch cites Comm2_04. This 
    bit of the sketch was indecipherable.*)

End No4.

Module No5.

Import No1.
Import No2.
Import No3.
Import No4.

Theorem n5_1 : ∀ P Q : Prop,
  (P ∧ Q) → (P ↔ Q).
  Proof. intros P Q.
  specialize n3_4 with P Q.
  intros n3_4a.
  specialize n3_4 with Q P.
  intros n3_4b.
  specialize n3_22 with P Q.
  intros n3_22a.
  Syll n3_22a n3_4b Sa.
  clear n3_22a. clear n3_4b.
  Conj n3_4a Sa C.
  specialize n4_76 with (P∧Q) (P→Q) (Q→P).
  intros n4_76a. (*Not cited*)
  apply propositional_extensionality in n4_76a.
  replace ((P∧Q→P→Q)∧(P∧Q→Q→P)) with 
      (P ∧ Q → (P → Q) ∧ (Q → P)) in C 
      by now apply n4_76a.
  replace ((P→Q)∧(Q→P)) with (P↔Q) in C
    by now rewrite Equiv4_01.
  exact C.
Qed. 

Theorem n5_11 : ∀ P Q : Prop,
  (P → Q) ∨ (¬P → Q).
  Proof. intros P Q.
  specialize n2_5 with P Q.
  intros n2_5a.
  specialize n2_54 with (P → Q) (¬P → Q).
  intros n2_54a.
  MP n2_54a n2_5a.
  exact n2_54a.
Qed.
  (*The proof sketch cites n2_51, 
      but this may be a misprint.*)

Theorem n5_12 : ∀ P Q : Prop,
  (P → Q) ∨ (P → ¬Q).
  Proof. intros P Q.
  specialize n2_51 with P Q.
  intros n2_51a.
  specialize n2_54 with ((P → Q)) (P → ¬Q).
  intros n2_54a.
  MP n2_54a n2_5a.
  exact n2_54a.
Qed.
  (*The proof sketch cites n2_52, 
      but this may be a misprint.*)

Theorem n5_13 : ∀ P Q : Prop,
  (P → Q) ∨ (Q → P).
  Proof. intros P Q.
  specialize n2_521 with P Q.
  intros n2_521a.
  replace (¬(P → Q) → Q → P) with 
      (¬¬(P → Q) ∨ (Q → P)) in n2_521a
      by now rewrite <- Impl1_01.
  specialize n4_13 with (P→Q).
  intros n4_13a. (*Not cited*)
  apply propositional_extensionality in n4_13a.
  replace (¬¬(P→Q)) with (P→Q)
    in n2_521a by now apply n4_13a.
  exact n2_521a.
Qed. 

Theorem n5_14 : ∀ P Q R : Prop,
  (P → Q) ∨ (Q → R).
  Proof. intros P Q R.
  specialize Simp2_02 with P Q.
  intros Simp2_02a.
  specialize Transp2_16 with Q (P→Q).
  intros Transp2_16a.
  MP Transp2_16a Simp2_02a.
  specialize n2_21 with Q R.
  intros n2_21a.
  Syll Transp2_16a n2_21a Sa.
  replace (¬(P→Q)→(Q→R)) with 
      (¬¬(P→Q)∨(Q→R)) in Sa
      by now rewrite <- Impl1_01.
  specialize n4_13 with (P→Q).
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬(P→Q)) with (P→Q) in Sa
    by now apply n4_13a.
  exact Sa.
Qed.

Theorem n5_15 : ∀ P Q : Prop,
  (P ↔ Q) ∨ (P ↔ ¬Q).
  Proof. intros P Q.
  specialize n4_61 with P Q.
  intros n4_61a.
  replace (¬(P → Q) ↔ P ∧ ¬Q) with 
      ((¬(P→Q)→P∧¬Q)∧((P∧¬Q)→¬(P→Q))) in n4_61a
      by now rewrite Equiv4_01.
  specialize Simp3_26 with 
      (¬(P → Q) → P ∧ ¬Q) ((P ∧ ¬Q) → ¬(P → Q)).
  intros Simp3_26a.
  MP Simp3_26a n4_61a.
  specialize n5_1 with P (¬Q).
  intros n5_1a.
  Syll Simp3_26a n5_1a Sa.
  specialize n2_54 with (P→Q) (P ↔ ¬Q).
  intros n2_54a.
  MP n2_54a Sa.
  specialize n4_61 with Q P.
  intros n4_61b.
  replace ((¬(Q → P)) ↔ (Q ∧ ¬P)) with 
      (((¬(Q→P))→(Q∧¬P))∧((Q∧¬P)→(¬(Q→P)))) 
      in n4_61b by now rewrite Equiv4_01.
  specialize Simp3_26 with 
      (¬(Q→P)→(Q∧¬P)) ((Q∧¬P)→(¬(Q→P))).
  intros Simp3_26b.
  MP Simp3_26b n4_61b.
  specialize n5_1 with Q (¬P).
  intros n5_1b.
  Syll Simp3_26b n5_1b Sb.
  specialize n4_12 with P Q.
  intros n4_12a.
  apply propositional_extensionality in n4_12a.
  replace (Q↔¬P) with (P↔¬Q) in Sb 
    by now apply n4_12a.
  specialize n2_54 with (Q→P) (P↔¬Q).
  intros n2_54b.
  MP n2_54b Sb.
  replace (¬(P → Q) → P ↔ ¬Q) with 
      (¬¬(P → Q) ∨ (P ↔ ¬Q)) in Sa
      by now rewrite <- Impl1_01.
  specialize n4_13 with (P→Q).
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬(P→Q)) with (P→Q) in Sa
    by now apply n4_13a.
  replace (¬(Q → P) → (P ↔ ¬Q)) with 
      (¬¬(Q → P) ∨ (P ↔ ¬Q)) in Sb
      by now rewrite <- Impl1_01.
  specialize n4_13 with (Q→P).
  intros n4_13b.
  apply propositional_extensionality in n4_13b.
  replace (¬¬(Q→P)) with (Q→P) in Sb
    by now apply n4_13b.
  clear n4_61a. clear Simp3_26a. clear n5_1a. 
      clear n2_54a. clear n4_61b. clear Simp3_26b. 
      clear n5_1b. clear n4_12a. clear n2_54b.
      clear n4_13a. clear n4_13b.
  Conj Sa Sb C.
  specialize n4_31 with (P → Q) (P ↔ ¬Q).
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  replace ((P → Q) ∨ (P ↔ ¬Q)) with 
      ((P ↔ ¬Q) ∨ (P → Q)) in C
      by now apply n4_31a.
  specialize n4_31 with (Q → P) (P ↔ ¬Q).
  intros n4_31b.
  apply propositional_extensionality in n4_31b.
  replace ((Q → P) ∨ (P ↔ ¬Q)) with 
      ((P ↔ ¬Q) ∨ (Q → P)) in C
      by now apply n4_31b.
  specialize n4_41 with (P↔¬Q) (P→Q) (Q→P).
  intros n4_41a.
  apply propositional_extensionality in n4_41a.
  replace (((P↔¬Q)∨(P→Q))∧((P↔¬Q)∨(Q→P))) 
      with ((P ↔ ¬Q) ∨ (P → Q) ∧ (Q → P)) in C
      by now apply n4_41a.
  replace ((P→Q) ∧ (Q → P)) with (P↔Q) in C
    by now rewrite Equiv4_01.
    specialize n4_31 with (P ↔ ¬Q) (P ↔ Q).
    intros n4_31c.
    apply propositional_extensionality in n4_31c.
  replace ((P ↔ ¬Q) ∨ (P ↔ Q)) with 
      ((P ↔ Q) ∨ (P ↔ ¬Q)) in C
      by now apply n4_31c.
  exact C.
Qed.

Theorem n5_16 : ∀ P Q : Prop,
  ¬((P ↔ Q) ∧ (P ↔ ¬Q)).
  Proof. intros P Q.
  specialize Simp3_26 with ((P→Q)∧ (P → ¬Q)) (Q→P).
  intros Simp3_26a.
  specialize Id2_08 with ((P ↔ Q) ∧ (P → ¬Q)).
  intros Id2_08a.
  specialize n4_32 with (P→Q) (P→¬Q) (Q→P).
  intros n4_32a.
  apply propositional_extensionality in n4_32a.
  replace (((P → Q) ∧ (P → ¬Q)) ∧ (Q → P)) with 
      ((P→Q)∧((P→¬Q)∧(Q→P))) in Simp3_26a
      by now apply n4_32a.
  specialize n4_3 with (Q→P) (P→¬Q).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace ((P → ¬Q) ∧ (Q → P)) with 
      ((Q → P) ∧ (P → ¬Q)) in Simp3_26a
      by now apply n4_3a.
  specialize n4_32 with (P→Q) (Q→P) (P→¬Q).
  intros n4_32b.
  apply propositional_extensionality in n4_32b.
  replace ((P→Q) ∧ (Q → P)∧ (P → ¬Q)) with 
      (((P→Q) ∧ (Q → P)) ∧ (P → ¬Q)) in Simp3_26a
      by now apply n4_32b.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q)
       in Simp3_26a by now rewrite Equiv4_01.
  Syll Id2_08a Simp3_26a Sa.
  specialize n4_82 with P Q.
  intros n4_82a.
  apply propositional_extensionality in n4_82a.
  replace ((P → Q) ∧ (P → ¬Q)) with (¬P) in Sa
    by now apply n4_82a.
  specialize Simp3_27 with 
      (P→Q) ((Q→P)∧ (P → ¬Q)).
  intros Simp3_27a.
  replace ((P→Q) ∧ (Q → P) ∧ (P → ¬Q)) with 
      (((P→Q) ∧ (Q → P)) ∧ (P → ¬Q)) in Simp3_27a
      by now apply n4_32b.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) 
      in Simp3_27a by now rewrite Equiv4_01.
  specialize Syll3_33 with Q P (¬Q).
  intros Syll3_33a.
  Syll Simp3_27a Syll2_06a Sb.
  specialize Abs2_01 with Q.
  intros Abs2_01a.
  Syll Sb Abs2_01a Sc.
  clear Sb. clear Simp3_26a. clear Id2_08a. 
      clear n4_82a. clear Simp3_27a. clear Syll3_33a. 
      clear Abs2_01a. clear n4_32a. clear n4_32b. clear n4_3a.
  Conj Sa Sc C.
  specialize Comp3_43 with 
      ((P ↔ Q) ∧ (P → ¬Q)) (¬P) (¬Q).
  intros Comp3_43a.
  MP Comp3_43a C.
  specialize n4_65 with Q P.
  intros n4_65a.
  specialize n4_3 with (¬P) (¬Q).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace (¬Q ∧ ¬P) with (¬P ∧ ¬Q) in n4_65a
    by now apply n4_3a.
  apply propositional_extensionality in n4_65a.
  replace (¬P∧¬Q) with (¬(¬Q→P)) in Comp3_43a
    by now apply n4_65a.
  specialize Exp3_3 with 
      (P↔Q) (P→¬Q) (¬(¬Q→P)).
  intros Exp3_3a.
  MP Exp3_3a Comp3_43a.
  replace ((P→¬Q)→¬(¬Q→P)) with 
      (¬(P→¬Q)∨¬(¬Q→P)) in Exp3_3a
      by now rewrite <- Impl1_01.
  specialize n4_51 with (P→¬Q) (¬Q→P).
  intros n4_51a.
  apply propositional_extensionality in n4_51a.
  replace (¬(P → ¬Q) ∨ ¬(¬Q → P)) with 
      (¬((P → ¬Q) ∧ (¬Q → P))) in Exp3_3a
      by now apply n4_51a.
  replace ((P→¬Q)∧(¬Q→P)) with (P↔¬Q) 
    in Exp3_3a by now rewrite Equiv4_01.
  replace ((P↔Q)→¬(P↔¬Q)) with 
      (¬(P↔Q)∨¬(P↔¬Q)) in Exp3_3a
      by now rewrite Impl1_01.
  specialize n4_51 with (P↔Q) (P↔¬Q).
  intros n4_51b.
  apply propositional_extensionality in n4_51b.
  replace (¬(P ↔ Q) ∨ ¬(P ↔ ¬Q)) with 
      (¬((P ↔ Q) ∧ (P ↔ ¬Q))) in Exp3_3a
      by now apply n4_51b.
  exact Exp3_3a.
Qed.

Theorem n5_17 : ∀ P Q : Prop,
  ((P ∨ Q) ∧ ¬(P ∧ Q)) ↔ (P ↔ ¬Q).
  Proof. intros P Q.
  specialize n4_64 with Q P.
  intros n4_64a.
  specialize n4_21 with (Q∨P) (¬Q→P).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace ((¬Q→P)↔(Q∨P)) with 
      ((Q∨P)↔(¬Q→P)) in n4_64a
      by now apply n4_21a.
  specialize n4_31 with P Q.
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  replace (Q∨P) with (P∨Q) in n4_64a
    by now apply n4_31a.
  specialize n4_63 with P Q.
  intros n4_63a.
  specialize n4_21 with (P ∧ Q) (¬(P→¬Q)).
  intros n4_21b.
  apply propositional_extensionality in n4_21b.
  replace (¬(P → ¬Q) ↔ P ∧ Q) with 
      (P ∧ Q ↔ ¬(P → ¬Q)) in n4_63a
      by now apply n4_21b.
  specialize Transp4_11 with (P∧Q) (¬(P→¬Q)).
  intros Transp4_11a.
  specialize n4_13 with (P→¬Q).
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬(P→¬Q)) with (P→¬Q) 
    in Transp4_11a by now apply n4_13a.
  apply propositional_extensionality in Transp4_11a.
  replace (P ∧ Q ↔ ¬(P → ¬Q)) with 
      (¬(P ∧ Q) ↔ (P → ¬Q)) in n4_63a
      by now apply Transp4_11a.
  clear Transp4_11a. clear n4_21a.
  clear n4_31a. clear n4_21b. clear n4_13a.
  Conj n4_64a n4_63a C.
  specialize n4_38 with 
      (P ∨ Q) (¬(P ∧ Q)) (¬Q → P) (P → ¬Q).
  intros n4_38a.
  MP n4_38a C.
  replace ((¬Q→P) ∧ (P → ¬Q)) with (¬Q↔P)
       in n4_38a by now rewrite Equiv4_01.
  specialize n4_21 with P (¬Q).
  intros n4_21c.
  apply propositional_extensionality in n4_21c.
  replace (¬Q↔P) with (P↔¬Q) in n4_38a
    by now apply n4_21c.
  exact n4_38a.
Qed.

Theorem n5_18 : ∀ P Q : Prop,
  (P ↔ Q) ↔ ¬(P ↔ ¬Q).
  Proof. intros P Q.
  specialize n5_15 with P Q.
  intros n5_15a.
  specialize n5_16 with P Q.
  intros n5_16a.
  Conj n5_15a n5_16a C.
  specialize n5_17 with (P↔Q) (P↔¬Q).
  intros n5_17a.
  rewrite Equiv4_01 in n5_17a.
  specialize Simp3_26 with 
    ((((P↔Q)∨(P↔¬Q))∧¬((P↔Q)∧(P↔¬Q)))
    →((P↔Q)↔¬(P↔¬Q))) (((P↔Q)↔¬(P↔¬Q))→
    (((P↔Q)∨(P↔¬Q))∧¬((P↔Q)∧(P↔¬Q)))).
  intros Simp3_26a. (*not cited*)
  MP Simp3_26a n5_17a.
  MP Simp3_26a C.
  exact Simp3_26a.
Qed.

Theorem n5_19 : ∀ P : Prop,
  ¬(P ↔ ¬P).
  Proof. intros P.
  specialize n5_18 with P P.
  intros n5_18a.
  specialize n4_2 with P.
  intros n4_2a.
  rewrite Equiv4_01 in n5_18a.
  specialize Simp3_26 with (P↔P→¬(P↔¬P))
    (¬(P↔¬P)→P↔P).
  intros Simp3_26a. (*not cited*)
  MP Simp3_26a n5_18a.
  MP Simp3_26a n4_2a.
  exact Simp3_26a.
Qed.

Theorem n5_21 : ∀ P Q : Prop,
  (¬P ∧ ¬Q) → (P ↔ Q).
  Proof. intros P Q.
  specialize n5_1 with (¬P) (¬Q).
  intros n5_1a.
  specialize Transp4_11 with P Q.
  intros Transp4_11a.
  apply propositional_extensionality in Transp4_11a.
  replace (¬P↔¬Q) with (P↔Q) in n5_1a
    by now apply Transp4_11a.
  exact n5_1a.
Qed.

Theorem n5_22 : ∀ P Q : Prop,
  ¬(P ↔ Q) ↔ ((P ∧ ¬Q) ∨ (Q ∧ ¬P)).
  Proof. intros P Q.
  specialize n4_61 with P Q.
  intros n4_61a.
  specialize n4_61 with Q P.
  intros n4_61b.
  Conj n4_61a n4_61b C.
  specialize n4_39 with 
      (¬(P → Q)) (¬(Q → P)) (P ∧ ¬Q) (Q ∧ ¬P).
  intros n4_39a.
  MP n4_39a C.
  specialize n4_51 with (P→Q) (Q→P).
  intros n4_51a.
  apply propositional_extensionality in n4_51a.
  replace (¬(P → Q) ∨ ¬(Q → P)) with 
      (¬((P → Q) ∧ (Q → P))) in n4_39a
      by now apply n4_51a.
  replace ((P → Q) ∧ (Q → P)) with (P↔Q) 
      in n4_39a by now rewrite Equiv4_01.
  exact n4_39a.
Qed.

Theorem n5_23 : ∀ P Q : Prop,
  (P ↔ Q) ↔ ((P ∧ Q) ∨ (¬P ∧ ¬Q)).
  Proof. intros P Q.
  specialize n5_18 with P Q.
  intros n5_18a.
  specialize n5_22 with P (¬Q).
  intros n5_22a.
  Conj n5_18a n5_22a C.
  specialize n4_22 with (P↔Q) (¬(P↔¬Q)) 
    (P ∧ ¬¬Q ∨ ¬Q ∧ ¬P).
  intros n4_22a.
  MP n4_22a C.
  specialize n4_13 with Q.
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬Q) with Q in n4_22a by now apply n4_13a.
  specialize n4_3 with (¬P) (¬Q).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace (¬Q ∧ ¬P) with (¬P ∧ ¬Q) in n4_22a
    by now apply n4_3a.
  exact n4_22a.
Qed. 
  (*The proof sketch in Principia offers n4_36. 
    This seems to be a misprint. We used n4_3.*)

Theorem n5_24 : ∀ P Q : Prop,
  ¬((P ∧ Q) ∨ (¬P ∧ ¬Q)) ↔ ((P ∧ ¬Q) ∨ (Q ∧ ¬P)).
  Proof. intros P Q.
  specialize n5_23 with P Q.
  intros n5_23a.
  specialize Transp4_11 with 
    (P↔Q) (P ∧ Q ∨ ¬P ∧ ¬Q).
  intros Transp4_11a. (*Not cited*)
  rewrite Equiv4_01 in Transp4_11a.
  specialize Simp3_26 with (((P↔Q)↔P∧Q∨¬P∧¬Q)
    →(¬(P↔Q)↔¬(P∧Q∨¬P∧¬Q))) 
    ((¬(P↔Q)↔¬(P∧Q∨¬P∧¬Q))
    →((P↔Q)↔P∧Q∨¬P∧¬Q)).
  intros Simp3_26a.
  MP Simp3_26a Transp4_11a.
  MP Simp3_26a n5_23a.
  specialize n5_22 with P Q.
  intros n5_22a.
    clear n5_23a. clear Transp4_11a.
  Conj Simp3_26a n5_22a C.
  specialize n4_22 with (¬(P∧Q∨¬P∧¬Q))
    (¬(P↔Q)) (P∧¬Q∨Q∧¬P).
  intros n4_22a.
  specialize n4_21 with (¬(P∧Q∨¬P∧¬Q)) (¬(P↔Q)).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace ((¬(P↔Q))↔(¬((P ∧ Q)∨(¬P ∧ ¬Q))))
    with ((¬((P ∧ Q)∨(¬P ∧ ¬Q)))↔(¬(P↔Q))) in C
    by now apply n4_21a.
  MP n4_22a C.
  exact n4_22a.
Qed. 

Theorem n5_25 : ∀ P Q : Prop,
  (P ∨ Q) ↔ ((P → Q) → Q).
  Proof. intros P Q.
  specialize n2_62 with P Q.
  intros n2_62a.
  specialize n2_68 with P Q.
  intros n2_68a.
  Conj n2_62a n2_68a C.
  Equiv C.
  exact C.
Qed.

Theorem n5_3 : ∀ P Q R : Prop,
  ((P ∧ Q) → R) ↔ ((P ∧ Q) → (P ∧ R)).
  Proof. intros P Q R.
  specialize Comp3_43 with (P ∧ Q) P R.
  intros Comp3_43a.
  specialize Exp3_3 with 
      (P ∧ Q → P) (P ∧ Q →R) (P ∧ Q → P ∧ R).
  intros Exp3_3a. (*Not cited*)
  MP Exp3_3a Comp3_43a.
  specialize Simp3_26 with P Q.
  intros Simp3_26a.
  MP Exp3_3a Simp3_26a.
  specialize Syll2_05 with (P ∧ Q) (P ∧ R) R.
  intros Syll2_05a.
  specialize Simp3_27 with P R.
  intros Simp3_27a.
  MP Syll2_05a Simp3_27a.
  clear Comp3_43a. clear Simp3_27a. 
      clear Simp3_26a.
  Conj Exp3_3a Syll2_05a C.
  Equiv C.
  exact C.
Qed. 

Theorem n5_31 : ∀ P Q R : Prop,
  (R ∧ (P → Q)) → (P → (Q ∧ R)).
  Proof. intros P Q R.
  specialize Comp3_43 with P Q R.
  intros Comp3_43a.
  specialize Simp2_02 with P R.
  intros Simp2_02a.
  specialize Exp3_3 with 
      (P→R) (P→Q) (P→(Q ∧ R)).
  intros Exp3_3a. (*Not cited*)
  specialize n3_22 with (P → R) (P → Q). (*Not cited*)
  intros n3_22a.
  Syll n3_22a Comp3_43a Sa.
  MP Exp3_3a Sa.
  Syll Simp2_02a Exp3_3a Sb.
  specialize Imp3_31 with R (P→Q) (P→(Q ∧ R)).
  intros Imp3_31a. (*Not cited*)
  MP Imp3_31a Sb.
  exact Imp3_31a.
Qed. 

Theorem n5_32 : ∀ P Q R : Prop,
  (P → (Q ↔ R)) ↔ ((P ∧ Q) ↔ (P ∧ R)).
  Proof. intros P Q R.
  specialize n4_76 with P (Q→R) (R→Q).
  intros n4_76a.
  specialize Exp3_3 with P Q R.
  intros Exp3_3a.
  specialize Imp3_31 with P Q R.
  intros Imp3_31a.
  Conj Exp3_3a Imp3_31a Ca.
  Equiv Ca.
  specialize Exp3_3 with P R Q.
  intros Exp3_3b.
  specialize Imp3_31 with P R Q.
  intros Imp3_31b.
  Conj Exp3_3b Imp3_31b Cb.
  Equiv Cb.
  specialize n5_3 with P Q R.
  intros n5_3a.
  specialize n5_3 with P R Q.
  intros n5_3b.
  apply propositional_extensionality in Ca.
  replace (P→Q→R) with (P∧Q→R) in n4_76a
    by now apply Ca.
  apply propositional_extensionality in Cb.
  replace (P→R→Q) with (P∧R→Q) in n4_76a
    by now apply Cb.
  apply propositional_extensionality in n5_3a.
  replace (P∧Q→R) with (P∧Q→P∧R) in n4_76a
    by now apply n5_3a.
  apply propositional_extensionality in n5_3b.
  replace (P∧R→Q) with (P∧R→P∧Q) in n4_76a
    by now apply n5_3b.
  replace ((P∧Q→P∧R)∧(P∧R→P∧Q)) with 
      ((P∧Q)↔(P∧R)) in n4_76a 
      by now rewrite Equiv4_01.
  specialize n4_21 with 
      (P→((Q→R)∧(R→Q))) ((P∧Q)↔(P∧R)).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace ((P∧Q↔P∧R)↔(P→(Q→R)∧(R→Q))) with 
      ((P→(Q→R)∧(R→Q))↔(P∧Q ↔ P∧R)) in n4_76a
      by now apply n4_21a.
  replace ((Q→R)∧(R→Q)) with (Q↔R) in n4_76a
    by now rewrite Equiv4_01.
  exact n4_76a.
Qed.

Theorem n5_33 : ∀ P Q R : Prop,
  (P ∧ (Q → R)) ↔ (P ∧ ((P ∧ Q) → R)).
  Proof. intros P Q R.
    specialize n5_32 with P (Q→R) ((P∧Q)→R).
    intros n5_32a.
    replace 
        ((P→(Q→R)↔(P∧Q→R))↔(P∧(Q→R)↔P∧(P∧Q→R))) 
        with 
        (((P→(Q→R)↔(P∧Q→R))→(P∧(Q→R)↔P∧(P∧Q→R)))
        ∧
        ((P∧(Q→R)↔P∧(P∧Q→R)→(P→(Q→R)↔(P∧Q→R))))) 
        in n5_32a by now rewrite Equiv4_01.
    specialize Simp3_26 with 
        ((P→(Q→R)↔(P∧Q→R))→(P∧(Q→R)↔P∧(P∧Q→R))) 
        ((P∧(Q→R)↔P∧(P∧Q→R)→(P→(Q→R)↔(P∧Q→R)))). 
    intros Simp3_26a. (*Not cited*)
    MP Simp3_26a n5_32a.
    specialize n4_73 with Q P.
    intros n4_73a.
    specialize n4_84 with Q (Q∧P) R.
    intros n4_84a.
    Syll n4_73a n4_84a Sa.
    specialize n4_3 with P Q.
    intros n4_3a.
    apply propositional_extensionality in n4_3a.
    replace (Q∧P) with (P∧Q) in Sa 
      by now apply n4_3a. (*Not cited*)
    MP Simp3_26a Sa.
    exact Simp3_26a.
Qed.

Theorem n5_35 : ∀ P Q R : Prop,
  ((P → Q) ∧ (P → R)) → (P → (Q ↔ R)).
  Proof. intros P Q R.
  specialize Comp3_43 with P Q R.
  intros Comp3_43a.
  specialize n5_1 with Q R.
  intros n5_1a.
  specialize Syll2_05 with P (Q∧R) (Q↔R).
  intros Syll2_05a.
  MP Syll2_05a n5_1a.
  Syll Comp3_43a Syll2_05a Sa.
  exact Sa.
Qed.

Theorem n5_36 : ∀ P Q : Prop,
  (P ∧ (P ↔ Q)) ↔ (Q ∧ (P ↔ Q)).
  Proof. intros P Q.
  specialize Id2_08 with (P↔Q).
  intros Id2_08a.
  specialize n5_32 with (P↔Q) P Q.
  intros n5_32a.
  apply propositional_extensionality in n5_32a.
  replace (P↔Q→P↔Q) with 
      ((P↔Q)∧P↔(P↔Q)∧Q) in Id2_08a
      by now apply n5_32a.
  specialize n4_3 with P (P↔Q).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace ((P↔Q)∧P) with (P∧(P↔Q)) in Id2_08a
    by now apply n4_3a.
  specialize n4_3 with Q (P↔Q).
  intros n4_3b.
  apply propositional_extensionality in n4_3b.
  replace ((P↔Q)∧Q) with (Q∧(P↔Q)) in Id2_08a
    by now apply n4_3b.
  exact Id2_08a.
Qed. 
  (*The proof sketch cites Ass3_35 and n4_38, 
    but the sketch was indecipherable.*)

Theorem n5_4 : ∀ P Q : Prop,
  (P → (P → Q)) ↔ (P → Q).
  Proof. intros P Q.
  specialize n2_43 with P Q.
  intros n2_43a.
  specialize Simp2_02 with (P) (P→Q).
  intros Simp2_02a.
  Conj n2_43a Simp2_02a C.
  Equiv C.
  exact C.
Qed.

Theorem n5_41 : ∀ P Q R : Prop,
  ((P → Q) → (P → R)) ↔ (P → Q → R).
  Proof. intros P Q R.
  specialize n2_86 with P Q R.
  intros n2_86a.
  specialize n2_77 with P Q R.
  intros n2_77a.
  Conj n2_86a n2_77a C.
  Equiv C.
  exact C.
Qed.

Theorem n5_42 : ∀ P Q R : Prop,
  (P → Q → R) ↔ (P → Q → P ∧ R).
  Proof. intros P Q R.
  specialize n5_3 with P Q R.
  intros n5_3a.
  specialize n4_87 with P Q R.
  intros n4_87a.
  specialize Imp3_31 with P Q R.
  intros Imp3_31a.
  specialize Exp3_3 with P Q R.
  intros Exp3_3a.
  Conj Imp3_31a Exp3_3 Ca.
  Equiv Ca.
  apply propositional_extensionality in Ca.
  replace ((P∧Q)→R) with (P→Q→R) in n5_3a
    by now apply Ca.
  specialize n4_87 with P Q (P∧R).
  intros n4_87b.
  specialize Imp3_31 with P Q (P∧R).
  intros Imp3_31b.
  specialize Exp3_3 with P Q (P∧R).
  intros Exp3_3b.
  Conj Imp3_31b Exp3_3b Cb.
  Equiv Cb.
  apply propositional_extensionality in Cb.
  replace ((P∧Q)→(P∧R)) with 
      (P→Q→(P∧R)) in n5_3a by now apply Cb.
  exact n5_3a.
Qed. 

Theorem n5_44 : ∀ P Q R : Prop,
  (P→Q) → ((P → R) ↔ (P → (Q ∧ R))).
  Proof. intros P Q R.
  specialize n4_76 with P Q R.
  intros n4_76a.
  rewrite Equiv4_01 in n4_76a.
  specialize Simp3_26 with 
    (((P→Q)∧(P→R))→(P→(Q∧R)))
    ((P→(Q∧R))→((P→Q)∧(P→R))).
  intros Simp3_26a.
  MP Simp3_26a n4_76a.
  specialize Simp3_27 with 
    (((P→Q)∧(P→R))→(P→(Q∧R)))
    ((P→(Q∧R))→((P→Q)∧(P→R))).
  intros Simp3_27a.
  MP Simp3_27a n4_76a.
  specialize Simp3_27 with (P→Q) (P→Q∧R).
  intros Simp3_27d.
  Syll Simp3_27d Simp3_27a Sa.
  specialize n5_3 with (P→Q) (P→R) (P→(Q∧R)).
  intros n5_3a.
  rewrite Equiv4_01 in n5_3a.
  specialize Simp3_26 with 
    ((((P→Q)∧(P→R))→(P→(Q∧R)))→
    (((P→Q)∧(P→R))→((P→Q)∧(P→(Q∧R)))))
    ((((P→Q)∧(P→R))→((P→Q)∧(P→(Q∧R))))
    →(((P→Q)∧(P→R))→(P→(Q∧R)))).
  intros Simp3_26b.
  MP Simp3_26b n5_3a.
  specialize Simp3_27 with 
  ((((P→Q)∧(P→R))→(P→(Q∧R)))→
  (((P→Q)∧(P→R))→((P→Q)∧(P→(Q∧R)))))
  ((((P→Q)∧(P→R))→((P→Q)∧(P→(Q∧R))))
  →(((P→Q)∧(P→R))→(P→(Q∧R)))).
  intros Simp3_27b.
  MP Simp3_27b n5_3a.
  MP Simp3_26a Simp3_26b.
  MP Simp3_27a Simp3_27b.
  clear n4_76a. clear Simp3_26a. clear Simp3_27a. 
    clear Simp3_27b. clear Simp3_27d. clear n5_3a.
  Conj Simp3_26b Sa C.
  Equiv C.
  specialize n5_32 with (P→Q) (P→R) (P→(Q∧R)).
  intros n5_32a.
  rewrite Equiv4_01 in n5_32a.
  specialize Simp3_27 with 
    (((P → Q) → (P → R) ↔ (P → Q ∧ R))
      → (P → Q) ∧ (P → R) ↔ (P → Q) ∧ (P → Q ∧ R))
    ((P → Q) ∧ (P → R) ↔ (P → Q) ∧ (P → Q ∧ R)
      → (P → Q) → (P → R) ↔ (P → Q ∧ R)).
  intros Simp3_27c.
  MP Simp3_27c n5_32a.
  specialize n4_21 with 
    ((P→Q)∧(P→R)) ((P→Q)∧(P→(Q∧R))).
  intros n4_21a.
  apply propositional_extensionality in n4_21a.
  replace (((P→Q)∧(P→(Q∧R)))↔((P→Q)∧(P→R)))
    with (((P→Q)∧(P→R))↔((P→Q)∧(P→(Q∧R))))
    in C by now apply n4_21a.
  MP Simp3_27c C.
  exact Simp3_27c.
Qed. 

Theorem n5_5 : ∀ P Q : Prop,
  P → ((P → Q) ↔ Q).
  Proof. intros P Q.
  specialize Ass3_35 with P Q.
  intros Ass3_35a.
  specialize Exp3_3 with P (P→Q) Q.
  intros Exp3_3a.
  MP Exp3_3a Ass3_35a.
  specialize Simp2_02 with P Q.
  intros Simp2_02a.
  specialize Exp3_3 with P Q (P→Q).
  intros Exp3_3b.
  specialize n3_42 with P Q (P→Q). (*Not cited*)
  intros n3_42a.
  MP n3_42a Simp2_02a.
  MP Exp3_3b n3_42a.
  clear n3_42a. clear Simp2_02a. clear Ass3_35a.
  Conj Exp3_3a Exp3_3b C.
  specialize n3_47 with P P ((P→Q)→Q) (Q→(P→Q)).
  intros n3_47a.
  MP n3_47a C.
  specialize n4_24 with P.
  intros n4_24a. (*Not cited*)
  apply propositional_extensionality in n4_24a.
  replace (P∧P) with P in n3_47a by now apply n4_24a. 
  replace (((P→Q)→Q)∧(Q→(P→Q))) with ((P→Q)↔Q)
    in n3_47a by now rewrite Equiv4_01.
  exact n3_47a.
Qed.

Theorem n5_501 : ∀ P Q : Prop,
  P → (Q ↔ (P ↔ Q)).
  Proof. intros P Q.
  specialize n5_1 with P Q.
  intros n5_1a.
  specialize Exp3_3 with P Q (P↔Q).
  intros Exp3_3a.
  MP Exp3_3a n5_1a.
  specialize Ass3_35 with P Q.
  intros Ass3_35a.
  specialize Simp3_26 with (P∧(P→Q)) (Q→P).
  intros Simp3_26a. (*Not cited*)
  Syll Simp3_26a Ass3_35a Sa.
  specialize n4_32 with P (P→Q) (Q→P).
  intros n4_32a. (*Not cited*)
  apply propositional_extensionality in n4_32a.
  replace ((P∧(P→Q))∧(Q→P)) with 
      (P∧((P→Q)∧(Q→P))) in Sa by now apply n4_32a.
  replace ((P→Q)∧(Q→P)) with (P↔Q) in Sa
    by now rewrite Equiv4_01.
  specialize Exp3_3 with P (P↔Q) Q.
  intros Exp3_3b.
  MP Exp3_3b Sa.
  clear n5_1a. clear Ass3_35a. clear n4_32a.
      clear Simp3_26a. clear Sa. 
  Conj Exp3_3a Exp3_3b C.
  specialize n4_76 with P (Q→(P↔Q)) ((P↔Q)→Q).
  intros n4_76a. (*Not cited*)
  apply propositional_extensionality in n4_76a.
  replace ((P→Q→P↔Q)∧(P→P↔Q→Q)) with 
      ((P→(Q→P↔Q)∧(P↔Q→Q))) in C
      by now apply n4_76a.
  replace ((Q→(P↔Q))∧((P↔Q)→Q)) with 
      (Q↔(P↔Q)) in C by now rewrite Equiv4_01.
  exact C.
Qed.

Theorem n5_53 : ∀ P Q R S : Prop,
  (((P ∨ Q) ∨ R) → S) ↔ (((P → S) ∧ (Q → S)) ∧ (R → S)).
  Proof. intros P Q R S.
  specialize n4_77 with S (P∨Q) R.
  intros n4_77a.
  specialize n4_77 with S P Q.
  intros n4_77b.
  apply propositional_extensionality in n4_77b.
  replace (P ∨ Q → S) with 
      ((P→S)∧(Q→S)) in n4_77a
      by now apply n4_77b. (*Not cited*)
  specialize n4_21 with ((P ∨ Q) ∨ R → S) 
      (((P → S) ∧ (Q → S)) ∧ (R → S)).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace ((((P→S)∧(Q→S))∧(R→S))↔(((P∨Q)∨R)→S)) 
      with 
      ((((P∨Q)∨R)→S)↔(((P→S)∧(Q→S))∧(R→S))) 
      in n4_77a by now apply n4_21.
  exact n4_77a.
Qed.

Theorem n5_54 : ∀ P Q : Prop,
  ((P ∧ Q) ↔ P) ∨ ((P ∧ Q) ↔ Q).
  Proof. intros P Q.
  specialize n4_73 with P Q.
  intros n4_73a.
  specialize n4_44 with Q P.
  intros n4_44a.
  specialize Transp2_16 with Q (P↔(P∧Q)).
  intros Transp2_16a.
  MP n4_73a Transp2_16a.
  specialize n4_3 with P Q.
  intros n4_3a. (*Not cited*)
  apply propositional_extensionality in n4_3a.
  replace (Q∧P) with (P∧Q) in n4_44a
    by now apply n4_3a.
  specialize Transp4_11 with Q (Q∨(P∧Q)).
  intros Transp4_11a.
  apply propositional_extensionality in Transp4_11a.
  replace (Q↔Q∨P∧Q) with 
      (¬Q↔¬(Q∨P∧Q)) in n4_44a by now apply Transp4_11a.
  apply propositional_extensionality in n4_44a.
  replace (¬Q) with (¬(Q∨P∧Q)) in Transp2_16a
    by now apply n4_44a.
  specialize n4_56 with Q (P∧Q).
  intros n4_56a. (*Not cited*)
  apply propositional_extensionality in n4_56a.
  replace (¬(Q∨P∧Q)) with 
      (¬Q∧¬(P∧Q)) in Transp2_16a
      by now apply n4_56a.
  specialize n5_1 with (¬Q) (¬(P∧Q)).
  intros n5_1a.
  Syll Transp2_16a n5_1a Sa.
  replace (¬(P↔P∧Q)→(¬Q↔¬(P∧Q))) with 
      (¬¬(P↔P∧Q)∨(¬Q↔¬(P∧Q))) in Sa
      by now rewrite Impl1_01. (*Not cited*)
  specialize n4_13 with (P ↔ (P∧Q)).
  intros n4_13a. (*Not cited*)
  apply propositional_extensionality in n4_13a.
  replace (¬¬(P↔P∧Q)) with (P↔P∧Q) in Sa
    by now apply n4_13a.
  specialize Transp4_11 with Q (P∧Q).
  intros Transp4_11b.
  apply propositional_extensionality in Transp4_11b.
  replace (¬Q↔¬(P∧Q)) with (Q↔(P∧Q)) in Sa
    by now apply Transp4_11b.
  specialize n4_21 with (P∧Q) Q.
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (Q↔(P∧Q)) with ((P∧Q)↔Q) in Sa
    by now apply n4_21a.
  specialize n4_21 with (P∧Q) P.
  intros n4_21b. (*Not cited*)
  apply propositional_extensionality in n4_21b.
  replace (P↔(P∧Q)) with ((P∧Q)↔P) in Sa
    by now apply n4_21b.
  exact Sa.
Qed. 

Theorem n5_55 : ∀ P Q : Prop,
  ((P ∨ Q) ↔ P) ∨ ((P ∨ Q) ↔ Q).
  Proof. intros P Q.
  specialize Add1_3 with (P∧Q) (P).
  intros Add1_3a.
  specialize n4_3 with P Q.
  intros n4_3a. (*Not cited*)
  apply propositional_extensionality in n4_3a.
  specialize n4_41 with P Q P. 
  intros n4_41a. (*Not cited*)
  replace (Q ∧ P) with (P ∧ Q) in n4_41a 
    by now apply n4_3a.
  specialize n4_31 with (P ∧ Q) P.
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  replace (P ∨ P ∧ Q) with (P ∧ Q ∨ P) in n4_41a
    by now apply n4_31a.
  apply propositional_extensionality in n4_41a.
  replace ((P∧Q)∨P) with ((P∨Q)∧(P∨P)) in Add1_3a
    by now apply n4_4a.
  specialize n4_25 with P.
  intros n4_25a. (*Not cited*)
  apply propositional_extensionality in n4_25a.
  replace (P∨P) with P in Add1_3a
    by now apply n4_25a.
  specialize n4_31 with P Q.
  intros n4_31b.
  apply propositional_extensionality in n4_31b.
  replace (Q∨P) with (P∨Q) in Add1_3a
    by now apply n4_31b. 
  specialize n5_1 with P (P∨Q).
  intros n5_1a.
  specialize n4_3 with (P ∨ Q) P.
  intros n4_3b.
  apply propositional_extensionality in n4_3b.
  replace ((P ∨ Q) ∧ P) with (P ∧ (P ∨ Q)) in Add1_3a
    by now apply n4_3b.
  Syll Add1_3a n5_1a Sa.
  specialize n4_74 with P Q.
  intros n4_74a.
  specialize Transp2_15 with P (Q↔P∨Q).
  intros Transp2_15a. (*Not cited*)
  MP Transp2_15a n4_74a.
  Syll Transp2_15a Sa Sb.
  replace (¬ (Q ↔ P ∨ Q) → P ↔ P ∨ Q) with
    (¬¬(Q ↔ P ∨ Q) ∨ (P ↔ P ∨ Q)) in Sb 
    by now rewrite Impl1_01.
  specialize n4_13 with (Q ↔ P ∨ Q).
  intros n4_13a. (*Not cited*)
  apply propositional_extensionality in n4_13a.
  replace (¬¬(Q↔(P∨Q))) with (Q↔(P∨Q)) in Sb
    by now apply n4_13a.
  specialize n4_21 with (P ∨ Q) Q.
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (Q↔(P∨Q)) with ((P∨Q)↔Q) in Sb
    by now apply n4_21a.
  specialize n4_21 with (P ∨ Q) P.
  intros n4_21b. (*Not cited*)
  apply propositional_extensionality in n4_21b.
  replace (P↔(P∨Q)) with ((P∨Q)↔P) in Sb
    by now apply n4_21b.
  apply n4_31 in Sb.
  exact Sb. 
Qed.

Theorem n5_6 : ∀ P Q R : Prop,
  ((P ∧ ¬Q) → R) ↔ (P → (Q ∨ R)).
  Proof. intros P Q R.
  specialize n4_87 with P (¬Q) R.
  intros n4_87a.
  specialize n4_64 with Q R.
  intros n4_64a.
  specialize n4_85 with P Q R.
  intros n4_85a.
  replace (((P∧¬Q→R)↔(P→¬Q→R))↔((¬Q→P→R)↔(¬Q∧P→R)))
       with 
       ((((P∧¬Q→R)↔(P→¬Q→R))→((¬Q→P→R)↔(¬Q∧P→R)))
       ∧
       ((((¬Q→P→R)↔(¬Q∧P→R)))→(((P∧¬Q→R)↔(P→¬Q→R))))) 
       in n4_87a by now rewrite Equiv4_01.
  specialize Simp3_27 with 
      (((P∧¬Q→R)↔(P→¬Q→R)→(¬Q→P→R)↔(¬Q∧P→R))) 
      (((¬Q→P→R)↔(¬Q∧P→R)→(P∧¬Q→R)↔(P→¬Q→R))).
  intros Simp3_27a.
  MP Simp3_27a n4_87a.
  specialize Imp3_31 with (¬Q) P R.
  intros Imp3_31a.
  specialize Exp3_3 with (¬Q) P R.
  intros Exp3_3a.
  Conj Imp3_31a Exp3_3a C.
  Equiv C.
  MP Simp3_27a C.
  apply propositional_extensionality in n4_64a.
  replace (¬Q→R) with (Q∨R) in Simp3_27a
    by now apply n4_64a.
  exact Simp3_27a.  
Qed. 

Theorem n5_61 : ∀ P Q : Prop,
  ((P ∨ Q) ∧ ¬Q) ↔ (P ∧ ¬Q).
  Proof. intros P Q.
  specialize n4_74 with Q P.
  intros n4_74a.
  specialize n5_32 with (¬Q) P (Q∨P).
  intros n5_32a.
  apply propositional_extensionality in n5_32a.
  replace (¬Q → P ↔ Q ∨ P) with 
      (¬Q ∧ P ↔ ¬Q ∧ (Q ∨ P)) in n4_74a
      by now apply n5_32a.
  specialize n4_3 with P (¬Q).
  intros n4_3a. (*Not cited*)
  apply propositional_extensionality in n4_3a.
  replace (¬Q ∧ P) with (P ∧ ¬Q) in n4_74a
    by now apply n4_3a.
  specialize n4_3 with (Q ∨ P) (¬Q).
  intros n4_3b. (*Not cited*)
  apply propositional_extensionality in n4_3b.
  replace (¬Q ∧ (Q ∨ P)) with ((Q ∨ P) ∧ ¬Q) in n4_74a
    by now apply n4_3b.
  specialize n4_31 with P Q.
  intros n4_31a. (*Not cited*)
  apply propositional_extensionality in n4_31a.
  replace (Q ∨ P) with (P ∨ Q) in n4_74a
    by now apply n4_31a.
  specialize n4_21 with ((P ∨ Q) ∧ ¬Q) (P ∧ ¬Q).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (P ∧ ¬Q ↔ (P ∨ Q) ∧ ¬Q) with 
      ((P ∨ Q) ∧ ¬Q ↔ P ∧ ¬Q) in n4_74a
      by now apply n4_21a.
  exact n4_74a.
Qed.

Theorem n5_62 : ∀ P Q : Prop,
  ((P ∧ Q) ∨ ¬Q) ↔ (P ∨ ¬Q).
  Proof. intros P Q.
  specialize n4_7 with Q P.
  intros n4_7a.
  replace (Q→P) with (¬Q∨P) in n4_7a
    by now rewrite Impl1_01.
  replace (Q→(Q∧P)) with (¬Q∨(Q∧P)) in n4_7a
    by now rewrite Impl1_01.
  specialize n4_31 with (Q ∧ P) (¬Q).
  intros n4_31a. (*Not cited*)
  apply propositional_extensionality in n4_31a.
  replace (¬Q∨(Q∧P)) with ((Q∧P)∨¬Q) in n4_7a
    by now apply n4_31a.
  specialize n4_31 with P (¬Q).
  intros n4_31b. (*Not cited*)
  apply propositional_extensionality in n4_31b.
  replace (¬Q∨P) with (P∨¬Q) in n4_7a
    by now apply n4_31b.
  specialize n4_3 with P Q.
  intros n4_3a. (*Not cited*)
  apply propositional_extensionality in n4_3a.
  replace (Q∧P) with (P∧Q) in n4_7a
    by now apply n4_3a.
  specialize n4_21 with (P ∧ Q ∨ ¬Q) (P ∨ ¬Q).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (P ∨ ¬Q ↔ P ∧ Q ∨ ¬Q) with 
      (P ∧ Q ∨ ¬Q ↔ P ∨ ¬Q) in n4_7a
      by now apply n4_21a.
  exact n4_7a.
Qed.

Theorem n5_63 : ∀ P Q : Prop,
  (P ∨ Q) ↔ (P ∨ (¬P ∧ Q)).
  Proof. intros P Q.
  specialize n5_62 with Q (¬P).
  intros n5_62a.
  specialize n4_13 with P.
  intros n4_13a. (*Not cited*)
  apply propositional_extensionality in n4_13a.
  replace (¬¬P) with P in n5_62a
    by now apply n4_13a.
  specialize n4_31 with P Q.
  intros n4_31a. (*Not cited*)
  apply propositional_extensionality in n4_31a.
  replace (Q ∨ P) with (P ∨ Q) in n5_62a
    by now apply n4_31a.
  specialize n4_31 with P (Q∧¬P).
  intros n4_31b. (*Not cited*)
  apply propositional_extensionality in n4_31b.
  replace ((Q∧¬P)∨P) with (P∨(Q∧¬P)) in n5_62a
    by now apply n4_31b.
  specialize n4_21 with (P∨Q) (P∨(Q∧¬P)).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (P ∨ Q ∧ ¬P ↔ P ∨ Q) with 
      (P ∨ Q ↔ P ∨ Q ∧ ¬P) in n5_62a
      by now apply n4_21a.
  specialize n4_3 with (¬P) Q.
  intros n4_3a. (*Not cited*)
  apply propositional_extensionality in n4_3a.
  replace (Q∧¬P) with (¬P∧Q) in n5_62a
    by now apply n4_3a.
  exact n5_62a.
Qed.

Theorem n5_7 : ∀ P Q R : Prop,
  ((P ∨ R) ↔ (Q ∨ R)) ↔ (R ∨ (P ↔ Q)).
  Proof. intros P Q R.
  specialize n4_74 with R P.
  intros n4_74a.
  specialize n4_74 with R Q.
  intros n4_74b. (*Greg's suggestion*)
  Conj n4_74a n4_74b Ca.
  specialize Comp3_43 with 
    (¬R) (P↔R∨P) (Q↔R∨Q).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  specialize n4_22 with P (R∨P) (R∨Q).
  intros n4_22a.
  specialize n4_22 with P (R∨Q) Q.
  intros n4_22b.
  specialize Exp3_3 with (P↔(R∨Q)) 
    ((R∨Q)↔Q) (P↔Q).
  intros Exp3_3a.
  MP Exp3_3a n4_22b.
  Syll n4_22a Exp3_3a Sa.
  specialize Imp3_31 with ((P↔(R∨P))∧
    ((R ∨ P) ↔ (R ∨ Q))) ((R∨Q)↔Q) (P↔Q).
  intros Imp3_31a.
  MP Imp3_31a Sa.
  specialize n4_32 with (P↔R∨P) (R∨P↔R∨Q) (R∨Q↔Q).
  intros n4_32a.
  apply propositional_extensionality in n4_32a.
  replace (((P↔(R∨P))∧((R ∨ P) ↔ 
      (R ∨ Q))) ∧ ((R∨Q)↔Q)) with 
    ((P↔(R∨P))∧(((R ∨ P) ↔ 
      (R ∨ Q)) ∧ ((R∨Q)↔Q))) in Imp3_31a 
    by now apply n4_32a.
  specialize n4_3 with (R ∨ Q ↔ Q) (R ∨ P ↔ R ∨ Q).
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace ((R ∨ P ↔ R ∨ Q) ∧ (R ∨ Q ↔ Q)) with 
    ((R ∨ Q ↔ Q) ∧ (R ∨ P ↔ R ∨ Q)) in Imp3_31a
    by now apply n4_3a.
  specialize n4_32 with (P ↔ R ∨ P) (R ∨ Q ↔ Q) (R ∨ P ↔ R ∨ Q).
  intros n4_32b.
  apply propositional_extensionality in n4_32b.
  replace ((P↔(R∨P)) ∧ 
      ((R ∨ Q ↔ Q) ∧ (R ∨ P ↔ R ∨ Q))) with 
    (((P↔(R∨P)) ∧ (R ∨ Q ↔ Q)) ∧ 
      (R ∨ P ↔ R ∨ Q)) in Imp3_31a
    by now apply n4_32b.
  specialize Exp3_3 with 
    ((P↔(R∨P))∧(R∨Q↔Q)) 
    (R ∨ P ↔ R ∨ Q) (P ↔ Q).
  intros Exp3_3b.
  MP Exp3_3b Imp3_31a.
  specialize n4_21 with Q (R∨Q).
  intros n4_21a.
  apply propositional_extensionality in n4_21a. 
  replace (Q↔R∨Q) with (R∨Q↔Q) in Comp3_43a
    by now apply n4_21a.
  Syll Comp3_43a Exp3_3b Sb.
  specialize n4_31 with P R.
  intros n4_31a.
  apply propositional_extensionality in n4_31a.
  replace (R∨P) with (P∨R) in Sb by now apply n4_31a.
  specialize n4_31 with Q R.
  intros n4_31b.
  apply propositional_extensionality in n4_31b.
  replace (R∨Q) with (Q∨R) in Sb by now apply n4_31b.
  specialize Imp3_31 with (¬R) (P∨R↔Q∨R) (P↔Q).
  intros Imp3_31b.
  MP Imp3_31b Sb.
  specialize n4_3 with (P ∨ R ↔ Q ∨ R) (¬R).
  intros n4_3b. 
  apply propositional_extensionality in n4_3b.
  replace (¬R ∧ (P ∨ R ↔ Q ∨ R)) with 
    ((P ∨ R ↔ Q ∨ R) ∧ ¬R) in Imp3_31b
    by now apply n4_3b.
  specialize Exp3_3 with 
    (P ∨ R ↔ Q ∨ R) (¬R) (P ↔ Q).
  intros Exp3_3c.
  MP Exp3_3c Imp3_31b.
  replace (¬R→(P↔Q)) with (¬¬R∨(P↔Q)) 
    in Exp3_3c by now rewrite Impl1_01.
  specialize n4_13 with R.
  intros n4_13a.
  apply propositional_extensionality in n4_13a.
  replace (¬¬R) with R in Exp3_3c
    by now apply n4_13a.
  specialize Add1_3 with P R.
  intros Add1_3a.
  specialize Add1_3 with Q R.
  intros Add1_3b.
  Conj Add1_3a Add1_3b Cb.
  specialize Comp3_43 with (R) (P∨R) (Q∨R).
  intros Comp3_43b.
  MP Comp3_43b Cb.
  specialize n5_1 with (P ∨ R) (Q ∨ R).
  intros n5_1a.
  Syll Comp3_43b n5_1a Sc.
  specialize n4_37 with P Q R.
  intros n4_37a.
  Conj Sc n4_37a Cc.
  specialize n4_77 with (P ∨ R ↔ Q ∨ R)
    R (P↔Q).
  intros n4_77a.
  rewrite Equiv4_01 in n4_77a.
  specialize Simp3_26 with 
    ((R → P ∨ R ↔ Q ∨ R) ∧ 
      (P ↔ Q → P ∨ R ↔ Q ∨ R)
    → R ∨ (P ↔ Q) → P ∨ R ↔ Q ∨ R)
    ((R ∨ (P ↔ Q) → P ∨ R ↔ Q ∨ R)
      → (R → P ∨ R ↔ Q ∨ R) ∧ 
        (P ↔ Q → P ∨ R ↔ Q ∨ R)).
  intros Simp3_26a.
  MP Simp3_26 n4_77a.
  MP Simp3_26a Cc.
  clear n4_77a. clear Cc. clear n4_37a. clear Sa.
    clear n5_1a. clear Comp3_43b. clear Cb. 
    clear Add1_3a. clear Add1_3b. clear Ca. clear Imp3_31b.
    clear n4_74a. clear n4_74b. clear Comp3_43a.
    clear Imp3_31a. clear n4_22a. clear n4_22b. 
    clear Exp3_3a. clear Exp3_3b. clear Sb. clear Sc.
    clear n4_13a. clear n4_3a. clear n4_3b. clear n4_21a.
    clear n4_31a. clear n4_31b. clear n4_32a. clear n4_32b.
  Conj Exp3_3c Simp3_26a Cdd.
  Equiv Cdd.
  exact Cdd.
Qed.

Theorem n5_71 : ∀ P Q R : Prop,
  (Q → ¬R) → (((P ∨ Q) ∧ R) ↔ (P ∧ R)).
  Proof. intros P Q R.
  specialize n4_62 with Q R.
  intros n4_62a.
  specialize n4_51 with Q R.
  intros n4_51a.
  specialize n4_21 with (¬(Q∧R)) (¬Q∨¬R).
  intros n4_21a.
  rewrite Equiv4_01 in n4_21a.
  specialize Simp3_26 with 
    ((¬(Q∧R)↔(¬Q∨¬R))→((¬Q∨¬R)↔¬(Q∧R)))
    (((¬Q∨¬R)↔¬(Q∧R))→(¬(Q∧R)↔(¬Q∨¬R))).
  intros Simp3_26a.
  MP Simp3_26a n4_21a.
  MP Simp3_26a n4_51a.
  clear n4_21a. clear n4_51a.
  Conj n4_62a Simp3_26a C.
  specialize n4_22 with 
    (Q→¬R) (¬Q∨¬R) (¬(Q∧R)).
  intros n4_22a.
  MP n4_22a C.
  replace ((Q→¬R)↔¬(Q∧R)) with 
      (((Q→¬R)→¬(Q∧R))
      ∧
      (¬(Q∧R)→(Q→¬R))) in n4_22a
      by now rewrite Equiv4_01.
  specialize Simp3_26 with 
      ((Q→¬R)→¬(Q∧R)) (¬(Q∧R)→(Q→¬R)).
  intros Simp3_26b.
  MP Simp3_26b n4_22a.
  specialize n4_74 with (Q∧R) (P∧R).
  intros n4_74a.
  Syll Simp3_26a n4_74a Sa.
  specialize n4_31 with (Q∧R) (P∧R).
  intros n4_31a. (*Not cited*)
  apply propositional_extensionality in n4_31a.
  replace ((P∧R)∨(Q∧R)) with ((Q∧R)∨(P∧R))
       in Sa by now rewrite n4_31a.
  specialize n4_31 with (R∧Q) (R∧P).
  intros n4_31b. (*Not cited*)
  apply propositional_extensionality in n4_31b.
  specialize n4_21 with ((P∨Q)∧R) (P∧R).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  specialize n4_4 with R P Q.
  intros n4_4a.
  replace (R ∧ P ∨ R ∧ Q) with (R ∧ Q ∨ R ∧ P) 
    in n4_4a by now apply n4_31b.
  specialize n4_3 with P R.
  intros n4_3a.
  apply propositional_extensionality in n4_3a.
  replace (R ∧ P) with (P ∧ R) in n4_4a 
    by now apply n4_3a.
  specialize n4_3 with Q R.
  intros n4_3b.
  apply propositional_extensionality in n4_3b.
  replace (R ∧ Q) with (Q ∧ R) in n4_4a 
    by now apply n4_3b.
  apply propositional_extensionality in n4_4a.
  replace ((Q∧R)∨(P∧R)) with (R∧(P∨Q)) in Sa
    by now apply n4_4a.
  specialize n4_3 with (P∨Q) R.
  intros n4_3c. (*Not cited*)
  apply propositional_extensionality in n4_3c. 
  replace (R∧(P∨Q)) with ((P∨Q)∧R) in Sa
    by now apply n4_3c.
  replace ((P∧R)↔((P∨Q)∧R)) with 
      (((P∨Q)∧R)↔(P∧R)) in Sa
      by now apply n4_21a.
  exact Sa.
Qed.

Theorem n5_74 : ∀ P Q R : Prop,
  (P → (Q ↔ R)) ↔ ((P → Q) ↔ (P → R)).
  Proof. intros P Q R.
  specialize n5_41 with P Q R.
  intros n5_41a.
  specialize n5_41 with P R Q.
  intros n5_41b.
  Conj n5_41a n5_41b C.
  specialize n4_38 with 
      ((P→Q)→(P→R)) ((P→R)→(P→Q)) 
      (P→Q→R) (P→R→Q).
  intros n4_38a.
  MP n4_38a C.
  replace (((P→Q)→(P→R))∧((P→R)→(P→Q))) 
    with ((P→Q)↔(P→R)) in n4_38a
    by now rewrite Equiv4_01.
  specialize n4_76 with P (Q→R) (R→Q).
  intros n4_76a.
  replace ((Q→R)∧(R→Q)) with (Q↔R) in n4_76a
    by now rewrite Equiv4_01.
  apply propositional_extensionality in n4_76a.
  replace ((P→Q→R)∧(P→R→Q)) with 
      (P→(Q↔R)) in n4_38a by now apply n4_76a.
  specialize n4_21 with (P→Q↔R) 
    ((P→Q)↔(P→R)).
  intros n4_21a. (*Not cited*)
  apply propositional_extensionality in n4_21a.
  replace (((P→Q)↔(P→R))↔(P→Q↔R)) with 
      ((P→(Q↔R))↔((P→Q)↔(P→R))) in n4_38a
      by now apply n4_21a.
  exact n4_38a.
Qed.

Theorem n5_75 : ∀ P Q R : Prop,
  ((R → ¬Q) ∧ (P ↔ Q ∨ R)) → ((P ∧ ¬Q) ↔ R).
  Proof. intros P Q R.
  specialize n5_6 with P Q R.
  intros n5_6a.
  replace ((P∧¬Q→R)↔(P→Q∨R)) with 
      (((P∧¬Q→R)→(P→Q∨R)) ∧
      ((P→Q∨R)→(P∧¬Q→R))) in n5_6a
      by now rewrite Equiv4_01.
  specialize Simp3_27 with 
      ((P∧¬Q→R)→(P→Q∨R)) 
      ((P→Q∨R)→(P∧¬Q→R)).
  intros Simp3_27a.
  MP Simp3_27a n5_6a.
  specialize Simp3_26 with 
    (P→(Q∨R)) ((Q∨R)→P).
  intros Simp3_26a.
  replace ((P→(Q∨R))∧((Q∨R)→P)) with 
      (P↔(Q∨R)) in Simp3_26a
      by now rewrite Equiv4_01.
  Syll Simp3_26a Simp3_27a Sa.
  specialize Simp3_27 with 
    (R→¬Q) (P↔(Q∨R)).
  intros Simp3_27b.
  Syll Simp3_27b Sa Sb.
  specialize Simp3_27 with 
    (P→(Q∨R)) ((Q∨R)→P).
  intros Simp3_27c.
  replace ((P→(Q∨R))∧((Q∨R)→P)) with 
      (P↔(Q∨R)) in Simp3_27c 
      by now rewrite Equiv4_01.
  Syll Simp3_27b Simp3_27c Sc.
  specialize n4_77 with P Q R.
  intros n4_77a.
  apply propositional_extensionality in n4_77a.
  replace (Q∨R→P) with ((Q→P)∧(R→P)) in Sc
    by now apply n4_77a.
  specialize Simp3_27 with (Q→P) (R→P).
  intros Simp3_27d.
  Syll Sa Simp3_27d Sd.
  specialize Simp3_26 with (R→¬Q) (P↔(Q∨R)).
  intros Simp3_26b.
  Conj Sd Simp3_26b Ca.
  specialize Comp3_43 with 
      ((R→¬Q)∧(P↔(Q∨R))) (R→P) (R→¬Q).
  intros Comp3_43a.
  MP Comp3_43a Ca.
  specialize Comp3_43 with R P (¬Q).
  intros Comp3_43b.
  Syll Comp3_43a Comp3_43b Se.
  clear n5_6a. clear Simp3_27a. 
      clear Simp3_27c. clear Simp3_27d. 
      clear Simp3_26a.  clear Comp3_43b. 
      clear Simp3_26b. clear Comp3_43a.
      clear Sa. clear Sc. clear Sd. clear Ca. 
      clear n4_77a. clear Simp3_27b. 
  Conj Sb Se Cb.
  specialize Comp3_43 with 
    ((R→¬Q)∧(P↔Q∨R)) 
    (P∧¬Q→R) (R→P∧¬Q).
  intros Comp3_43c.
  MP Comp3_43c Cb.
  replace ((P∧¬Q→R)∧(R→P∧¬Q)) with 
      (P∧¬Q↔R) in Comp3_43c 
      by now rewrite Equiv4_01.
  exact Comp3_43c.
Qed.

End No5.

Module No9.

(* Df 9.01, 9.02,: Definition of negation on forall and negation on existence *)
Theorem n9_01 : forall P : Prop -> Prop, ~(forall x : Prop, P x) -> (exists x : Prop, ~(P x)).
Proof. Admitted.

Theorem n9_02 : forall P : Prop -> Prop, ~(exists x : Prop, P x) -> (forall x : Prop, ~(P x)).
Proof. Admitted.

(* Df 9.011, 9.021: Definition to eliminate brackets *)

(* Df 9.03 - 9.08: definition of disjunctions *)

Theorem n9_03 : forall (Phi : Prop -> Prop) (P : Prop), 
  (forall x : Prop, Phi x) \/ P -> forall x : Prop, Phi x \/ P.
Proof. Admitted.

Theorem n9_04 : forall (Phi : Prop -> Prop) (P : Prop), 
  (P \/ forall x : Prop, Phi x) -> forall x: Prop, P \/ Phi x.
Proof. Admitted.

Theorem n9_05 : forall (Phi : Prop -> Prop) (P : Prop), 
    (exists x : Prop, Phi x) \/ P -> exists x : Prop, Phi x \/ P.
Proof. Admitted.

Theorem n9_06 : forall (Phi : Prop -> Prop) (P : Prop), 
  (P \/ exists x : Prop, Phi x) -> exists x: Prop, P \/ Phi x.
Proof. Admitted.

Theorem n9_07 : forall (Phi Psi : Prop -> Prop),
  (forall x : Prop, Phi x) \/ (exists y : Prop, Psi y)
  -> forall x : Prop, exists y : Prop, Phi x \/ Psi y.
Proof. Admitted.

Theorem n9_08 : forall (Phi Psi : Prop -> Prop),
  (exists y, Psi y) \/ (forall x : Prop, Phi x)
  -> forall x : Prop, exists y : Prop, Psi y \/ Phi x.
Proof. Admitted.

