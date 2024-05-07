/*
-- =========================================================================== A
Produit : CoFELI.Exemple.Universite
Variante : 2023.iter06
Artefact : Universite_MDD_types.sql
Responsable : Luc.Lavoie@USherbrooke.ca
Version : 0.5.0a (2023-03-08)
Statut : travail en cours
Encodage : UTF-8, sans BOM; fin de ligne simple (LF)
Plateformes : PostgreSQL 12+
-- =========================================================================== A
*/

/*
-- =========================================================================== B

== Iteration 06

Rendre disponibles les contraintes de domaines -- ceci sera utile dans une contexte
de vérification en général et d'alimentation en particulier.

...

-- =========================================================================== B
*/

--
--  Définir la portée.
--
set search_path to 'MDD' ;

create function Bureau_dom (t Text) returns Boolean
  immutable
  return t similar to '[A-Z][0-9]{1,2}-[0-9]{4}(-[0-9]{2})?' ;
create domain Bureau
  Text
  check (Bureau_dom(value)) ;

create function Cause_dom (t Text) returns Boolean
  immutable
  return true ;
create domain Cause
  Text
  check (Cause_dom(value)) ;

create function CDC_dom (i SmallInt) returns Boolean
  immutable
  return i between 1 and 90 ;
create domain CDC
  SmallInt
  check (CDC_dom(value)) ;

create function MatriculeE_dom (t Text) returns Boolean
  immutable
  return t similar to '[a-z]{4}[0-9]{4}' ;
create domain MatriculeE
  Text
  check (MatriculeE_dom(value)) ;

create function MatriculeP_dom (t Text) returns Boolean
  immutable
  return t similar to '[a-z]{4}[0-9]{4}' ;
create domain MatriculeP
  Text
  check (MatriculeP_dom(value)) ;

create function NoGroupe_dom (t Text) returns Boolean
  immutable
  return t similar to '[0-9]{2}' ;
create domain NoGroupe
  Text
  check (NoGroupe_dom(value)) ;

create function Nom_dom (t Text) returns Boolean
  immutable
  return length(t) <= 120 and t similar to '[[:alpha:]]+([-’ [:alpha:]])*[[:alpha:]]+' ;
create domain Nom
  Text
  check (Nom_dom(value));

create function Note_dom (i SmallInt) returns Boolean
  immutable
  return i between 1 and 100 ;
create domain Note
  SmallInt
  check (Note_dom(value)) ;

create function Sigle_dom (t Text) returns Boolean
  immutable
  return t similar to '[A-Z]{3}[0-9]{3}' ;
create domain Sigle
  Text
  check (Sigle_dom(value)) ;

create function Titre_dom (t Text) returns Boolean
  immutable
  return true ;
create domain Titre
  Text
  check (Titre_dom(value)) ;

create function Trimestre_dom (t Text) returns Boolean
  immutable
  return t similar to '[0-9]{4}-[1-3]' ;
create domain Trimestre
  Text
  check (Trimestre_dom(value)) ;

/*
-- =========================================================================== Z

=== Contributeurs
  (CK01) Christina.Khnaisser@USherbrooke.ca,
  (LL01) Luc.Lavoie@USherbrooke.ca

=== Adresse, droits d’auteur et copyright
  Groupe Μῆτις (Métis)
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
  http://info.usherbrooke.ca/llavoie/
  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

=== Tâches projetées
  S. O.

=== Tâches réalisées
  2024-04-17 (LL01) : Mise à disposition des fonctions de contraintes.
  2024-04-16 (LL01) : Correction de la contrainte du type Nom.
  2021-03-19 (LL01) : Première factorisation.

=== Références
[ddv] http://info.usherbrooke.ca/llavoie/enseignement/Exemples/Universite/
      Universite_DDV.pdf
[std] http://info.usherbrooke.ca/llavoie/enseignement/Modules/
      BD190-STD-SQL-01_NDC.pdf

-- =========================================================================== Z
*/
